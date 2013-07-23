Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3GWC2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:28:18 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:40702 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3GWC2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:28:17 -0400
Message-ID: <51EDEA39.3000400@ozlabs.ru>
Date: Tue, 23 Jul 2013 12:28:09 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] hashtable: add hash_for_each_possible_rcu_notrace()
References: <1373084210-27767-1-git-send-email-aik@ozlabs.ru> <51E3C92B.2070704@ozlabs.ru>
In-Reply-To: <51E3C92B.2070704@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone, ping. Is it good, bad, ugly (ack/nack)? Thanks!

Is there any "trivial patches" list? Could not find it on vger.


On 07/15/2013 08:04 PM, Alexey Kardashevskiy wrote:
> Anyone, ping?
> 
> On 07/06/2013 02:16 PM, Alexey Kardashevskiy wrote:
>> This adds hash_for_each_possible_rcu_notrace() which is basically
>> a notrace clone of hash_for_each_possible_rcu() which cannot be
>> used in real mode due to its tracing/debugging capability.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>  include/linux/hashtable.h | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/include/linux/hashtable.h b/include/linux/hashtable.h
>> index a9df51f..af8b169 100644
>> --- a/include/linux/hashtable.h
>> +++ b/include/linux/hashtable.h
>> @@ -174,6 +174,21 @@ static inline void hash_del_rcu(struct hlist_node *node)
>>  		member)
>>  
>>  /**
>> + * hash_for_each_possible_rcu_notrace - iterate over all possible objects hashing
>> + * to the same bucket in an rcu enabled hashtable in a rcu enabled hashtable
>> + * @name: hashtable to iterate
>> + * @obj: the type * to use as a loop cursor for each entry
>> + * @member: the name of the hlist_node within the struct
>> + * @key: the key of the objects to iterate over
>> + *
>> + * This is the same as hash_for_each_possible_rcu() except that it does
>> + * not do any RCU debugging or tracing.
>> + */
>> +#define hash_for_each_possible_rcu_notrace(name, obj, member, key)	\
>> +	hlist_for_each_entry_rcu_notrace(obj, &name[hash_min(key, HASH_BITS(name))],\
>> +		member)
>> +
>> +/**
>>   * hash_for_each_possible_safe - iterate over all possible objects hashing to the
>>   * same bucket safe against removals
>>   * @name: hashtable to iterate
>>
> 
> 


-- 
Alexey
