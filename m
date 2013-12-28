Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3L1Pab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 10:30:31 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:60122 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab3L1Pa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 10:30:29 -0500
Message-ID: <52BEEBD5.1040301@gmail.com>
Date: Sat, 28 Dec 2013 23:18:45 +0800
From: Ding Tianhong <dthxman@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 11/20] net: packetengines: slight optimization
 of addr
References: <52BE6D0D.9050301@huawei.com> <52BED8ED.2040908@cogentembedded.com>
In-Reply-To: <52BED8ED.2040908@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/12/28 21:58, Sergei Shtylyov 写道:
> Hello.
> 
> On 28-12-2013 10:17, Ding Tianhong wrote:
> 
>> Use possibly more efficient ether_addr_equal
>> to instead of memcmp.
> 
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
>> ---
>>   drivers/net/ethernet/packetengines/yellowfin.c |   12 ++++++------
>>   1 files changed, 6 insertions(+), 6 deletions(-)
> 
>> diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/ethernet/packetengines/yellowfin.c
>> index d28593b..b83ac0e 100644
>> --- a/drivers/net/ethernet/packetengines/yellowfin.c
>> +++ b/drivers/net/ethernet/packetengines/yellowfin.c
>> @@ -1097,12 +1097,12 @@ static int yellowfin_rx(struct net_device *dev)
>>               if (status2 & 0x80) dev->stats.rx_dropped++;
>>   #ifdef YF_PROTOTYPE        /* Support for prototype hardware errata. */
>>           } else if ((yp->flags & HasMACAddrBug)  &&
>> -            memcmp(le32_to_cpu(yp->rx_ring_dma +
>> -                entry*sizeof(struct yellowfin_desc)),
>> -                dev->dev_addr, 6) != 0 &&
>> -            memcmp(le32_to_cpu(yp->rx_ring_dma +
>> -                entry*sizeof(struct yellowfin_desc)),
>> -                "\377\377\377\377\377\377", 6) != 0) {
>> +            !ether_addr_equal(le32_to_cpu(yp->rx_ring_dma +
>> +                              entry * sizeof(struct yellowfin_desc)),
>> +                              dev->dev_addr) &&
> 
>    Previous line was aligned correctly, the above line should start under le32_to_cpu.
> 
>> +            !ether_addr_equal(le32_to_cpu(yp->rx_ring_dma +
>> +                              entry * sizeof(struct yellowfin_desc)),
> 
>    Start the continuation lines under 'yp', please.
> 
>> +                              "\377\377\377\377\377\377")) {
> 
>    This line should start under le32_to_cpu.
> 
> WBR, Sergei
> 

Hi sergei:
you mean this way?
	!ether_addr_equal(le32_to_cpu(yp->rx_ring_dma +
				      entry * sizeof(struct yellowfin_desc)),
			  dev->dev_addr) &&

	!ether_addr_equal(le32_to_cpu(yp->rx_ring_dma +
				      entry * sizeof(struct yellowfin_desc)),
			  "\377\377\377\377\377\377")) {

Regards
Ding

> -- 
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

