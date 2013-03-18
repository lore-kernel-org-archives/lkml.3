Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3CRIDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:03:00 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:27343 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3CRICx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:02:53 -0400
Date: Mon, 18 Mar 2013 09:02:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RFC PATCH 0/2] fs: sysfs: Add devres support
Message-ID: <20130318090241.3856df75@endymion.delvare>
In-Reply-To: <20130317131933.GA15179@roeck-us.net>
References: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
	<20130316162140.GB2630@kroah.com>
	<20130316181253.GA23608@roeck-us.net>
	<20130316195002.GB3112@kroah.com>
	<20130316212540.GA18933@roeck-us.net>
	<20130317133920.465e8a8c@endymion.delvare>
	<20130317131933.GA15179@roeck-us.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Mar 2013 06:19:33 -0700, Guenter Roeck wrote:
> On Sun, Mar 17, 2013 at 01:39:20PM +0100, Jean Delvare wrote:
> > I'd like to add something at this point.
> > 
> > We have historically created the hwmon attributes in the hardware (i2c,
> > platform...) device, and then created an empty hwmon class device on
> > top of it so that libsensors etc. can locate all hardware monitoring
> > chips on the system. This is probably wrong and this may explain the
> > difference of views between Greg and Guenter.
> > 
> > I suspect that ideally all hwmon-related attributes should belong to the
> > hwmon-class device and not the physical device. Would doing so solve
> > the problem of is_visible() needing chip-specific information that can
> > only be gathered during probe()? Sure this is an interface change, but
> > a few hwmon drivers already do it that way (the ones without an actual
> > hardware device, e.g. ACPI thermal zones) and libsensors supports this
> > since version 3.0.3, which was released in September 2008 - 4.5 years
> > ago.
> > 
> > This would require creating the attributes after calling
> > hwmon_device_register() rather than before, but from the ongoing
> > discussion I seem to understand that the driver core supports creating
> > the attributes for us, possibly at the same time as the class device
> > will be created. Would this solve the userspace timing issue?
> > 
> This is what I had in mind as ultimate possibility when I created
> the second API mentioned in my other e-mail.
> 
> struct device *devm_hwmon_device_register(struct device *dev,
> 					  const struct attribute_group **groups)
> 
> The attributes are still attached to dev (ie to the hardware device)
> in my current code, but it should be possible to attach them to the
> hwmon class device instead.
> 
> Problem with that approach is that it makes drivers larger, not smaller,
> at least if is_visible is needed. So it kind of defeats the purpose.
> 
> We can go along that route anyway if people think it is the right or a better
> approach, but I am not sure if it is worth it. I can send out the patches if
> there is interest.

Really, I don't know. All I know is that I do not have any time to
devote to this ATM.

-- 
Jean Delvare
