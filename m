Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab3LNNMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:12:24 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44355 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3LNNMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:12:23 -0500
Date: Sat, 14 Dec 2013 18:42:14 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH] drivers: infiniband: Mark function _c4iw_write_mem_dma() as
 static in mem.c
Message-ID: <20131214131214.GA8459@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function _c4iw_write_mem_dma() as static in
hw/cxgb4/mem.c because it is not used outside this file.

Thus, it also eliminates the following warning in hw/cxgb4/mem.c:
drivers/infiniband/hw/cxgb4/mem.c:176:5: warning: no previous prototype for ‘_c4iw_write_mem_dma’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/infiniband/hw/cxgb4/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 4cb8eb2..84e4500 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -173,7 +173,7 @@ static int _c4iw_write_mem_inline(struct c4iw_rdev *rdev, u32 addr, u32 len,
 	return ret;
 }
 
-int _c4iw_write_mem_dma(struct c4iw_rdev *rdev, u32 addr, u32 len, void *data)
+static int _c4iw_write_mem_dma(struct c4iw_rdev *rdev, u32 addr, u32 len, void *data)
 {
 	u32 remain = len;
 	u32 dmalen;
-- 
1.7.9.5

