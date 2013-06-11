Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab3FKQLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:11:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:39383 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab3FKQLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:11:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,845,1363158000"; 
   d="scan'208";a="348231541"
Date: Tue, 11 Jun 2013 18:10:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
Message-ID: <20130611161054.GJ29135@zurbaran>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <20130611142358.GG29135@zurbaran>
 <51B74252.5090906@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51B74252.5090906@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Tue, Jun 11, 2013 at 05:29:22PM +0200, Sebastian Andrzej Siewior wrote:
> > Then, this is a pretty big patchset, with iio, input and mfd all mixed
> > together and it is likely to create merge conflicts.
> They somehow depend on each other. Otherwise I would have sent three
> series, one per subsystem.
Of course they depend on each other, but the dependency is mostly for
iio and input to depend on the MFD changes.


> >>From what I can see from it, and please correct me if I'm
> > wrong, the iio and input changes depend on the mfd ones, and not the
> > other way around. If that's so, I'm going to ask you to reshuffle your
> > patch set and separate the MFD changes from the iio and input ones. I'll
> > take the MFD ones and will create an immutable branch for Jonathan and
> > Dmitry to pull from and apply the iio and input changes on top of it.
> > Merge conflicts should be mostly avoided that way.
> > AFAICT, only patch #2 should be kept with input and iio bits mixed
> > together with MFD as otherwise this would introduce functional breakage.
> > Otherwise, all MFD bits from the other patches could be either separated
> > or merged together (e.g. MFD bits from patches #6 and #8, and #16 and
> > #17).
> > 
> > Does that sound doable to you ?
> 
> The device renaming shouldn't matter since I added DT nodes for the mfd
> child devices earlier. But then the of_compatible assignments should
> go hand in hand. However if I split this then the driver won't work
> but then it does not now as well (because there is no platform_data
> provider in tree).
> 
> Still. There is #18 which reworks the "step addressing" and involves
> changes in both (iio & input) at the same time.
Would splitting iio and input break anything there ?


> There is #21. Adding this to the initial "DT support" patch would be bad
> I think because it requires some changes on the iio side which have
> nothing to do with DT. Putting the iio changes before DT would require
> to make some change to platform-data part which will go away anyway.
Wouldn't it workif you split this one into an MFD+dts file changes and
another one for the iio changes ?

 
> So I started collecting ACKs from input and iio to avoid this split. If
> you really want the split then I will start doing so…
I think it would be nicer, yes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
