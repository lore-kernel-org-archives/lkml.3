Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaIYSaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:30:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:9785 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbaIYSat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:30:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,598,1406617200"; 
   d="scan'208";a="605420502"
Date: Thu, 25 Sep 2014 11:30:04 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v6 0/2] Initial support for XPowers AXP288 PMIC
Message-ID: <20140925113004.582367d1@jacob-VirtualBox>
In-Reply-To: <1411643739-21205-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1411643739-21205-1-git-send-email-jacob.jun.pan@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee/Jonathan,

Can you consider taking this for 3.18 if there are no other issues?

Thanks,

Jacob


On Thu, 25 Sep 2014 04:15:39 -0700
Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:

> X-Powers AXP288 is a customized PMIC found on some Intel Baytrail-CR
> platforms. It comes with sub-functions such as USB charging, fuel
> gauge, ADC, and many LDO and BUCK channels.
> 
> By extending the existing AXP20x driver, this patchset adds basic
> support for AXP288 PMIC with ADC as one MFD cell device driver.
> 
> Currently, the PMIC driver in this patchset does not support platform
> data enumeration. But when ACPI _DSD and unified device properties
> become available, cell devices with platform data will be added.
> 
> This patch does not use intel_soc_pmic core for i2c and regmap
> handling in that axp288 shares similar programming interface with
> other X-Power PMICs supported in axp20x.c. Therefore, extending
> axp20x.c to include axp288 makes more sense.
> 
> Changes
>  v6:	- change axp20x_match_device() flow to give more specific
> error messages.
> 	- remove unnecessary cast
> 
>  v5:	- excluded iio documentation patch, already applied to
> iio.git
>  	- restructured axp288_adc read_raw code to make it more
> readable
> 	- renamed adc_enable to adc_set_state and add comment about
> why adc has to be always on and there is no disable function.
> 	- axp20x use const as needed for regmap structures
> 
>  v4:	- removed rename patch, use Kconfig description to list
> supported devices
>  	- misc clean up in ADC code, use regmap_bulk_read and
> improve error handling, etc.
> 	- remove IIO ADC scale, treat raw data as processed since the
> unit is already in IIO expected milliamps.
> 
>  v3:	- put all file rename changes in 1/5
>  	- add iio documentation for in_current_raw/scale
> 	- removed global variables in axp2xx
> 	- removed pm callbacks from GPADC
> 	- removed ACPI opregion cell device
> 	- added scales to ADC current and voltage
> 	- removed ADC thermal sensor from sysfs, kernel internal use
> only
> 
>  v2:
> 	- use format -M for 1/4
> 	- minor tweak based on Maxime's review
> 
> 
> Jacob Pan (2):
>   mfd/axp20x: extend axp20x to support axp288 pmic
>   iio/adc: add support for axp288 adc
> 
>  drivers/iio/adc/Kconfig      |   8 +
>  drivers/iio/adc/Makefile     |   1 +
>  drivers/iio/adc/axp288_adc.c | 253 ++++++++++++++++++++++++++++++
>  drivers/mfd/Kconfig          |   3 +-
>  drivers/mfd/axp20x.c         | 361
> ++++++++++++++++++++++++++++++++++++-------
> include/linux/mfd/axp20x.h   |  59 +++++++ 6 files changed, 629
> insertions(+), 56 deletions(-) create mode 100644
> drivers/iio/adc/axp288_adc.c
> 

[Jacob Pan]
