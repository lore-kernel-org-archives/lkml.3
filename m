Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaCLNiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:38:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36717 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaCLNiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:38:07 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-51-5320633ed475
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        cooloney@gmail.com, rpurdie@rpsys.net, dbaryshkov@gmail.com,
        dwmw2@infradead.org, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 0/3] mfd: max8997: add regmap support
Date: Wed, 12 Mar 2014 14:37:43 +0100
Message-id: <1394631466-6429-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQV27ZIVggzVt/BZLLl5lt5j68Amb
	xdGdE5ksrn95zmox6cl7ZovDi14wWkxcOZnZ4vULQ4v7X48yWny70sFkcfPTN1aLy7vmsFls
	fbOO0WLtkbvsFrcbV7BZXNt7nNniweGd7Ba7dz1ltdjf2cFocbqb1UHEY+esu+weeyaeZPPY
	vELLY9OqTjaPO9f2sHnMOxnosWf+D1aPvi2rGD2mz/vJ5PF5k5zH+i1bmQK4o7hsUlJzMstS
	i/TtErgyPt7qZi7YxFPxdfdytgbGU5xdjJwcEgImEp/OXWaBsMUkLtxbz9bFyMUhJDCdUeLl
	zWOMEE47k8T97++ZQKrYBHQktnyfwAhiiwjoS3zYcZUZpIhZ4CazxJwz/WAJYQELiUnvNoDZ
	LAKqEsc+zANr5hVwkVixZzZQnANonYLEnEk2Exi5FzAyrGIUTS1ILihOSs811CtOzC0uzUvX
	S87P3cQIDu5nUjsYVzZYHGIU4GBU4uFdoCkfLMSaWFZcmXuIUYKDWUmEd1mUQrAQb0piZVVq
	UX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGRtvJd1/tbaubOn3Xw7vt
	6Tm1yt8jL/DH751mpzTlgztf/qN0iyy+vqi/EgEZLp/WrV+SufPeu/iNDS8/VR9d5O8/vV95
	/8LJs872zC6en9o2eefX32omTzPPr5R9IKv6eFvpJ7Wy6YXnLyVN4n9nY6w7VXKNysLn5+u4
	5+X8T9Ccsv7UhoBv4bJKLMUZiYZazEXFiQDSIKVHagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset modifies max8997 driver and associated function drivers to use
register maps instead of operating directly on i2c bus. This change allowed
to simplify irq handling, and to move some initializations to individual
function drivers. Hence now when some functions are not enabled, their i2c
clients, regmaps and irqs are not registered.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:

v2:
- rebase patches on Lee Jones' MFD tree
- add missing selects in Kconfig
- add missing deinitializations
- add interrupt disabling when suspend
- few minor changes and typo fixes

v1: https://lkml.org/lkml/2014/3/11/291

Robert Baldyga (3):
  mfd: max8997: use regmap to access registers
  mfd: max8997: handle IRQs using regmap
  mfd: max8997: move regmap handling to function drivers

 drivers/extcon/extcon-max8997.c     |  176 +++++++++++++---
 drivers/input/misc/max8997_haptic.c |  121 +++++++++--
 drivers/leds/leds-max8997.c         |   13 +-
 drivers/mfd/Kconfig                 |    3 +-
 drivers/mfd/Makefile                |    2 +-
 drivers/mfd/max8997-irq.c           |  387 -----------------------------------
 drivers/mfd/max8997.c               |  237 +++++++--------------
 drivers/power/max8997_charger.c     |   33 +--
 drivers/regulator/max8997.c         |   87 ++++----
 drivers/rtc/rtc-max8997.c           |  102 ++++++---
 include/linux/mfd/max8997-private.h |   88 ++++++--
 11 files changed, 528 insertions(+), 721 deletions(-)
 delete mode 100644 drivers/mfd/max8997-irq.c

-- 
1.7.9.5

