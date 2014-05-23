Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaEWPKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:10:39 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48672 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaEWPKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:10:38 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [RESEND PATCH v5 0/5] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Fri, 23 May 2014 16:10:14 +0100
Message-Id: <1400857819-7975-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398355246-29571-1-git-send-email-daniel.thompson@linaro.org>
References: <1398355246-29571-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes some single-platform compatibility tricks related
to DEBUG_LL and, as a result, allows multi_v7_defconfig derived builds
to enable DEBUG_LL without forcibly selecting of the PL01X's DEBUG_LL
implementation (which doesn't work on some platforms).

* Tidy a couple of existing defconfig's so they continue to issue
  DEBUG_LL messages to PL01X when the subsequent changes come along.
* Limit DEBUG_LL_UART_NONE to platforms that support it
* Fix a potential build problem on EP93XX
* Get rid of the compatibility code that causes us to forcibly enable
  DEBUG_UART_PL01X 

Changes since v4:

* Rebased to latest mainline (and tested again). No functional changes.

Changes since v3:

* Converted from a single patch to a series.
* Tested defconfig builds of all impacted platforms.

Changes since v2:

* Switch from def_bool to bool (thanks Russell King)

Changes since v1:

* Remove pointless single platform support (thanks Arnd Bergmann)


Daniel Thompson (5):
  ARM: versatile: Enable DEBUG_LL_UART_PL01X
  ARM: ep93xx: Enable DEBUG_LL_UART_PL01X
  ARM: Conceal DEBUG_LL_UART_NONE from unsupported platforms
  arm: Seperate DEBUG_UART_PHYS from DEBUG_LL on EP93XX
  arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)

 arch/arm/Kconfig.debug               | 23 +++++++++++++++--------
 arch/arm/configs/ep93xx_defconfig    |  1 +
 arch/arm/configs/versatile_defconfig |  1 +
 3 files changed, 17 insertions(+), 8 deletions(-)

-- 
1.9.0

