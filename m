Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaKDIVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:21:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:46281 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaKDIVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:21:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411026603"
Date: Tue, 4 Nov 2014 10:20:56 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Message-ID: <20141104082056.GG1618@lahna.fi.intel.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAOZdJXXAQtmR_Wq194nbiEpg2TYS7_5tXhLtDWckD4xMHGkdZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOZdJXXAQtmR_Wq194nbiEpg2TYS7_5tXhLtDWckD4xMHGkdZg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 05:24:55PM -0600, Timur Tabi wrote:
> On Mon, Nov 3, 2014 at 5:01 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > Hi,
> >
> > This is second version of the patch series adding pinctrl/GPIO support
> > for Intel Braswell and Cherrryview. The previous version can be found here:
> >
> > https://lkml.org/lkml/2014/10/27/118
> >
> > I've dropped patches [2/4] and [3/4] as they are already applied to the
> > pinctrl tree.
> 
> Mika,
> 
> I am also trying to add ACPI enablement to my pinctrl driver (not yet
> submitted), but I'm new to ACPI and pin control drivers, so I have a
> lot of catching up to do.
> 
> In reviewing this patchset, it appears to me that pinctrl-cherryview.c
> is a normal pinctrl driver that has an acpi_match_table entry, and
> nothing more.

Indeed, it just a normal platform driver that can be enumerated from
ACPI using the .acpi_match_table entry.

> Assuming that this driver is booting on an ACPI system, what is the
> mechanism that calls into the driver to configure the pins?  Is there
> a definition for pin control in ASL that provides similar
> functionality as the pinctrl nodes in a device tree?

There is nothing like that yet in ACPI world but with the ACPI _DSD
patches we are getting properties similar to DT which means that we can
provide pinctrl bindings from ACPI systems as well. Typically it has
been the BIOS that configures things but it cannot get everything 100%
right.

Currently I've been testing the muxing functionality so that I have a
small board file that sets mappings and the driver core handles
everything from there. For example I have development board where SPI
pins are muxed as GPIOs by the BIOS and with the mappings when the SPI
device appears the core will mux SPI out of those pins.
