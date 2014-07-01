Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbaGATiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:38:08 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:24731 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922AbaGATiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:38:07 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsHAKgNs1NbsGsk/2dsb2JhbABagw2sYwUBbplbgQ8XdYRgI4EaN4hGAbMKlXaFb4kwHYQtBZpmi0WIPoNEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>, devel@driverdev.osuosl.org
Subject: [PATCH 1/1] staging/lustre/libcfs: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Tue,  1 Jul 2014 21:38:02 +0200
Message-Id: <1404243482-23799-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use macro definition

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/staging/lustre/lustre/libcfs/nidstrings.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/nidstrings.c b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
index 87705ae..4fc7b45 100644
--- a/drivers/staging/lustre/lustre/libcfs/nidstrings.c
+++ b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
@@ -74,8 +74,7 @@ libcfs_next_nidstring(void)
 	spin_lock_irqsave(&libcfs_nidstring_lock, flags);
 
 	str = libcfs_nidstrings[libcfs_nidstring_idx++];
-	if (libcfs_nidstring_idx ==
-	    sizeof(libcfs_nidstrings)/sizeof(libcfs_nidstrings[0]))
+	if (libcfs_nidstring_idx == ARRAY_SIZE(libcfs_nidstrings))
 		libcfs_nidstring_idx = 0;
 
 	spin_unlock_irqrestore(&libcfs_nidstring_lock, flags);
@@ -198,7 +197,7 @@ static struct netstrfns  libcfs_netstrfns[] = {
 	{/* .nf_type      */  -1},
 };
 
-const int libcfs_nnetstrfns = sizeof(libcfs_netstrfns)/sizeof(libcfs_netstrfns[0]);
+const int libcfs_nnetstrfns = ARRAY_SIZE(libcfs_netstrfns);
 
 int
 libcfs_lo_str2addr(const char *str, int nob, __u32 *addr)
-- 
1.9.1

