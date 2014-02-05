Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBETCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:02:54 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:52837 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBETB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:01:57 -0500
From: Matt Porter <mporter@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Linux IIO List <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 4/6] iio: Add ABI docs for pulse capture devices
Date: Wed,  5 Feb 2014 14:01:39 -0500
Message-Id: <1391626901-31684-5-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1391626901-31684-1-git-send-email-mporter@linaro.org>
References: <1391626901-31684-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add standard ABI entries for pulse capture devices. Also add
a separate ABI entry for the TI ECAP driver polarity option.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 Documentation/ABI/testing/sysfs-bus-iio              | 18 ++++++++++++++++++
 Documentation/ABI/testing/sysfs-bus-iio-pulse-tiecap |  9 +++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-pulse-tiecap

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 6e02c50..918a201 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -210,6 +210,14 @@ Contact:	linux-iio@vger.kernel.org
 Description:
 		Scaled humidity measurement in milli percent.
 
+What:		/sys/bus/iio/devices/iio:deviceX/in_pulseY_raw
+What:		/sys/bus/iio/devices/iio:deviceX/in_pulse_raw
+KernelVersion:	3.15
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Raw pulse measurement from channel Y. Units after
+		application of scale and offset are nanoseconds.
+
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_x_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_y_offset
@@ -220,6 +228,8 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_tempY_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_temp_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_offset
+What:		/sys/bus/iio/devices/iio:deviceX/in_pulseY_offset
+What:		/sys/bus/iio/devices/iio:deviceX/in_pulse_offset
 KernelVersion:	2.6.35
 Contact:	linux-iio@vger.kernel.org
 Description:
@@ -251,6 +261,8 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_pulseY_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_pulse_scale
 KernelVersion:	2.6.35
 Contact:	linux-iio@vger.kernel.org
 Description:
@@ -784,6 +796,8 @@ What:		/sys/.../iio:deviceX/scan_elements/in_incli_x_en
 What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_en
 What:		/sys/.../iio:deviceX/scan_elements/in_pressureY_en
 What:		/sys/.../iio:deviceX/scan_elements/in_pressure_en
+What:		/sys/.../iio:deviceX/scan_elements/in_pulseY_en
+What:		/sys/.../iio:deviceX/scan_elements/in_pulse_en
 KernelVersion:	2.6.37
 Contact:	linux-iio@vger.kernel.org
 Description:
@@ -799,6 +813,8 @@ What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_supply_type
 What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_type
 What:		/sys/.../iio:deviceX/scan_elements/in_pressureY_type
 What:		/sys/.../iio:deviceX/scan_elements/in_pressure_type
+What:		/sys/.../iio:deviceX/scan_elements/in_pulseY_type
+What:		/sys/.../iio:deviceX/scan_elements/in_pulse_type
 KernelVersion:	2.6.37
 Contact:	linux-iio@vger.kernel.org
 Description:
@@ -845,6 +861,8 @@ What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_index
 What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_index
 What:		/sys/.../iio:deviceX/scan_elements/in_pressureY_index
 What:		/sys/.../iio:deviceX/scan_elements/in_pressure_index
+What:		/sys/.../iio:deviceX/scan_elements/in_pulseY_index
+What:		/sys/.../iio:deviceX/scan_elements/in_pulse_index
 KernelVersion:	2.6.37
 Contact:	linux-iio@vger.kernel.org
 Description:
diff --git a/Documentation/ABI/testing/sysfs-bus-iio-pulse-tiecap b/Documentation/ABI/testing/sysfs-bus-iio-pulse-tiecap
new file mode 100644
index 0000000..a9e4a9f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-iio-pulse-tiecap
@@ -0,0 +1,9 @@
+What:		/sys/bus/iio/devices/iio:deviceX/pulse_polarityY
+What:		/sys/bus/iio/devices/iio:deviceX/pulse_polarity
+Date:		January 2014
+KernelVersion:	3.15
+Contact:	Matt Porter <mporter@linaro.org>
+Description:
+		Get and set the polarity of the pulse signal to be captured
+		for channel Y.  1 indicates a high pulse signal and 0
+		indicates a low pulse signal.
-- 
1.8.4

