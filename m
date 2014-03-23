Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaCWVDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 17:03:43 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.144]:56721 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbaCWVDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 17:03:41 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-9.tower-179.messagelabs.com!1395608616!26673463!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <79211de889340ba3786f46021fac3a6f7be2132d.1395607051.git.stwiss.opensource@diasemi.com>
In-Reply-To: <cover.1395607051.git.stwiss.opensource@diasemi.com>
References: <cover.1395607051.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Sun, 23 Mar 2014 20:37:31 +0000
Subject: [RFC V1 3/3] Documentation: hwmon: New information for DA9063
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        Rob Landley <rob@landley.net>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LINUX-DOC <linux-doc@vger.kernel.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        LM-SENSORS <lm-sensors@lm-sensors.org>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

Addition of HWMON documentation for the DA9063 driver.

Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
---
Checks performed with linux-next/next-20140321/scripts/checkpatch.pl
 da9063                    total: 0 errors, 0 warnings, 67 lines checked

This is the documentation that goes along with the DA9063 HWMON driver
and the associated changes to the DA9063 mfd core and platform data.

Dependencies:

- The two other patches in this patch set:
  These are the HWMON driver and the MFD core changes

This patch applies against linux-next and next-20140321

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 Documentation/hwmon/da9063 |   67 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 Documentation/hwmon/da9063

diff --git a/Documentation/hwmon/da9063 b/Documentation/hwmon/da9063
new file mode 100644
index 0000000..fa616bb
--- /dev/null
+++ b/Documentation/hwmon/da9063
@@ -0,0 +1,67 @@
+
+Kernel driver da9063-hwmon
+==========================
+
+Supported chips:
+ * Dialog Semiconductor DA9063 PMIC
+    Prefix: 'da9063'
+    Datasheet:
+	http://www.dialog-semiconductor.com/products/power-management/DA9063
+
+Authors: S Twiss <stwiss.opensource@diasemi.com>
+
+Description
+-----------
+
+The DA9063 PMIC provides a general purpose ADC with 10 bits of resolution.
+It uses track and hold circuitry with an analogue input multiplexer which
+allows the conversion of up to 9 different inputs.
+
+ Channel  0: VSYS_RES	measurement of the system VDD (2.5 - 5.5V)
+ Channel  1: ADCIN1_RES	high impedance input (0 - 2.5V)
+ Channel  2: ADCIN2_RES	high impedance input (0 - 2.5V)
+ Channel  3: ADCIN3_RES	high impedance input (0 - 2.5V)
+ Channel  4: Tjunc	measurement of internal temperature sensor
+ Channel  5: VBBAT	measurement of the backup battery voltage (0 - 5.0V)
+ Channel  6: N/A	Reserved
+ Channel  7: N/A	Reserved
+ Channel  8: MON1_RES	group 1 internal regulators voltage (0 - 5.0V)
+ Channel  9: MON2_RES	group 2 internal regulators voltage (0 - 5.0V)
+ Channel 10: MON3_RES	group 3 internal regulators voltage (0 - 5.0V)
+
+The MUX selects from and isolates the 9 inputs and presents the channel to
+be measured to the ADC input. When selected, an input amplifier on the VSYS
+channel subtracts the VDDCORE reference voltage and scales the signal to the
+correct value for the ADC.
+
+The analog ADC includes current sources at ADC_IN1, ADC_IN2 and ADC_IN3 to
+support resistive measurements.
+
+Channels 1, 2 and 3 current source capability can be set through the ADC
+thresholds ADC_CFG register and values for ADCIN1_CUR, ADCIN2_CUR and
+ADCIN3_CUR. Settings for ADCIN1_CUR and ADCIN2_CUR are 1.0, 2.0, 10 and
+40 micro Amps. The setting for ADCIN3_CUR is 10 micro Amps.
+
+Voltage Monitoring
+------------------
+
+The manual measurement allows monitoring of the system voltage VSYS, the
+auxiliary channels ADCIN1, ADCIN2 and ADCIN3, and a VBBAT measurement of
+the backup battery voltage (0 - 5.0V). The manual measurements store 10
+bits of ADC resolution.
+
+The manual ADC measurements attributes described above are supported by
+the driver.
+
+The automatic ADC measurement is not supported by the driver.
+
+Temperature Monitoring
+----------------------
+
+Channel 4 (Tjunc) will be used to measure the output of the internal
+temperature sensor. The ADC measurement result and the T_OFFSET value can
+be used by the host to calculate the internal junction temperature
+
+	Tjunc = -0.41 * (ADC - T_OFFSET - 812.5);
+
+The junction temperature attribute is supported by the driver.
-- 
end-of-patch for RFC V1

