Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaLWJTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:19:51 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48752 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLWJTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:19:49 -0500
Date: Tue, 23 Dec 2014 10:19:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave@sr71.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 1/2] x86, mpx: explicitly disable 32-bit MPX support on
 64-bit kernels
Message-ID: <20141223091944.GB9112@gmail.com>
References: <20141222200803.D316DA2A@viggo.jf.intel.com>
 <20141222200804.18A7A803@viggo.jf.intel.com>
 <CALCETrWAgPjLTA-iSabFmqVKiOKGPGgDgSWdjz3wsncs1X+WOg@mail.gmail.com>
 <54987D4F.3000908@sr71.net>
 <CALCETrXF11MeP8vc4eKqJz+2OOYQzmrK_erVEz=pZS3c=YWibw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXF11MeP8vc4eKqJz+2OOYQzmrK_erVEz=pZS3c=YWibw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> On Mon, Dec 22, 2014 at 12:21 PM, Dave Hansen <dave@sr71.net> wrote:
> > On 12/22/2014 12:17 PM, Andy Lutomirski wrote:
> >>> >         /*
> >>> > +        * 32-bit binaries on 64-bit kernels are currently
> >>> > +        * unsupported.
> >>> > +        */
> >>> > +       if (IS_ENABLED(CONFIG_X86_64) && test_thread_flag(TIF_IA32))
> >>> > +               return MPX_INVALID_BOUNDS_DIR;
> >> Should this check mm->ia32_compat instead?
> >
> > set_personality_64bit/ia32() seem to make that and TIF_IA32 awfully
> > equivalent.  Is there a specific reason for wanting it done this way?
> 
> My general desire to remove various bogus TIF_IA32 references. 
> [...]

So we generally want to use mm->context.ia32_compat instead of 
TIF_IA32, because in the end TIF_IA32 will go away altogether?

Or do you just want to audit all TIF_IA32 places (because most of 
them are wrong), and using mm->context.ia32_compat where it's 
justified and eliminating TIF_IA32 use is a nice way to document 
that ongoing audit without breaking stuff and such?

> [...]  But this is only temporary, so I don't really care.

New code that touches this area should better use new principles, 
so I have no problem with requiring this, as long as it's well 
explained and logical and desirable to everyone.

Thanks,

	Ingo
