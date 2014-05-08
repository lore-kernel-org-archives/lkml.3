Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaEHKWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:22:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:53865 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaEHKWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:22:30 -0400
Date: Thu, 8 May 2014 12:22:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: LKML <linux-kernel@vger.kernel.org>, Tony Lu <zlu@tilera.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 03/32] genirq: Provide generic hwirq allocation
 facility
In-Reply-To: <alpine.DEB.2.02.1405072259230.6261@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1405081140410.6261@ionos.tec.linutronix.de>
References: <20140507153622.703412101@linutronix.de> <20140507154334.208629358@linutronix.de> <536A998A.4000307@tilera.com> <alpine.DEB.2.02.1405072259230.6261@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Thomas Gleixner wrote:
> Now on top of that we need irq domain support for this kind of matrix
> mappings down to the vector level and everything else falls in
> place. I have not thought through the irq domain angle, but maybe
> Grant/Ben can give some input on that.

Just talked to Grant to get my irqdomain foo up to speed.

irq domains support parent irq domains already, which allow you to
request an irq from the parent.

What's missing is:

- a bitmap based matrix vector allocator, but that shouldn't be rocket
  science to write one.

- a mechanism to hand a cpumask down in the allocation chain

- a shortcut support to avoid multi level map lookups for the fast
  path.

Once we have that everything just falls in place and when tile and x86
are switched over we can rip out the LEGACY allocator again. That'll
leave itanic with its homebrewn create_irq machinery, but I'm happy to
ignore that as this is almost completely confined in ia64 code where
is can bitrot happily until it sinks.

Thanks,

	tglx
