Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422800Ab3CVUJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:09:11 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:53549 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422691Ab3CVUJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:09:09 -0400
Date: Fri, 22 Mar 2013 21:09:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 00/34] idle: Consolidate idle implementations
Message-ID: <20130322200907.GA29202@merkur.ravnborg.org>
References: <20130321214930.752934102@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321214930.752934102@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas.
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
I wanted to take a quick look at sparc - but build failed
after applying patch 1-5. Looks like the same issue Tony already
reaported.

At very first glnce it looks straightforward to convert
both sparc32 and sparc64.
The assembler stuff used by sparc64 fits into one of the arch functions
as far as I could see.

When I get back from vacation I may take a look.

	Sam
