Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaJ2Iyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:54:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:17894 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504AbaJ2Iyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:54:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,808,1406617200"; 
   d="scan'208";a="598195763"
Date: Wed, 29 Oct 2014 10:54:29 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index()
 when using properties
Message-ID: <20141029085429.GJ1304@lahna.fi.intel.com>
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com>
 <2740724.5yjNTKs1RY@vostro.rjw.lan>
 <54509A3B.5090709@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54509A3B.5090709@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:41:47PM +0900, Alexandre Courbot wrote:
> On 10/29/2014 06:59 AM, Rafael J. Wysocki wrote:
> >On Tuesday, October 28, 2014 01:15:27 PM Mika Westerberg wrote:
> >>acpi_dev_add_driver_gpios() makes it possible to set up mapping between
> >>properties and ACPI GpioIo resources in a driver, so we can take index
> >>parameter in acpi_find_gpio() into use with _DSD device properties now.
> >>
> >>This index can be used to select a GPIO from a property with multiple
> >>GPIOs:
> >>
> >>   Package () {
> >>   	"data-gpios",
> >>   	Package () {
> >>   		\_SB.GPIO, 0, 0, 0,
> >>   		\_SB.GPIO, 1, 0, 0,
> >>   		\_SB.GPIO, 2, 0, 1,
> >>   	}
> >>   }
> >>
> >>In order to retrieve the last GPIO from a driver we can simply do:
> >>
> >>   desc = devm_gpiod_get_index(dev, "data", 2);
> >>
> >>and so on.
> >>
> >>Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >
> >Cool. :-)
> >
> >Any objections anyone?
> 
> Looks good to me!
> 
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>

Thanks!

> Since this looks like a bug fix, shouldn't this be squashed into the
> relevant patch of the device-properties set?

I agree.
