Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaFAHCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 03:02:08 -0400
Received: from si-002-i42.relay.mailchannels.net ([184.154.112.207]:51301 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751009AbaFAHCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 03:02:06 -0400
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Cbillaue
X-MailChannels-Auth-Id: totalchoicehosting
From: Eli Billauer <eli.billauer@gmail.com>
To: tj@kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, shuah.kh@samsung.com,
        iommu@lists.linux-foundation.org, discuss@x86-64.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH v2 0/4] devres: dma-mapping: Introducing new functions
Date: Sun,  1 Jun 2014 10:01:13 +0300
Message-Id: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-AuthUser: billaue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset consists of new functions to the managed device resource
API, followed by a patch for the Xillybus driver, which is my motivation
and what I tested with.

This is a resubmission after changing the API slightly.

Rationale: While migrating the staging/xillybus driver to rely completely on
managed resources, some functionalities were missing, and hence added:

* dmam_map_single()
* dmam_unmap_single()
* pcim_map_single()
* pcim_unmap_single()

Tejun suggested that dma_map_single_attrs() should have a managed version as
well. The second patch in this set turns dmam_map_single() into
dma_map_single_attrs(), and implements the former as a macro. Functions added:

* dmam_map_single_attrs()
* dmam_unmap_single_attrs()

Xillybus' driver works with and without this patch (depends on patches #1 and #3
only).

Thanks,
   Eli

Eli Billauer (4):
  dma-mapping: Add devm_ interface for dma_map_single()
  dma-mapping: Add devm_ interface for dma_map_single_attrs()
  dma-mapping: pci: Add devm_ interface for pci_map_single
  staging: xillybus: Use devm_ API for memory allocation and DMA
    mapping

 Documentation/driver-model/devres.txt    |    6 +
 drivers/base/dma-mapping.c               |  106 +++++++++++++++++
 drivers/staging/xillybus/xillybus.h      |   38 +------
 drivers/staging/xillybus/xillybus_core.c |  186 +++++++++---------------------
 drivers/staging/xillybus/xillybus_of.c   |   61 +---------
 drivers/staging/xillybus/xillybus_pcie.c |   54 ++--------
 include/asm-generic/dma-mapping-common.h |    3 +
 include/asm-generic/pci-dma-compat.h     |   18 +++
 include/linux/dma-mapping.h              |    8 +-
 9 files changed, 214 insertions(+), 266 deletions(-)

-- 
1.7.2.3

