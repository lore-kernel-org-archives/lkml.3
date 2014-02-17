Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaBQHPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 02:15:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43219 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBQHPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 02:15:51 -0500
Message-ID: <5301B71D.2010507@ti.com>
Date: Mon, 17 Feb 2014 16:15:41 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 10/10] Documentation: Add device tree bindings for TI
 LMU devices
References: <1392359564-7205-1-git-send-email-milo.kim@ti.com> <20140214205027.GT4451@sirena.org.uk>
In-Reply-To: <20140214205027.GT4451@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 02/15/2014 05:50 AM, Mark Brown wrote:
> On Fri, Feb 14, 2014 at 03:32:44PM +0900, Milo Kim wrote:
>> Bindings for TI LMU, backlight, LM3631 regulator and LM3633 LED are added.
>
> Ah, sorry - I didn't notice that there were several different binding
> documents in the patch.
>
>> @@ -0,0 +1,49 @@
>> +TI LMU LM3631 regulator device tree bindings
>> +
>> +Required properties:
>> +  - compatible: "ti,lm3631-regulator"
>> +
>> +Optional properties:
>> +  - regulator-name
>> +  - regulator-min-microvolt
>> +  - regulator-max-microvolt
>> +  - regulator-always-on
>> +  - regulator-boot-on
>> +
>> +  For those properties, please refer to:
>> +  Documentation/devicetree/bindings/regulator/regulator.txt
>
> This doesn't correspond to the example which says that there is an
> optional property "regulators" which can contain regualators lcd_boost,
> lcd_vpos and lcd_vneg.  It's also better to not enumerate all the
> standard properties but just refer to the generic document (as you do).
> That avoids confusion if new properties are added to the generic
> regulator bindings.
>
> The actual binding is fine, it's just the way it's documented.

Thank you. I've fixed things based on your comments.
Could you check the description below?
I'd like to get your feedback before sending patch-set v2.


 From f0dcb9d8b21d38a6764c2e43cde4b41da3078c23 Mon Sep 17 00:00:00 2001
From: Milo Kim <milo.kim@ti.com>
Date: Mon, 17 Feb 2014 14:33:15 +0900
Subject: [PATCH 2/2] Documentation: fix LM3631 regulator DT based on
  maintainer's feedback

Signed-off-by: Milo Kim <milo.kim@ti.com>
---
  .../bindings/regulator/lm3631-regulator.txt        |   63 
++++++++++++++++++++
  1 file changed, 63 insertions(+)
  create mode 100644 
Documentation/devicetree/bindings/regulator/lm3631-regulator.txt

diff --git 
a/Documentation/devicetree/bindings/regulator/lm3631-regulator.txt 
b/Documentation/devicetree/bindings/regulator/lm3631-regulator.txt
new file mode 100644
index 0000000..272cdc1
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/lm3631-regulator.txt
@@ -0,0 +1,63 @@
+TI LMU LM3631 regulator device tree bindings
+
+Required properties:
+  - compatible: "ti,lm3631-regulator"
+
+Sub-nodes:
+  - vboost
+  - vcont
+  - voref
+  - vpos
+  - vneg
+
+  Optional properties of each node:
+  Please refer to Documentation/devicetree/bindings/regulator/regulator.txt
+
+LM3631 regulator is represented as a sub-node of the "ti,lm3631" device.
+Please refer to "ti,lm3631" in 
Documentation/devicetree/bindings/mfd/ti-lmu.txt
+
+Example:
+
+lm3631@29 {
+	compatible = "ti,lm3631";
+	reg = <0x29>;
+
+	ti,enable-gpio = <&gpio5 6 GPIO_ACTIVE_HIGH>;
+
+	regulators {
+		compatible = "ti,lm3631-regulator";
+
+		vboost {
+			regulator-name = "lcd_boost";
+			regulator-min-microvolt = <4500000>;
+			regulator-max-microvolt = <6350000>;
+			regulator-always-on;
+		};
+
+		vcont {
+			regulator-name = "lcd_vcont";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
+		};
+
+		voref {
+			regulator-name = "lcd_voref";
+			regulator-min-microvolt = <4000000>;
+			regulator-max-microvolt = <6000000>;
+		};
+
+		vpos {
+			regulator-name = "lcd_vpos";
+			regulator-min-microvolt = <4000000>;
+			regulator-max-microvolt = <6000000>;
+			regulator-boot-on;
+		};
+
+		vneg {
+			regulator-name = "lcd_vneg";
+			regulator-min-microvolt = <4000000>;
+			regulator-max-microvolt = <6000000>;
+			regulator-boot-on;
+		};
+	};
+};
-- 
1.7.9.5


Best regards,
Milo


