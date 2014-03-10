Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaCJUuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:50:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:53639 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaCJUuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:50:19 -0400
Date: Mon, 10 Mar 2014 21:50:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <1394479176.18058.10.camel@x41>
Message-ID: <alpine.DEB.2.02.1403102122310.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>  <1394447253.2979.12.camel@x220>  <alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de>  <1394465314.12752.18.camel@x220>  <alpine.DEB.2.02.1403101757320.18573@ionos.tec.linutronix.de>  <1394476346.12752.43.camel@x220>
  <alpine.DEB.2.02.1403101956250.18573@ionos.tec.linutronix.de> <1394479176.18058.10.camel@x41>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014, Paul Bolle wrote:
> Thomas Gleixner schreef op ma 10-03-2014 om 19:57 [+0100]:
> > On Mon, 10 Mar 2014, Paul Bolle wrote:
> > > 
> > > Or is there a way to handle the "SMI nonsense" (whatever that may be)?
> > 
> > No, there is none. That's "value add" from the BIOS/board manufacturer
> > which utilizes the System Management Interrupt and steals CPU time
> > from the OS.
> 
> So could you please consider downgrading this message?
>
> Yes, this will make regressions less visible, although I'm unsure we're
> actually seeing a regression here. But I think that this is better than
> scaring people about a situation they can't easily do something about,
> if at all. Especially since fast TSC calibration failures, apparently,
> can be worked around.

If something works fine from version X up to v3.13 and then suddenly
fails, then we can safely ignore it because there is a work around or
fallback? And just shrug and say: Oh, it's not a regression.

Dammit no. We want to know WHY!

I'm not going to downgrade that message for a simple reason.

A lot of people including me spent quite some precious time to work
around the brainwreckage of

 - those who invented the concept of unreliable hardware (TSC) in the
   first place

 - the BIOS/board manufacturers who add crap to their BIOSes which
   renders it even more unusable. Yes, even the slow calibration fails
   due to that.

And now you whine because we tell loudly, that the hardware/BIOS is
crap?

You're barking up the wrong tree:

       Go and tell your hardware supplier!

But sure, it's simpler to submit a patch which makes that issue less
visible just because you don't like the verbosity of those who made it
work for YOU in the first place.

Thanks,

	tglx
