Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3KERQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:16:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58861 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3KERQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:16:15 -0500
Subject: Re: [PATCH 04/11] devicetree: bindings: Document qcom,saw2 node
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1383343739-23080-5-git-send-email-sboyd@codeaurora.org>
Date: Tue, 5 Nov 2013 11:16:14 -0600
Cc: linux-arm-kernel@lists.infradead.org, David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <CF57F27A-A622-4FA7-B0B0-AEA18C6F1E43@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org> <1383343739-23080-5-git-send-email-sboyd@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 1, 2013, at 5:08 PM, Stephen Boyd wrote:

> The saw2 binding describes the SPM/AVS wrapper hardware used to
> control the regulator supplying voltage to the Krait CPUs.
> 
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> When a SAW is for a CPU it is put behind the CPU alias region similar
> to the ACC and timers. I haven't documented that here because I'm not using
> it right now. I'm also thinking perhaps l2-saw2 is not important (technically
> its the same hardware block as a CPU's saw). Instead I should point to this
> node via the l2-cache node via some *-supply property. Thoughts?

I don't get this, why wouldn't the SAW just be under the soc node?  Do we really need to encode a relationship between the cpu and the SAW?

And kill the "l2-saw2" stuff until its needed.

Also are SAWs specific to a given SoC or not?

> 
> .../devicetree/bindings/arm/msm/qcom,saw2.txt      | 23 ++++++++++++++++++++++
> 1 file changed, 23 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt b/Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt
> new file mode 100644
> index 0000000..6360db2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/msm/qcom,saw2.txt
> @@ -0,0 +1,23 @@
> +* SPM AVS Wrapper 2 (SAW2)
> +
> +The SAW2 is a wrapper around the Subsystem Power Manager (SPM) and the
> +Adaptive Voltage Scaling (AVS) hardware. The SPM is programmable
> +micro-controller that transitions a piece of hardware (like a processor) into
> +and out of low power modes via a direct connection to the PMIC. It can also
> +be wired up to interact with other processors in the system, notifying them
> +when a low power state is entered or exited.
> +
> +Required Properties:
> +
> +- compatible : Shall contain "qcom,saw2".
> +	       A more specific property can be specified as follows:
> +		"qcom,l2-saw2"
> +- reg: Specifies the base address and size of the register region.
> +
> +Example:
> +
> +	regulator@f9012000 {
> +		compatible = "qcom,l2-saw2", "qcom,saw2";
> +		reg = <0xf9012000 0x1000>;
> +	};
> +
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

