Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162578AbaDCIIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:08:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59818 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1162517AbaDCIIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:08:19 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ARM: berlin: convert smp to CPU_METHOD_OF_DECLARE
Date: Thu,  3 Apr 2014 10:08:13 +0200
Message-Id: <1396512496-8030-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly introduced CPU_METHOD_OF_DECLARE (6c3ff8b11a16) [1] allows to
get rid of the board file reference to smp ops. This serie converts the
Berlin SoC smp to use this and allows to set the enable-method in the
device tree.

This serie applies on top of Sebastian's topic/smp-bg3-bg2q branch [2]
rebased on top of linux-next.

Tested on the Berlin BG2Q.

[1] https://patchwork.kernel.org/patch/3399311/
[2] https://github.com/shesselba/linux-berlin/tree/topic/smp-bg2-bg2q

Antoine Ténart (3):
  ARM: berlin: use CPU_METHOD_OF_DECLARE for smp
  ARM: dts: document the berlin enable-method property
  ARM: dts: berlin: add enable-method property in cpus node for smp

 Documentation/devicetree/bindings/arm/cpus.txt | 2 ++
 arch/arm/boot/dts/berlin2.dtsi                 | 1 +
 arch/arm/boot/dts/berlin2q.dtsi                | 1 +
 arch/arm/mach-berlin/berlin.c                  | 1 -
 arch/arm/mach-berlin/common.h                  | 2 --
 arch/arm/mach-berlin/platsmp.c                 | 3 ++-
 6 files changed, 6 insertions(+), 4 deletions(-)

-- 
1.8.3.2

