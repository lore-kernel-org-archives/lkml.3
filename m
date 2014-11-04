Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaKDRyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:54:31 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59610 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKDRy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:54:29 -0500
Message-ID: <545912D2.5090708@codeaurora.org>
Date: Tue, 04 Nov 2014 11:54:26 -0600
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <CAOZdJXXAQtmR_Wq194nbiEpg2TYS7_5tXhLtDWckD4xMHGkdZg@mail.gmail.com> <20141104082056.GG1618@lahna.fi.intel.com>
In-Reply-To: <20141104082056.GG1618@lahna.fi.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 02:20 AM, Mika Westerberg wrote:
> There is nothing like that yet in ACPI world but with the ACPI _DSD
> patches we are getting properties similar to DT which means that we can
> provide pinctrl bindings from ACPI systems as well.

Do you know if anyone has signed up to actually do the work of defining 
how pinctrl will look in ACPI?  I'm guessing the simplest approach would 
be to:

1) Modify pinctrl_dt_to_map() so that it uses functions like 
device_read_property() instead of of_find_property() (i.e. use 
ACPI/DT-agnostic calls instead of DT-specific calls).

2) Define all of the DSD property in ASL so that pinctrl_dt_to_map() 
works as-is.

3) Possibly rename pinctrl_dt_to_map() to something like 
pinctrl_prop_to_map() or whatever.

 > Typically it has
> been the BIOS that configures things but it cannot get everything 100%
> right.

True, but this assumes that the BIOS can already talk to the pin control 
device without using the Linux driver.  If we use DSD properties to 
describe the pin control functions, then we're actually using the Linux 
driver to do pin control, albeit indirectly.

> Currently I've been testing the muxing functionality so that I have a
> small board file that sets mappings and the driver core handles
> everything from there. For example I have development board where SPI
> pins are muxed as GPIOs by the BIOS and with the mappings when the SPI
> device appears the core will mux SPI out of those pins.

How do you actually get the kernel to call into your pinctrl driver, 
without using any device tree properties or DSD properties?

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
