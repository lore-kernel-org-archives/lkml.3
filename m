Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbaIBQn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:43:29 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:7815 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbaIBQn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:43:27 -0400
Date: Tue, 2 Sep 2014 09:43:26 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "agross@codeaurora.org" <agross@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "iivanov@mm-sol.com" <iivanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] dt: Document Qualcomm APQ8084 pinctrl binding
Message-ID: <20140902164324.GM12494@sonymobile.com>
References: <1409663625-3185-1-git-send-email-gdjakov@mm-sol.com>
 <1409663625-3185-3-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409663625-3185-3-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02 Sep 06:13 PDT 2014, Georgi Djakov wrote:

> Define a new binding for the Qualcomm TLMM (Top-Level Mode Mux) based pin
> controller inside the APQ8084.
> 
> Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Don't remember giving you this...

But, with the s/sdc3/sdc2 below I think it looks good; so with that change you
have my Acked-by

Regards,
Bjorn

> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
>  .../bindings/pinctrl/qcom,apq8084-pinctrl.txt      |  179 ++++++++++++++++++++
>  1 file changed, 179 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt
> new file mode 100644
> index 0000000..9d95700
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt
> @@ -0,0 +1,179 @@
> +Qualcomm APQ8084 TLMM block
> +
> +This binding describes the Top Level Mode Multiplexer block found in the
> +MSM8960 platform.
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be "qcom,apq8084-pinctrl"
> +
> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: the base address and size of the TLMM register space.
> +
> +- interrupts:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: should specify the TLMM summary IRQ.
> +
> +- interrupt-controller:
> +	Usage: required
> +	Value type: <none>
> +	Definition: identifies this node as an interrupt controller
> +
> +- #interrupt-cells:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: must be 2. Specifying the pin number and flags, as defined
> +		    in <dt-bindings/interrupt-controller/irq.h>
> +
> +- gpio-controller:
> +	Usage: required
> +	Value type: <none>
> +	Definition: identifies this node as a gpio controller
> +
> +- #gpio-cells:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: must be 2. Specifying the pin number and flags, as defined
> +		    in <dt-bindings/gpio/gpio.h>
> +
> +Please refer to ../gpio/gpio.txt and ../interrupt-controller/interrupts.txt for
> +a general description of GPIO and interrupt bindings.
> +
> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices, including the meaning of the
> +phrase "pin configuration node".
> +
> +The pin configuration nodes act as a container for an abitrary number of
> +subnodes. Each of these subnodes represents some desired configuration for a
> +pin, a group, or a list of pins or groups. This configuration can include the
> +mux function to select on those pin(s)/group(s), and various pin configuration
> +parameters, such as pull-up, drive strength, etc.
> +
> +
> +PIN CONFIGURATION NODES:
> +
> +The name of each subnode is not important; all subnodes should be enumerated
> +and processed purely based on their content.
> +
> +Each subnode only affects those parameters that are explicitly listed. In
> +other words, a subnode that lists a mux function but no pin configuration
> +parameters implies no information about any pin configuration parameters.
> +Similarly, a pin subnode that describes a pullup parameter implies no
> +information about e.g. the mux function.
> +
> +
> +The following generic properties as defined in pinctrl-bindings.txt are valid
> +to specify in a pin configuration subnode:
> +
> +- pins:
> +	Usage: required
> +	Value type: <string-array>
> +	Definition: List of gpio pins affected by the properties specified in
> +		    this subnode.  Valid pins are:
> +		    gpio0-gpio146,
> +		    sdc1_clk,
> +		    sdc1_cmd,
> +		    sdc1_data
> +		    sdc3_clk,
> +		    sdc3_cmd,
> +		    sdc3_data

These are supposed to be sdc2.

