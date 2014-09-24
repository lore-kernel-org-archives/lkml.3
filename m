Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIXTrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:47:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39089 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750891AbaIXTrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:47:17 -0400
Date: Wed, 24 Sep 2014 15:47:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        <linux-doc@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v7 1/5] PM / Runtime: Add getter for quering the IRQ safe
 option
In-Reply-To: <20140924175302.GB1231@amd>
Message-ID: <Pine.LNX.4.44L0.1409241544070.1580-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Pavel Machek wrote:

> On Wed 2014-09-24 15:50:08, Krzysztof Kozlowski wrote:
> > Add a simple getter pm_runtime_is_irq_safe() for quering whether runtime
> > PM IRQ safe was set or not.
> > 
> > Various bus drivers implementing runtime PM may use choose to suspend
> > differently based on IRQ safeness status of child driver (e.g. do not
> > unprepare the clock if IRQ safe is not set).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> Are you sure this is good interface?
> 
> "Tell me if another function works this or that way".
> 
> That's certainly not traditional interface, and it seems dangerous to
> me. Callbacks now have different semantic requirements based on value
> of some flag...
> 
> Would it be possible to have two sets of callbacks, one irq safe and
> one not?

Or maybe add a flag to the bus-specific device structures, indicating
specifically whether or not the clock should be unprepared during a
runtime suspend.  Then individual drivers could set this flag or not, 
independent of the irq-safe setting.

Alan Stern

