Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbaHYNON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:14:13 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:50545 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbaHYNOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:14:10 -0400
Message-ID: <1408972440.5256.8.camel@iivanov-dev>
Subject: Re: [PATCH v3 1/6] pinctrl: Device tree bindings for Qualcomm
 pm8xxx gpio block
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 25 Aug 2014 16:14:00 +0300
In-Reply-To: <20140820222741.GD16274@sonymobile.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
	 <1407771634-14946-2-git-send-email-iivanov@mm-sol.com>
	 <20140820222741.GD16274@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 15:27 -0700, Bjorn Andersson wrote:
> On Mon 11 Aug 08:40 PDT 2014, Ivan T. Ivanov wrote:
> [...]
> > diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
> [...]
> > +SUBNODES:
> [...]
> > +- function:
> > +	Usage: required
> > +	Value type: <string>
> > +	Definition: Specify the alternative function to be configured for the
> > +		    specified pins.  Valid values are:
> > +		    "normal",
> > +		    "paired",
> > +		    "func1",
> > +		    "func2",
> > +		    "dtest1",
> > +		    "dtest2",
> > +		    "dtest3",
> > +		    "dtest4"
> > +
> 
> I still think it looks better with "real" functions, but I rather go with this
> than discussing it forever.
> 
> > +- qcom,pull-up-strength:
> > +	Usage: optional
> > +	Value type: <u32>
> > +	Definition: Specifies the strength to use for pull up, if selected.
> > +		    Valid values are; as defined in
> > +		    <dt-bindings/pinctrl/qcom,pmic-gpio.h>:
> > +		    1: 30uA                     (PMIC_GPIO_PULL_UP_30)
> > +		    2: 1.5uA                    (PMIC_GPIO_PULL_UP_1P5)
> > +		    3: 31.5uA                   (PMIC_GPIO_PULL_UP_31P5)
> > +		    4: 1.5uA + 30uA boost       (PMIC_GPIO_PULL_UP_1P5_30)
> > +		    If this property is ommited 30uA strength will be used if
> > +		    pull up is selected
> 
> I would prefer if we decrement this one step, as it will follow the register
> values of both the "ssbi" and "spmi" based pmics.

Ok.

> 
> [...]
> > +
> > +- power-source:
> > +	Usage: optional
> > +	Value type: <u32>
> > +	Definition: Selects the power source for the specified pins. Valid
> > +		    power sources are defined per chip in
> > +		    <dt-bindings/pinctrl/qcom,pmic-gpio.h>
> > +		    xxxx_GPIO_L6, xxxx_GPIO_L5...
> 
> After implementing this my only concern is that debugfs output is not as useful
> anymore; saying VIN2 instead of S4. But I can live with this.
> 
> > diff --git a/include/dt-bindings/pinctrl/qcom,pmic-gpio.h b/include/dt-bindings/pinctrl/qcom,pmic-gpio.h
> [...]
> > +
> > +#define PM8038_GPIO1_2_LPG_DRV		PMIC_GPIO_FUNC_FUNC1
> > +#define PM8038_GPIO3_5V_BOOST_EN	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8038_GPIO4_SSBI_ALT_CLK	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8038_GPIO5_6_EXT_REG_EN	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8038_GPIO10_11_EXT_REG_EN	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8038_GPIO6_7_CLK		PMIC_GPIO_FUNC_FUNC1
> > +#define PM8038_GPIO9_BAT_ALRM_OUT	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8038_GPIO6_12_KYPD_DRV	PMIC_GPIO_FUNC_FUNC2
> > +
> > +#define PM8058_GPIO7_8_MP3_CLK		PMIC_GPIO_FUNC_FUNC1
> > +#define PM8058_GPIO7_8_BCLK_19P2MHZ	PMIC_GPIO_FUNC_FUNC2
> > +#define PM8058_GPIO9_26_KYPD_DRV	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8058_GPIO21_23_UART_TX	PMIC_GPIO_FUNC_FUNC2
> > +#define PM8058_GPIO24_26_LPG_DRV	PMIC_GPIO_FUNC_FUNC2
> > +#define PM8058_GPIO33_BCLK_19P2MHZ	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8058_GPIO34_35_MP3_CLK	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8058_GPIO36_BCLK_19P2MHZ	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8058_GPIO37_UPL_OUT		PMIC_GPIO_FUNC_FUNC1
> > +#define PM8058_GPIO37_UART_M_RX		PMIC_GPIO_FUNC_FUNC2
> > +#define PM8058_GPIO38_XO_SLEEP_CLK	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8058_GPIO38_39_CLK_32KHZ	PMIC_GPIO_FUNC_FUNC2
> > +#define PM8058_GPIO39_MP3_CLK		PMIC_GPIO_FUNC_FUNC1
> > +#define PM8058_GPIO40_EXT_BB_EN		PMIC_GPIO_FUNC_FUNC1
> > +
> > +#define PM8917_GPIO9_18_KEYP_DRV	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8917_GPIO20_BAT_ALRM_OUT	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8917_GPIO21_23_UART_TX	PMIC_GPIO_FUNC_FUNC2
> > +#define PM8917_GPIO25_26_EXT_REG_EN	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8917_GPIO37_38_XO_SLEEP_CLK	PMIC_GPIO_FUNC_FUNC1
> > +#define PM8917_GPIO37_38_MP3_CLK	PMIC_GPIO_FUNC_FUNC2
> 
> Stephens argument was that we don't want to have huge tables for the functions
> and I can see his point, it will be some work to build all the tables.
> Adding all this defines is unfortunately doing just that.

It is still little bit simpler :-)

> 
> I had a version of my driver that exposed real functions by name from the
> driver, following the pattern we have for other pinctrl drivers and making the
> dts very easy to read. But if you don't think we should go that route then I
> suggest that we just call it func1/func2 and skip these defines.
> 
> Regards,
> Bjorn

Regards,
Ivan

