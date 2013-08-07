Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3HGLNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:13:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1839 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757307Ab3HGLNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:13:39 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8144300"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH v3 12/25] x86, acpi: Rename check_multiple_madt() and make it global.
Date: Wed, 7 Aug 2013 18:52:03 +0800
Message-Id: <1375872736-4822-13-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:18,
	Serialize complete at 2013/08/07 18:52:18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we split acpi_table_init() into two steps, and want to do
the two steps separately, we need to do check_multiple_madt() after
acpi_table_init_override().

But we also have to keep acpi_table_init() as before because it
is also used in ia64, we have to do check_multiple_madt() directly
in acpi_boot_table_init() in x86.

This patch make check_multiple_madt() global, and rename it to
acpi_check_multiple_madt() because all interfaces provided by
drivers/acpi/tables.c begins with "acpi_".

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/tables.c |    4 ++--
 include/linux/acpi.h  |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 4913a85..45727b2 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -314,7 +314,7 @@ int __init acpi_table_parse(char *id, acpi_tbl_table_handler handler)
  * but some report two.  Provide a knob to use either.
  * (don't you wish instance 0 and 1 were not the same?)
  */
-static void __init check_multiple_madt(void)
+void __init acpi_check_multiple_madt(void)
 {
 	struct acpi_table_header *table = NULL;
 	acpi_size tbl_size;
@@ -369,7 +369,7 @@ int __init acpi_table_init(void)
 
 	acpi_table_init_override();
 
-	check_multiple_madt();
+	acpi_check_multiple_madt();
 
 	return 0;
 }
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 9704179..44a3e5f 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -95,6 +95,7 @@ void acpi_boot_table_init (void);
 int acpi_mps_check (void);
 int acpi_numa_init (void);
 
+void acpi_check_multiple_madt(void);
 int acpi_table_init_firmware(void);
 void acpi_table_init_override(void);
 int acpi_table_init (void);
-- 
1.7.1

