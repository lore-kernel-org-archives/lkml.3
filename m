Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaDGN6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:58:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:60182 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaDGN6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:58:50 -0400
Message-ID: <5342AEEF.4080503@windriver.com>
Date: Mon, 7 Apr 2014 09:58:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Sanjay Lal <sanjayl@kymasys.com>,
        John Crispin <blogic@openwrt.org>, <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mips: export icache_flush_range
References: <20140322154720.GA23863@www.outflux.net> <CAGXu5jL+o4dG+ruUDh-+5LY=iD0veWaimBUq3cJBtuCiNbYt1A@mail.gmail.com>
In-Reply-To: <CAGXu5jL+o4dG+ruUDh-+5LY=iD0veWaimBUq3cJBtuCiNbYt1A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-03-22 03:05 PM, Kees Cook wrote:
> On Sat, Mar 22, 2014 at 9:47 AM, Kees Cook <keescook@chromium.org> wrote:
>> The lkdtm module performs tests against executable memory ranges, so
>> it needs to flush the icache for proper behaviors. Other architectures
>> already export this, so do the same for MIPS.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> This is currently untested! I'm building a MIPS cross-compiler now...
>> If someone can validate this fixes the build when lkdtm is a module,
>> that would be appreciated. :)
> 
> Okay, now tested. I reproduced the failure and this patch fixes it. :)

Just checking if this happened to fall through the cracks.
The most recent (Apr4) linux-next build for mips still fails
with this error.

http://kisskb.ellerman.id.au/kisskb/buildresult/10877159/

Paul.
--

> 
> -Kees
> 
>> ---
>>  arch/mips/mm/cache.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
>> index fde7e56d13fe..b3f1df13d9f6 100644
>> --- a/arch/mips/mm/cache.c
>> +++ b/arch/mips/mm/cache.c
>> @@ -38,6 +38,7 @@ void (*__flush_kernel_vmap_range)(unsigned long vaddr, int size);
>>  void (*__invalidate_kernel_vmap_range)(unsigned long vaddr, int size);
>>
>>  EXPORT_SYMBOL_GPL(__flush_kernel_vmap_range);
>> +EXPORT_SYMBOL_GPL(flush_icache_range);
>>
>>  /* MIPS specific cache operations */
>>  void (*flush_cache_sigtramp)(unsigned long addr);
>> --
>> 1.7.9.5
>>
>>
>> --
>> Kees Cook
>> Chrome OS Security
> 
> 
> 
