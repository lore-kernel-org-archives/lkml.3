Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaE1UOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:14:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59566 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaE1UN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:13:58 -0400
Date: Wed, 28 May 2014 15:09:49 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: qcom: Update msm8960 device trees
Message-ID: <20140528200948.GI2012@joshc.qualcomm.com>
References: <1401301643-20191-1-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401301643-20191-1-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 01:27:23PM -0500, Kumar Gala wrote:
> * Move SoC peripherals into an SoC container node
> * Move serial enabling into board file (qcom-msm8960-cdp.dts)
> * Cleanup cpu node to match binding spec, enable-method and compatible
>   should be per cpu, not part of the container
> * Drop interrupts property from l2-cache node as its not part of the
>   binding spec
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
>  arch/arm/boot/dts/qcom-msm8960-cdp.dts |   6 ++
>  arch/arm/boot/dts/qcom-msm8960.dtsi    | 165 +++++++++++++++++----------------
>  2 files changed, 93 insertions(+), 78 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
> index a58fb88..8e77ed7 100644
> --- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
> +++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
> @@ -3,4 +3,10 @@
>  / {
>  	model = "Qualcomm MSM8960 CDP";
>  	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
> +
> +	soc {
> +		serial@16440000 {
> +			status = "ok";
> +		};
> +	};
>  };

Is now the time put these serial nodes under a GSBI parent node?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
