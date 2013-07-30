Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3G3AUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:20:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52228 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3G3AU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:20:29 -0400
Date: Mon, 29 Jul 2013 17:20:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Abhimanyu Kapur <abhimany@codeaurora.org>
Cc: Anton Vorontsov <anton@enomsg.org>, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: power: reset: add msm restart support
Message-ID: <20130730002027.GD8868@codeaurora.org>
References: <1375136906-22501-1-git-send-email-abhimany@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375136906-22501-1-git-send-email-abhimany@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Abhimanyu Kapur wrote:
> diff --git a/Documentation/devicetree/bindings/power_supply/msm-poweroff.txt b/Documentation/devicetree/bindings/power_supply/msm-poweroff.txt
> new file mode 100644
> index 0000000..de08480
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/msm-poweroff.txt
> @@ -0,0 +1,17 @@
> +MSM Poweroff Driver
> +
> +A power supply hold (ps-hold) bit is set to power the msm chipsets.
> +Clearing that bit enables us to restart/poweroff. The difference

s/enables us/allows us/ perhaps?

> +between poweroff and restart is determined by unique power manager IC
> +settings.
> +
> +Required Properties:
> +-compatible: "qcom,pshold"
> +-reg: Specifies the physical address of the ps-hold register
> +
> +Example:
> +
> +	restart@800820 {
> +		compatible = "qcom,pshold";
> +		reg = <0x00800820 0x4>;
> +	};
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index 349e9ae..fa6178f 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -37,3 +37,9 @@ config POWER_RESET_VEXPRESS
>  	help
>  	  Power off and reset support for the ARM Ltd. Versatile
>  	  Express boards.
> +
> +config POWER_RESET_MSM
> +	bool "Qualcomm MSM power-off driver"
> +	depends on POWER_RESET && ARCH_MSM
> +	help
> +	  Power off and restart support for Qualcomm boards.

It looks like this Kconfig file is trying to be alphabetically
ordered. Please make sure that it's maintained.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
