Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231Ab3DSMBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:01:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50995 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968123Ab3DSMBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:01:46 -0400
From: Taras Kondratiuk <taras@ti.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <rjw@sisk.pl>,
        <viresh.kumar@linaro.org>, <shawn.guo@linaro.org>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Taras Kondratiuk <taras@ti.com>
Subject: [RFC PATCH 0/2] cpufreq/regulator: Limit minimum voltage only
Date: Fri, 19 Apr 2013 14:55:52 +0300
Message-ID: <1366372554-20866-1-git-send-email-taras@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a "voltage tolerance" for doing DVFS is not a proper way.
It leads to a few issues:
- voltage is limited to a narrow range near OPP voltage,
  so other consumers of the same regulator can't set their own constraints
  if they don't overlap with this narrow range. No ganged rails :(
- usually OPP voltage is an absolute minimum voltage
  necessary for correct work (not taking into account AVS).
  Applying plus/minus tolerance can lead to an unstable device.
  For example omap-cpufreq has 4% tolerance configured,
  so for OMAP4430 MPU OPP50 we get 0.984V instead of 1.025V. 

This series adds a new API to regulator FW to limit only minimum voltage.
As example API is used for cpufreq-cpu0, but if it is accepted I'll fix
other drivers (omap-cpufreq, imx6q-cpufreq, etc).
Maybe regulator_set_voltage_tol() should be removed completely,
because it started to be used in a wrong way.
  
Patches are based on v3.9-rc7.
I've tested them on v3.8 based branch on OMAP4430 Blaze board.

Taras Kondratiuk (2):
  regulator: core: Add regulator_set_voltage_min()
  cpufreq: cpufreq-cpu0: Limit minimum voltage only

 drivers/cpufreq/cpufreq-cpu0.c     |   12 ++++--------
 include/linux/regulator/consumer.h |    6 ++++++
 2 files changed, 10 insertions(+), 8 deletions(-)

-- 
1.7.9.5

