Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaD1U0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:26:15 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:33907 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbaD1U0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:26:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiUUAO64XlNXQw00/2dsb2JhbABZgwaCQKlNBQEBAQWZcgICgRoXdIJmHCMYgQIkE4hFAckbhVqIf4RAAQOOfIoPAYpzh2uDMzs
Date: Mon, 28 Apr 2014 22:28:16 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] mm/memory_hotplug.c: use PFN_DOWN()
Message-Id: <20140428222816.c740c8e2d7cce4ede25d78b8@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace ((x) >> PAGE_SHIFT) by pfn macro.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/memory_hotplug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a650db2..b756740 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1007,7 +1007,7 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 	struct pglist_data *pgdat;
 	unsigned long zones_size[MAX_NR_ZONES] = {0};
 	unsigned long zholes_size[MAX_NR_ZONES] = {0};
-	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long start_pfn = PFN_DOWN(start);
 
 	pgdat = NODE_DATA(nid);
 	if (!pgdat) {
@@ -1079,7 +1079,7 @@ out:
 
 static int check_hotplug_memory_range(u64 start, u64 size)
 {
-	u64 start_pfn = start >> PAGE_SHIFT;
+	u64 start_pfn = PFN_DOWN(start);
 	u64 nr_pages = size >> PAGE_SHIFT;
 
 	/* Memory range must be aligned with section */
-- 
1.8.4.5

