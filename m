Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3AQWce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:32:34 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:43971 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab3AQWcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:32:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: enable common clk on x86
Date: Thu, 17 Jan 2013 23:38:25 +0100
Message-ID: <2235088.IlKyunT6NE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130116152807.GF2239@intel.com>
References: <1358174788-24439-1-git-send-email-mika.westerberg@linux.intel.com> <28908583.J70dQJd3BK@vostro.rjw.lan> <20130116152807.GF2239@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 16, 2013 05:28:07 PM Mika Westerberg wrote:
> On Wed, Jan 16, 2013 at 04:01:20PM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, January 16, 2013 07:20:54 AM Mika Westerberg wrote:
> > > On Wed, Jan 16, 2013 at 12:59:17AM +0100, Rafael J. Wysocki wrote:
> > > > On Monday, January 14, 2013 04:46:26 PM Mika Westerberg wrote:
> > > > > We are starting to see traditional SoC peripherals also in the x86 world,
> > > > > things like UART, I2C and SPI controllers that might already have a working
> > > > > device driver. These drivers typically take advantage of the Linux clk
> > > > > framework to control and retrieve information about the peripheral clock.
> > > > > 
> > > > > There hasn't been a standard way on x86 to pass the clock rate from
> > > > > whatever configuration system is used to the driver, but instead different
> > > > > variations have emerged, like adding this information to the platform data.
> > > > > 
> > > > > In order to use the standard Linux way we enable the common clk subsystem
> > > > > also on x86. This allows us to re-use the drivers with little or no
> > > > > modification wrt. clock API usage.
> > > > > 
> > > > > This patch was originally proposed by Mark Brown.
> > > > 
> > > > Are there any side effects of selecting COMMON_CLK by an arch and if so then
> > > > what are they?
> > > 
> > > Selecting COMMON_CLK also selects HAVE_CLK, so drivers that are dependent
> > > on that option become available when you run make config.
> > 
> > Well, that's not very nice.  Do you know how many of them there are?
> 
> There are few. I tried how many I get on my config and there were 9 new
> questions with 'make oldconfig'.
> 
> Grepping (if I did it correctly) reveals:
> 
> % git grep 'depends .*HAVE_CLK' -- '*/Kconfig' | wc -l
> 27
> 
> > Distros often build all drivers available regardless of whether or not they
> > are going to be used and it would be kind of wasteful for them to build drivers
> > that aren't even going to work.
> 
> If a driver depends only on HAVE_CLK and doesn't work everywhere, there is
> a problem in that particular driver and its Kconfig options (some
> dependencies are missing). These drivers should be fixed.

Well, on a second thought it might be better to add a new Kconfig option for
x86, say CONFIG_INTEL_LPSS ("Intel LPSS Support") that will select COMMON_CLK
and depend on ACPI.  This way we'll only compile the clocks stuff when
explicitly requested (although distros will probably set that to 'y' anyway).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
