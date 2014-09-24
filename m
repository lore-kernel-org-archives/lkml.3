Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaIXJin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:38:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:39663 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaIXJil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:38:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,588,1406617200"; 
   d="scan'208";a="596092510"
Date: Wed, 24 Sep 2014 12:38:23 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Darren Hart <dvhart@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <david.woodhouse@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device
 properties interface
Message-ID: <20140924093823.GW1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <2809308.3y5s7TV5Ip@wuerfel>
 <D04730D8.A9DB0%dvhart@linux.intel.com>
 <6744174.JquHLt80n3@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6744174.JquHLt80n3@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:12:36AM +0200, Arnd Bergmann wrote:
> As a start, we could probably take the proposed device_for_each_child_node
> and move that into the leds-core, changing the fw_dev_node argument
> for an led_classdev with the addition of the of_node and acpi_object
> members. It would still leave it up to the gpio-leds driver to do
> 
> 	if (led_cdev->of_node)
> 		gpiod = devm_of_get_gpiod(led_cdev->of_node, ...);
> 	else
> 		gpiod = devm_acpi_get_gpiod(led_cdev->acpi_object, ...);
> 
> but there seems little benefit in abstracting this because there is
> only one driver that needs it.

The same interface is used also in gpio_keys_polled.c driver so if we
want to avoid duplicating code this needs to be abstracted away from the
drivers.
