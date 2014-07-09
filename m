Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797AbaGIP0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:26:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:64911 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511AbaGIP0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:26:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="540934519"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 0/5] fs/seq_file: introduce seq_hex_dump() helper
Date: Wed,  9 Jul 2014 18:24:25 +0300
Message-Id: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces a new helper and switches current users to use it.

parisc and s390 weren't tested anyhow, the other are compile tested.

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
2.0.1

