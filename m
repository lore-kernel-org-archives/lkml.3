Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaJAR27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:28:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47048 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaJAR25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:28:57 -0400
Date: Wed, 1 Oct 2014 10:28:55 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: qcom: add description of KPSS WDT for IPQ8064
Message-ID: <20141001172855.GL10233@codeaurora.org>
References: <cover.1412182773.git.joshc@codeaurora.org>
 <50c0ec1514173ce07641a95839e939dcda41b110.1412182773.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50c0ec1514173ce07641a95839e939dcda41b110.1412182773.git.joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01, Josh Cartwright wrote:
> @@ -96,6 +104,13 @@
>  			cpu-offset = <0x80000>;
>  		};
>  
> +		watchdog@208a038 {
> +			compatible = "qcom,kpss-wdt-ipq8064";
> +			reg = <0x0208a038 0x40>;

Not being aligned to 4k or 1k raises red flags.

The watchdog is part of the timer block (on this chip it's
"qcom,kpss-timer"). We should add qcom,kpss-wdt to the compatible
list in the timer binding and extend that binding to have clocks
and timeout-sec (watchdog-timeout-sec?). This would follow DT
best practices of having one node per device. We could also add
the interrupts too, even if they're not used by the driver right
now.

> +			clocks = <&sleep_clk>;
> +			timeout-sec = <10>;
> +		};
> +

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
