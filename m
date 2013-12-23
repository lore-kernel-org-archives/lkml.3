Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3LWJJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 04:09:38 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:60088 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab3LWJJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 04:09:36 -0500
Message-ID: <52B7FDB2.6090700@huawei.com>
Date: Mon, 23 Dec 2013 17:09:06 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Antonio Quartulli <antonio@meshcoding.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        "David S. Miller" <davem@davemloft.net>,
        <b.a.t.m.a.n@lists.open-mesh.org>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/21] batman-adv: slight optimization of addr compare
References: <52B7C5C5.2050304@huawei.com> <52B7F853.8050806@meshcoding.com>
In-Reply-To: <52B7F853.8050806@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/23 16:46, Antonio Quartulli wrote:
> On 23/12/13 06:10, Ding Tianhong wrote:
> 
> [...]
> 
>> --- a/net/batman-adv/originator.c
>> +++ b/net/batman-adv/originator.c
>> @@ -41,7 +41,7 @@ int batadv_compare_orig(const struct hlist_node *node, const void *data2)
>>  	const void *data1 = container_of(node, struct batadv_orig_node,
>>  					 hash_entry);
>>  
>> -	return (memcmp(data1, data2, ETH_ALEN) == 0 ? 1 : 0);
>> +	return ether_addr_equal_unaligned(data1, data2) ? 1 : 0;
> 
> ether_addr_equal_unaligned() returns a bool value which is implicitly
> converted to 1 or 0: there is no need for the ternary if anymore.
> 
> 
>>  }
>>  
>>  /**
>> diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
>> index 4add57d..5e66d4b 100644
>> --- a/net/batman-adv/translation-table.c
>> +++ b/net/batman-adv/translation-table.c
>> @@ -51,7 +51,7 @@ static int batadv_compare_tt(const struct hlist_node *node, const void *data2)
>>  	const void *data1 = container_of(node, struct batadv_tt_common_entry,
>>  					 hash_entry);
>>  
>> -	return (memcmp(data1, data2, ETH_ALEN) == 0 ? 1 : 0);
>> +	return ether_addr_equal_unaligned(data1, data2) ? 1 : 0;
> 
> same here
> 
> 
> Moreover, include linux/etherdevice.h in both files as explained in
> point 1) of Documentation/SubmitChecklist
> 
> Thanks.
> 
> 
> 
> Cheers,
> 

Yes, thanks a lot, fix it soon.

Regards
Ding



