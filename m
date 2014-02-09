Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaBIOUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 09:20:53 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:49366 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaBIOUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 09:20:51 -0500
Date: Sun, 9 Feb 2014 15:20:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bin Gao <bin.gao@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v3 1/2] x86, tsc: Fallback to normal calibration if fast
 MSR calibration fails
Message-ID: <20140209142048.GA28126@gmail.com>
References: <20140206054410.GB18884@gmail.com>
 <1391687365-10922-1-git-send-email-mika.westerberg@linux.intel.com>
 <alpine.DEB.2.02.1402061531310.21991@ionos.tec.linutronix.de>
 <20140206151117.GL18029@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206151117.GL18029@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mika Westerberg <mika.westerberg@linux.intel.com> wrote:

> On Thu, Feb 06, 2014 at 03:34:18PM +0100, Thomas Gleixner wrote:
> > On Thu, 6 Feb 2014, Mika Westerberg wrote:
> > >  arch/x86/kernel/tsc.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> > > index 19e5adb49a27..56facfc54575 100644
> > > --- a/arch/x86/kernel/tsc.c
> > > +++ b/arch/x86/kernel/tsc.c
> > > @@ -655,10 +655,11 @@ unsigned long native_calibrate_tsc(void)
> > >  	local_irq_save(flags);
> > >  	i = try_msr_calibrate_tsc(&fast_calibrate);
> > >  	local_irq_restore(flags);
> > > -	if (i >= 0) {
> > > -		if (i == 0)
> > > -			pr_warn("Fast TSC calibration using MSR failed\n");
> > > +	if (i > 0) {
> > >  		return fast_calibrate;
> > > +	} else if (i == 0) {
> > > +		pr_warn("Fast TSC calibration using MSR failed\n");
> > > +		/* Continue with the normal calibration */
> > >  	}
> > 
> > Bah. Can we please fix that proper. The whole 0,1,-1 return value from
> > try_msr_calibrate_tsc() is just horrible. Why not doing the obvious?
> 
> Yes, that looks better and works fine, thanks.
> 
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Please resend the two updated/fixed patches in a new thread.

Thanks,

	Ingo
