Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3HPHIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:08:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29462 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab3HPHIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:08:17 -0400
X-IronPort-AV: E=Sophos;i="4.89,892,1367942400"; 
   d="scan'208";a="8217639"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 5/6] acpi: Check if @id is NULL in acpi_table_parse()
Date: Fri, 16 Aug 2013 15:06:48 +0800
Message-Id: <1376636809-10159-6-git-send-email-tangchen@cn.fujitsu.com>
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

strncmp() does not check if the params are NULL. In acpi_table_parse(),
if @id is NULL, the kernel will panic.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index d67a1fe..5a5263b 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -293,7 +293,7 @@ int __init acpi_table_parse(char *id, acpi_tbl_table_handler handler)
 	if (acpi_disabled)
 		return -ENODEV;
 
-	if (!handler)
+	if (!id || !handler)
 		return -EINVAL;
 
 	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
-- 
1.7.1

