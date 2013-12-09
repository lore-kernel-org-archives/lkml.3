Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3LIKIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:08:54 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:65109 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3LIKIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:08:51 -0500
Message-ID: <52A5973A.7020509@gmail.com>
Date: Mon, 09 Dec 2013 18:11:06 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/zswap.c: add BUG() for default case in zswap_writeback_entry()
References: <52A53024.9090701@gmail.com> <52A5935A.4040709@imgtec.com>
In-Reply-To: <52A5935A.4040709@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 05:54 PM, James Hogan wrote:
> On 09/12/13 02:51, Chen Gang wrote:
>> Recommend to add default case to avoid compiler's warning, although at
>> present, the original implementation is still correct.
>>
>> The related warning (with allmodconfig for metag):
>>
>>     CC      mm/zswap.o
>>   mm/zswap.c: In function 'zswap_writeback_entry':
>>   mm/zswap.c:537: warning: 'ret' may be used uninitialized in this function
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  mm/zswap.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 5a63f78..bfd1807 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -585,6 +585,8 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
>>  
>>  		/* page is up to date */
>>  		SetPageUptodate(page);
>> +	default:
>> +		BUG();
> 
> This doesn't hide the warning when CONFIG_BUG=n since BUG() optimises
> out completely.
> 

When "CONFIG_BUG=n", it will report many related warnings (for me,
CONFIG_BUG need be as architecture specific config feature, not a
generic config feature -- most architectures always enable it).

So for common generic users, we can assume it will always have effect.


> Since the metag compiler is stuck on an old version (gcc 4.2.4), which
> is wrong to warn in this case, and newer versions of gcc don't appear to
> warn about it anyway (I just checked with gcc 4.7.2 x86_64), I have no
> objection to this warning remaining in the metag build.
> 

Do you try "EXTRA_CFLAGS=-W" with gcc 4.7.2? I guess it will report the
warning too, I don't feel the compiler is smart enough (except it lets
the long function zswap_get_swap_cache_page really inline)  :-)


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water and life which God blessed
