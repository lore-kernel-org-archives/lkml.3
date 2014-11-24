Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaKXKio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:38:44 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38929 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaKXKil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:38:41 -0500
Date: Mon, 24 Nov 2014 10:38:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: qcom_rpm: add support for IPQ8064
Message-ID: <20141124103835.GH4241@x1>
References: <1416512485-7292-1-git-send-email-joshc@codeaurora.org>
 <1416512485-7292-3-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416512485-7292-3-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Josh Cartwright wrote:

> The IPQ8064 also includes an RPM following the same message structure as
> other chips.  In addition, it supports a few new resource types to
> support the NSS fabric clocks and the SMB208/SMB209 regulators found on
> the reference boards.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/mfd/qcom_rpm.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)

For my own reference:

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/qcom_rpm.c b/drivers/mfd/qcom_rpm.c
> index 0dd7a6fe..5ead23b 100644
> --- a/drivers/mfd/qcom_rpm.c
> +++ b/drivers/mfd/qcom_rpm.c
> @@ -324,10 +324,51 @@ static const struct qcom_rpm_data msm8960_template = {
>  	.n_resources = ARRAY_SIZE(msm8960_rpm_resource_table),
>  };
>  
> +static const struct qcom_rpm_resource ipq806x_rpm_resource_table[] = {
> +	[QCOM_RPM_CXO_CLK] =			{ 25, 9, 5, 1 },
> +	[QCOM_RPM_PXO_CLK] =			{ 26, 10, 6, 1 },
> +	[QCOM_RPM_APPS_FABRIC_CLK] =		{ 27, 11, 8, 1 },
> +	[QCOM_RPM_SYS_FABRIC_CLK] =		{ 28, 12, 9, 1 },
> +	[QCOM_RPM_NSS_FABRIC_0_CLK] =		{ 29, 13, 10, 1 },
> +	[QCOM_RPM_DAYTONA_FABRIC_CLK] =		{ 30, 14, 11, 1 },
> +	[QCOM_RPM_SFPB_CLK] =			{ 31, 15, 12, 1 },
> +	[QCOM_RPM_CFPB_CLK] =			{ 32, 16, 13, 1 },
> +	[QCOM_RPM_NSS_FABRIC_1_CLK] =		{ 33, 17, 14, 1 },
> +	[QCOM_RPM_EBI1_CLK] =			{ 34, 18, 16, 1 },
> +	[QCOM_RPM_APPS_FABRIC_HALT] =		{ 35, 19, 18, 2 },
> +	[QCOM_RPM_APPS_FABRIC_MODE] =		{ 37, 20, 19, 3 },
> +	[QCOM_RPM_APPS_FABRIC_IOCTL] =		{ 40, 21, 20, 1 },
> +	[QCOM_RPM_APPS_FABRIC_ARB] =		{ 41, 22, 21, 12 },
> +	[QCOM_RPM_SYS_FABRIC_HALT] =		{ 53, 23, 22, 2 },
> +	[QCOM_RPM_SYS_FABRIC_MODE] =		{ 55, 24, 23, 3 },
> +	[QCOM_RPM_SYS_FABRIC_IOCTL] =		{ 58, 25, 24, 1 },
> +	[QCOM_RPM_SYS_FABRIC_ARB] =		{ 59, 26, 25, 30 },
> +	[QCOM_RPM_MM_FABRIC_HALT] =		{ 89, 27, 26, 2 },
> +	[QCOM_RPM_MM_FABRIC_MODE] =		{ 91, 28, 27, 3 },
> +	[QCOM_RPM_MM_FABRIC_IOCTL] =		{ 94, 29, 28, 1 },
> +	[QCOM_RPM_MM_FABRIC_ARB] =		{ 95, 30, 29, 2 },
> +	[QCOM_RPM_CXO_BUFFERS] =		{ 209, 33, 31, 1 },
> +	[QCOM_RPM_USB_OTG_SWITCH] =		{ 210, 34, 32, 1 },
> +	[QCOM_RPM_HDMI_SWITCH] =		{ 211, 35, 33, 1 },
> +	[QCOM_RPM_DDR_DMM] =			{ 212, 36, 34, 2 },
> +	[QCOM_RPM_VDDMIN_GPIO] =		{ 215, 40, 39, 1 },
> +	[QCOM_RPM_SMB208_S1a] =			{ 216, 41, 90, 2 },
> +	[QCOM_RPM_SMB208_S1b] =			{ 218, 43, 91, 2 },
> +	[QCOM_RPM_SMB208_S2a] =			{ 220, 45, 92, 2 },
> +	[QCOM_RPM_SMB208_S2b] =			{ 222, 47, 93, 2 },
> +};
> +
> +static const struct qcom_rpm_data ipq806x_template = {
> +	.version = 3,
> +	.resource_table = ipq806x_rpm_resource_table,
> +	.n_resources = ARRAY_SIZE(ipq806x_rpm_resource_table),
> +};
> +
>  static const struct of_device_id qcom_rpm_of_match[] = {
>  	{ .compatible = "qcom,rpm-apq8064", .data = &apq8064_template },
>  	{ .compatible = "qcom,rpm-msm8660", .data = &msm8660_template },
>  	{ .compatible = "qcom,rpm-msm8960", .data = &msm8960_template },
> +	{ .compatible = "qcom,rpm-ipq8064", .data = &ipq806x_template },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(of, qcom_rpm_of_match);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
