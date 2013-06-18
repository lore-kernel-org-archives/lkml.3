Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab3FRNcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:32:13 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51350 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab3FRNcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:32:10 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <tj@kernel.org>,
        Imre Deak <imre.deak@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/4] introduce sg_pcopy_from_buffer() and sg_pcopy_to_buffer()
Date: Tue, 18 Jun 2013 22:31:30 +0900
Message-Id: <1371562294-13642-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces sg_pcopy_from_buffer() and sg_pcopy_to_buffer(),
which copy data between a linear buffer and an SG list.

The only difference between sg_pcopy_{from,to}_buffer() and
sg_copy_{from,to}_buffer() is an additional argument that specifies
the number of bytes to skip the SG list before copying.

The main reason for introducing these functions is to fix a problem
in scsi_debug module.  And there is a local function in crypto/talitos
module, which can be replaced by sg_pcopy_to_buffer().

* Changes from v1
- Separate the change that factors out sg_miter_get_next_page() from
  the patch "introduce sg_pcopy_from_buffer() and sg_pcopy_to_buffer()"
- Add function comment for internal function sg_miter_seek()
- Simplify the assignment of sdb->resid in fill_from_dev_buffer() in
  scsi_debug

Akinobu Mita (4):
  lib/scatterlist: factor out sg_miter_get_next_page() from
    sg_miter_next()
  lib/scatterlist: introduce sg_pcopy_from_buffer() and
    sg_pcopy_to_buffer()
  crypto: talitos: use sg_pcopy_to_buffer()
  scsi_debug: fix do_device_access() with wrap around range

 drivers/crypto/talitos.c    |  60 +--------------------
 drivers/scsi/scsi_debug.c   |  48 +++++++++++++----
 include/linux/scatterlist.h |   5 ++
 lib/scatterlist.c           | 127 +++++++++++++++++++++++++++++++++++++-------
 4 files changed, 150 insertions(+), 90 deletions(-)

Cc: Tejun Heo <tj@kernel.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org

-- 
1.8.1.4

