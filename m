Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3L3GTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 01:19:38 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:43311 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3L3GTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 01:19:37 -0500
Message-ID: <52C11062.9040906@huawei.com>
Date: Mon, 30 Dec 2013 14:19:14 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ding Tianhong <dthxman@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 11/20] net: packetengines: slight optimization
 of addr
References: <52BE6D0D.9050301@huawei.com>	 <52BED8ED.2040908@cogentembedded.com> <52BEEBD5.1040301@gmail.com>	 <1388251380.24123.15.camel@joe-AO722> <52C0DCF7.6040402@huawei.com> <1388383526.26796.21.camel@joe-AO722>
In-Reply-To: <1388383526.26796.21.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/30 14:05, Joe Perches wrote:
> On Mon, 2013-12-30 at 10:39 +0800, Ding Tianhong wrote:
>> I don't understand packetengine NIC anymore, But I think the change is clearly,
>> as your said, the broadcast check is enough here, did you mean that?
>>
>> 	!is_broadcast_ether_addr((u8 *)(le32_to_cpu(yp->rx_ring_dma) +
>> 						    entry * sizeof(struct yellowfin_desc)))
> 
> Not quite.  I meant this could be:
> 
> 		u8 *addr = (u8 *)(unsigned long)le32_to_cpu(yp->rx_ring_dma) +
> 							    entry * sizeof(struct yellowfin_desc);
> 
> 		if (!ether_addr_equal(addr, dev->dev_addr) &&
> 		    !is_broadcast_ether_addr(addr)) {
> 			etc...
> 
> but again, I think thus hardly matters and could just as well
> be left alone.
> 
> 

Ok, I will focus on ether_addr_equal in this patch, anymore will left alone. Thanks

Regards
Ding

> 
> 


