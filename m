Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaIXQjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:39:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58690 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaIXQjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:39:12 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v7 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT binding
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1411428329-23172-2-git-send-email-bjorn.andersson@sonymobile.com>
Date: Wed, 24 Sep 2014 11:39:06 -0500
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <334C6A04-9607-4E97-A7A7-2FEED5986E57@codeaurora.org>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com> <1411428329-23172-2-git-send-email-bjorn.andersson@sonymobile.com>
To: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 22, 2014, at 6:25 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:

> Add binding for the Qualcomm Resource Power Manager (RPM) found in 8660,
> 8960 and 8064 based devices. The binding currently describes the rpm
> itself and the regulator subnodes.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
> Documentation/devicetree/bindings/mfd/qcom-rpm.txt |  246 ++++++++++++++++++++
> include/dt-bindings/mfd/qcom-rpm.h                 |  154 ++++++++++++
> 2 files changed, 400 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/mfd/qcom-rpm.txt
> create mode 100644 include/dt-bindings/mfd/qcom-rpm.h
> 
> diff --git a/Documentation/devicetree/bindings/mfd/qcom-rpm.txt b/Documentation/devicetree/bindings/mfd/qcom-rpm.txt
> new file mode 100644
> index 0000000..4264021
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/qcom-rpm.txt
> @@ -0,0 +1,246 @@
> +Qualcomm Resource Power Manager (RPM)
> +
> +This driver is used to interface with the Resource Power Manager (RPM) found in
> +various Qualcomm platforms. The RPM allows each component in the system to vote
> +for state of the system resources, such as clocks, regulators and bus
> +frequencies.
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-apq8064"
> +		    "qcom,rpm-msm8660"
> +		    "qcom,rpm-msm8960"
> +
> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: base address and size of the RPM's message ram
> +
> +- interrupts:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: three entries specifying the RPM's:
> +		    1. acknowledgement interrupt
> +		    2. error interrupt
> +		    3. wakeup interrupt
> +
> +- interrupt-names:
> +	Usage: required
> +	Value type: <string-array>
> +	Definition: must be the three strings "ack", "err" and "wakeup", in order
> +
> +- #address-cells:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: must be 1
> +
> +- #size-cells:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: must be 0
> +
> +- qcom,ipc:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +
> +	Definition: three entries specifying the outgoing ipc bit used for
> +		    signaling the RPM:
> +		    - phandle to a syscon node representing the apcs registers
> +		    - u32 representing offset to the register within the syscon
> +		    - u32 representing the ipc bit within the register
> +

Does this really ever differ for the SoCs, and even if it does why do we need to encode it in DT.  Can’t we determine it via the compatible setting?

> +
> += SUBDEVICES

These should be split out into their own specs/patches.


