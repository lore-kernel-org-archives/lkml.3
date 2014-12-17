Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaLQBP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:15:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50548 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaLQBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:15:55 -0500
Message-ID: <5490D949.4@codeaurora.org>
Date: Tue, 16 Dec 2014 17:15:53 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@linaro.org>
CC: Courtney Cavin <courtney.cavin@sonymobile.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] leds: add DT binding for Qualcomm PM8941 WLED block
References: <1418084551-28946-1-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1418084551-28946-1-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 04:22 PM, Bjorn Andersson wrote:

> +
> +Optional properties:
> +- label: The label for this led
> +  See Documentation/devicetree/bindings/leds/common.txt
> +- linux,default-trigger: Default trigger assigned to the LED
> +  See Documentation/devicetree/bindings/leds/common.txt
> +- qcom,cs-out: bool; enable current sink output
> +- qcom,cabc: bool; enable content adaptive backlight control
> +- qcom,ext-gen: bool; use externally generated modulator signal to dim
> +- qcom,current-limit: mA; per-string current limit; value from 0 to 25
> +	default: 20mA
> +- qcom,current-boost-limit: mA; boost current limit; one of:
> +	105, 385, 525, 805, 980, 1260, 1400, 1680
> +	default: 805mA
> +- qcom,switching-freq: kHz; switching frequency; one of:
> +	600, 640, 685, 738, 800, 872, 960, 1066, 1200, 1371,
> +	1600, 1920, 2400, 3200, 4800, 9600,
> +	default: 1600kHz
> +- qcom,ovp: V; Over-voltage protection limit; one of:
> +	27, 29, 32, 35
> +	default: 29V

It would be nice if the units were part of the property name, i.e.
qcom,ovp-V, qcom,current-boost-limit-mA, etc. That way the units are
known without having to refer to the documentation.

> +- qcom,num-strings: #; number of led strings attached; value from 1 to 3
> +	default: 2

I wonder if qcom,#strings is more appropriate?

> +
> +Example:
> +
> +pm8941-wled@d800 {
> +	compatible = "qcom,pm8941-wled";
> +	reg = <0xd800>;
> +	label = "backlight";
> +
> +	qcom,cs-out;
> +	qcom,current-limit = <20>;
> +	qcom,current-boost-limit = <805>;
> +	qcom,switching-freq = <1600>;
> +	qcom,ovp = <29>;
> +	qcom,num-strings = <2>;
> +};


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

