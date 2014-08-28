Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965255AbaH1CKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:10:23 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:56568 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbaH1CKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:10:16 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: James Hogan <james.hogan@imgtec.com>, Paul Burton <paul.burton@imgtec.com>,
        David Daney <david.daney@cavium.com>,
        John Crispin <blogic@openwrt.org>,
        Jayachandran C <jchandra@broadcom.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonas Gorski <jogo@openwrt.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 0/7] MIPS: Move device-tree files to a common location
Date: Wed, 27 Aug 2014 19:10:05 -0700
Message-Id: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be consistent with other architectures and to avoid unnecessary
makefile duplication, move all MIPS device-trees to arch/mips/boot/dts
and build them with a common makefile.  Per Olof's suggestion in v1,
device-trees are grouped into per-vendor subdirectories.  Note that
since there is currently no Kbuild infrastructure for recursively
building dtbs like there is for object files, the top level Makefile
in arch/mips/boot/dts/ just includes the sub-Makefiles.

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

Based on 3.17-rc2.

Changes from v1:
 - moved to per-vendor subdirectories
 - rebased on 3.17-rc2

Andrew Bresticker (7):
  MIPS: Create common infrastructure for building built-in device-trees
  MIPS: Add support for building device-tree binaries
  MIPS: Octeon: Move device-trees to arch/mips/boot/dts/cavium-octeon/
  MIPS: Lantiq: Move device-trees to arch/mips/boot/dts/lantiq/
  MIPS: sead3: Move device-trees to arch/mips/boot/dts/mti/
  MIPS: Netlogic: Move device-trees to arch/mips/boot/dts/netlogic/
  MIPS: ralink: Move device-trees to arch/mips/boot/dts/ralink/

 arch/mips/Kconfig                                          |  5 +++++
 arch/mips/Makefile                                         | 11 +++++++++++
 arch/mips/boot/.gitignore                                  |  1 +
 arch/mips/boot/dts/Makefile                                | 14 ++++++++++++++
 arch/mips/boot/dts/cavium-octeon/Makefile                  |  2 ++
 arch/mips/{ => boot/dts}/cavium-octeon/octeon_3xxx.dts     |  0
 arch/mips/{ => boot/dts}/cavium-octeon/octeon_68xx.dts     |  0
 arch/mips/boot/dts/lantiq/Makefile                         |  1 +
 arch/mips/{lantiq/dts => boot/dts/lantiq}/danube.dtsi      |  0
 arch/mips/{lantiq/dts => boot/dts/lantiq}/easy50712.dts    |  0
 arch/mips/boot/dts/mti/Makefile                            |  1 +
 arch/mips/{mti-sead3 => boot/dts/mti}/sead3.dts            |  0
 arch/mips/boot/dts/netlogic/Makefile                       |  4 ++++
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_evp.dts  |  0
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_fvp.dts  |  0
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_gvp.dts  |  0
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_svp.dts  |  0
 arch/mips/boot/dts/ralink/Makefile                         |  4 ++++
 arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a.dtsi     |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a_eval.dts |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt2880.dtsi      |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt2880_eval.dts  |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3050.dtsi      |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3052_eval.dts  |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3883.dtsi      |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3883_eval.dts  |  0
 arch/mips/cavium-octeon/.gitignore                         |  2 --
 arch/mips/cavium-octeon/Makefile                           | 10 ----------
 arch/mips/lantiq/Kconfig                                   |  1 +
 arch/mips/lantiq/Makefile                                  |  2 --
 arch/mips/lantiq/dts/Makefile                              |  1 -
 arch/mips/mti-sead3/Makefile                               |  4 ----
 arch/mips/netlogic/Kconfig                                 |  4 ++++
 arch/mips/netlogic/Makefile                                |  1 -
 arch/mips/netlogic/dts/Makefile                            |  4 ----
 arch/mips/ralink/Kconfig                                   |  4 ++++
 arch/mips/ralink/Makefile                                  |  2 --
 arch/mips/ralink/dts/Makefile                              |  4 ----
 38 files changed, 52 insertions(+), 30 deletions(-)
 create mode 100644 arch/mips/boot/dts/Makefile
 create mode 100644 arch/mips/boot/dts/cavium-octeon/Makefile
 rename arch/mips/{ => boot/dts}/cavium-octeon/octeon_3xxx.dts (100%)
 rename arch/mips/{ => boot/dts}/cavium-octeon/octeon_68xx.dts (100%)
 create mode 100644 arch/mips/boot/dts/lantiq/Makefile
 rename arch/mips/{lantiq/dts => boot/dts/lantiq}/danube.dtsi (100%)
 rename arch/mips/{lantiq/dts => boot/dts/lantiq}/easy50712.dts (100%)
 create mode 100644 arch/mips/boot/dts/mti/Makefile
 rename arch/mips/{mti-sead3 => boot/dts/mti}/sead3.dts (100%)
 create mode 100644 arch/mips/boot/dts/netlogic/Makefile
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_evp.dts (100%)
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_fvp.dts (100%)
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_gvp.dts (100%)
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_svp.dts (100%)
 create mode 100644 arch/mips/boot/dts/ralink/Makefile
 rename arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a_eval.dts (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt2880.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt2880_eval.dts (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3050.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3052_eval.dts (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3883.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3883_eval.dts (100%)
 delete mode 100644 arch/mips/cavium-octeon/.gitignore
 delete mode 100644 arch/mips/lantiq/dts/Makefile
 delete mode 100644 arch/mips/netlogic/dts/Makefile
 delete mode 100644 arch/mips/ralink/dts/Makefile

-- 
2.1.0.rc2.206.gedb03e5

