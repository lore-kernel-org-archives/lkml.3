Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3GFTzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 15:55:13 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:23901 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3GFTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 15:55:10 -0400
Date: Sat, 6 Jul 2013 21:54:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] hwmon: (ds1621) Convert to use 
 hwmon_device_register_groups
Message-ID: <20130706215458.64753cd0@endymion.delvare>
In-Reply-To: <20130706193142.GA9778@kroah.com>
References: <1373131495-13465-1-git-send-email-linux@roeck-us.net>
	<1373131495-13465-4-git-send-email-linux@roeck-us.net>
	<20130706175747.GA8658@kroah.com>
	<20130706200151.70b7ac3d@endymion.delvare>
	<20130706191816.GA15066@roeck-us.net>
	<20130706193142.GA9778@kroah.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jul 2013 12:31:42 -0700, Greg Kroah-Hartman wrote:
> On Sat, Jul 06, 2013 at 12:18:16PM -0700, Guenter Roeck wrote:
> > Yes, and I tested it with the new nct6775 driver to make sure that it works.
> > The i2c and spi drivers need some more work, though - the name attribute is
> > now missing and will have to be created for the hwmon device itself. If you have
> > an idea how to do that without adding it in every driver, please let me know.
> 
> Why do you need a name attribute at all?  Shouldn't that just be the
> name of the device, or the parent?

libsensors expects the hwmon attributes and the name attribute at the
same place.

> Can you make the name be part of the groups always?

Sounds good, but then we have to make the hwmon core handles it. So far
each driver (or its bus type subsystem) was responsible for it.

-- 
Jean Delvare
