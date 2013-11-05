Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3KERNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:13:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58684 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3KERNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:13:49 -0500
Subject: Re: [PATCH 03/11] devicetree: bindings: Document qcom,kpss-acc
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1383343739-23080-4-git-send-email-sboyd@codeaurora.org>
Date: Tue, 5 Nov 2013 11:13:47 -0600
Cc: linux-arm-kernel@lists.infradead.org, David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EA8C3C10-2AD6-4179-A785-12001E439364@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org> <1383343739-23080-4-git-send-email-sboyd@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 1, 2013, at 5:08 PM, Stephen Boyd wrote:

> The kpss acc binding describes the clock, reset, and power domain
> controller for a Krait CPU.
> 
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> .../devicetree/bindings/arm/msm/qcom,kpss-acc.txt   | 21 +++++++++++++++++++++
> 1 file changed, 21 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
> new file mode 100644
> index 0000000..ed4a9c8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
> @@ -0,0 +1,21 @@
> +* Krait Processor Sub-system (KPSS) Application Clock Controller (ACC)
> +
> +The KPSS ACC provides clock, power domain, and reset control to a Krait CPU.
> +There is one ACC register region per CPU within the KPSS remaped region as
> +well as an alias register region that remaps accesses to the ACC associated
> +with the CPU accessing the region.
> +
> +Required Properties:
> +
> +- compatible : Shall contain "qcom,kpss-acc-v1" or "qcom,kpss-acc-v2".
> +- reg: Specifies the base address and size of the banked register region.
> +- cpu-offset : per-cpu offset used when the device is accessed without the
> +		CPU remapping facilities.
> +		The offset is cpu-offset + (0x10000 * cpu-nr).
> +
> +Example:
> +
> +	clock-controller@2008000 {
> +		compatible = "qcom,kpss-acc-v2";
> +		reg = <0x02008000 0x1000>;
> +	};
> -- 

I don't get the cpu-offset business, shouldn't this just be:
	reg = <0x02008000 0x1000>, <0x02018000 0x1000>, <0x02028000 0x1000>, <0x02038000 0x1000>;

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

