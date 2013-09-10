Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3IJWV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:21:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42588 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab3IJWVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:21:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C client devices
Date: Wed, 11 Sep 2013 00:32:55 +0200
Message-ID: <2029393.u6DaKBPszu@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130910213522.GG29403@sirena.org.uk>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com> <3397524.g9aUWuArnm@vostro.rjw.lan> <20130910213522.GG29403@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 10, 2013 10:35:22 PM Mark Brown wrote:
> On Tue, Sep 10, 2013 at 10:04:21PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, September 10, 2013 05:13:21 PM Mark Brown wrote:
> 
> > > OK, that is very much not the model which embedded systems follow, in
> > > embedded systems the driver for the device is fully in control of its
> > > own power.  It gets resources like GPIOs and regulators which allow it
> > > to make fine grained decisions.
> 
> > There are platforms where those resources are simply not available for
> > direct manipulation and we need to use ACPI methods for power management.
> 
> > Now, since those methods are used in pretty much the same way for all I2C
> > devices, we add a PM domain for that to avoid duplicating the same code in
> > all of the drivers in question (patch [2/2]).  Does that make sense to you?
> 
> It doesn't seem like a particular problem, but the existing usage does
> need to be preserved for the systems that use it so things like having
> auto as the default and updating the drivers seem like they're needed.
> 
> > > If we're starting to get a reasonable number of buses following the same
> > > pattern it seems like we're in a position to start 
> 
> > We need that for exactly 3 buses: platform (already done), I2C and SPI.
> 
> > No other bus types are going to use ACPI this way for PM, at least for the
> > time being, simply because PCI, USB and SATA/IDE have their own ways of doing
> > this (which are bus-specific) and the spec doesn't cover other bus types
> > directly (it defines support for UART, but we don't have a UART bus type).
> 
> > Moreover, because PCI and USB use ACPI for PM in their own ways, moving that
> > thing up to the driver core would be rather inconvenient.
> 
> That only applies to the power domains though, what Mika was saying was
> that the process for enabling runtime PM (just drop a reference) also
> becomes easier with this method regardless of anything else - that makes
> sense to me as something we might want to end up with so do we want to
> just move towards making that a default?

Possibly. :-)

At least I don't see any fundamental obstacles ...


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
