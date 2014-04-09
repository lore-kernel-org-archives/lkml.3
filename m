Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbaDITng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:43:36 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:58523 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaDITne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:43:34 -0400
MIME-Version: 1.0
In-Reply-To: <5342AEEF.4080503@windriver.com>
References: <20140322154720.GA23863@www.outflux.net>
	<CAGXu5jL+o4dG+ruUDh-+5LY=iD0veWaimBUq3cJBtuCiNbYt1A@mail.gmail.com>
	<5342AEEF.4080503@windriver.com>
Date: Wed, 9 Apr 2014 12:43:33 -0700
X-Google-Sender-Auth: OQtpwDo_FzRgr3gIoleDQKyTDVE
Message-ID: <CAGXu5jL=p3xRxAxaobqXsXda7V9bU5fnKUB-vHL4Pm-UVWPs=Q@mail.gmail.com>
Subject: Re: [PATCH] mips: export icache_flush_range
From: Kees Cook <keescook@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sanjay Lal <sanjayl@kymasys.com>, John Crispin <blogic@openwrt.org>,
        linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 6:58 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On 14-03-22 03:05 PM, Kees Cook wrote:
>> On Sat, Mar 22, 2014 at 9:47 AM, Kees Cook <keescook@chromium.org> wrote:
>>> The lkdtm module performs tests against executable memory ranges, so
>>> it needs to flush the icache for proper behaviors. Other architectures
>>> already export this, so do the same for MIPS.
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>> This is currently untested! I'm building a MIPS cross-compiler now...
>>> If someone can validate this fixes the build when lkdtm is a module,
>>> that would be appreciated. :)
>>
>> Okay, now tested. I reproduced the failure and this patch fixes it. :)
>
> Just checking if this happened to fall through the cracks.
> The most recent (Apr4) linux-next build for mips still fails
> with this error.
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/10877159/

Ralf, you acked this offlist, but someone needs to pull this into the tree?

On Mar 24, Ralf Baechle wrote:
> Acked-by: Ralf Baechle <ralf@linux-mips.org>

Thanks!

-Kees

>
> Paul.
> --
>
>>
>> -Kees
>>
>>> ---
>>>  arch/mips/mm/cache.c |    1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
>>> index fde7e56d13fe..b3f1df13d9f6 100644
>>> --- a/arch/mips/mm/cache.c
>>> +++ b/arch/mips/mm/cache.c
>>> @@ -38,6 +38,7 @@ void (*__flush_kernel_vmap_range)(unsigned long vaddr, int size);
>>>  void (*__invalidate_kernel_vmap_range)(unsigned long vaddr, int size);
>>>
>>>  EXPORT_SYMBOL_GPL(__flush_kernel_vmap_range);
>>> +EXPORT_SYMBOL_GPL(flush_icache_range);
>>>
>>>  /* MIPS specific cache operations */
>>>  void (*flush_cache_sigtramp)(unsigned long addr);
>>> --
>>> 1.7.9.5
>>>
>>>
>>> --
>>> Kees Cook
>>> Chrome OS Security
>>
>>
>>



-- 
Kees Cook
Chrome OS Security
