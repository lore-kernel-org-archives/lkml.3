Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3EOJuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:50:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:56325 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3EOJuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:50:17 -0400
Date: Wed, 15 May 2013 11:50:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 13/15] clockevents: Provide sysfs interface
In-Reply-To: <20130426223729.GA782@sboyd-linux.qualcomm.com>
Message-ID: <alpine.LFD.2.02.1305151148470.1388@ionos>
References: <20130425142452.908423538@linutronix.de> <20130425143436.371634778@linutronix.de> <20130426223729.GA782@sboyd-linux.qualcomm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, Stephen Boyd wrote:

> On 04/25, Thomas Gleixner wrote:
> > Provide a simple sysfs interface for the clockevent devices. Show the
> > current active clockevent device.
> > 
> 
> Neat. Does this do anything about clockevents that aren't in use
> for the tick devices or broadcast device?

No, but that would be simple to add.
 
> > +static int tick_broadcast_init_sysfs(void)
> 
> __init?

Yes
 
> > +{
> > +	int err = device_register(&tick_bc_dev);
> > +
> > +	if (!err)
> > +		err = device_create_file(&tick_bc_dev, &dev_attr_current_device);
> > +	return err;
> > +}
> > +#else
> > +static struct tick_device *tick_get_tick_dev(struct device *dev)
> > +{
> > +	return &per_cpu(tick_cpu_device, dev->id);
> > +}
> > +static inline int tick_broadcast_init_sysfs(void) { return 0; }
> >  #endif
> > +
> > +int __init tick_init_sysfs(void)
> 
> static?

Yes
 
> > +{
> > +	int cpu;
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		struct device *dev = &per_cpu(tick_percpu_dev, cpu);
> > +		int err;
> > +
> > +		dev->id = cpu;
> > +		dev->bus = &clockevents_subsys;
> > +		err = device_register(dev);
> > +		if (!err)
> > +			err = device_create_file(dev, &dev_attr_current_device);
> > +		if (err)
> > +			return err;
> > +	}
> > +	return tick_broadcast_init_sysfs();
> > +}
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
