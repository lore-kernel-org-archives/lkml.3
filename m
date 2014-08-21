Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaHUUEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:04:49 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41610 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaHUUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:04:46 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: James Hogan <james.hogan@imgtec.com>, Paul Burton <paul.burton@imgtec.com>,
        David Daney <david.daney@cavium.com>,
        John Crispin <blogic@openwrt.org>,
        Jayachandran C <jchandra@broadcom.com>,
        Qais Yousef <qais.yousef@imgtec.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 0/7] MIPS: Move device-tree files to a common location
Date: Thu, 21 Aug 2014 13:04:19 -0700
Message-Id: <1408651466-8334-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be consistent with other architectures and to avoid unnecessary
makefile duplication, move all MIPS device-trees to arch/mips/boot/dts
and build them with a common makefile.

Patch 1 sets up the makefiles for building the DTs in arch/mips/boot/dts
and introduces the config option BUILTIN_DTB for platforms that require
it.

Patch 2 introduces the 'dtbs' makefile target to allow building of just
the DT binaries.

Patches 3-7 move the DTs out of the platform directores.

I've build tested this on all affected platforms (Octeon, Lantiq, SEAD3,
Netlogic, and Ralink) as well as Malta.  For platforms where builtin DTBs
are optional (Netlogic and Ralink), I built with and without the builtin
DTBs.

Based on 3.17-rc1.

Andrew Bresticker (7):
  MIPS: Create common infrastructure for building built-in device-trees
  MIPS: Add support for building device-tree binaries
  MIPS: Octeon: Move device-trees to arch/mips/boot/dts/
  MIPS: Lantiq: Move device-trees to arch/mips/boot/dts/
  MIPS: sead3: Move device-trees to arch/mips/boot/dts/
  MIPS: Netlogic: Move device-trees to arch/mips/boot/dts/
  MIPS: ralink: Move device-trees to arch/mips/boot/dts/

 arch/mips/Kconfig                                    |  5 +++++
 arch/mips/Makefile                                   | 11 +++++++++++
 arch/mips/boot/.gitignore                            |  1 +
 arch/mips/boot/dts/Makefile                          | 20 ++++++++++++++++++++
 arch/mips/{lantiq => boot}/dts/danube.dtsi           |  0
 arch/mips/{lantiq => boot}/dts/easy50712.dts         |  0
 arch/mips/{ralink => boot}/dts/mt7620a.dtsi          |  0
 arch/mips/{ralink => boot}/dts/mt7620a_eval.dts      |  0
 .../mips/{cavium-octeon => boot/dts}/octeon_3xxx.dts |  0
 .../mips/{cavium-octeon => boot/dts}/octeon_68xx.dts |  0
 arch/mips/{ralink => boot}/dts/rt2880.dtsi           |  0
 arch/mips/{ralink => boot}/dts/rt2880_eval.dts       |  0
 arch/mips/{ralink => boot}/dts/rt3050.dtsi           |  0
 arch/mips/{ralink => boot}/dts/rt3052_eval.dts       |  0
 arch/mips/{ralink => boot}/dts/rt3883.dtsi           |  0
 arch/mips/{ralink => boot}/dts/rt3883_eval.dts       |  0
 arch/mips/{mti-sead3 => boot/dts}/sead3.dts          |  0
 arch/mips/{netlogic => boot}/dts/xlp_evp.dts         |  0
 arch/mips/{netlogic => boot}/dts/xlp_fvp.dts         |  0
 arch/mips/{netlogic => boot}/dts/xlp_gvp.dts         |  0
 arch/mips/{netlogic => boot}/dts/xlp_svp.dts         |  0
 arch/mips/cavium-octeon/.gitignore                   |  2 --
 arch/mips/cavium-octeon/Makefile                     | 10 ----------
 arch/mips/lantiq/Kconfig                             |  1 +
 arch/mips/lantiq/Makefile                            |  2 --
 arch/mips/lantiq/dts/Makefile                        |  1 -
 arch/mips/mti-sead3/Makefile                         |  4 ----
 arch/mips/netlogic/Kconfig                           |  4 ++++
 arch/mips/netlogic/Makefile                          |  1 -
 arch/mips/netlogic/dts/Makefile                      |  4 ----
 arch/mips/ralink/Kconfig                             |  4 ++++
 arch/mips/ralink/Makefile                            |  2 --
 arch/mips/ralink/dts/Makefile                        |  4 ----
 33 files changed, 46 insertions(+), 30 deletions(-)
 create mode 100644 arch/mips/boot/dts/Makefile
 rename arch/mips/{lantiq => boot}/dts/danube.dtsi (100%)
 rename arch/mips/{lantiq => boot}/dts/easy50712.dts (100%)
 rename arch/mips/{ralink => boot}/dts/mt7620a.dtsi (100%)
 rename arch/mips/{ralink => boot}/dts/mt7620a_eval.dts (100%)
 rename arch/mips/{cavium-octeon => boot/dts}/octeon_3xxx.dts (100%)
 rename arch/mips/{cavium-octeon => boot/dts}/octeon_68xx.dts (100%)
 rename arch/mips/{ralink => boot}/dts/rt2880.dtsi (100%)
 rename arch/mips/{ralink => boot}/dts/rt2880_eval.dts (100%)
 rename arch/mips/{ralink => boot}/dts/rt3050.dtsi (100%)
 rename arch/mips/{ralink => boot}/dts/rt3052_eval.dts (100%)
 rename arch/mips/{ralink => boot}/dts/rt3883.dtsi (100%)
 rename arch/mips/{ralink => boot}/dts/rt3883_eval.dts (100%)
 rename arch/mips/{mti-sead3 => boot/dts}/sead3.dts (100%)
 rename arch/mips/{netlogic => boot}/dts/xlp_evp.dts (100%)
 rename arch/mips/{netlogic => boot}/dts/xlp_fvp.dts (100%)
 rename arch/mips/{netlogic => boot}/dts/xlp_gvp.dts (100%)
 rename arch/mips/{netlogic => boot}/dts/xlp_svp.dts (100%)
 delete mode 100644 arch/mips/cavium-octeon/.gitignore
 delete mode 100644 arch/mips/lantiq/dts/Makefile
 delete mode 100644 arch/mips/netlogic/dts/Makefile
 delete mode 100644 arch/mips/ralink/dts/Makefile

-- 
2.1.0.rc2.206.gedb03e5

