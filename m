Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab3LWJN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 04:13:29 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:43481 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3LWJN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 04:13:27 -0500
Message-ID: <52B7FE84.4030302@huawei.com>
Date: Mon, 23 Dec 2013 17:12:36 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Antonio Quartulli <antonio@meshcoding.com>, Joe Perches <joe@perches.com>
CC: Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        "David S. Miller" <davem@davemloft.net>,
        <b.a.t.m.a.n@lists.open-mesh.org>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/21] batman-adv: slight optimization of addr compare
References: <52B7C5C5.2050304@huawei.com> <52B7F853.8050806@meshcoding.com> <1387789163.22671.62.camel@joe-AO722> <52B7FD01.9080006@meshcoding.com>
In-Reply-To: <52B7FD01.9080006@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/23 17:06, Antonio Quartulli wrote:
> On 23/12/13 09:59, Joe Perches wrote:
>> On Mon, 2013-12-23 at 09:46 +0100, Antonio Quartulli wrote:
>>> On 23/12/13 06:10, Ding Tianhong wrote:
>>>
>>> [...]
>>>
>>>> --- a/net/batman-adv/originator.c
>>>> +++ b/net/batman-adv/originator.c
>>>> @@ -41,7 +41,7 @@ int batadv_compare_orig(const struct hlist_node *node, const void *data2)
>>>>  	const void *data1 = container_of(node, struct batadv_orig_node,
>>>>  					 hash_entry);
>>>>  
>>>> -	return (memcmp(data1, data2, ETH_ALEN) == 0 ? 1 : 0);
>>>> +	return ether_addr_equal_unaligned(data1, data2) ? 1 : 0;
>>>
>>> ether_addr_equal_unaligned() returns a bool value which is implicitly
>>> converted to 1 or 0: there is no need for the ternary if anymore.
>>
>> Should these use batadv_compare_eth?
>>
> 
> That makes sense.
> 
> I was wondering whether we should get rid of batadv_compare_eth() at all
> and always use ether_addr_equal_unaligned(). The "unaligned explanation"
> is part of the name, so there is no need to use a commented helper anymore.
> 
> However, until that moment it is better to get stuck to
> batadv_compare_eth().
> 
> 
> Ding, can you also follow Joe's suggestion for this patch please?
> 
> 
> Thanks,
> 
> 
Ok



