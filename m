Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbaJNOhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:37:55 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46171 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaJNOhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:37:53 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-34-543d353e4557
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Antonio Borneo <borneo.antonio@gmail.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v3 0/1] misc: st32fwu: Add stm32 upgrade protocol handling
Date: Tue, 14 Oct 2014 16:37:44 +0200
Message-id: <1413297465-11039-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t/xy7p2prYhBpfum1r8nXSM3WLjjPWs
	FgdXLmOyeNC0isni1LL9TBZnm96wW8w78o7F4vKuOWwOHB6/f01i9Ng56y67x6ZVnWwefVtW
	MXp83iQXwBrFZZOSmpNZllqkb5fAlfFu5kzGgnf8FUe21jcw7uHpYuTkkBAwkZg/8SkThC0m
	ceHeerYuRi4OIYGljBLHejazQzh9TBIz2+exgVSxCahLNO9YzAySEBFoZJS4ubgfLMEssJVR
	Yus+2y5GDg5hAS+JvweSQMIsAqoSJz60s4CEeQWcJZa1iIOYEgIKEnMm2Uxg5F7AyLCKUTS1
	NLmgOCk911CvODG3uDQvXS85P3cTIyRUvuxgXHzM6hCjAAejEg9vQaRNiBBrYllxZe4hRgkO
	ZiURXgUO2xAh3pTEyqrUovz4otKc1OJDjEwcnFINjOVd4on64SnzszISs68YXDL9fHqCpNda
	A9fDtgVL5efFRnFnbDt566F47vVHdjebD1+Wzoxe4FqaNbPydZCvWqrIqxnHK5ND252F2udv
	Say6c63uqa35ixNTHKsv8DcJnmE6nGCeOnvGXtXAA3FGSr82PNQqeMadvM+D/bd1xa2nteqF
	Ycv1lViKMxINtZiLihMBGbFsiPMBAAA=
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

>From v2:
  some typos fixes
  kfree to devm_kfree in error handling
  ...
  generally things advised by Antonio Borneo for v2

TODO (I will not have had time to touch it for few weeks):
  erase command with sector mode
  command checking and disabling unimplemented ones

Also some Antonio opinion is needed if we are able (or want) to use the same
stm32_core layer for this.

Karol Wrona (1):
  misc: st32fwu: Add stm32 upgrade protocol handling

 drivers/misc/Kconfig               |    1 +
 drivers/misc/Makefile              |    1 +
 drivers/misc/stm32fwu/Kconfig      |    6 +
 drivers/misc/stm32fwu/Makefile     |    3 +
 drivers/misc/stm32fwu/stm32_core.c |  399 ++++++++++++++++++++++++++++++++++++
 drivers/misc/stm32fwu/stm32_core.h |   81 ++++++++
 drivers/misc/stm32fwu/stm32_spi.c  |  108 ++++++++++
 include/linux/stm32fwu.h           |   47 +++++
 8 files changed, 646 insertions(+)
 create mode 100644 drivers/misc/stm32fwu/Kconfig
 create mode 100644 drivers/misc/stm32fwu/Makefile
 create mode 100644 drivers/misc/stm32fwu/stm32_core.c
 create mode 100644 drivers/misc/stm32fwu/stm32_core.h
 create mode 100644 drivers/misc/stm32fwu/stm32_spi.c
 create mode 100644 include/linux/stm32fwu.h

-- 
1.7.9.5

