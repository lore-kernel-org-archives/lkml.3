Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab3BVSph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:45:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:59632 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3BVSpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:45:35 -0500
Date: Fri, 22 Feb 2013 19:45:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, fweisbec@gmail.com, john.stultz@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/2][RFC] time : set broadcast irq affinity
In-Reply-To: <20130222095530.377fd218@chromoly>
Message-ID: <alpine.LFD.2.02.1302221945170.22263@ionos>
References: <5123C299.3080005@linaro.org> <1361484083-5906-1-git-send-email-daniel.lezcano@linaro.org> <1361484083-5906-2-git-send-email-daniel.lezcano@linaro.org> <20130222095530.377fd218@chromoly>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Jacob Pan wrote:
> On Thu, 21 Feb 2013 23:01:23 +0100
> Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> 
> > +/*
> > + * Set broadcast interrupt affinity
> > + */
> > +static void tick_broadcast_set_affinity(struct clock_event_device
> > *bc, int cpu) +{
> > +	struct cpumask cpumask;
> > +
> > +	if (!(bc->features & CLOCK_EVT_FEAT_DYNIRQ))
> > +		return;
> > +
> > +	cpumask_clear(&cpumask);
> > +	cpumask_set_cpu(cpu, &cpumask);
> > +	irq_set_affinity(bc->irq, &cpumask);
> would it be more efficient to keep track of the current bc->irq affinity
> via cpumask then set it only if it is different?

You beat me :)
