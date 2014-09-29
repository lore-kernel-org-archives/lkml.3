Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaI2WSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:18:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48812 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaI2WR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:17:59 -0400
Message-ID: <5429DA95.80505@codeaurora.org>
Date: Mon, 29 Sep 2014 15:17:57 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
CC: broonie@kernel.org, lee.jones@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 1/4] ARM: DT: apq8064: add rpm support
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org> <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/14 02:14, Srinivas Kandagatla wrote:
> @@ -246,6 +247,24 @@
>  			#reset-cells = <1>;
>  		};
>  
> +		apcs: syscon@2011000 {
> +			compatible = "syscon";
> +			reg = <0x2011000 0x1000>;
> +		};

This is actually a clock controller block that hw designers decided was
good place to shove the ipc bits (because there's room!). Can we call it

                l2cc: clock-controller@2011000 {
                        compatible = "syscon";
                        reg = <0x2011000 0x1000>;
                };

Eventually I'll add the specific krait compatible when we merge krait
clock support:

                l2cc: clock-controller@2011000 {
                        compatible = "qcom,kpss-gcc", "syscon";
                        reg = <0x2011000 0x1000>;
                        clock-output-names = "acpu_l2_aux";
                };

> +
> +		rpm@108000 {
> +			compatible	= "qcom,rpm-apq8064";
> +			reg		= <0x108000 0x1000>;
> +			qcom,ipc = <&apcs 0x8 2>;

There are actually 3 ipc bits. I guess if we ever have to use the other
two we'll extend this binding to have the other bits specified some
other way?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

