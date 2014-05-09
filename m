Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbaEISY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:24:29 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:36138 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756796AbaEISY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:24:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMXAA8dbVNXQw5R/2dsb2JhbABZgwaCQaoKBAEBAQEBAQUBmhQCAoEZF3SCZhwjGIECJBOIRQHROYVWiHyERwEDjySKIgGLA4d/gXeBQTs
Date: Fri, 9 May 2014 20:24:23 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/utsname_sysctl.c: replace obsolete __initcall by
 device_initcall
Message-Id: <20140509202423.daaa048a3e697a4d67a689a8@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fixes checkpatch warnings on proc_dostring function parameters

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/utsname_sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index 4f69f9a..6fbe811 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -51,7 +51,7 @@ static int proc_do_uts_string(ctl_table *table, int write,
 	int r;
 	memcpy(&uts_table, table, sizeof(uts_table));
 	uts_table.data = get_uts(table, write);
-	r = proc_dostring(&uts_table,write,buffer,lenp, ppos);
+	r = proc_dostring(&uts_table, write, buffer, lenp, ppos);
 	put_uts(table, write, uts_table.data);
 
 	if (write)
@@ -135,4 +135,4 @@ static int __init utsname_sysctl_init(void)
 	return 0;
 }
 
-__initcall(utsname_sysctl_init);
+device_initcall(utsname_sysctl_init);
-- 
1.8.4.5

