Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaKYScj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:32:39 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:25840 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbaKYScf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:32:35 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-4.tower-179.messagelabs.com!1416939941!37248304!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.4; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <9d3c3451c2cac6035277fb36ffead1a1f8af453e.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Tue, 25 Nov 2014 18:25:39 +0000
Subject: [PATCH v4 8/8] iio: Add ABI documentation for input current readings
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, <linux-api@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information on in_current related readings.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index d760b02..37cd4d4 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -92,6 +92,18 @@ Description:
 		is required is a consistent labeling.  Units after application
 		of scale and offset are millivolts.

+What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_raw
+What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_supply_raw
+KernelVersion:	3.17
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Raw (unscaled no bias removal etc.) current measurement from
+		channel Y. In special cases where the channel does not
+		correspond to externally available input one of the named
+		versions may be used. The number must always be specified and
+		unique to allow association with event codes. Units after
+		application of scale and offset are milliamps.
+
 What:		/sys/bus/iio/devices/iio:deviceX/in_capacitanceY_raw
 KernelVersion:	3.2
 Contact:	linux-iio@vger.kernel.org
@@ -227,6 +239,8 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_accel_y_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_z_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_voltage_offset
+What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_offset
+What:		/sys/bus/iio/devices/iio:deviceX/in_current_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_tempY_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_temp_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_offset
@@ -249,8 +263,11 @@ Description:
 		to the _raw output.

 What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_supply_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_supply_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_voltage_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_current_scale
 What:		/sys/bus/iio/devices/iio:deviceX/out_voltageY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/out_altvoltageY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale
--
1.9.3

