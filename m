Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3C2QTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:19:08 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:14953 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3C2QTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:19:07 -0400
Date: Fri, 29 Mar 2013 17:19:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 00/34] idle: Consolidate idle implementations
Message-ID: <20130329161905.GC6201@merkur.ravnborg.org>
References: <20130321214930.752934102@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321214930.752934102@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:52:56PM -0000, Thomas Gleixner wrote:
> Each architecture implements its own cpu_idle() code, which is more or
> less the same on all architectures (plus/minus a few bugs and a few
> missing extra functionalities, instrumentation ...). That also forces
> everyone who is interested in idle related features to add new
> functionality to every architecture. What a waste.
> 
> Aside of that pointless code duplicaiton the ongoing quest to
> consolidate the cpu hotplug code needs a common entry point for the
> non boot cpus.
> 
> The following series implements a generic idle function and converts
> most architectures over. I left out SPARC (it involves sparc asm) and
> UM (it made me barf). If we can move those architectures as well, we
> can get rid of the extra config switch and have everything
> consolidated.
> 
> I spent a lot of time to make sure that the conversion preserved the
> non obvious differences of the architecture implementations, but I
> really need help from the affected maintainers to prove the
> correctness.

Hi Thomas.

Where can I find the git tree with the latest patches?
Or do you plan to submit a v2 soon?

	Sam
