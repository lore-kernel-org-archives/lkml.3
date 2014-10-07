Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaJGSxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:53:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37100 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaJGSxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:53:30 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] input: pm8941-pwrkey: Add DT binding documentation
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1412644321-27683-3-git-send-email-bjorn.andersson@sonymobile.com>
Date: Tue, 7 Oct 2014 13:53:24 -0500
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <9E29A717-A001-409E-9CAC-28E47B149F0E@codeaurora.org>
References: <1412644321-27683-1-git-send-email-bjorn.andersson@sonymobile.com> <1412644321-27683-3-git-send-email-bjorn.andersson@sonymobile.com>
To: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 6, 2014, at 8:12 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:

> From: Courtney Cavin <courtney.cavin@sonymobile.com>
> 
> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
> .../bindings/input/qcom,pm8941-pwrkey.txt          |   43 ++++++++++++++++++++
> 1 file changed, 43 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8941-pwrkey.txt
> 
> diff --git a/Documentation/devicetree/bindings/input/qcom,pm8941-pwrkey.txt b/Documentation/devicetree/bindings/input/qcom,pm8941-pwrkey.txt
> new file mode 100644
> index 0000000..4d75e2c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/qcom,pm8941-pwrkey.txt
> @@ -0,0 +1,43 @@
> +Qualcomm PM8941 PMIC Power Key
> +
> +PROPERTIES
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,pm8941-pwrkey"
> +
> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: base address of registers for block
> +
> +- interrupts:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: key change interrupt; The format of the specifier is
> +		    defined by the binding document describing the node's
> +		    interrupt parent.
> +
> +- debounce:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: time in microseconds that key must be pressed or released
> +		    for state change interrupt to trigger.
> +
> +- bias-pull-up:
> +	Usage: optional
> +	Value type: <empty>

boolean, is probably better than <empty> here.

> +	Definition: presence of this property indicates that the KPDPWR_N pin
> +		    should be configured for pull up.
> +
> +EXAMPLE
> +
> +	pwrkey@800 {
> +		compatible = "qcom,pm8941-pwrkey";
> +		reg = <0x800>;
> +		interrupts = <0x0 0x8 0 0>;
> +		debounce = <15625>;
> +		bias-pull-up;
> +	};
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

