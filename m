Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaIXTwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:52:43 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41342 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751124AbaIXTwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:52:41 -0400
Date: Wed, 24 Sep 2014 20:52:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v7 1/5] PM / Runtime: Add getter for quering the IRQ
	safe option
Message-ID: <20140924195222.GB5182@n2100.arm.linux.org.uk>
References: <20140924175302.GB1231@amd> <Pine.LNX.4.44L0.1409241544070.1580-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409241544070.1580-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:47:17PM -0400, Alan Stern wrote:
> On Wed, 24 Sep 2014, Pavel Machek wrote:
> 
> > On Wed 2014-09-24 15:50:08, Krzysztof Kozlowski wrote:
> > > Add a simple getter pm_runtime_is_irq_safe() for quering whether runtime
> > > PM IRQ safe was set or not.
> > > 
> > > Various bus drivers implementing runtime PM may use choose to suspend
> > > differently based on IRQ safeness status of child driver (e.g. do not
> > > unprepare the clock if IRQ safe is not set).
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> > 
> > Are you sure this is good interface?
> > 
> > "Tell me if another function works this or that way".
> > 
> > That's certainly not traditional interface, and it seems dangerous to
> > me. Callbacks now have different semantic requirements based on value
> > of some flag...
> > 
> > Would it be possible to have two sets of callbacks, one irq safe and
> > one not?
> 
> Or maybe add a flag to the bus-specific device structures, indicating
> specifically whether or not the clock should be unprepared during a
> runtime suspend.  Then individual drivers could set this flag or not, 
> independent of the irq-safe setting.

What you're proposing is _less_ safe, because with your proposal, you
now have the possibility that drivers will tell runtime PM that it has
IRQ safe callbacks, but the bus code tries to prepare/unprepare the
clock, which causes a might-sleep-if warning.

This is fragile.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
