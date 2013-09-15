Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3IONXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 09:23:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:13161 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab3IONXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 09:23:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,909,1371106800"; 
   d="scan'208";a="295062850"
Date: Sun, 15 Sep 2013 16:28:24 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
Message-ID: <20130915132823.GL7393@intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <87bo3whjz4.fsf@linaro.org>
 <20130913145022.GC7393@intel.com>
 <20130913173149.GE7393@intel.com>
 <87ioy4e8bw.fsf@linaro.org>
 <20130915064139.GJ7393@intel.com>
 <20130915124744.GW29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130915124744.GW29403@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 01:47:44PM +0100, Mark Brown wrote:
> On Sun, Sep 15, 2013 at 09:41:39AM +0300, Mika Westerberg wrote:
> 
> > There's also a less intrusive way of fixing the problem we see with ACPI
> > enabled I2C devices:
> 
> > 	1. In I2C core i2c_device_probe() we power on the I2C controller
> > 	and attach the client device to the ACPI power domain. Just like in
> > 	this patch but we don't touch the I2C client device runtime PM.
> 
> > 	-> This should allow the existing drivers to keep using whatever
> > 	runtime PM strategy they have chosen.
> 
> There should be no explicit need to power on the I2C controller if it's
> implemented the same way the existing ones are - just have it power
> itself on when it is doing a transfer.

The problem is that the ACPI child device can't be in higher power state
than its parent (and this is also what the runtime PM expects). If we don't
power the I2C controller device before we power on the I2C client device
that rule is violated and we get an complaint to the console.

> > 	2. For ACPI enumerated I2C client devices drivers we need to
> > 	implement the runtime PM in order to save power (otherwise the
> > 	devices will be left powered on).
> 
> > and do the same for SPI devices as well.
> 
> > Then only thing that changes for non-ACPI devices is that the controller
> > will be powered on during the client device probe (well, and during
> > remove).
> 
> > Thoughts?
> 
> This is definitely less intrusive than the current proposal, there's one
> ACPI I2C device binding queued for -next after the merge window (rt5640)
> which will need an update.

OK, thanks for the heads up. I'll check it.
