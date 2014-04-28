Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaD1Bbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42834 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752385AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Qiang Huang" <h.huangqiang@huawei.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.487492871@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 88/94] drivers: hv: additional switch to use mb()
 instead of smp_mb()
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Huang <h.huangqiang@huawei.com>

commit e4af376d04b0(drivers: hv: switch to use mb() instead of smp_mb()),
the adjustment mistakenly dropped the change in hv_ringbuffer_read,
so add it.

Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hv/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -485,7 +485,7 @@ int hv_ringbuffer_read(struct hv_ring_bu
 	/* Make sure all reads are done before we update the read index since */
 	/* the writer may start writing to the read area once the read index */
 	/*is updated */
-	smp_mb();
+	mb();
 
 	/* Update the read index */
 	hv_set_next_read_location(inring_info, next_read_location);

