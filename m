Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaFEQLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:11:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52687 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFEQLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:11:03 -0400
Date: Thu, 5 Jun 2014 18:08:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
Message-ID: <20140605160842.GE16642@pd.tnic>
References: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org>
 <538F9AFA.5050806@zytor.com>
 <20140604224920.GB4126@pd.tnic>
 <538FB775.8070405@amacapital.net>
 <20140605071805.GA16647@pd.tnic>
 <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com>
 <20140605090206.GA16642@pd.tnic>
 <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com>
 <20140605155307.GD16642@pd.tnic>
 <CALCETrVqqgExhuAYawh_7tc8-Nm8GGiMxmtw25mLFoxru-odZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrVqqgExhuAYawh_7tc8-Nm8GGiMxmtw25mLFoxru-odZg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 09:01:02AM -0700, Andy Lutomirski wrote:
> NMI might be okay.  I haven't checked.

Well, if efi decides to do FPU math and it happens in NMI, we will have
to provide for proper contexts handling.

> It has to change back, though.  Completely unrealistic and useless example:
> 
> int ctxt = what_context_im_in();
> 
> set_up_the_fpu(ctxt);
> 
> // kprobe fires and changes the context
> // kprobe does something

And since we're being completely unrealistic, kprobe decides to use the
fpu too and uses it...

> // kprobe changes the context back
> 
> use the FPU.  Life is good.
> 
> put_back_the_fpu(ctxt);

So you probably need some way of mapping preallocated, per-cpu FPU
contexts to their users which can get and put them.

It's a whole different question whether that makes sense though, at all
or we simply remain conservative and don't do any efi in NMI context...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
