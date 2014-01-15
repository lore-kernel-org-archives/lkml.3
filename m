Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaAOBLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:11:01 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:58497 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751843AbaAOBK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:10:58 -0500
From: Feng Kan <fkan@apm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V3 0/3] Enable X-Gene platform reboot driver.
Date: Tue, 14 Jan 2014 17:07:32 -0800
Message-Id: <1389748055-23534-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable X-Gene platform driver for the X-Gene platform. Change the
driver to use syscon to access the system clock unit's system
reset register.

V2 Change:
	- Add support for using ACPI resource.

V3 Change:
	- Remove the reboot driver's use of acpi resource patch.
	- Change the reboot driver to use syscon to parse out 
	  system clock register. Remove the old method of getting
	  register from the reboot driver directly.
	- Remove documentation since its now simple.

Feng Kan (3):
  arm64: add reboot dts entry for X-Gene platform.
  arm64: Enable system reset via arch Kconfig for X-Gene system.
  power: reset: use syscon driver to parse reboot register from scu

 arch/arm64/Kconfig                 |    2 ++
 arch/arm64/boot/dts/apm-storm.dtsi |   10 ++++++++++
 drivers/power/reset/xgene-reboot.c |   33 +++++++++++++++++----------------
 3 files changed, 29 insertions(+), 16 deletions(-)

-- 
1.7.6.1

