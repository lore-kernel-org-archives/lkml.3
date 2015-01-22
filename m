Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbbAVNIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:08:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:59727 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbAVNIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:08:52 -0500
Date: Thu, 22 Jan 2015 14:08:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 11/23] x86/x2apic: Split enable and setup function
In-Reply-To: <20150116190018.GK18880@pd.tnic>
Message-ID: <alpine.DEB.2.11.1501221407490.5526@nanos>
References: <20150115210458.625399149@linutronix.de> <20150115211703.129287153@linutronix.de> <20150116190018.GK18880@pd.tnic>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Borislav Petkov wrote:
> On Thu, Jan 15, 2015 at 09:22:26PM -0000, Thomas Gleixner wrote:
> > +/* Called from cpu_init() to enable x2apic on (secondary) cpus */
> > +void x2apic_setup(void)
> > +{
> > +	/*
> > +	 * If x2apic is not in ON state, disable it if already enabled
> > +	 * from BIOS.
> > +	 */
> > +	if (x2apic_state != X2APIC_ON) {
> > +		if (cpu_has_apic)
> 
> Let's move this test into disable_x2apic() so that callers don't have to
> pay attention.

Si, senor!
 
> >  	x86_configure_nx();
> > -	enable_x2apic();
> > +	x2apic_setup();
> 
> 64-bit only?
> 
> I'd guess so since the original call enable_x2apic() is 64-bit only too
> but why?

Don't ask me. :)
