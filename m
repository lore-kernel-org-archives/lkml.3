Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaIIJMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:12:08 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:48380 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbaIIJMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:12:06 -0400
Date: Tue, 9 Sep 2014 11:12:01 +0200
From: Robert Richter <rric@kernel.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Robert Richter <rrichter@cavium.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] GICv3: Fixing 32 bit compatibility
Message-ID: <20140909091201.GA4527@rric.localhost>
References: <1410185480-5153-1-git-send-email-rric@kernel.org>
 <20140909080042.GO23009@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140909080042.GO23009@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.14 10:00:42, Uwe Kleine-König wrote:
> On Mon, Sep 08, 2014 at 04:11:19PM +0200, Robert Richter wrote:

> > @@ -479,7 +479,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
> >     smp_wmb();
> >  
> >     for_each_cpu_mask(cpu, *mask) {
> > -           u64 cluster_id = cpu_logical_map(cpu) & ~0xffUL;
> > +           u64 cluster_id = cpu_logical_map(cpu) & ~0xffULL;
> This doesn't change anything, does it?

It does, not in 64 bit but in 32 bit there unsigned long is 32
bit. So, bit masks are broken if you compile a 32 bit kernel.

> I wonder if it would be cleaner to use (u64)0xff here.

No, that's ULL for. This is commonly used in x86 too.

-Robert
