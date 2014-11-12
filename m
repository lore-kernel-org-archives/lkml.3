Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaKLHXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:23:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12610 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaKLHXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:23:43 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-20-54630af7daf3
From: Robert Baldyga <r.baldyga@samsung.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        dmitry.torokhov@gmail.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, sachin.kamat@linaro.org,
        k.kozlowski@samsung.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-pm@vger.kernel.org, rtc-linux@googlegroups.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v5 0/3] mfd: max8997: add regmap support
Date: Wed, 12 Nov 2014 08:23:13 +0100
Message-id: <1415776996-11569-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jQd3vXMkhBvufClssuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi9cvDC3ufz3KaPHtSgeTxc1P31gtLu+aw2ax
	9c06RovPvUcYLW43rmCzuLb3OLPFg8M72S1273rKarG/s4PR4uSfXkaL092sFqd3lziIeeyc
	dZfdY8/Ek2wem1doeWxa1cnmcefaHjaPeScDPfbM/8Hq0bdlFaPH9Hk/mTw+b5LzWL9lK1MA
	dxSXTUpqTmZZapG+XQJXxuS9vUwFp/krNl9Yx9zAOJuni5GTQ0LARGJtx2xmCFtM4sK99Wxd
	jFwcQgLTGSW2dn2EctqZJI6+ewRWxSagI7Hl+wRGEFtEQEJi448+FpAiZoHZLBIvXj9iA0kI
	C1hIXDuxhhXEZhFQlZh9pxHM5hVwlbg8oZkdYp2cxMljk1knMHIvYGRYxSiaWpBcUJyUnmuk
	V5yYW1yal66XnJ+7iREc8M+kdzCuarA4xCjAwajEw5uxOSlEiDWxrLgy9xCjBAezkgjvp69A
	Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxSDYyGJ3+YXFBr
	MnJ/IiD052kfLzvXb1UeR622tryp+kJBU1WO33kf8KHL9GuGZfjq7RU3DTvfbDT+q7n0a2dV
	0NkfP+5k82U2CIRHvbyuLS6QmHA0vXhhYZC90o8j5fvNewr+/t2i+jbxdsAEibfdqj+Ct1Vv
	Pauw98iS1nq2ZVG7f5UsMmme5qfEUpyRaKjFXFScCADRm8XEdAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset modifies max8997 driver and associated function drivers to use
register maps instead of operating directly on i2c bus. This change allowed
to simplify irq handling, and to move some initializations to individual
function drivers. Hence now when some functions are not enabled, their i2c
clients, regmaps and irqs are not registered.

Because patches are under review for very long time and I still don't have
all needed Acks, I'm resending this series rebased to the latest next branch.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:

v5:
- rebase patches to last next branch

v4:
- remove patch moving regmap handling to function drivers

v3: https://lkml.org/lkml/2014/3/13/101
- fix error handling
- fix deinitializations order
- move muic irq enum values renaming to separate patch

v2: https://lkml.org/lkml/2014/3/12/237
- rebase patches on Lee Jones' MFD tree
- add missing selects in Kconfig
- add missing deinitializations
- add interrupt disabling when suspend
- few minor changes and typo fixes

v1: https://lkml.org/lkml/2014/3/11/291

Robert Baldyga (3):
  mfd: max8997: use regmap to access registers
  mfd: max8997: handle IRQs using regmap
  mfd: max8997: change irq names to upper case

 drivers/extcon/extcon-max8997.c     |  66 +++---
 drivers/input/misc/max8997_haptic.c |  34 ++--
 drivers/leds/leds-max8997.c         |  13 +-
 drivers/mfd/Kconfig                 |   3 +-
 drivers/mfd/Makefile                |   2 +-
 drivers/mfd/max8997-irq.c           | 387 ------------------------------------
 drivers/mfd/max8997.c               | 245 +++++++++++++++--------
 drivers/power/max8997_charger.c     |  33 +--
 drivers/regulator/max8997.c         |  87 ++++----
 drivers/rtc/rtc-max8997.c           |  58 +++---
 include/linux/mfd/max8997-private.h |  82 ++++++--
 11 files changed, 381 insertions(+), 629 deletions(-)
 delete mode 100644 drivers/mfd/max8997-irq.c

-- 
1.9.1