> +
> +- function:
> +	Usage: required
> +	Value type: <string>
> +	Definition: Specify the alternative function to be configured for the
> +		    specified pins. Functions are only valid for gpio pins.
> +		    Valid values are:
> +		    adsp_ext, audio_ref, blsp_i2c1, blsp_i2c2, blsp_i2c3,
> +		    blsp_i2c4, blsp_i2c5, blsp_i2c6, blsp_i2c7, blsp_i2c8,
> +		    blsp_i2c9, blsp_i2c10, blsp_i2c11, blsp_i2c12,
> +		    blsp_spi1, blsp_spi2, blsp_spi3, blsp_spi4, blsp_spi5,
> +		    blsp_spi6, blsp_spi7, blsp_spi8, blsp_spi9, blsp_spi10,
> +		    blsp_spi11, blsp_spi12, blsp_uart1, blsp_uart2, blsp_uart3,
> +		    blsp_uart4, blsp_uart5, blsp_uart6, blsp_uart7, blsp_uart8,
> +		    blsp_uart9, blsp_uart10, blsp_uart11, blsp_uart12,
> +		    blsp_uim1, blsp_uim2, blsp_uim3, blsp_uim4, blsp_uim5,
> +		    blsp_uim6, blsp_uim7, blsp_uim8, blsp_uim9, blsp_uim10,
> +		    blsp_uim11, blsp_uim12, cam_mclk0, cam_mclk1, cam_mclk2,
> +		    cam_mclk3, cci_async, cci_async_in0, cci_i2c0, cci_i2c1,
> +		    cci_timer0, cci_timer1, cci_timer2, cci_timer3, cci_timer4,
> +		    edp_hpd, gcc_gp1, gcc_gp2, gcc_gp3, gcc_obt, gcc_vtt,i
> +		    gp_mn, gp_pdm0, gp_pdm1, gp_pdm2, gp0_clk, gp1_clk, gpio,
> +		    hdmi_cec, hdmi_ddc, hdmi_dtest, hdmi_hpd, hdmi_rcv, hsic,
> +		    ldo_en, ldo_update, mdp_vsync, pci_e0, pci_e0_n, pci_e0_rst,
> +		    pci_e1, pci_e1_rst, pci_e1_rst_n, pci_e1_clkreq_n, pri_mi2s,
> +		    qua_mi2s, sata_act, sata_devsleep, sata_devsleep_n,
> +		    sd_write, sdc_emmc_mode, sdc3, sdc4, sec_mi2s, slimbus,
> +		    spdif_tx, spkr_i2s, spkr_i2s_ws, spss_geni, ter_mi2s, tsif1,
> +		    tsif2, uim, uim_batt_alarm
> +
> +- bias-disable:
> +	Usage: optional
> +	Value type: <none>
> +	Definition: The specified pins should be configued as no pull.
> +
> +- bias-pull-down:
> +	Usage: optional
> +	Value type: <none>
> +	Definition: The specified pins should be configued as pull down.
> +
> +- bias-pull-up:
> +	Usage: optional
> +	Value type: <none>
> +	Definition: The specified pins should be configued as pull up.
> +
> +- output-high:
> +	Usage: optional
> +	Value type: <none>
> +	Definition: The specified pins are configured in output mode, driven
> +		    high.
> +		    Not valid for sdc pins.
> +
> +- output-low:
> +	Usage: optional
> +	Value type: <none>
> +	Definition: The specified pins are configured in output mode, driven
> +		    low.
> +		    Not valid for sdc pins.
> +
> +- drive-strength:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: Selects the drive strength for the specified pins, in mA.
> +		    Valid values are: 2, 4, 6, 8, 10, 12, 14 and 16
> +
> +Example:
> +
> +	tlmm: pinctrl@fd510000 {
> +		compatible = "qcom,apq8084-pinctrl";
> +		reg = <0xfd510000 0x4000>;
> +
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +		interrupts = <0 208 0>;
> +
> +		uart2: uart2-default {

"uart2" might be a little bit too generic name of a label here, but it is after
all just an example...

> +			mux {
> +				pins = "gpio4", "gpio5";
> +				function = "blsp_uart2";
> +			};
> +
> +			tx {
> +				pins = "gpio4";
> +				drive-strength = <4>;
> +				bias-disable;
> +			};
> +
> +			rx {
> +				pins = "gpio5";
> +				drive-strength = <2>;
> +				bias-pull-up;
> +			};
> +		};
> +	};
> -- 
> 1.7.9.5
> 
