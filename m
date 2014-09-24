Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaIXNvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:51:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54041 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751746AbaIXNvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:51:44 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Darren Hart <dvhart@infradead.org>,
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
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device properties interface
Date: Wed, 24 Sep 2014 16:11:33 +0200
Message-ID: <1965808.H15Dedhqve@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140924093823.GW1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <6744174.JquHLt80n3@wuerfel> <20140924093823.GW1786@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 24, 2014 12:38:23 PM Mika Westerberg wrote:
> On Wed, Sep 24, 2014 at 11:12:36AM +0200, Arnd Bergmann wrote:
> > As a start, we could probably take the proposed device_for_each_child_node
> > and move that into the leds-core, changing the fw_dev_node argument
> > for an led_classdev with the addition of the of_node and acpi_object
> > members. It would still leave it up to the gpio-leds driver to do
> > 
> > 	if (led_cdev->of_node)
> > 		gpiod = devm_of_get_gpiod(led_cdev->of_node, ...);
> > 	else
> > 		gpiod = devm_acpi_get_gpiod(led_cdev->acpi_object, ...);
> > 
> > but there seems little benefit in abstracting this because there is
> > only one driver that needs it.
> 
> The same interface is used also in gpio_keys_polled.c driver so if we
> want to avoid duplicating code this needs to be abstracted away from the
> drivers.

Well, precisely.

Moving it to the leds-core doesn't buy us anything.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
