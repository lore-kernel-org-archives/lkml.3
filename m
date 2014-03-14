Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaCNOQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:16:01 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:58634 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaCNOP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:15:58 -0400
MIME-Version: 1.0
In-Reply-To: <1394762863-12154-2-git-send-email-bjorn.andersson@sonymobile.com>
References: <1394762863-12154-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1394762863-12154-2-git-send-email-bjorn.andersson@sonymobile.com>
Date: Fri, 14 Mar 2014 09:15:57 -0500
Message-ID: <CAL_JsqJNp2XZ_EkTFqcsG5RZK0Nm7iquVTb=QX59pa1Z-ODAAQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] i2c: qup: Add device tree bindings information
From: Rob Herring <robherring2@gmail.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On March 13, 2014 9:07:42 PM CDT, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
>From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
>The Qualcomm Universal Peripherial (QUP) wraps I2C mini-core and
>provide input and output FIFO's for it. I2C controller can operate
>as master with supported bus speeds of 100Kbps and 400Kbps.
>
>Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>[bjorn: reformulated part of binding description
>        added version to compatible
>        cleaned up example]
>Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Acked-by: Rob Herring <robh@kernel.org>

>---
>.../devicetree/bindings/i2c/qcom,i2c-qup.txt       |   46
>++++++++++++++++++++
> 1 file changed, 46 insertions(+)
>create mode 100644
>Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
>
>diff --git a/Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
>b/Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
>new file mode 100644
>index 0000000..32ef64e
>--- /dev/null
>+++ b/Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
>@@ -0,0 +1,46 @@
>+Qualcomm Universal Peripheral (QUP) I2C controller
>+
>+Required properties:
>+ - compatible: Should be:
>+   * "qcom,i2c-qup-v1.1.1" for 8660, 8960 and 8064.
>+   * "qcom,i2c-qup-v2.1.1" for 8974 v1.
>+   * "qcom,i2c-qup-v2.2.1" for 8974 v2 and later.
>+ - reg: Should contain QUP register address and length.
>+ - interrupts: Should contain I2C interrupt.
>+
>+ - clocks: A list of phandles + clock-specifiers, one for each entry
>in
>+   clock-names.
>+ - clock-names: Should contain:
>+   * "core" for the core clock
>+   * "iface" for the AHB clock
>+
>+ - #address-cells: Should be <1> Address cells for i2c device address
>+ - #size-cells: Should be <0> as i2c addresses have no size component
>+
>+Optional properties:
>+ - clock-frequency: Should specify the desired i2c bus clock frequency
>in Hz,
>+                    defaults to 100kHz if omitted.
>+
>+Child nodes should conform to i2c bus binding.
>+
>+Example:
>+
>+ i2c@f9924000 {
>+ compatible = "qcom,i2c-qup-v2.2.1";
>+ reg = <0xf9924000 0x1000>;
>+ interrupts = <0 96 0>;
>+
>+ clocks = <&gcc GCC_BLSP1_QUP2_I2C_APPS_CLK>, <&gcc
>GCC_BLSP1_AHB_CLK>;
>+ clock-names = "core", "iface";
>+
>+ clock-frequency = <355000>;
>+
>+ #address-cells = <1>;
>+ #size-cells = <0>;
>+
>+ dummy@60 {
>+ compatible = "dummy";
>+ reg = <0x60>;
>+ };
>+ };
>+
