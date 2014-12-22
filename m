Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaLVKuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:50:12 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:54712 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754378AbaLVKuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:50:10 -0500
Message-ID: <1419245407.30945.35.camel@x220>
Subject: Re: [PATCH v8 2/3] mfd: qcom-rpm: Driver for the Qualcomm RPM
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Date: Mon, 22 Dec 2014 11:50:07 +0100
In-Reply-To: <1417038661-30209-3-git-send-email-bjorn.andersson@sonymobile.com>
References: <1417038661-30209-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1417038661-30209-3-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Dec 2014 10:50:07.0369 (UTC) FILETIME=[0CCC2790:01D01DD5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Wed, 2014-11-26 at 13:51 -0800, Bjorn Andersson wrote:
> Driver for the Resource Power Manager (RPM) found in Qualcomm 8660, 8960
> and 8064 based devices. The driver exposes resources that child drivers
> can operate on; to implementing regulator, clock and bus frequency
> drivers.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
> 
> Lee, since your Acked-by earlier I've folded in the part of the RFC where I add
> an extra parameter to qcom_rpm_write(). Part of that this is unchanged.
> 
>  drivers/mfd/Kconfig          |  14 ++
>  drivers/mfd/Makefile         |   1 +
>  drivers/mfd/qcom_rpm.c       | 581 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/qcom_rpm.h |  13 +
>  4 files changed, 609 insertions(+)
>  create mode 100644 drivers/mfd/qcom_rpm.c
>  create mode 100644 include/linux/mfd/qcom_rpm.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 1456ea7..b6bcb79 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -567,6 +567,20 @@ config MFD_PM8921_CORE
>  	  Say M here if you want to include support for PM8921 chip as a module.
>  	  This will build a module called "pm8921-core".
>  
> +config MFD_QCOM_RPM
> +	tristate "Qualcomm Resource Power Manager (RPM)"
> +	depends on ARCH_QCOM && OF
> +	help
> +	  If you say yes to this option, support will be included for the
> +	  Resource Power Manager system found in the Qualcomm 8660, 8960 and
> +	  8064 based devices.
> +
> +	  This is required to access many regulators, clocks and bus
> +	  frequencies controlled by the RPM on these devices.
> +
> +	  Say M here if you want to include support for the Qualcomm RPM as a
> +	  module. This will build a module called "qcom_rpm".
> +

The Qualcomm RPM regulator driver (see Kconfig symbol
REGULATOR_QCOM_RPM) was added in v3.18. It depends on the above symbol,
so it has not yet gotten build coverage. Even manual hacks like
    make -C ../.. M=$PWD CONFIG_REGULATOR_QCOM_RPM=m qcom_rpm-regulator.ko

won't work for that driver, because it includes linux/mfd/qcom_rpm.h,
which is not part of the tree.

It seems there's no generally agreed upon guideline for situations like
this. So I guess it's up to Mark to decide how long the tree should
include an unbuildable driver.


Paul Bolle

