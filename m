Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaEEK6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:58:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36381 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaEEK6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:58:39 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-93-53676ede14e1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 0/7] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with secure
 firmware enabled
Date: Mon, 05 May 2014 12:57:12 +0200
Message-id: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jAd17eenBBq1nxS02zljPajHvs6xF
	74KrbBZnm96wW7w/9IzZYtPja6wWl3fNYbP43HuE0WLG+X1MFmdOX2K1OPmnl9Fi/YzXLBYb
	v3o48HrcubaHzWPzknqP2/8eM3tsudrO4tG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZj47n
	FVzgrjg1/RZLA+Nuzi5GTg4JAROJNW0/2CFsMYkL99azdTFycQgJLGKU6D7whhEkISTQxSTR
	skMExGYTsJKY2L4KLC4ioCbRs3grI0gDs8BeZoml3ZvAJgkLJErc/rAbzGYRUJVYe3c5E4jN
	K+AhcXHDV6htihLdzyawTWDkXsDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOMieSe1g
	XNlgcYhRgINRiYc3gTk9WIg1say4MvcQowQHs5IIb3YiUIg3JbGyKrUoP76oNCe1+BCjNAeL
	kjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAPjyrP5kjyRi47N2MuXdjjl677A57GdK+3XZIsw
	XHHfk2u1XO98zj1T/h6lT1+V7m0/te+F2yaFJzcXysTKR8is2f2kZ9eNOs+MvoRplTsVjebc
	UjaxDHzWfsgipOjCUoEDE67dsXp7purCcT/h7qV5M/4/4djc+Ud2fvs104/P59nZblhgXPLw
	qxJLcUaioRZzUXEiAN7s3g0uAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series fixes support for AFTR idle mode on boards with
secure firmware enabled (it also includes fix for register setup on
EXYNOS4x12 SoCs).  It has been tested on Trats2 target but should
also work on (EXYNOS4412 based) Insignal Origen board.

This patchset depends on "[PATCH V5 00/20] ARM: exynos: cpuidle:
Move the driver to drivers/cpuidle" patch series from Daniel Lezcano
("http://www.spinics.net/lists/linux-samsung-soc/msg28494.html").

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (5):
  ARM: EXYNOS: add AFTR mode support to firmware do_idle method
  ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
  ARM: EXYNOS: PM: use c15resume firmware method if secure firmware is
    enabled
  ARM: EXYNOS: PM: fix register setup on EXYNOS4x12 for AFTR mode code
  ARM: EXYNOS: cpuidle: add secure firmware support to AFTR mode code

Kyungmin Park (1):
  arm: firmware: Check firmware is running or not

Tomasz Figa (1):
  ARM: EXYNOS: add support for firmware-assisted c15resume

 arch/arm/common/firmware.c       |  5 +++++
 arch/arm/include/asm/firmware.h  | 14 +++++++++++++-
 arch/arm/mach-exynos/firmware.c  | 18 ++++++++++++++++--
 arch/arm/mach-exynos/pm.c        | 40 ++++++++++++++++++++++++++++++++--------
 drivers/cpuidle/cpuidle-exynos.c |  7 ++++++-
 5 files changed, 72 insertions(+), 12 deletions(-)

-- 
1.8.2.3

