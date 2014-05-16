Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbaEPId6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:33:58 -0400
Received: from si-002-i75.relay.mailchannels.net ([184.154.112.250]:13483 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756292AbaEPId4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:33:56 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2014 04:33:56 EDT
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Cbillaue
X-MailChannels-Auth-Id: totalchoicehosting
X-MC-Relay: Neutral
From: Eli Billauer <eli.billauer@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tj@kernel.org, linux-kernel@vger.kernel.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 0/5] devres: Add functions + migrate Xillybus driver
Date: Fri, 16 May 2014 11:26:34 +0300
Message-Id: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-AuthUser: billaue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset consists of new functions to the managed device resource
API, followed by patches for the Xillybus driver that now relies on these.

Rationale: While migrating the staging/xillybus driver to rely completely on
managed resources, some functionalities were missing, and hence added:

* devm_get_free_pages()
* devm_free_pages()
* dmam_map_single()
* dmam_unmap_single()
* pcim_map_single()
* pcim_unmap_single()

After applying these patches, the Xillybus driver uses all six functions,
and has been hardware tested on arm and x86_32. A compilation check went
cleanly on x86_64 as well.

Dependencies:
Patch #3 relies on patch #2 (quite obviously).
Patch #5 relies on all previous patches.

Thanks,
   Eli

Eli Billauer (5):
  devres: Add devm_get_free_pages API
  dma-mapping: Add devm_ interface for dma_map_single()
  dma-mapping: pci: Add devm_ interface for pci_map_single
  staging: xillybus: Use devm_ API on probe and remove
  staging: xillybus: Use devm_ API for memory allocation and DMA
    mapping

 Documentation/driver-model/devres.txt    |    6 +
 drivers/base/devres.c                    |   76 ++++++++++++++
 drivers/base/dma-mapping.c               |   80 +++++++++++++++
 drivers/staging/xillybus/xillybus.h      |   32 +------
 drivers/staging/xillybus/xillybus_core.c |  162 ++++++++----------------------
 drivers/staging/xillybus/xillybus_of.c   |   99 ++----------------
 drivers/staging/xillybus/xillybus_pcie.c |  111 ++++-----------------
 include/asm-generic/pci-dma-compat.h     |   17 +++
 include/linux/device.h                   |    4 +
 include/linux/dma-mapping.h              |    5 +-
 10 files changed, 261 insertions(+), 331 deletions(-)

-- 
1.7.2.3

