Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936290AbaH1HYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:24:53 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.119]:48963 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935780AbaH1HYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:24:45 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-3.tower-193.messagelabs.com!1409210682!12683387!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 28 Aug 2014 09:24:43 +0200
Date: Thu, 28 Aug 2014 10:16:43 +0200
From: Andreas Werner <andreas.werner@men.de>
To: Guenter Roeck <linux@roeck-us.net>
CC: Andreas Werner <andreas.werner@men.de>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <lm-sensors@lm-sensors.org>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>
Subject: Re: [PATCH v6 4/4] drivers/hwmon/menf21bmc_hwmon: introduce
 MEN14F021P00 BMC HWMON driver
Message-ID: <20140828081643.GA27707@awelinux>
References: <cover.1409161615.git.andreas.werner@men.de>
 <65074740dfc6363134384b45fcd3acf5f2b4254f.1409161615.git.andreas.werner@men.de>
 <20140827183843.GC2198@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140827183843.GC2198@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:38:43AM -0700, Guenter Roeck wrote:
> On Wed, Aug 27, 2014 at 07:53:06PM +0200, Andreas Werner wrote:
> > Added driver to support the 14F021P00 BMC Hardware Monitoring.
> > The BMC is a Board Management Controller including monitoring of the
> > board voltages.
> > 
> > Signed-off-by: Andreas Werner <andreas.werner@men.de>
> 
> Looks good, though I do have one comment ...
> 
> > +
> > +	hwmon_dev = devm_hwmon_device_register_with_groups(&pdev->dev,
> > +						   "menf21bmc", drv_data,
> > +						   menf21bmc_hwmon_groups);
> > +	if (IS_ERR(hwmon_dev))
> > +		return PTR_ERR(hwmon_dev);
> > +
> > +	dev_info(&pdev->dev, "MEN 14F021P00 BMC hwmon device enabled");
> > +
> You removed the dev_info from the mfd driver but left it in the client
> drivers.  If you'd drop it here as well, you could use
> 'return PTR_ERR_OR_ZERO(hwmon_dev);'.  Just a suggestion, not mandatory.
> 
> Either case,

It is a nice info for every slave driver which are the drivers for accessing
the features in the BMC. The mfd is just the driver who will instantiate the
slaves. For the mfd the most important info is if there was an error.

Anyway good idea with PTR_ERR_OR_ZERO.

Thanks for the nice review and the comments.

Regards
Andy

> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> 
> I assume this will go in through the mfd tree.
> 
> Thanks,
> Guenter
