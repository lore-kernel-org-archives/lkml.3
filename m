Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422759AbaKNV7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:59:50 -0500
Received: from mail-pd0-f202.google.com ([209.85.192.202]:45764 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422676AbaKNV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:59:47 -0500
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
Subject: [PATCH V2 0/2] dmaengine: Support for IMG MDC
Date: Fri, 14 Nov 2014 13:59:41 -0800
Message-Id: <1416002384-3525-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
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

Based on Vinod's slave-dma/next + Maxime's device_control and slave caps
cleanup series [2].

Changes from v1:
 - addressed Arnd's review comments
 - rebased on Maxime's dmaengine cleanups

[1] https://lkml.org/lkml/2014/11/12/763
[2] https://lkml.org/lkml/2014/10/28/1067

Andrew Bresticker (2):
  dmaengine: Add binding document for IMG MDC
  dmaengine: Add driver for IMG MDC

 .../devicetree/bindings/dma/img-mdc-dma.txt        |  57 ++
 drivers/dma/Kconfig                                |   9 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/img-mdc-dma.c                          | 973 +++++++++++++++++++++
 4 files changed, 1040 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/img-mdc-dma.txt
 create mode 100644 drivers/dma/img-mdc-dma.c

-- 
2.1.0.rc2.206.gedb03e5

