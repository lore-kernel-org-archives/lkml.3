Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaLJBTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:19:34 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:39158 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbaLJBTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:19:31 -0500
MIME-Version: 1.0
In-Reply-To: <1418084551-28946-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1418084551-28946-1-git-send-email-bjorn.andersson@sonymobile.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 9 Dec 2014 17:19:10 -0800
Message-ID: <CAK5ve-+NV2OCKABr16-DfkGre4pM_iEeac8ryY_4ALdEZdeZ1w@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds: add DT binding for Qualcomm PM8941 WLED block
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 4:22 PM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> From: Courtney Cavin <courtney.cavin@sonymobile.com>
>
> This adds device tree binding documentation for the WLED ('White' LED)
> block on Qualcomm's PM8941 PMICs.
>

Looks good to me, I need device tree reviewer's Ack to merge it.

Thanks,
-Bryan

> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  .../devicetree/bindings/leds/leds-pm8941-wled.txt  | 43 ++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/leds-pm8941-wled.txt
>
> diff --git a/Documentation/devicetree/bindings/leds/leds-pm8941-wled.txt b/Documentation/devicetree/bindings/leds/leds-pm8941-wled.txt
> new file mode 100644
> index 0000000..a85a964
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/leds-pm8941-wled.txt
> @@ -0,0 +1,43 @@
> +Binding for Qualcomm PM8941 WLED driver
> +
> +Required properties:
> +- compatible: should be "qcom,pm8941-wled"
> +- reg: slave address
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
> +       default: 20mA
> +- qcom,current-boost-limit: mA; boost current limit; one of:
> +       105, 385, 525, 805, 980, 1260, 1400, 1680
> +       default: 805mA
> +- qcom,switching-freq: kHz; switching frequency; one of:
> +       600, 640, 685, 738, 800, 872, 960, 1066, 1200, 1371,
> +       1600, 1920, 2400, 3200, 4800, 9600,
> +       default: 1600kHz
> +- qcom,ovp: V; Over-voltage protection limit; one of:
> +       27, 29, 32, 35
> +       default: 29V
> +- qcom,num-strings: #; number of led strings attached; value from 1 to 3
> +       default: 2
> +
> +Example:
> +
> +pm8941-wled@d800 {
> +       compatible = "qcom,pm8941-wled";
> +       reg = <0xd800>;
> +       label = "backlight";
> +
> +       qcom,cs-out;
> +       qcom,current-limit = <20>;
> +       qcom,current-boost-limit = <805>;
> +       qcom,switching-freq = <1600>;
> +       qcom,ovp = <29>;
> +       qcom,num-strings = <2>;
> +};
> --
> 1.8.2.2
>
