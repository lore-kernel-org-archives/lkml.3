Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaHSOsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:48:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48769 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaHSOsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:48:50 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v8 0/9] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Tue, 19 Aug 2014 15:48:26 +0100
Message-Id: <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
References: <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes some single-platform compatibility tricks related
to DEBUG_LL and, as a result, allows multi_v7_defconfig derived builds
to enable DEBUG_LL. Currently the user selected kbuild setting is
ignored and the PL01X's DEBUG_LL stub is silently selected instead. This
is a pain if your hardware doesn't have this cell, not least because it
takes a little time to figure out that kbuild built the wrong code.

Warning:

    silentoldconfig on PL011 single platforms will result in DEBUG_LL
    being directed at ICEDCC rather than PL011. This should only
    affect silentoldconfig since oldconfig prompts and the defconfigs have
    been updated to avoid this problem.

Changes since v7:
- Killed DEBUG_LL_UART_NONE completely and migrated over the four remaining
  platforms that relied on this (Arnd Bergmann, Russell King). This
  fixes some problems with oldconfig builds.
- Rebased on latest mainline (v3.17rc1).

Changes since v6:
- Removed a patch to limit DEBUG_LL_UART_NONE to platforms that support
  it because it almost time to drop DEBUG_LL_UART_NONE anyway (only
  four platforms still use it).
- Rebased on latest mainline (v3.16rc3).

Changes since v5:

- Shortened the list of platforms that can select DEBUG_LL_UART_NONE
  (changes Arnd Bergmann)
- Rebased on latest mainline (v3.15rc7).

Changes since v4:

- Rebased to latest mainline (and tested again). No functional changes.

Changes since v3:

- Converted from a single patch to a series.
- Tested defconfig builds of all impacted platforms.

Changes since v2:

- Switch from def_bool to bool (thanks Russell King)

Changes since v1:

- Remove pointless single platform support (thanks Arnd Bergmann)

Daniel Thompson (9):
  arm: versatile: Enable DEBUG_LL_UART_PL01X
  arm: ep93xx: Enable DEBUG_LL_UART_PL01X
  arm: Remove DEBUG_LL_UART_NONE
  arm: ks8695: Migrate debug_ll macros to shared directory
  arm: omap1: Migrate debug_ll macros to use 8250.S
  arm: netx: Migrate DEBUG_LL macros to shared directory
  arm: sa1100: Migrate DEBUG_LL macros to shared directory
  arm: Seperate DEBUG_UART_PHYS from DEBUG_LL on EP93XX
  arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)

 arch/arm/Kconfig.debug                          | 138 ++++++++++++++++++++----
 arch/arm/configs/ep93xx_defconfig               |   1 +
 arch/arm/configs/versatile_defconfig            |   1 +
 arch/arm/include/debug/ks8695.S                 |  40 +++++++
 arch/arm/include/debug/netx.S                   |  36 +++++++
 arch/arm/include/debug/sa1100.S                 |  37 +++++++
 arch/arm/mach-ks8695/include/mach/debug-macro.S |  36 -------
 arch/arm/mach-netx/include/mach/debug-macro.S   |  36 -------
 arch/arm/mach-omap1/include/mach/debug-macro.S  | 101 -----------------
 arch/arm/mach-sa1100/include/mach/debug-macro.S |  62 -----------
 10 files changed, 233 insertions(+), 255 deletions(-)
 create mode 100644 arch/arm/include/debug/ks8695.S
 create mode 100644 arch/arm/include/debug/netx.S
 create mode 100644 arch/arm/include/debug/sa1100.S
 delete mode 100644 arch/arm/mach-ks8695/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-netx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-omap1/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-sa1100/include/mach/debug-macro.S

--
1.9.3

