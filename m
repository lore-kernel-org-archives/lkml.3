Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaB1XTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:19:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46417 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaB1XT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:19:29 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Sandeep Nair <sandeep_n@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 0/3] soc: Introduce drivers/soc and add Keystone QMSS driver
Date: Fri, 28 Feb 2014 18:18:37 -0500
Message-ID: <1393629520-12713-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on earlier thread "https://lkml.org/lkml/2013/10/7/662" and
further discussion at Kernel Summit'2013, series creates 'driver/soc'
for drivers which are very SOC specific.

Then we add the Keystone QMSS (Queue Manager SubSystem) driver.
The QMSS found on Keystone SOCs is one of the main hardware sub
system which forms the backbone of the Keystone Multi-core Navigator.
QMSS consist of queue managers, packed-data structure processors(PDSP),
linking RAM, descriptor pools and infrastructure DMA.

Sandeep Nair (2):
  soc: keystone: add QMSS driver
  firmware: add Keystone QMSS PDSP accumulator firmware blob

Santosh Shilimkar (1):
  soc: Introduce drivers/soc place-holder for SOC specific drivers

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sandeep Nair <sandeep_n@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>

 .../devicetree/bindings/soc/keystone-qmss.txt      |  209 +++
 drivers/Kconfig                                    |    4 +
 drivers/Makefile                                   |    7 +
 drivers/soc/Kconfig                                |    5 +
 drivers/soc/Makefile                               |    5 +
 drivers/soc/keystone/Kconfig                       |   15 +
 drivers/soc/keystone/Makefile                      |    5 +
 drivers/soc/keystone/qmss_acc.c                    |  591 ++++++++
 drivers/soc/keystone/qmss_queue.c                  | 1533 ++++++++++++++++++++
 drivers/soc/keystone/qmss_queue.h                  |  236 +++
 firmware/Makefile                                  |    1 +
 .../keystone/qmss_pdsp_acc48_k2_le_1_0_0_8.fw.ihex |  110 ++
 include/linux/soc/keystone_qmss.h                  |  390 +++++
 13 files changed, 3111 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/keystone-qmss.txt
 create mode 100644 drivers/soc/Kconfig
 create mode 100644 drivers/soc/Makefile
 create mode 100644 drivers/soc/keystone/Kconfig
 create mode 100644 drivers/soc/keystone/Makefile
 create mode 100644 drivers/soc/keystone/qmss_acc.c
 create mode 100644 drivers/soc/keystone/qmss_queue.c
 create mode 100644 drivers/soc/keystone/qmss_queue.h
 create mode 100644 firmware/keystone/qmss_pdsp_acc48_k2_le_1_0_0_8.fw.ihex
 create mode 100644 include/linux/soc/keystone_qmss.h

-- 
1.7.9.5

