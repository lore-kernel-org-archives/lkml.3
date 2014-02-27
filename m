Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaB0IXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:23:21 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:65418 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaB0IXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:23:18 -0500
Date: Thu, 27 Feb 2014 08:23:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [RFCv4 2/7] mfd: twl4030-madc: Add DT support and convert to IIO
 framework
Message-ID: <20140227082309.GT9195@lee--X1>
References: <1393374270-20079-1-git-send-email-sre@debian.org>
 <1393444990-28140-1-git-send-email-sre@debian.org>
 <1393444990-28140-3-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393444990-28140-3-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014, Sebastian Reichel wrote:

> This converts twl4030-madc module to use the Industrial IO ADC
> framework and adds device tree support.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/mfd/twl4030-madc.c | 127 +++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 118 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
> index 5458561..37cb3ad 100644
> --- a/drivers/mfd/twl4030-madc.c
> +++ b/drivers/mfd/twl4030-madc.c

<snip>

> -	if (!pdata) {
> +	if (!pdata && !np) {
>  		dev_err(&pdev->dev, "platform_data not available\n");

                                     and Device Tree node ...

<snip>

> +	iio_dev->channels = twl4030_madc_iio_channels;
> +	iio_dev->num_channels = 16;

ARRAY_SIZE()

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
