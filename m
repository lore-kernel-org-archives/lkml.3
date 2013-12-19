Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3LSRJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:09:34 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:43850 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3LSRJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:09:32 -0500
Date: Thu, 19 Dec 2013 18:09:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] x86: sysfb: remove sysfb when probing real hw
Message-ID: <20131219170927.GC30382@gmail.com>
References: <1387374611-12493-1-git-send-email-dh.herrmann@gmail.com>
 <1387448038-8260-1-git-send-email-dh.herrmann@gmail.com>
 <20131219163606.GA29243@gmail.com>
 <CANq1E4Ss30G72t3R1iza9vOO7ESYQynjS74mB+nJ-zT2zAvyzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4Ss30G72t3R1iza9vOO7ESYQynjS74mB+nJ-zT2zAvyzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Herrmann <dh.herrmann@gmail.com> wrote:

> Hi
> 
> On Thu, Dec 19, 2013 at 5:36 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * David Herrmann <dh.herrmann@gmail.com> wrote:
> >
> >> --- a/drivers/video/fbmem.c
> >> +++ b/drivers/video/fbmem.c
> >> @@ -35,6 +35,9 @@
> >>
> >>  #include <asm/fb.h>
> >>
> >> +#if IS_ENABLED(CONFIG_X86)
> >> +#include <asm/sysfb.h>
> >> +#endif
> >
> > I think this can be written as:
> >
> > #ifdef CONFIG_X86
> > # include <asm/sysfb.h>
> > #endif
> >
> > also ... the dependency on a large, unrelated option like CONFIG_X86
> > looks pretty ugly here - is there no other, more specific CONFIG_
> > option that can be used here - such as CONFIG_FB_SIMPLE or
> > CONFIG_X86_SYSFB?
> >
> >> +#if IS_ENABLED(CONFIG_X86)
> >> +     sysfb_unregister(apert, primary);
> >> +#endif
> >
> > Ditto.
> 
> CONFIG_X86 is probably never 'm'.. will fix that. It was 
> CONFIG_X86_SYSFB before and that works, too, but the broader X86 
> seemed more appropriate as sysfb is available on all x86.

Well, sysfb is available if CONFIG_X86_SYSFB is set, right? So on 
!CONFIG_X86_SYSFB x86 kernels this code should not run, right?

> Note that I have patches here locally which move 
> sysfb_register/unregister to drivers/video/sysfb.c and add 
> include/linux/sysfb.h with dummies if CONFIG_SYSFB is not selected 
> to avoid the #ifdef. This will allow other architectures to do 
> gfx-hand-over, too. They seem too big for stable, though. That's why 
> I split them up and added it to x86/kernel/sysfb.c first.

Yeah, it's fine to do those cleanups after the minimal fix. But using 
a sensible config option must still be done - we cannot just slap 
broad CONFIG_X86 dependencies into random code.

Thanks,

	Ingo
