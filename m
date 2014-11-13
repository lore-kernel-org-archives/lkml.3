Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaKMHq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 02:46:59 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41934 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaKMHq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 02:46:57 -0500
From: Ankit Jindal <ankit.jindal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        Ankit Jindal <ankit.jindal@linaro.org>
Subject: [PATCH v4 0/6] UIO driver for APM X-Gene QMTM
Date: Thu, 13 Nov 2014 13:15:16 +0530
Message-Id: <1415864722-2800-1-git-send-email-ankit.jindal@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset enables user space access to APM X-Gene QMTM
using UIO framework.

The patchset also introduces new type UIO_MEM_PHYS_CACHE
for mem regions because APM X-Gene QMTM device supports
cache coherency with CPU caches.

Changes since v3:
 - Renamed qpool to qpool-memory in dt-binding.
 - Some cleanups in dt-binding documentation.

Changes since v2:
 - Formatting cleanups.
 - Remove qmtm_cleanup().

Changes since v1:
 - Factor-out formating related change in uio/uio.c as separate patch.
 - Use devm_xxx() APIs where appilicable.
 - Some cleanups and buggy loop fixed in qmtm_reset().
 - Removed open and release functions.
 - Use phandle for specifying QMTM qpool resource.
 - Removed "uio" from the compatible string.
 - Added more information about QMTM in binding documentation.

Ankit Jindal (6):
  uio: code style cleanup
  uio: Add new UIO_MEM_PHYS_CACHE type for mem regions
  Documentation: Update documentation for UIO_MEM_PHYS_CACHE
  uio: Add X-Gene QMTM UIO driver
  Documentation: dt-bindings: Add binding info for X-Gene QMTM UIO
    driver
  MAINTAINERS: Add entry for APM X-Gene QMTM UIO driver

 Documentation/DocBook/uio-howto.tmpl               |    5 +-
 .../devicetree/bindings/uio/uio_xgene_qmtm.txt     |   51 ++++
 MAINTAINERS                                        |    7 +
 drivers/uio/Kconfig                                |    8 +
 drivers/uio/Makefile                               |    1 +
 drivers/uio/uio.c                                  |   23 +-
 drivers/uio/uio_xgene_qmtm.c                       |  271 ++++++++++++++++++++
 include/linux/uio_driver.h                         |    1 +
 8 files changed, 356 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
 create mode 100644 drivers/uio/uio_xgene_qmtm.c

-- 
1.7.9.5