> +
> +The RPM exposes resources to its subnodes. The below bindings specify the set
> +of valid subnodes that can operate on these resources.
> +
> +== Switch-mode Power Supply regulator
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-pm8058-smps"
> +		    "qcom,rpm-pm8901-ftsmps"
> +		    "qcom,rpm-pm8921-smps"
> +		    "qcom,rpm-pm8921-ftsmps"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom-rpm.h>
> +		    must be one of:
> +		    QCOM_RPM_PM8058_SMPS0 - QCOM_RPM_PM8058_SMPS4,
> +		    QCOM_RPM_PM8821_SMPS1 - QCOM_RPM_PM8821_SMPS2,
> +		    QCOM_RPM_PM8901_SMPS0 - QCOM_RPM_PM8901_SMPS4,
> +		    QCOM_RPM_PM8921_SMPS1 - QCOM_RPM_PM8921_SMPS8
> +
> +- bias-pull-down:
> +	Usage: optional
> +	Value type: <empty>
> +	Definition: enable pull down of the regulator when inactive
> +
> +- qcom,switch-mode-frequency:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: Frequency (Hz) of the switch-mode power supply;
> +		    must be one of:
> +		    19200000, 9600000, 6400000, 4800000, 3840000, 3200000,
> +		    2740000, 2400000, 2130000, 1920000, 1750000, 1600000,
> +		    1480000, 1370000, 1280000, 1200000
> +
> +- qcom,force-mode:
> +	Usage: optional (default if no other qcom,force-mode is specified)
> +	Value type: <u32>
> +	Defintion: indicates that the regulator should be forced to a
> +		   particular mode, valid values are:
> +		   QCOM_RPM_FORCE_MODE_NONE - do not force any mode
> +		   QCOM_RPM_FORCE_MODE_LPM - force into low power mode
> +		   QCOM_RPM_FORCE_MODE_HPM - force into high power mode
> +		   QCOM_RPM_FORCE_MODE_AUTO - allow regulator to automatically
> +					      select its own mode based on
> +					      realtime current draw, only for:
> +					      qcom,rpm-pm8921-smps,
> +					      qcom,rpm-pm8921-ftsmps
> +
> +- qcom,power-mode-hysteretic:
> +	Usage: optional
> +	Value type: <empty>
> +	Definition: select that the power supply should operate in hysteretic
> +		    mode, instead of the default pwm mode
> +
> +Standard regulator bindings are used inside switch mode power supply subnodes.
> +Check Documentation/devicetree/bindings/regulator/regulator.txt for more
> +details.
> +
> +== Low-dropout regulator
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-pm8058-pldo"
> +		    "qcom,rpm-pm8058-nldo"
> +		    "qcom,rpm-pm8901-pldo"
> +		    "qcom,rpm-pm8901-nldo"
> +		    "qcom,rpm-pm8921-pldo"
> +		    "qcom,rpm-pm8921-nldo"
> +		    "qcom,rpm-pm8921-nldo1200"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom-rpm.h>
> +		    must be one of:
> +		    QCOM_RPM_PM8058_LDO0 - QCOM_RPM_PM8058_LDO25,
> +		    QCOM_RPM_PM8821_LDO1,
> +		    QCOM_RPM_PM8901_LDO0 - QCOM_RPM_PM8901_LDO6,
> +		    QCOM_RPM_PM8921_LDO1 - QCOM_RPM_PM8921_LDO29
> +
> +- bias-pull-down:
> +	Usage: optional
> +	Value type: <empty>
> +	Definition: enable pull down of the regulator when inactive
> +
> +- qcom,force-mode:
> +	Usage: optional
> +	Value type: <u32>
> +	Defintion: indicates that the regulator should not be forced to any
> +		   particular mode, valid values are:
> +		   QCOM_RPM_FORCE_MODE_NONE - do not force any mode
> +		   QCOM_RPM_FORCE_MODE_LPM - force into low power mode
> +		   QCOM_RPM_FORCE_MODE_HPM - force into high power mode
> +		   QCOM_RPM_FORCE_MODE_BYPASS - set regulator to use bypass
> +						mode, i.e.  to act as a switch
> +						and not regulate, only for:
> +						qcom,rpm-pm8921-pldo,
> +						qcom,rpm-pm8921-nldo,
> +						qcom,rpm-pm8921-nldo1200
> +
> +Standard regulator bindings are used inside switch low-dropout regulator
> +subnodes.  Check Documentation/devicetree/bindings/regulator/regulator.txt for
> +more details.
> +
> +== Negative Charge Pump
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-pm8058-ncp"
> +		    "qcom,rpm-pm8921-ncp"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom-rpm.h>
> +		    must be one of:
> +		    QCOM_RPM_PM8058_NCP,
> +		    QCOM_RPM_PM8921_NCP
> +
> +- qcom,switch-mode-frequency:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: Frequency (Hz) of the swith mode power supply;
> +		    must be one of:
> +		    19200000, 9600000, 6400000, 4800000, 3840000, 3200000,
> +		    2740000, 2400000, 2130000, 1920000, 1750000, 1600000,
> +		    1480000, 1370000, 1280000, 1200000
> +
> +Standard regulator bindings are used inside negative charge pump regulator
> +subnodes.  Check Documentation/devicetree/bindings/regulator/regulator.txt for
> +more details.
> +
> +== Switch
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-pm8058-switch"
> +		    "qcom,rpm-pm8901-switch"
> +		    "qcom,rpm-pm8921-switch"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom/qcom-rpm.h>
> +		    must be one of:
> +		    QCOM_RPM_PM8058_LVS0 - QCOM_RPM_PM8058_LVS1,
> +		    QCOM_RPM_PM8901_LVS0 - QCOM_RPM_PM8901_LVS3,
> +		    QCOM_RPM_PM8901_MVS,
> +		    QCOM_RPM_PM8921_LVS1 - QCOM_RPM_PM8921_LVS7,
> +		    QCOM_RPM_PM8921_MVS
> +
> += EXAMPLE
> +
> +	#include <dt-bindings/mfd/qcom-rpm.h>
> +
> +	rpm@108000 {
> +		compatible = "qcom,rpm-msm8960";
> +		reg = <0x108000 0x1000>;
> +		qcom,ipc = <&apcs 0x8 2>;
> +
> +		interrupts = <0 19 0>, <0 21 0>, <0 22 0>;
> +		interrupt-names = "ack", "err", "wakeup";
> +
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		pm8921_smps1: pm8921-smps1 {
> +			compatible = "qcom,rpm-pm8921-smps";
> +			reg = <QCOM_RPM_PM8921_SMPS1>;
> +
> +			regulator-min-microvolt = <1225000>;
> +			regulator-max-microvolt = <1225000>;
> +			regulator-always-on;
> +
> +			bias-pull-down;
> +
> +			qcom,switch-mode-frequency = <3200000>;
> +		};
> +	};
> +
> diff --git a/include/dt-bindings/mfd/qcom-rpm.h b/include/dt-bindings/mfd/qcom-rpm.h
> new file mode 100644
> index 0000000..388a6f3
> --- /dev/null
> +++ b/include/dt-bindings/mfd/qcom-rpm.h
> @@ -0,0 +1,154 @@
> +/*
> + * This header provides constants for the Qualcomm RPM bindings.
> + */
> +
> +#ifndef _DT_BINDINGS_MFD_QCOM_RPM_H
> +#define _DT_BINDINGS_MFD_QCOM_RPM_H
> +
> +/*
> + * Constants use to identify individual resources in the RPM.
> + */
> +#define QCOM_RPM_APPS_FABRIC_ARB		1
> +#define QCOM_RPM_APPS_FABRIC_CLK		2
> +#define QCOM_RPM_APPS_FABRIC_HALT		3
> +#define QCOM_RPM_APPS_FABRIC_IOCTL		4
> +#define QCOM_RPM_APPS_FABRIC_MODE		5
> +#define QCOM_RPM_APPS_L2_CACHE_CTL		6
> +#define QCOM_RPM_CFPB_CLK			7
> +#define QCOM_RPM_CXO_BUFFERS			8
> +#define QCOM_RPM_CXO_CLK			9
> +#define QCOM_RPM_DAYTONA_FABRIC_CLK		10
> +#define QCOM_RPM_DDR_DMM			11
> +#define QCOM_RPM_EBI1_CLK			12
> +#define QCOM_RPM_HDMI_SWITCH			13
> +#define QCOM_RPM_MMFPB_CLK			14
> +#define QCOM_RPM_MM_FABRIC_ARB			15
> +#define QCOM_RPM_MM_FABRIC_CLK			16
> +#define QCOM_RPM_MM_FABRIC_HALT			17
> +#define QCOM_RPM_MM_FABRIC_IOCTL		18
> +#define QCOM_RPM_MM_FABRIC_MODE			19
> +#define QCOM_RPM_PLL_4				20
> +#define QCOM_RPM_PM8058_LDO0			21
> +#define QCOM_RPM_PM8058_LDO1			22
> +#define QCOM_RPM_PM8058_LDO2			23
> +#define QCOM_RPM_PM8058_LDO3			24
> +#define QCOM_RPM_PM8058_LDO4			25
> +#define QCOM_RPM_PM8058_LDO5			26
> +#define QCOM_RPM_PM8058_LDO6			27
> +#define QCOM_RPM_PM8058_LDO7			28
> +#define QCOM_RPM_PM8058_LDO8			29
> +#define QCOM_RPM_PM8058_LDO9			30
> +#define QCOM_RPM_PM8058_LDO10			31
> +#define QCOM_RPM_PM8058_LDO11			32
> +#define QCOM_RPM_PM8058_LDO12			33
> +#define QCOM_RPM_PM8058_LDO13			34
> +#define QCOM_RPM_PM8058_LDO14			35
> +#define QCOM_RPM_PM8058_LDO15			36
> +#define QCOM_RPM_PM8058_LDO16			37
> +#define QCOM_RPM_PM8058_LDO17			38
> +#define QCOM_RPM_PM8058_LDO18			39
> +#define QCOM_RPM_PM8058_LDO19			40
> +#define QCOM_RPM_PM8058_LDO20			41
> +#define QCOM_RPM_PM8058_LDO21			42
> +#define QCOM_RPM_PM8058_LDO22			43
> +#define QCOM_RPM_PM8058_LDO23			44
> +#define QCOM_RPM_PM8058_LDO24			45
> +#define QCOM_RPM_PM8058_LDO25			46
> +#define QCOM_RPM_PM8058_LVS0			47
> +#define QCOM_RPM_PM8058_LVS1			48
> +#define QCOM_RPM_PM8058_NCP			49
> +#define QCOM_RPM_PM8058_SMPS0			50
> +#define QCOM_RPM_PM8058_SMPS1			51
> +#define QCOM_RPM_PM8058_SMPS2			52
> +#define QCOM_RPM_PM8058_SMPS3			53
> +#define QCOM_RPM_PM8058_SMPS4			54
> +#define QCOM_RPM_PM8821_LDO1			55
> +#define QCOM_RPM_PM8821_SMPS1			56
> +#define QCOM_RPM_PM8821_SMPS2			57
> +#define QCOM_RPM_PM8901_LDO0			58
> +#define QCOM_RPM_PM8901_LDO1			59
> +#define QCOM_RPM_PM8901_LDO2			60
> +#define QCOM_RPM_PM8901_LDO3			61
> +#define QCOM_RPM_PM8901_LDO4			62
> +#define QCOM_RPM_PM8901_LDO5			63
> +#define QCOM_RPM_PM8901_LDO6			64
> +#define QCOM_RPM_PM8901_LVS0			65
> +#define QCOM_RPM_PM8901_LVS1			66
> +#define QCOM_RPM_PM8901_LVS2			67
> +#define QCOM_RPM_PM8901_LVS3			68
> +#define QCOM_RPM_PM8901_MVS			69
> +#define QCOM_RPM_PM8901_SMPS0			70
> +#define QCOM_RPM_PM8901_SMPS1			71
> +#define QCOM_RPM_PM8901_SMPS2			72
> +#define QCOM_RPM_PM8901_SMPS3			73
> +#define QCOM_RPM_PM8901_SMPS4			74
> +#define QCOM_RPM_PM8921_CLK1			75
> +#define QCOM_RPM_PM8921_CLK2			76
> +#define QCOM_RPM_PM8921_LDO1			77
> +#define QCOM_RPM_PM8921_LDO2			78
> +#define QCOM_RPM_PM8921_LDO3			79
> +#define QCOM_RPM_PM8921_LDO4			80
> +#define QCOM_RPM_PM8921_LDO5			81
> +#define QCOM_RPM_PM8921_LDO6			82
> +#define QCOM_RPM_PM8921_LDO7			83
> +#define QCOM_RPM_PM8921_LDO8			84
> +#define QCOM_RPM_PM8921_LDO9			85
> +#define QCOM_RPM_PM8921_LDO10			86
> +#define QCOM_RPM_PM8921_LDO11			87
> +#define QCOM_RPM_PM8921_LDO12			88
> +#define QCOM_RPM_PM8921_LDO13			89
> +#define QCOM_RPM_PM8921_LDO14			90
> +#define QCOM_RPM_PM8921_LDO15			91
> +#define QCOM_RPM_PM8921_LDO16			92
> +#define QCOM_RPM_PM8921_LDO17			93
> +#define QCOM_RPM_PM8921_LDO18			94
> +#define QCOM_RPM_PM8921_LDO19			95
> +#define QCOM_RPM_PM8921_LDO20			96
> +#define QCOM_RPM_PM8921_LDO21			97
> +#define QCOM_RPM_PM8921_LDO22			98
> +#define QCOM_RPM_PM8921_LDO23			99
> +#define QCOM_RPM_PM8921_LDO24			100
> +#define QCOM_RPM_PM8921_LDO25			101
> +#define QCOM_RPM_PM8921_LDO26			102
> +#define QCOM_RPM_PM8921_LDO27			103
> +#define QCOM_RPM_PM8921_LDO28			104
> +#define QCOM_RPM_PM8921_LDO29			105
> +#define QCOM_RPM_PM8921_LVS1			106
> +#define QCOM_RPM_PM8921_LVS2			107
> +#define QCOM_RPM_PM8921_LVS3			108
> +#define QCOM_RPM_PM8921_LVS4			109
> +#define QCOM_RPM_PM8921_LVS5			110
> +#define QCOM_RPM_PM8921_LVS6			111
> +#define QCOM_RPM_PM8921_LVS7			112
> +#define QCOM_RPM_PM8921_MVS			113
> +#define QCOM_RPM_PM8921_NCP			114
> +#define QCOM_RPM_PM8921_SMPS1			115
> +#define QCOM_RPM_PM8921_SMPS2			116
> +#define QCOM_RPM_PM8921_SMPS3			117
> +#define QCOM_RPM_PM8921_SMPS4			118
> +#define QCOM_RPM_PM8921_SMPS5			119
> +#define QCOM_RPM_PM8921_SMPS6			120
> +#define QCOM_RPM_PM8921_SMPS7			121
> +#define QCOM_RPM_PM8921_SMPS8			122
> +#define QCOM_RPM_PXO_CLK			123
> +#define QCOM_RPM_QDSS_CLK			124
> +#define QCOM_RPM_SFPB_CLK			125
> +#define QCOM_RPM_SMI_CLK			126
> +#define QCOM_RPM_SYS_FABRIC_ARB			127
> +#define QCOM_RPM_SYS_FABRIC_CLK			128
> +#define QCOM_RPM_SYS_FABRIC_HALT		129
> +#define QCOM_RPM_SYS_FABRIC_IOCTL		130
> +#define QCOM_RPM_SYS_FABRIC_MODE		131
> +#define QCOM_RPM_USB_OTG_SWITCH			132
> +#define QCOM_RPM_VDDMIN_GPIO			133
> +
> +/*
> + * Constants used to select force mode for regulators.
> + */
> +#define QCOM_RPM_FORCE_MODE_NONE		0
> +#define QCOM_RPM_FORCE_MODE_LPM			1
> +#define QCOM_RPM_FORCE_MODE_HPM			2
> +#define QCOM_RPM_FORCE_MODE_AUTO		3
> +#define QCOM_RPM_FORCE_MODE_BYPASS		4
> +
> +#endif
> -- 
> 1.7.9.5
> 

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

