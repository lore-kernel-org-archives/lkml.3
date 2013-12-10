Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3LJCOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:14:23 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49731 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3LJCOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:14:18 -0500
Message-ID: <52A67973.20904@gmail.com>
Date: Tue, 10 Dec 2013 10:16:19 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Seth Jennings <sjennings@variantweb.net>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH] mm/zswap.c: add BUG() for default case in zswap_writeback_entry()
References: <52A53024.9090701@gmail.com> <20131209153626.GA3752@cerebellum.variantweb.net>
In-Reply-To: <20131209153626.GA3752@cerebellum.variantweb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 11:36 PM, Seth Jennings wrote:
> On Mon, Dec 09, 2013 at 10:51:16AM +0800, Chen Gang wrote:
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
> Typically, the way you want to address this is initialize ret to 0
> at declaration time if not every control path will set that value.
> 

At least, your suggestion sounds reasonable.

But I am also aware that normally need content 'default' for 'switch',
so I choose this fix way.

And sorry, current patch is incorrect (need 'break' before 'default'),
so if no additional suggestions or discussions or completions, I
will/should send patch v2 for it.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water and life which God blessed
