Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaHYJDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:03:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:47085 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbaHYJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:03:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="472265597"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 0/5] fs/seq_file: introduce seq_hex_dump() helper
Date: Mon, 25 Aug 2014 12:03:10 +0300
Message-Id: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces a new helper and switches current users to use it.

parisc and s390 weren't tested anyhow, the others are compile tested.

Changelog v3:
- append Mauro's Ack
- rebase on top of recent linux-next

Changelog v2:
- append Acked-by and Reviewed-by tags
- update commit messages in patches 3/5. and 5/5
- update line size to be 32 bytes instead of 16 in patch 3/5
- Joe found that output is changed in patch 4/5, thus I update commit message
  there

Andy Shevchenko (5):
  seq_file: provide an analogue of print_hex_dump()
  saa7164: convert to seq_hex_dump()
  crypto: qat - use seq_hex_dump() to dump buffers
  parisc: use seq_hex_dump() to dump buffers
  [S390] zcrypt: use seq_hex_dump() to dump buffers

 .../crypto/qat/qat_common/adf_transport_debug.c    | 16 ++--------
 drivers/media/pci/saa7164/saa7164-core.c           | 31 +++----------------
 drivers/parisc/ccio-dma.c                          | 14 ++-------
 drivers/parisc/sba_iommu.c                         | 11 ++-----
 drivers/s390/crypto/zcrypt_api.c                   | 10 +------
 fs/seq_file.c                                      | 35 ++++++++++++++++++++++
 include/linux/seq_file.h                           |  4 +++
 7 files changed, 52 insertions(+), 69 deletions(-)

-- 
2.1.0

