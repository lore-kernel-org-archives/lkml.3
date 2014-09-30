Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaI3Nqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:46:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50961 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaI3Nqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:46:36 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC 3/7] mfd: devicetree: bindings: Add Qualcomm SMD based RPM DT binding
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1412037291-16880-4-git-send-email-bjorn.andersson@sonymobile.com>
Date: Tue, 30 Sep 2014 08:46:29 -0500
Cc: Andy Gross <agross@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <85C5C172-D309-41B4-B511-7820BAFDA017@codeaurora.org>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com> <1412037291-16880-4-git-send-email-bjorn.andersson@sonymobile.com>
To: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 29, 2014, at 7:34 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:

> Add binding documentation for the Qualcomm Resource Power Manager (RPM)
> using shared memory (Qualcomm SMD) as transport mechanism. This is found
> in 8974 and newer based devices.
> 
> The binding currently describes the rpm itself and the regulator
> subnodes.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
> 
> Note that this patch extends the rpm dt-bindings header from [1].
> 
> [1] https://lkml.org/lkml/2014/9/22/733
> 
> .../devicetree/bindings/mfd/qcom-rpm-smd.txt       |  122 ++++++++++++++++++++
> include/dt-bindings/mfd/qcom-rpm.h                 |   36 ++++++
> 2 files changed, 158 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt b/Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt
> new file mode 100644
> index 0000000..a846101
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt
> @@ -0,0 +1,122 @@
> +Qualcomm Resource Power Manager (RPM) over SMD
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
> +		    "qcom,rpm-msm8974”

Why not “qcom,rpm-smd”.  I’d like to get Jeff H’s input on how what we do here for compat and distinguish the A-family RPM support vs B-family/RPM-SMD support.

> +
> +- qcom,smd-channels:
> +	Usage: required
> +	Value type: <stringlist>
> +	Definition: Shared Memory Channel used for communication with the RPM
> +

This needs more details.

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
> += SUBDEVICES

As I mentioned for the the RPM binding on a-family, we should split out the devices into their own binding specs.

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
> +		    "qcom,rpm-pm8841-smps"
> +		    "qcom,rpm-pm8941-smps"
> +
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom-rpm.h>
> +		    must be one of:
> +		    QCOM_RPM_PM8841_SMPS1 - QCOM_RPM_PM8841_SMPS4,
> +		    QCOM_RPM_PM8941_SMPS1 - QCOM_RPM_PM8941_SMPS3
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
> +		    "qcom,rpm-pm8941-ldo"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom-rpm.h>
> +		    must be one of:
> +		    QCOM_RPM_PM8941_LDO1 - QCOM_RPM_PM8941_LDO24
> +
> +Standard regulator bindings are used inside switch low-dropout regulator
> +subnodes.  Check Documentation/devicetree/bindings/regulator/regulator.txt for
> +more details.
> +
> +== Switch
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,rpm-pm8941-switch"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: resource as defined in <dt-bindings/mfd/qcom/qcom-rpm.h>
> +		    must be one of:
> +		    QCOM_RPM_PM8941_LVS1 - QCOM_RPM_PM8941_LVS3,
> +		    QCOM_RPM_PM8941_MVS1 - QCOM_RPM_PM8941_MVS2
> +
> +Standard regulator bindings are used inside switch regulator subnodes.  Check
> +Documentation/devicetree/bindings/regulator/regulator.txt for more details.
> +
> += EXAMPLE
> +
> +	#include <dt-bindings/mfd/qcom-rpm.h>
> +
> +	rpm@108000 {
> +		compatible = "qcom,rpm-msm8960";
> +		qcom,smd-channels = "rpm_requests";
> +
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		pm8941_s1: regulator-s1 {
> +			compatible = "qcom,rpm-pm8941-smps";
> +			reg = <QCOM_RPM_PM8941_SMPS1>;
> +
> +			regulator-min-microvolt = <1300000>;
> +			regulator-max-microvolt = <1300000>;
> +		};
> +
> +		pm8941_l3: pm8941-l3 {
> +			compatible = "qcom,rpm-pm8941-ldo";
> +			reg = <QCOM_RPM_PM8941_LDO3>;
> +
> +			regulator-min-microvolt = <1200000>;
> +			regulator-max-microvolt = <1200000>;
> +		};
> +
> +	};
> +

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

