Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaKHN3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:29:49 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57619 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbaKHN3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:29:47 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-b0-545e1ac65f20
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-iio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Antonio Borneo <borneo.antonio@gmail.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v4 0/1] misc: st32fwu: Add stm32 upgrade protocol handling
Date: Sat, 08 Nov 2014 14:29:11 +0100
Message-id: <1415453352-14842-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xq7rHpOJCDO6+Mbf4O+kYu8XGGetZ
	LQ6uXMZk8aBpFZPFqWX7mSx2/X/DbHG26Q27xbwj71gsLu+aw+bA6fH71yRGj52z7rJ7fPgY
	57FpVSebR9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGW8PraXueAIX8W9my9ZGhi3c3cxcnBI
	CJhIzNwR38XICWSKSVy4t56ti5GLQ0hgKaPE6h13GCGcPiaJkwdmM4FUsQmoSzTvWMwMkhAB
	qeq7fYkNJMEssJVRYus+WxBbWMBLYveM+2BxFgFViSdTzjOC2LwCzhI/2j6wQWxWkJgzyWYC
	I/cCRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCEB9GUH4+JjVocYBTgYlXh4LW7Ghgix
	JpYVV+YeYpTgYFYS4e09DxTiTUmsrEotyo8vKs1JLT7EyMTBKdXAqHZ1Fof/yyO6ZTuXeLo/
	y3h2ctIZJv8DF/OveEYKzV5q2tFVfFnQ3lote4mhWxx/fsTbTkdm8a08udnTzi+V7W4t4upK
	6lXcaiE1JXsWDw9zxKXIMObvVrOrl+zl/3btGvuKt38CMoPii1pmqkUrtk+9uz5p9mG9woBv
	Jgsc1scbLds1V0pPiaU4I9FQi7moOBEA1PlOwP4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch is needed by the sensorhub driver which uses STM32F4xx and Jonathan
suggested to factor out these sources (mentioned in: 
[RFC/PATCH 2/6] misc: sensorhub: Add sensorhub).

I feel a bit ashamed because I know a bit STM32F4 controllers but I did not
realize that it is generic ST protocol. It helped us a lot because this
code really needed some refactoring.

So this patch contains SPI protocol used in the STM32 bootloader and is based
on AN4286. Generally it can be used to implement handling of other interfaces
like UART or I2C because the flow is quite similar and maybe adding proper
hw access callbacks will do all work.

It supports:
  - get info frame
  - get version
  - firmware write (write, read, write address, erase)

>From v3:
  Fixes after Hartmut Knaack review:
    - typos, comments style
    - lengths, timeouts as unsigned values

TODO:
  erase command with sector mode
  command checking and disabling unimplemented ones


Karol Wrona (1):
  misc: st32fwu: Add stm32 upgrade protocol handling

 drivers/misc/Kconfig               |    1 +
 drivers/misc/Makefile              |    1 +
 drivers/misc/stm32fwu/Kconfig      |    6 +
 drivers/misc/stm32fwu/Makefile     |    1 +
 drivers/misc/stm32fwu/stm32_core.c |  403 ++++++++++++++++++++++++++++++++++++
 drivers/misc/stm32fwu/stm32_core.h |   81 ++++++++
 drivers/misc/stm32fwu/stm32_spi.c  |  108 ++++++++++
 include/linux/stm32fwu.h           |   49 +++++
 8 files changed, 650 insertions(+)
 create mode 100644 drivers/misc/stm32fwu/Kconfig
 create mode 100644 drivers/misc/stm32fwu/Makefile
 create mode 100644 drivers/misc/stm32fwu/stm32_core.c
 create mode 100644 drivers/misc/stm32fwu/stm32_core.h
 create mode 100644 drivers/misc/stm32fwu/stm32_spi.c
 create mode 100644 include/linux/stm32fwu.h

-- 
1.7.9.5

