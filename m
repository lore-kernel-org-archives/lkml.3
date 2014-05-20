Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaETQsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:48:17 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:32399 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbaETQsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:48:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYWAJ6Ge1NbsnsG/2dsb2JhbABPCoMGgkSoRAQBAQEBAQEFAYM6lm4CAoEcF3SCUxM/GIECJBOIRQHUIYVViBUIXIRHAQOPPIorAZMggzo7gTE
Date: Tue, 20 May 2014 18:48:09 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Kurt Garloff <garloff@suse.de>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop by ilog2
Message-Id: <20140520184809.56d3707440f64e2d9656e3c7@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Kurt Garloff <garloff@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/tmscsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index b006cf7..c353848 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -1611,7 +1611,7 @@ dc390_Reselect( struct dc390_acb* pACB )
       printk (KERN_ERR "DC390: Reselection must select host adapter: %02x!\n", lun);
     else
       lun ^= 1 << pACB->pScsiHost->this_id; /* Mask AdapterID */
-    id = 0; while (lun >>= 1) id++;
+    id = ilog2(lun);
     /* Get LUN */
     lun = DC390_read8 (ScsiFifo);
     if (!(lun & IDENTIFY_BASE)) printk (KERN_ERR "DC390: Resel: Expect identify message!\n");
-- 
1.8.4.5

