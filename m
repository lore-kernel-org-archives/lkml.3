Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3LBKts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:49:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:43431 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3LBKtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:49:46 -0500
Date: Mon, 2 Dec 2013 11:49:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Francis Moreau <francis.moro@gmail.com>
cc: Jingoo Han <jg1.han@samsung.com>, "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
In-Reply-To: <5299FF38.7060203@gmail.com>
Message-ID: <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de>
References: <20131117195358.GO27323@pd.tnic> <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com> <1821758.2MoNI3h1Mv@vostro.rjw.lan> <52985041.5050000@gmail.com> <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de>
 <5299FF38.7060203@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Nov 2013, Francis Moreau wrote:
> Hello Thomas,
> 
> Sorry for the delay.
> 
> On 11/29/2013 10:02 AM, Thomas Gleixner wrote:
> > On Fri, 29 Nov 2013, Francis Moreau wrote:
> >> Since it seems to be related to rtsx driver or its upper layer, could
> >> the folks involved in this area have a look to this issue please ?
> > 
> > I'm not involved, but looking at the debug objects backtrace it's
> > related to the delayed work in rtsx.
> > 
> > Does the untested patch below cure the issue?
> > 
> 
> It seems it does since I can't see the debug object trace anymore
> however Ican see this now:

<SNIP>
 
> So I don't think it completely solve the problem but it's a good start.

I kinda expected that, but I wanted to confirm my suspicion, that the
interrupt hits after the delayed work is canceled and just requeues it
again, which then leads to an armed timer being freed further down.

I'm not familiar with that driver and I leave the final fixup to the
driver maintainers. It's enough data for them to figure out the real
solution.

Thanks,

	tglx


