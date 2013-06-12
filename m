Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3FLOlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:41:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:25655 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab3FLOli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:41:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,852,1363158000"; 
   d="scan'208";a="253988919"
Date: Wed, 12 Jun 2013 16:41:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
Message-ID: <20130612144133.GP29135@zurbaran>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <20130611142358.GG29135@zurbaran>
 <20130611160415.GA379@core.coreip.homeip.net>
 <20130611161506.GK29135@zurbaran>
 <1565f2fb-7f16-4910-8fa2-cd5700e8986d@email.android.com>
 <20130611175519.GL29135@zurbaran>
 <51B877C7.8080001@linutronix.de>
 <20130612135042.GO29135@zurbaran>
 <51B87F58.9070000@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B87F58.9070000@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 04:02:00PM +0200, Sebastian Andrzej Siewior wrote:
> >> By keep the regmap code you mean I am allowed to remove the regmap
> >> usage in mfd (keep patch #1) or do you insist on adding its usage in
> >> iio and input?
> > I insist on keeping it on the MFD driver, i.e. _not_ keeping patch #1.
> 
> This forces me redo a few things and most likely adding it to the
> iio and input driver to be consistent here.
I'm not asking for that. The current MFD code uses regmap fine without
the iio and input using it, I don't see why you would have to add regmap
support there.

> Could you please give a reason why using the regmap here is a good
> thing? I mentioned a few why it is not and why is better to leave it
> out.
Yes, and I'm not convinced obviously. regmap prevents you from open
coding your MMIO access, and this is the right approach.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
