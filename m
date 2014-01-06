Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaAFCSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 21:18:24 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:55159 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaAFCSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 21:18:23 -0500
Message-ID: <52CA11FE.1090608@huawei.com>
Date: Mon, 6 Jan 2014 10:16:30 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Miller <davem@davemloft.net>
CC: <edumazet@google.com>, <kaber@trash.net>, <peterz@infradead.org>,
        <honkiko@gmail.com>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>, <jhs@mojatatu.com>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC PATCH net-next 3/4] veth: backup classid befor switch net_ns
References: <52C62A52.8050003@huawei.com> <52C694BF.3020903@cogentembedded.com>
In-Reply-To: <52C694BF.3020903@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/3 18:45, Sergei Shtylyov wrote:
> Hello.
> 
> On 03-01-2014 7:11, Libo Chen wrote:
> 
>> dev_forward_skb will clear skb->sk, so we need save classid
>> before that, otherwise the skb can not be under control by
>> net_cls.
> 
>> Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
>> ---
>>   drivers/net/veth.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
> 
>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>> index 2ec2041..ce43a2d 100644
>> --- a/drivers/net/veth.c
>> +++ b/drivers/net/veth.c
> [...]
>> @@ -123,6 +124,12 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>>           rcv->features & NETIF_F_RXCSUM)
>>           skb->ip_summed = CHECKSUM_UNNECESSARY;
>>
>> +    /**
> 
>    Why you're using kernel-doc style comments out of place? The format of multi-line comments  in the networking code is this:
> 
> /* bla
>  * bla
>  */

thank you

Libo

> 
>> +     * dev_forward_sbk will clear skb->sk, so save
>> +     * skb->sk->sk_classid for Qos
>> +     */
>> +    bk_cls_classid(skb);
>> +
> 
> WBR, Sergei
> 
> 
> 
> .
> 


