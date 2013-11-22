Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3KVW2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:28:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:47473 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3KVW2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:28:05 -0500
Date: Fri, 22 Nov 2013 23:27:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Francis Moreau <francis.moro@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
In-Reply-To: <2363041.q8n2SXViVK@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.02.1311222322480.30673@ionos.tec.linutronix.de>
References: <20131117195358.GO27323@pd.tnic> <24318767.PoCLxGCZH4@vostro.rjw.lan> <528FCE57.2000805@gmail.com> <2363041.q8n2SXViVK@vostro.rjw.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013, Rafael J. Wysocki wrote:
> On Friday, November 22, 2013 10:36:23 PM Francis Moreau wrote:
> > Ok, I've finally managed to find out the bad commit:
> > ad07277e82dedabacc52c82746633680a3187d25: ACPI / PM: Hold acpi_scan_lock
> > over system PM transitions
> > 
> > I verified that the parent commit doesn't have the problem.
> 
> Interesting.
> 
> > Rafael, you're the man now ;)
> 
> I kind of don't see how that commit may result in behavior that you
> described earlier in the thread.
> 
> You get a memory corruption that seems to have started to happen because
> we're holding an additional lock over suspend resume now.  Something's fishy
> on that machine and we need to figure out what it is.

The hickup happens in the timer softirq.

@Francis: Did you try to enable DEBUG_OBJECTS.*. If not please give it
	  a try.

Thanks,

	tglx


