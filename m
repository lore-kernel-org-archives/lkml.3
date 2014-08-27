Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbaH0Nqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:46:43 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:42651 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934136AbaH0Nql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:46:41 -0400
Date: Wed, 27 Aug 2014 14:46:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andreas Werner <andreas.werner@men.de>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        cooloney@gmail.com, rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        jdelvare@suse.de, lm-sensors@lm-sensors.org, johannes.thumshirn@men.de
Subject: Re: [PATCH v5 1/4] drivers/mfd/menf21bmc: introduce MEN 14F021P00
 BMC MFD Core driver
Message-ID: <20140827134635.GE6364@lee--X1>
References: <cover.1409074255.git.andreas.werner@men.de>
 <67faa70de03924edc768002df17b02e47256260c.1409074255.git.andreas.werner@men.de>
 <20140827072633.GY26707@lee--X1>
 <53FDDF0F.2080607@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53FDDF0F.2080607@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Guenter Roeck wrote:
> On 08/27/2014 12:26 AM, Lee Jones wrote:
> >On Tue, 26 Aug 2014, Andreas Werner wrote:
> >>The MEN 14F021P00 Board Management Controller provides an
> >>I2C interface to the host to access the feature implemented in the BMC.
> >>The BMC is a PIC Microntroller assembled on CPCI Card from MEN Mikroelektronik
> >>and on a few Box/Display Computer.
> >>
> >>Added MFD Core driver, supporting the I2C communication to the device.
> >>
> >>The MFD driver currently supports the following features:
> >>  	- Watchdog
> >>  	- LEDs
> >>	- Hwmon (voltage monitoring)
> >>
> 
> >>+	{ }
> >>+};
> >>+MODULE_DEVICE_TABLE(i2c, menf21bmc_id_table);
> >>+
> >>+static struct i2c_driver menf21bmc_driver = {
> >>+	.driver.name	= "menf21bmc",
> >>+	.id_table	= menf21bmc_id_table,
> >>+	.probe		= menf21bmc_probe,
> >>+	.remove		= menf21bmc_remove,
> >>+};
> >
> >No DT support?
> >
> i2c devices auto-instantiate from dt entries even if there is no
> explicit devicetree configuration here. The devicetree entry
> would have to be something like "men,menf21bmc", ie it needs
> to match the driver name.

https://patchwork.ozlabs.org/patch/362180/

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
