Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaKDTE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:04:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:58059 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaKDTE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:04:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,314,1413270000"; 
   d="scan'208";a="631358135"
Date: Tue, 4 Nov 2014 21:04:51 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Message-ID: <20141104190451.GS1618@lahna.fi.intel.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAOZdJXXAQtmR_Wq194nbiEpg2TYS7_5tXhLtDWckD4xMHGkdZg@mail.gmail.com>
 <20141104082056.GG1618@lahna.fi.intel.com>
 <545912D2.5090708@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545912D2.5090708@codeaurora.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:54:26AM -0600, Timur Tabi wrote:
> On 11/04/2014 02:20 AM, Mika Westerberg wrote:
> >There is nothing like that yet in ACPI world but with the ACPI _DSD
> >patches we are getting properties similar to DT which means that we can
> >provide pinctrl bindings from ACPI systems as well.
> 
> Do you know if anyone has signed up to actually do the work of defining how
> pinctrl will look in ACPI?

No, not yet.

> I'm guessing the simplest approach would be to:
> 
> 1) Modify pinctrl_dt_to_map() so that it uses functions like
> device_read_property() instead of of_find_property() (i.e. use
> ACPI/DT-agnostic calls instead of DT-specific calls).
> 
> 2) Define all of the DSD property in ASL so that pinctrl_dt_to_map() works
> as-is.
> 
> 3) Possibly rename pinctrl_dt_to_map() to something like
> pinctrl_prop_to_map() or whatever.

Yes, something like that.

We still need to account the fact that BIOS is supposed to configure the
pins in advance. The pinctrl mappings are just for refining that, like
muxing out the SPI pins instead of GPIOs and so on.

> > Typically it has
> >been the BIOS that configures things but it cannot get everything 100%
> >right.
> 
> True, but this assumes that the BIOS can already talk to the pin control
> device without using the Linux driver.  If we use DSD properties to describe
> the pin control functions, then we're actually using the Linux driver to do
> pin control, albeit indirectly.

Right.

> >Currently I've been testing the muxing functionality so that I have a
> >small board file that sets mappings and the driver core handles
> >everything from there. For example I have development board where SPI
> >pins are muxed as GPIOs by the BIOS and with the mappings when the SPI
> >device appears the core will mux SPI out of those pins.
> 
> How do you actually get the kernel to call into your pinctrl driver, without
> using any device tree properties or DSD properties?

I'm using a small board file (which is not included in this patch set)
that lives in arch/x86/platform/*.
