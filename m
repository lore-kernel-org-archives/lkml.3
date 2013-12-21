Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3LUC5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:57:44 -0500
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:52313 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752135Ab3LUC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:57:42 -0500
From: Ravi Patel <rapatel@apm.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jcm@redhat.com, patches@apm.com, Ravi Patel <rapatel@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Subject: [PATCH V2 0/4] misc: xgene: Add support for APM X-Gene SoC Queue Manager/Traffic Manager
Date: Fri, 20 Dec 2013 18:57:27 -0800
Message-Id: <1387594651-25771-1-git-send-email-rapatel@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for APM X-Gene SoC Queue Manager/Traffic Manager.
 QMTM is required by APM X-Gene SoC Ethernet, PktDMA (XOR Engine) and
 Security Engine subsystems. All subsystems communicate with QMTM using
 messages which include information about the work to be performed and
 the location of associated data buffers.  

V2:
 * Adding COMPILE_TEST dependency for QMTM in Kconfig
 * Updated license banner as per review comments
 * Fixed alignment for macros
 * Changed EXPORT_SYMBOL to EXPORT_SYMBOL_GPL

V1:
 * inital version

Signed-off-by: Ravi Patel <rapatel@apm.com>
Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
---
Ravi Patel (4):
  Documentation: Add documentation for APM X-Gene SoC Queue
    Manager/Traffic Manager DTS binding
  misc: xgene: Add base driver for APM X-Gene SoC Queue Manager/Traffic
    Manager
  arm64: boot: dts: Add DTS entries for APM X-Gene SoC Queue
    Manager/Traffic Manager
  misc: xgene: Add error handling for APM X-Gene SoC Queue
    Manager/Traffic Manager

 .../devicetree/bindings/misc/apm-xgene-qmtm.txt    |   51 ++
 MAINTAINERS                                        |    7 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   17 +
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/xgene/Kconfig                         |    1 +
 drivers/misc/xgene/Makefile                        |    5 +
 drivers/misc/xgene/qmtm/Kconfig                    |    9 +
 drivers/misc/xgene/qmtm/Makefile                   |    7 +
 drivers/misc/xgene/qmtm/xgene_qmtm_error.c         |  283 ++++++++
 drivers/misc/xgene/qmtm/xgene_qmtm_main.c          |  765 ++++++++++++++++++++
 drivers/misc/xgene/qmtm/xgene_qmtm_main.h          |  138 ++++
 drivers/misc/xgene/qmtm/xgene_qmtm_storm.c         |  370 ++++++++++
 drivers/misc/xgene/qmtm/xgene_qmtm_storm.h         |  139 ++++
 include/misc/xgene/xgene_qmtm.h                    |  277 +++++++
 15 files changed, 2071 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/apm-xgene-qmtm.txt
 create mode 100644 drivers/misc/xgene/Kconfig
 create mode 100644 drivers/misc/xgene/Makefile
 create mode 100644 drivers/misc/xgene/qmtm/Kconfig
 create mode 100644 drivers/misc/xgene/qmtm/Makefile
 create mode 100644 drivers/misc/xgene/qmtm/xgene_qmtm_error.c
 create mode 100644 drivers/misc/xgene/qmtm/xgene_qmtm_main.c
 create mode 100644 drivers/misc/xgene/qmtm/xgene_qmtm_main.h
 create mode 100644 drivers/misc/xgene/qmtm/xgene_qmtm_storm.c
 create mode 100644 drivers/misc/xgene/qmtm/xgene_qmtm_storm.h
 create mode 100644 include/misc/xgene/xgene_qmtm.h

-- 
1.7.9.5

