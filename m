Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3DVIBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:01:46 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:51770 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3DVIBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:01:44 -0400
Date: Mon, 22 Apr 2013 10:01:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, tiwai@suse.de,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: irq 16: nobody cared
Message-ID: <20130422080136.GA7080@gmail.com>
References: <20130421163002.GB3509@linux.vnet.ibm.com>
 <20130421165653.GA4623@pd.tnic>
 <20130421181035.GC4559@pd.tnic>
 <20130421185609.GD3509@linux.vnet.ibm.com>
 <20130421190655.GA5807@pd.tnic>
 <20130421203447.GE3509@linux.vnet.ibm.com>
 <20130421205139.GC5807@pd.tnic>
 <20130421214241.GA4593@pd.tnic>
 <20130421220015.GF3509@linux.vnet.ibm.com>
 <20130421221242.GB4593@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421221242.GB4593@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> From 3c155e9a22036839c09d98a4acbc7e17a5a3783c Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <bp@suse.de>
> Date: Sun, 21 Apr 2013 23:56:15 +0200
> Subject: [PATCH] RCU: Expedite grace periods during suspend/resume
> 
> Paul says CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by a
> factor of four. This, in turn, can change timings during suspend and can
> delay interrupts handling, leading to "IRQ XX: nobody cared" splats and
> the machine disabling those interrupt lines for no sensible reason.
> 
> Thus, we want to temporarily switch to expedited grace periods when
> suspending the box and return to normal settings when resuming. This
> patch does exactly that.

Hm, this really smells like a workaround: treating the symptom, not the 
cause.

How can an increase in grace-periods break drivers and suspend? Do we 
understand exactly what happens there? If we do, can we fix that instead 
of tweaking the RCU timeouts?

Thanks,

	Ingo
