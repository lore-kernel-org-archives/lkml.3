Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab3FFMx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:53:27 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40340 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab3FFMxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:53:24 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <tj@kernel.org>,
        Imre Deak <imre.deak@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 0/3] introduce sg_pcopy_from_buffer() and sg_pcopy_to_buffer()
Date: Thu,  6 Jun 2013 21:52:55 +0900
Message-Id: <1370523178-5437-1-git-send-email-akinobu.mita@gmail.com>
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

Akinobu Mita (3):
  lib/scatterlist: introduce sg_pcopy_from_buffer() and
    sg_pcopy_to_buffer()
  crypto: talitos: use sg_pcopy_to_buffer()
  scsi_debug: fix do_device_access() with wrap around range

 drivers/crypto/talitos.c    |  60 +-----------------------
 drivers/scsi/scsi_debug.c   |  43 ++++++++++++++---
 include/linux/scatterlist.h |   5 ++
 lib/scatterlist.c           | 109 ++++++++++++++++++++++++++++++++++++--------
 4 files changed, 131 insertions(+), 86 deletions(-)

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

