Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbbAUQHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:07:10 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60501 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbbAUQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:07:03 -0500
Message-ID: <54BFCE97.4050007@gmail.com>
Date: Wed, 21 Jan 2015 21:36:47 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-iio@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
Subject: Re: [PATCH v6 3/7] iio: Add support for DA9150 GPADC
References: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com> <ae9b56cc8cd15bd72ea1b721ae02b1dde8632dbf.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <ae9b56cc8cd15bd72ea1b721ae02b1dde8632dbf.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 21 January 2015 09:16 PM, Adam Thomson wrote:
> This patch adds support for DA9150 Charger & Fuel-Gauge IC GPADC.
>
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> Reviewed-by: Hartmut Knaack <knaack.h@gmx.de>
> Acked-by: Jonathan Cameron <jic23@kernel.org>

(...)

> +
> +static int da9150_gpadc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct da9150 *da9150 = dev_get_drvdata(dev->parent);
> +	struct da9150_gpadc *gpadc;
> +	struct iio_dev *indio_dev;
> +	int irq, ret;
> +
> +	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*gpadc));

  You can directly use *dev* instead of *&pdev->dev*


-- 
Thanks and Regards,
Varka Bhadram.

