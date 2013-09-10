Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab3IJL1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:27:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40685 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab3IJL1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:27:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mark Brown <broonie@kernel.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C client devices
Date: Tue, 10 Sep 2013 13:38:14 +0200
Message-ID: <1713872.SpMsCYYTas@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130910075100.GK7393@intel.com>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com> <20130909154028.GP29403@sirena.org.uk> <20130910075100.GK7393@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 10, 2013 10:51:00 AM Mika Westerberg wrote:
> On Mon, Sep 09, 2013 at 04:40:28PM +0100, Mark Brown wrote:
> > On Mon, Sep 09, 2013 at 04:34:38PM +0300, Mika Westerberg wrote:
> > 
> > > +	/*
> > > +	 * Enable runtime PM for the client device. If the client wants to
> > > +	 * participate on runtime PM it should call pm_runtime_put() in its
> > > +	 * probe() callback.
> > > +	 *
> > > +	 * User still needs to allow the PM runtime before it can actually
> > > +	 * happen.
> > > +	 */
> > > +	pm_runtime_forbid(&client->dev);
> > > +	pm_runtime_get_noresume(&client->dev);
> > > +	pm_runtime_set_active(&client->dev);
> > > +	pm_runtime_enable(&client->dev);
> > 
> > How is this going to interact with client devices which are already
> > enabling runtime PM for themselves, and what are the advantages of doing
> > this over having the client device enable runtime PM for itself (given
> > that the client still needs an explicit put() adding)?
> 
> My understanding is that you can call pm_runtime_enable() several times
> (provided that pm_runtime_disable() is called as many times). So that
> should have no effect on the current drivers that already take advantage of
> runtime PM.

That's correct.

> There is one difference though -- runtime PM is now blocked by default and
> it needs to be unblocked from the userspace per each device.
> 
> For the advantages compared to each driver handling it completely
> themselves:
> 
> 	- Few lines less as you only need to call _put().
> 	- It follows what is already been done for other buses, like PCI
> 	  and AMBA .
> 	- The I2C core makes sure that the device is available (from bus
> 	  point of view) when the driver ->probe() is called.
> 
> > Given that it's relatively common for devices to have both I2C and SPI
> > control it seems like it'd be sensible to keep the policy common between
> > the two buses to simplify driver implementation.
> 
> Yes and IMHO if I2C and SPI follows what has already been done for other
> buses it should make the driver writer's job easier as the usage is similar
> from one bus to another.

I agree here, FWIW.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
