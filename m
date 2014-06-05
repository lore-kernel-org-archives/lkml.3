Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaFEJDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:03:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40349 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaFEJDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:03:02 -0400
Date: Thu, 5 Jun 2014 11:02:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
Message-ID: <20140605090206.GA16642@pd.tnic>
References: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org>
 <538F9AFA.5050806@zytor.com>
 <20140604224920.GB4126@pd.tnic>
 <538FB775.8070405@amacapital.net>
 <20140605071805.GA16647@pd.tnic>
 <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 09:49:08AM +0100, Matt Fleming wrote:
> On 5 June 2014 08:18, Borislav Petkov <bp@alien8.de> wrote:.
> >
> > How are you going to detect when to save/restore state? Do it
> > unconditionally would probably be a no-no. Even with all that optimized
> > XSAVE* fun.
> 
> (I'm not talking about the crypto async code because I'm not familiar with it)
> 
> For the EFI pstore case we'd only be using this newly allocated
> context space if we can't do the usual FPU xsave dance. e.g. we'd be
> adding a new feature specifically for the !irq_fpu_usable() case. Only
> then would we do an unconditional save. It would be useful to get some
> numbers for this but I don't think it would be too bad, especially
> given that it's in a fatal crash handler state anyway.
> 
> I don't think it's worth going to the trouble solely for the EFI
> pstore code, but if it can also be used for the crypto code it might
> be worth a look.

Right, if we do this only for special, slowpath cases, then we're
probably fine with unconditional. It would be simpler too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
