Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3CRTBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:01:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38415 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab3CRTBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:01:43 -0400
Message-ID: <51476402.7050102@zytor.com>
Date: Mon, 18 Mar 2013 11:59:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Lin Feng <linfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, penberg@kernel.org,
        jacob.shin@amd.com
Subject: Re: [PATCH] x86: mm: accurate the comments for STEP_SIZE_SHIFT macro
References: <1363602068-11924-1-git-send-email-linfeng@cn.fujitsu.com> <CAE9FiQWuSL5Vq5VaAvQg_NT2gQJr17eMNoQbxtNJ8G3wweWNHQ@mail.gmail.com>
In-Reply-To: <CAE9FiQWuSL5Vq5VaAvQg_NT2gQJr17eMNoQbxtNJ8G3wweWNHQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 11:53 AM, Yinghai Lu wrote:
> On Mon, Mar 18, 2013 at 3:21 AM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
>> For x86 PUD_SHIFT is 30 and PMD_SHIFT is 21, so the consequence of
>> (PUD_SHIFT-PMD_SHIFT)/2 is 4. Update the comments to the code.
>>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
>> ---
>>  arch/x86/mm/init.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
>> index 59b7fc4..637a95b 100644
>> --- a/arch/x86/mm/init.c
>> +++ b/arch/x86/mm/init.c
>> @@ -389,7 +389,7 @@ static unsigned long __init init_range_memory_mapping(
>>         return mapped_ram_size;
>>  }
>>
>> -/* (PUD_SHIFT-PMD_SHIFT)/2 */
>> +/* (PUD_SHIFT-PMD_SHIFT)/2+1 */
>>  #define STEP_SIZE_SHIFT 5
>>  void __init init_mem_mapping(void)
>>  {
> 
> 9/2=4.5, so it becomes 5.
> 

No, it doesn't.  This is C, not elementary school  Now I'm really bothered.

The comment doesn't say *why* (PUD_SHIFT-PMD_SHIFT)/2 or any other
variant is correct, furthermore I suspect that the +1 is misplaced.
However, what is really needed is:

1. Someone needs to explain what the logic should be and why, and
2. replace the macro with a symbolic macro, not with a constant and a
   comment explaining, incorrectly, how that value was derived.

	-hpa

