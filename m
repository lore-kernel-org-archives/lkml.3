Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab3GVVqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:46:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36846 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3GVVqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:46:36 -0400
Date: Mon, 22 Jul 2013 14:46:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        wni@nvidia.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, l.stach@pengutronix.de
Subject: Re: [lm-sensors] [RESEND PATCH V1 0/9] thermal: introduce DT thermal
 zone build
Message-ID: <20130722214647.GA15765@roeck-us.net>
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com>
 <20130717220942.GB990@roeck-us.net>
 <51E7F341.8020508@ti.com>
 <51E8234D.1020607@wwwdotorg.org>
 <20130718212108.GC4110@roeck-us.net>
 <51E98A07.4050402@wwwdotorg.org>
 <20130721110807.GC24303@roeck-us.net>
 <51ED8B6F.6020700@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ED8B6F.6020700@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 12:43:43PM -0700, Stephen Warren wrote:
> On 07/21/2013 04:08 AM, Guenter Roeck wrote:
> > ... [a bunch of good points re: why DT shouldn't describe thermal
> > profiles]
> 
> Yes, lots of good arguments there.
> 
> So, where/how in your opinion should thermal profiles be defined, and
> how should they get into the kernel? The nice thing about DT is that
> it's a single place that describes the platform, with a well-defined
> method of getting that information into the kernel. What alternatives exist?
> 
Excellent but quite different question. Quite frankly, I would love to be able
to use DT to describe a platform and its configuration and use instead of just
its hardware. Just like with thermal data, it would be great if I could use
devicetree information to describe limits for hwmon devices and configuration
information for all kinds of devices. This would simplify my life a lot.
Unfortunately, that is not how it works, so one ends up with pre-configuring
devices on ROMMON or secondary methods such as sensors.conf for hwmon devices.
Sure, that all works, but for embedded devices it means I have to re-build the
root file system each time a limit is changed. It _would_ be much simpler to
just be able to change the limit(s) in devicetree data and be done.

So, no, I don't have a good other solution. I have seen attempts to implement a
user-space 'parallel' devicetree, or the above mentioned sensors.conf file, but
nothing comprehensive. If you find a good generic solution, let me know.

Note that ACPI is an attempt to do that, but its scope is not limited to
describing the hardware, and it is not available on non-Intel embedded systems.
Also, it is typically controlled by another entity in a company (the BIOS
engineers), who tend to be highly resistive to changes. Modifying ACPI
data tends to be way more difficult than modifying devicetree data.

> > Other but related subject .. from a thermal / hwmon driver's perspective, if
> > such a driver supports thermal subsystem, it should just register itself as
> > thermal sensor device, because that is what it is. If and how it is tied to
> > cooling devices should be part of the thermal subsystem and be decided there.
> 
> For audio, we have individual DT nodes that represent individual
> audio-related components such as audio controllers, audio CODECs, etc.
> We also have a "virtual" node that describes how those components
> interact and create a complete sound card. Would it make sense to do
> something similar with thermal sensors and cooling devices; represent
> them all individually, have them register themselves with the
> thermal/hwmon subsystem as you describe, but then have another "system
> level" node that describes how the system designer intended them to
> interact?
> 
For device registration itself, definitely. An instance of a sensor driver
should not have to know how (or if) it is used by the system, just like a gpio
driver does not have to know if and how the gpio pins it provides are used.

Binding is the tricky question here, as it is all virtual and, as you said
yourself, describes the interaction and thus use of the various sensors and
cooling devices to accomplish the ultimate goal of keeping the system in an
acceptable temperature range. Hopefully you'll get an answer from the
devicetree experts if your intended devicetree usage of it is acceptable.

Guenter
