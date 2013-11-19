Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3KSOxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:53:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:28113 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab3KSOx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:53:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,729,1378882800"; 
   d="scan'208";a="430258300"
Date: Tue, 19 Nov 2013 17:00:01 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST] i2c for 3.13
Message-ID: <20131119150001.GM2281@intel.com>
References: <20131118193802.GA14925@katana>
 <CA+55aFxZaC=beR+dN36Sv==6fjY7SdOdwXaSHU+wnk+-oDJp4g@mail.gmail.com>
 <3690707.5664qBQcL8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3690707.5664qBQcL8@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 01:11:25AM +0100, Rafael J. Wysocki wrote:
> On Monday, November 18, 2013 03:46:34 PM Linus Torvalds wrote:
> > On Mon, Nov 18, 2013 at 11:38 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > >
> > > here is the pull request from the i2c subsystem for 3.13:
> > 
> > So while resolving some fairly trivial conflicts here, I noticed that
> > commit a76e9bd89ae7 ("i2c: attach/detach I2C client device to the ACPI
> > power domain") that I got earlier through the ACPI/PM tree calls
> > acpi_dev_pm_detach() even when the device "->remove()" function fails.
> > But it only sets clientdata to NULL if it succeeds.
> > 
> > That looks a bit odd.
> > 
> > I didn't try to fix it, though. I just thought I'd point out the oddity.
> 
> Well, given that the driver core doesn't even check the return value of
> dev->bus->remove(dev), I think doing the unconditional acpi_dev_pm_detach()
> is actually correct and clientdata should be cleared unconditionally too.

Actually, can we remove the whole clientdata setting there?

Commit 0998d0631001 (device-core: Ensure drvdata = NULL when no driver is
bound) modified the driver core to always clear out that field. Same seems
to apply if driver probe fails.
