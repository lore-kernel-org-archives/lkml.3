Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3DKGY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 02:24:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27659 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3DKGYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 02:24:25 -0400
Date: Thu, 11 Apr 2013 09:23:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@redhat.com>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kbuild@01.org
Subject: [patch 1/2 -next] dma-buf: double unlock in debugfs code
Message-ID: <20130411062339.GA7603@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We unlock here when we failed to take the lock.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is in linux-next, and I think the debugfs code is only in Sumit's
tree.

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 466476f..174cd2c 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -593,7 +593,7 @@ static int dma_buf_describe(struct seq_file *s)
 		if (ret) {
 			seq_printf(s,
 				  "\tERROR locking buffer object: skipping\n");
-			goto skip_buffer;
+			continue;
 		}
 
 		seq_printf(s, "\t");
@@ -618,7 +618,6 @@ static int dma_buf_describe(struct seq_file *s)
 
 		count++;
 		size += buf_obj->size;
-skip_buffer:
 		mutex_unlock(&buf_obj->lock);
 	}

