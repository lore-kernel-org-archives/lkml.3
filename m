Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab3D2TcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:32:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619Ab3D2TC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 01/34] aio: fix possible invalid memory access when DEBUG is enabled
Date: Mon, 29 Apr 2013 12:02:08 -0700
Message-Id: <20130429184701.025730758@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

commit 91d80a84bbc8f28375cca7e65ec666577b4209ad upstream.

dprintk() shouldn't access @ring after it's unmapped.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1094,9 +1094,9 @@ static int aio_read_evt(struct kioctx *i
 	spin_unlock(&info->ring_lock);
 
 out:
-	kunmap_atomic(ring);
 	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
+	kunmap_atomic(ring);
 	return ret;
 }
 


