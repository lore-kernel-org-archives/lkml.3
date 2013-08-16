Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3HPHIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:08:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29462 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3HPHIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:08:18 -0400
X-IronPort-AV: E=Sophos;i="4.89,892,1367942400"; 
   d="scan'208";a="8217642"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 6/6] acpi: Return -ENOENT in acpi_table_parse() and fix wrong comment.
Date: Fri, 16 Aug 2013 15:06:49 +0800
Message-Id: <1376636809-10159-7-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376636809-10159-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1376636809-10159-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/16 15:06:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/16 15:06:38,
	Serialize complete at 2013/08/16 15:06:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment about return value of acpi_table_parse() is incorrect.
This patch fix it.

Furthermore, if the table is not found, return 1 means nothing, and
make it difficult to write the comment. So return -ENOENT when the
table is not found, and correct the comment.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/tables.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 5a5263b..e6de24f 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -278,12 +278,13 @@ acpi_table_parse_madt(enum acpi_madt_type id,
 
 /**
  * acpi_table_parse - find table with @id, run @handler on it
- *
  * @id: table id to find
  * @handler: handler to run
  *
  * Scan the ACPI System Descriptor Table (STD) for a table matching @id,
- * run @handler on it.  Return 0 if table found, return on if not.
+ * run @handler on it.
+ *
+ * Return 0 on success, -errno on failure.
  */
 int __init acpi_table_parse(char *id, acpi_tbl_table_handler handler)
 {
@@ -306,7 +307,7 @@ int __init acpi_table_parse(char *id, acpi_tbl_table_handler handler)
 		early_acpi_os_unmap_memory(table, tbl_size);
 		return 0;
 	} else
-		return 1;
+		return -ENOENT;
 }
 
 /* 
-- 
1.7.1

