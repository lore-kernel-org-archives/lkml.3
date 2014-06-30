Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaF3SMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:12:09 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:61002 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287AbaF3SMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:12:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhgJAFqnsVNbtAo1/2dsb2JhbABagw2sQQUBAQEBAQEFAW4BmUaBEhd1hGAjgQIYN4guAxUBwTwNhlIXhWSGfIFDZB2ELQWYYIF+iz+CLIYSg0Q7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH 1/1] staging/lustre/obdclass: use static const for seq_operations
Date: Mon, 30 Jun 2014 20:10:46 +0200
Message-Id: <1404151846-12941-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lprocfs_stats_seq_sops is only used in static int lprocfs_stats_seq_open
with seq_open as const struct seq_operations *

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peng Tao <bergwolf@gmail.com>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 1432dd7..b0a12c4 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1196,7 +1196,7 @@ out:
 	return (rc < 0) ? rc : 0;
 }
 
-struct seq_operations lprocfs_stats_seq_sops = {
+static const struct seq_operations lprocfs_stats_seq_sops = {
 	.start	= lprocfs_stats_seq_start,
 	.stop	= lprocfs_stats_seq_stop,
 	.next	= lprocfs_stats_seq_next,
-- 
1.8.4.5

