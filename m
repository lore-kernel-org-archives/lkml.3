Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab3J2Ak3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:40:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40930 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab3J2Ak2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:40:28 -0400
Message-ID: <526F03FA.6000307@codeaurora.org>
Date: Mon, 28 Oct 2013 17:40:26 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH v3 08/10] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
References: <cover.1382985169.git.joshc@codeaurora.org> <5a49bffc44c5f5bffe222560e489a712321ce971.1382985169.git.joshc@codeaurora.org>
In-Reply-To: <5a49bffc44c5f5bffe222560e489a712321ce971.1382985169.git.joshc@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 11:12, Josh Cartwright wrote:
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 914c3d1..0a288cb 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -476,6 +476,16 @@ config MFD_PM8XXX_IRQ
>  	  This is required to use certain other PM 8xxx features, such as GPIO
>  	  and MPP.
>  
> +config MFD_PM8X41
> +	bool "Qualcomm PM8X41 PMIC"

Can this be tristate?

> +	depends on ARCH_MSM

It would be nice if we didn't have to depend on ARCH_MSM so we get some
more build coverage but the driver is so simple it probably doesn't matter.

> +	select REGMAP_SPMI
> +	help
> +	  This enables basic support for the Qualcomm 8941 and 8841 PMICs.  These
> +	  PMICs are currently used with the Snapdragon 800 series of SoCs.  Note, that
> +	  this will only be useful paired with descriptions of the independent functions
> +	  as children nodes in the device tree.
> +
>  config MFD_RDC321X
>  	tristate "RDC R-321x southbridge"
>  	select MFD_CORE
> diff --git a/drivers/mfd/pm8x41.c b/drivers/mfd/pm8x41.c
> new file mode 100644
> index 0000000..0a57221
> --- /dev/nullalso
> +++ b/drivers/mfd/pm8x41.c
> @@ -0,0 +1,64 @@
[...]
> +
> +static int pm8x41_probe(struct spmi_device *sdev)
> +{
> +	struct regmap *regmap;
> +
> +	regmap = devm_regmap_init_spmi(sdev, &pm8x41_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		dev_dbg(&sdev->dev, "regmap creation failed.\n");
> +		return PTR_ERR(regmap);
> +	}
> +
> +	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
> +}
> +
> +static struct of_device_id pm8x41_id_table[] = {

const?

> +	{ "qcom,pm8841", },
> +	{ "qcom,pm8941", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, pm8x41_id_table);
>
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

