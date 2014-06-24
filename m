Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaFXHgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:36:12 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57338 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaFXHgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:36:11 -0400
Message-ID: <53A92A5B.4070403@linux.vnet.ibm.com>
Date: Tue, 24 Jun 2014 15:35:55 +0800
From: Lei Li <lilei@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: hannes@cmpxchg.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH] Documentation: Update remove_from_page_cache with delete_from_page_cache
References: <1403514679-24632-1-git-send-email-lilei@linux.vnet.ibm.com> <20140623092305.GF9743@dhcp22.suse.cz>
In-Reply-To: <20140623092305.GF9743@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062407-5564-0000-0000-00000E8FA556
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/23/2014 05:23 PM, Michal Hocko wrote:
> On Mon 23-06-14 17:11:19, Lei Li wrote:
>> remove_from_page_cache has been renamed to delete_from_page_cache
>> since Commit 702cfbf9 ("mm: goodbye remove_from_page_cache()"), adapt
>> to it in Memcg documentation.
>>
>> Signed-off-by: Lei Li <lilei@linux.vnet.ibm.com>
> This conflicts with the current mmotm tree because of Johannes' {un}charge rewrite.
> Anyway the comment is not up-to-date anyway. __delete_from_page_cache is
> called from more places and I do not see quite a good reason why to keep
> this in the documentation.
> I would just remove this note as it doesn't serve any useful purpose.

Thanks for your reply.
Just take a quick look at Johannes' patch of rewriting uncharge API. I'll
resend a patch with the note removed.


Thanks,

Lei

>
>> ---
>>   Documentation/cgroups/memcg_test.txt | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
>> index 80ac454..b2d6ccc 100644
>> --- a/Documentation/cgroups/memcg_test.txt
>> +++ b/Documentation/cgroups/memcg_test.txt
>> @@ -171,10 +171,10 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
>>   	- add_to_page_cache_locked().
>>   
>>   	uncharged at
>> -	- __remove_from_page_cache().
>> +	- __delete_from_page_cache().
>>   
>>   	The logic is very clear. (About migration, see below)
>> -	Note: __remove_from_page_cache() is called by remove_from_page_cache()
>> +	Note: __delete_from_page_cache() is called by delete_from_page_cache()
>>   	and __remove_mapping().
>>   
>>   6. Shmem(tmpfs) Page Cache
>> -- 
>> 1.8.5.3
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

