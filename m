Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3K0OgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:36:17 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61731 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3K0OgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:36:15 -0500
Date: Wed, 27 Nov 2013 15:36:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>, arjan@linux.intel.com,
        linux@roeck-us.net, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: override __compiletime_object_size()
Message-ID: <20131127143611.GE25043@gmail.com>
References: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
 <20131026103109.GC14949@gmail.com>
 <526F914A02000078000FD806@nat28.tlf.novell.com>
 <20131029095408.GB25306@gmail.com>
 <526F971F02000078000FD841@nat28.tlf.novell.com>
 <20131029101257.GA25953@gmail.com>
 <529385AF0200007800106C84@nat28.tlf.novell.com>
 <20131127140332.GC24403@gmail.com>
 <52960DD202000078001079D8@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52960DD202000078001079D8@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 27.11.13 at 15:03, Ingo Molnar <mingo@kernel.org> wrote:
> 
> > * Jan Beulich <JBeulich@suse.com> wrote:
> > 
> >> As discussed in the context of commits 3df7b41a ("x86: Unify
> >> copy_from_user() size checking") and 7a3d9b0f ("x86: Unify
> >> copy_to_user() and add size checking to it"), we want to leverage
> >> __builtin_object_size() also on newer gcc versions, but with other
> >> architectures still using another model of copy_*_user() verification
> >> we can't replace the global definition. Do it in the (only) header
> >> needing the construct for now.
> >> 
> >> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >> Cc: Arjan van de Ven <arjan@linux.intel.com>
> >> Cc: Guenter Roeck <linux@roeck-us.net>
> >> ---
> >>  arch/x86/include/asm/uaccess.h |    6 ++++++
> >>  1 file changed, 6 insertions(+)
> >> 
> >> --- 3.13-rc1/arch/x86/include/asm/uaccess.h
> >> +++ 3.13-rc1-x86-compiletime-object-size/arch/x86/include/asm/uaccess.h
> >> @@ -584,6 +584,12 @@ __copy_from_user_overflow(int size, unsi
> >>  
> >>  #endif
> >>  
> >> +/* linux/compiler-gcc4.h restricts this to gcc < 4.6, which doesn't suit us. */
> >> +#if defined(__GNUC__) && GCC_VERSION >= 40100
> >> +# undef __compiletime_object_size
> >> +# define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
> >> +#endif
> >> +
> > 
> > Would be nice to have a more verbose changelog that explains what 
> > benefits this brings us.
> 
> That makes no sense to me - the benefits of this construct should 
> have been explained with its introduction; the change here just 
> makes it being used under wider range of compilers (and the code 
> comment already says exactly that).

Yes indeed - I should have read the referenced changelog...

Thanks, will apply it as-is, if there are no objections from others.

Thanks,

	Ingo
