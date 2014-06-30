Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaF3LbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:31:15 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47313 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaF3LbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:31:14 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v7 0/4] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Mon, 30 Jun 2014 12:30:51 +0100
Message-Id: <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401206421-29832-1-git-send-email-daniel.thompson@linaro.org>
References: <1401206421-29832-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes some single-platform compatibility tricks related
to DEBUG_LL and, as a result, allows multi_v7_defconfig derived builds
to enable DEBUG_LL. Currently the user selected kbuild setting is
ignored and the PL01X's DEBUG_LL stub is silently selected instead. This
is a pain if your hardware doesn't have this cell, not least because it
takes a little time to figure out that kbuild built the wrong code.

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

Daniel Thompson (4):
  ARM: versatile: Enable DEBUG_LL_UART_PL01X
  ARM: ep93xx: Enable DEBUG_LL_UART_PL01X
  arm: Seperate DEBUG_UART_PHYS from DEBUG_LL on EP93XX
  arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)

 arch/arm/Kconfig.debug               | 10 +++-------
 arch/arm/configs/ep93xx_defconfig    |  1 +
 arch/arm/configs/versatile_defconfig |  1 +
 3 files changed, 5 insertions(+), 7 deletions(-)

--
1.9.3

