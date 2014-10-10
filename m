Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaJJLzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:55:06 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33993 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbaJJLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:55:01 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-bb-5437c91326e2
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v2 0/1] misc: st32boot: Add stm32 upgrade protocol handling
Date: Fri, 10 Oct 2014 13:54:42 +0200
Message-id: <1412942083-28231-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBJMWRmVeSWpSXmKPExsVy+t/xy7rCJ81DDL4sY7b4O+kYu8XGGetZ
	LR40rWKyOLVsP5PF2aY37Bbzjrxjsbi8aw6bA7vH71+TGD02repk8+jbsorR4/MmuQCWKC6b
	lNSczLLUIn27BK6MJ9PbGAtm8VZ8nvWXtYFxM1cXIyeHhICJxOzGI8wQtpjEhXvr2boYuTiE
	BJYySlw40soM4fQxSSw+dYYJpIpNQF2iecdisISIQCOjxM3F/WwgCWaBDkaJRe1gY4UFvCW6
	5k4EG8sioCrx8sJ91i5GDg5eAWeJnuf5IKaEgILEnEk2Exi5FzAyrGIUTS1NLihOSs810itO
	zC0uzUvXS87P3cQICY2vOxiXHrM6xCjAwajEw3tBxjxEiDWxrLgy9xCjBAezkgjv/L1AId6U
	xMqq1KL8+KLSnNTiQ4xMHJxSDYxL96bem3c+6HXKfyHvCW8t/0Qu2pGjUODGckj8+IR05aNr
	gsR1Wk4yu5QuTRBvPnq+/bit95Kpnpmyv6dN0J2uEbmbn72t31w/ZFuLzpwZBVPnvWvc5bTY
	r6lSiNtE/Lkzv8GNE4Z+3ge/rfKZnMp4Pvhl3BHGIzs3TzunW6crNrnDPVhlUqYSS3FGoqEW
	c1FxIgDLC+ZR6wEAAA==
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

>From v1: some typos fixes


Karol

Karol Wrona (1):
  misc: st32boot: Add stm32 upgrade protocol handling

 drivers/misc/Kconfig                |    1 +
 drivers/misc/Makefile               |    1 +
 drivers/misc/stm32boot/Kconfig      |    6 +
 drivers/misc/stm32boot/Makefile     |    3 +
 drivers/misc/stm32boot/stm32_core.c |  412 +++++++++++++++++++++++++++++++++++
 drivers/misc/stm32boot/stm32_core.h |   81 +++++++
 drivers/misc/stm32boot/stm32_spi.c  |  108 +++++++++
 include/linux/stm32fwu.h            |   47 ++++
 8 files changed, 659 insertions(+)
 create mode 100644 drivers/misc/stm32boot/Kconfig
 create mode 100644 drivers/misc/stm32boot/Makefile
 create mode 100644 drivers/misc/stm32boot/stm32_core.c
 create mode 100644 drivers/misc/stm32boot/stm32_core.h
 create mode 100644 drivers/misc/stm32boot/stm32_spi.c
 create mode 100644 include/linux/stm32fwu.h

-- 
1.7.9.5

