Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3CME47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:56:59 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63139 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3CME45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:56:57 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 12 Mar 2013 21:56:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: devicetree-discuss@lists.ozlabs.org, dianders@chromium.org,
        linux-kernel@vger.kernel.org, naveenkrishna.ch@gmail.com,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH v4] hwmon: ntc: Add DT with IIO support to
 NTC thermistor driver
Message-ID: <20130313045656.GA15989@roeck-us.net>
References: <1363077566-6254-1-git-send-email-ch.naveen@samsung.com>
 <1363147700-7042-1-git-send-email-ch.naveen@samsung.com>
 <20130313045226.GA15611@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130313045226.GA15611@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 09:52:26PM -0700, Guenter Roeck wrote:
> On Wed, Mar 13, 2013 at 09:38:20AM +0530, Naveen Krishna Chatradhi wrote:
> > This patch adds DT support to NTC driver to parse the
> > platform data.
> > 
> > Also adds the support to work as an iio device.
> > 
> > During the probe ntc driver gets the respective channels of ADC
> > and uses iio_raw_read calls to get the ADC converted value.
> > 
> > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> 
> Unfortunately there is still something we'll need to sort out:
> 
> fs/sysfs/Kconfig:1:     symbol SYSFS is selected by AT91_ADC
> drivers/iio/adc/Kconfig:85:     symbol AT91_ADC depends on IIO
> drivers/iio/Kconfig:5:  symbol IIO is selected by SENSORS_NTC_THERMISTOR
> drivers/hwmon/Kconfig:900:      symbol SENSORS_NTC_THERMISTOR depends on HWMON
> drivers/hwmon/Kconfig:5:        symbol HWMON is selected by EEEPC_LAPTOP
> drivers/platform/x86/Kconfig:477:       symbol EEEPC_LAPTOP depends on
> HOTPLUG_PCI
> drivers/pci/hotplug/Kconfig:5:  symbol HOTPLUG_PCI depends on SYSFS
> 
> So we can not just select IIO. I'll see if I can find a solution.
> 
Here it is:

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index f7adbe8..47d2176 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -899,7 +899,7 @@ config SENSORS_MCP3021

 config SENSORS_NTC_THERMISTOR
         tristate "NTC thermistor support"
-	 select IIO if OF
+	 depends on (!OF && !IIO) || (OF && IIO)
	 help
		This driver supports NTC thermistors sensor reading and its
		interpretation. The driver can also monitor the temperature and

I'll modify the patch accordingly. No need to resubmit.

Thanks,
Guenter
