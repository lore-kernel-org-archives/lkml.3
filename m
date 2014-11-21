Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaKUSRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:17:53 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60822 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaKUSRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:17:51 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-73-546f81cd979c
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-iio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Antonio Borneo <borneo.antonio@gmail.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v5 0/1] misc: st32fwu: Add stm32 upgrade protocol handling
Date: Fri, 21 Nov 2014 19:17:27 +0100
Message-id: <1416593848-19676-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsVy+t/xq7pnG/NDDDbM47f4O+kYu8XGGetZ
	LQ6uXMZk8aBpFZPFqWX7mSx2/X/DbHG26Q27xbwj71gsLu+aw+bA6fH71yRGj52z7rJ7fPgY
	57FpVSebR9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGVcnXuEsWC7QMXFiT9YGhhf8XQxcnJI
	CJhILJ69kA3CFpO4cG89kM3FISSwlFGi7eZfJginj0li47vJTCBVbALqEs07FjODJERAqvpu
	XwJrZxbYyiixdZ8tiC0s4CUx9+xtZhCbRUBVYtrjqWDNvALOEhdW9bB0MXIArVOQmDPJZgIj
	9wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYISH0dQfj0mNWhxgFOBiVeHgvzMoNEWJN
	LCuuzD3EKMHBrCTCWy6cHyLEm5JYWZValB9fVJqTWnyIkYmDU6qB8eCXi8nKvsIm91y6k3/l
	fnySIaletGHn2bVGRS2KrF4fLTNbXoa+W3QxmWWHrv7eHImvO34a3NwUtPB5y7r2p3ayH5uk
	3VxnXc/+uj20dE4U17Xwgg3eN1ac/MKmc07v6DvZp9NsfeOnmq7QZlF3ntA26fmy5VHrTLOe
	sxmmzxOZ/5zZald9uhJLcUaioRZzUXEiAFN6Czr/AQAA
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

>From v4:
  After some Antonio Borneo comments:
    - ack is specific for Samsung (or ST bootcode v1.0)
    - fixed read method
    - spi sync function was renamed as it is SPI specific
    - removed ACK2 define
    - add iface fiels to stm32fwu_fw struct to maintain different protocol
    versions

TODO:
  - erase command with sector mode
  - command checking and disabling unimplemented ones
  - spi wait for ack compatible with ST bootcode v1.1

Karol Wrona (1):
  misc: st32fwu: Add stm32 upgrade protocol handling

 drivers/misc/Kconfig               |    1 +
 drivers/misc/Makefile              |    1 +
 drivers/misc/stm32fwu/Kconfig      |    6 +
 drivers/misc/stm32fwu/Makefile     |    1 +
 drivers/misc/stm32fwu/stm32_core.c |  408 ++++++++++++++++++++++++++++++++++++
 drivers/misc/stm32fwu/stm32_core.h |   81 +++++++
 drivers/misc/stm32fwu/stm32_spi.c  |  117 +++++++++++
 include/linux/stm32fwu.h           |   53 +++++
 8 files changed, 668 insertions(+)
 create mode 100644 drivers/misc/stm32fwu/Kconfig
 create mode 100644 drivers/misc/stm32fwu/Makefile
 create mode 100644 drivers/misc/stm32fwu/stm32_core.c
 create mode 100644 drivers/misc/stm32fwu/stm32_core.h
 create mode 100644 drivers/misc/stm32fwu/stm32_spi.c
 create mode 100644 include/linux/stm32fwu.h

-- 
1.7.9.5

