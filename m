Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbaKMU6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:58:16 -0500
Received: from mail-qc0-f201.google.com ([209.85.216.201]:58086 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933909AbaKMU6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:58:12 -0500
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
        Damien Horsley <Damien.Horsley@imgtec.com>, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] dmaengine: Support for IMG MDC
Date: Thu, 13 Nov 2014 12:58:06 -0800
Message-Id: <1415912288-26926-1-git-send-email-abrestic@chromium.org>
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
Support for Pistachio will be submitted later.

Based on Vinod's slave-dma/next.  I can rebase on Maxime's device_control
refactoring [1] if necessary.

Andrew Bresticker (2):
  dmaengine: Add binding document for IMG MDC
  dmaengine: Add driver for IMG MDC

[1] https://lkml.org/lkml/2014/10/28/1067

 .../devicetree/bindings/dma/img-mdc-dma.txt        |   57 ++
 drivers/dma/Kconfig                                |    9 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/img-mdc-dma.c                          | 1016 ++++++++++++++++++++
 4 files changed, 1083 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/img-mdc-dma.txt
 create mode 100644 drivers/dma/img-mdc-dma.c

-- 
2.1.0.rc2.206.gedb03e5

