Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663Ab3JPLAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:00:13 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:65186 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760524Ab3JPLAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:00:11 -0400
From: Robert Richter <rric@kernel.org>
To: linux-edac@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH 0/5] edac, highbank: Add Calxeda ECX-2000 support
Date: Wed, 16 Oct 2013 12:59:33 +0200
Message-Id: <1381921178-28511-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enables ECC edac support for Calxeda ECX-2000
(Midway). The ECX-2000 memory controller is similar to Highbank but
has different register bases for error and interrupt registers.

Testing the driver uncovered a bug in the interrupt initialization.
So there is also a fix for this for all the Highbank edac drivers. The
interrupt was enabled too early which caused a crash if there are
interrupts pending (ECC errors) during driver initialization.

Also some improvements and unification of edac log messages I found
useful.

-Robert


Rob Herring (1):
  ARM: dts: calxeda: move memory-controller node out of ecx-common.dtsi

Robert Richter (4):
  edac, highbank: Fix interrupt setup of mem and l2 controller
  edac, highbank: Add Calxeda ECX-2000 support
  edac, highbank: Improve and unify naming
  edac: Unify reporting of device info for device, mc and pci

 .../devicetree/bindings/arm/calxeda/mem-ctrlr.txt  |   4 +-
 arch/arm/boot/dts/ecx-2000.dts                     |   6 +
 arch/arm/boot/dts/ecx-common.dtsi                  |   6 -
 arch/arm/boot/dts/highbank.dts                     |   6 +
 drivers/edac/edac_device.c                         |   9 +-
 drivers/edac/edac_mc.c                             |   6 +-
 drivers/edac/edac_pci.c                            |   8 +-
 drivers/edac/highbank_l2_edac.c                    |  33 +++---
 drivers/edac/highbank_mc_edac.c                    | 128 +++++++++++++--------
 9 files changed, 127 insertions(+), 79 deletions(-)

-- 
1.8.4.rc3

