Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3LZLJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 06:09:57 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:60610 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3LZLJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 06:09:55 -0500
Message-ID: <52BC0E56.80003@huawei.com>
Date: Thu, 26 Dec 2013 19:09:10 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 13/19] media: dvb_core: slight optimization of addr
 compare
References: <52BA5113.7070908@huawei.com> <52BABA23.2040709@cogentembedded.com>
In-Reply-To: <52BABA23.2040709@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/25 18:57, Sergei Shtylyov wrote:
> Hello.
> 
> On 25-12-2013 7:29, Ding Tianhong wrote:
> 
>> Use possibly more efficient ether_addr_equal
>> instead of memcmp.
> 
>> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
>> Cc: linux-media@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
>> ---
>>   drivers/media/dvb-core/dvb_net.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
>> diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
>> index f91c80c..3dfc33b 100644
>> --- a/drivers/media/dvb-core/dvb_net.c
>> +++ b/drivers/media/dvb-core/dvb_net.c
>> @@ -179,7 +179,7 @@ static __be16 dvb_net_eth_type_trans(struct sk_buff *skb,
>>       eth = eth_hdr(skb);
>>
>>       if (*eth->h_dest & 1) {
>> -        if(memcmp(eth->h_dest,dev->broadcast, ETH_ALEN)==0)
>> +        if(ether_addr_equal(eth->h_dest,dev->broadcast))
> 
>    There should be space after comma.
> 
>> @@ -674,11 +674,11 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
>>                       if (priv->rx_mode != RX_MODE_PROMISC) {
>>                           if (priv->ule_skb->data[0] & 0x01) {
>>                               /* multicast or broadcast */
>> -                            if (memcmp(priv->ule_skb->data, bc_addr, ETH_ALEN)) {
>> +                            if (!ether_addr_equal(priv->ule_skb->data, bc_addr)) {
>>                                   /* multicast */
>>                                   if (priv->rx_mode == RX_MODE_MULTI) {
>>                                       int i;
>> -                                    for(i = 0; i < priv->multi_num && memcmp(priv->ule_skb->data, priv->multi_macs[i], ETH_ALEN); i++)
>> +                                    for(i = 0; i < priv->multi_num && !ether_addr_equal(priv->ule_skb->data, priv->multi_macs[i]); i++)
> 
>    Shouldn't this line be broken?
> 

ok, thanks.

Regards
>>                                           ;
>>                                       if (i == priv->multi_num)
>>                                           drop = 1;
> 
> WBR, Sergei
> 
> 
> 
> 


