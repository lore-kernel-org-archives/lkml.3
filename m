Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaIJEUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:20:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:21412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaIJET5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:19:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,495,1406617200"; 
   d="scan'208";a="476511882"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, IIO <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Lu, Aaron" <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        "Angelo Compagnucci" <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>
Subject: RE: [PATCH 4/4] iio/adc/axp288: add support for axp288 gpadc
Thread-Topic: [PATCH 4/4] iio/adc/axp288: add support for axp288 gpadc
Thread-Index: AQHPy7P1jf7XBD1W9U+uoFAqdgHsLZv5wLdw
Date: Wed, 10 Sep 2014 04:19:49 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD576EDB3F@BGSMSX104.gar.corp.intel.com>
References: <1410215046-31751-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1410215046-31751-5-git-send-email-jacob.jun.pan@linux.intel.com>
In-Reply-To: <1410215046-31751-5-git-send-email-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacob,

> +#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME) static int 
> +axp288_gpadc_suspend(struct device *dev) {
> +	int ret;
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct gpadc_info *info = iio_priv(indio_dev);
> +
> +	mutex_lock(&indio_dev->mlock);
> +	ret = axp288_gpadc_enable(info->regmap, false);
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	return ret;
> +}

AXP288 has integrated fuel gauge which relies on VBATT and IBATT ADC measurements. If we disable the ADC then Fuel Gauge will get stuck.
So for the proper functioning of this integrated fuel gauging ADC measurements should always be ON.

Thanks,
Ram
