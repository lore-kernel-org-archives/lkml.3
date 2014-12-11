Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967570AbaLKXCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:02:53 -0500
Received: from mail-ig0-f201.google.com ([209.85.213.201]:45341 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967359AbaLKW7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:59:21 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <james.hartley@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        Damien Horsley <Damien.Horsley@imgtec.com>,
        Arnd Bergmann <arnd@arndb.de>, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 0/2] dmaengine: Support for IMG MDC
Date: Thu, 11 Dec 2014 14:59:15 -0800
Message-Id: <1418338757-10022-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the IMG Multi-threaded DMA Controller (MDC)
which is found on IMG SoCs.  Currently this driver only supports the
variant found on the MIPS-based Pistachio SoC.

The MDC supports slave and memory-to-memory transfers on up to 32 channels.
Requests from channels are handled by MDC threads.  Thread assignments are
per-channel and are specified in the device-tree.

Tested on a platform based on the Pistachio SoC with additional patches.
Support for Pistachio will be submitted later.  Slave DMA was tested
with the recently submitted IMG SPFI driver [1] and memory-to-memory
DMA was tested with the dmatest module.

Based on Vinod's slave-dma/topic/slave_caps_device_control_fix.

Changes from v2:
 - addressed Vinod's review comments
Changes from v1:
 - addressed Arnd's review comments
 - rebased on Maxime's dmaengine cleanups

[1] https://lkml.org/lkml/2014/11/12/763

Andrew Bresticker (2):
  dmaengine: Add binding document for IMG MDC
  dmaengine: Add driver for IMG MDC

 .../devicetree/bindings/dma/img-mdc-dma.txt        |   57 ++
 drivers/dma/Kconfig                                |    9 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/img-mdc-dma.c                          | 1011 ++++++++++++++++++++
 4 files changed, 1078 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/img-mdc-dma.txt
 create mode 100644 drivers/dma/img-mdc-dma.c

-- 
2.2.0.rc0.207.ga3a616c

