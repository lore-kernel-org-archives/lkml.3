Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbaEMQKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:10:51 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:46816 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbaEMQKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:10:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkXAL1CclNbtADP/2dsb2JhbABZgwasdgQBAQEBAQEFAZoXAgKBIhd0gmYcIxiBAiQTiEUB0HeFVoh8hEcBA48liiIBiwSIA4M4Ow
Date: Tue, 13 May 2014 18:10:39 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Steve French <sfrench@samba.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/cifs/netmisc.c: convert printk to pr_foo()
Message-Id: <20140513181039.9766ed456a097164a195d2fe@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fixes array checkpatch warning.

Cc: Steve French <sfrench@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cifs/netmisc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 0498845..4def0ae 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -795,8 +795,8 @@ cifs_print_status(__u32 status_code)
 	while (nt_errs[idx].nt_errstr != NULL) {
 		if (((nt_errs[idx].nt_errcode) & 0xFFFFFF) ==
 		    (status_code & 0xFFFFFF)) {
-			printk(KERN_NOTICE "Status code returned 0x%08x %s\n",
-				   status_code, nt_errs[idx].nt_errstr);
+			pr_notice("Status code returned 0x%08x %s\n",
+				  status_code, nt_errs[idx].nt_errstr);
 		}
 		idx++;
 	}
@@ -941,8 +941,8 @@ cifs_UnixTimeToNT(struct timespec t)
 	return (u64) t.tv_sec * 10000000 + t.tv_nsec/100 + NTFS_TIME_OFFSET;
 }
 
-static int total_days_of_prev_months[] =
-{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
+static int total_days_of_prev_months[] = {
+	0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
 
 struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 {
-- 
1.8.4.5

