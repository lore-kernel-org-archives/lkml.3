Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161123Ab3BODB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 22:01:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43643 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932410Ab3BODBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 22:01:10 -0500
X-IronPort-AV: E=Sophos;i="4.84,669,1355068800"; 
   d="scan'208";a="6712735"
From: liguang <lig.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Cc: rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH v4 3/4] acpi: add clock_domain field to acpi_srat_cpu_affinity
Date: Fri, 15 Feb 2013 10:23:11 +0800
Message-Id: <1360894992-14818-4-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1360894992-14818-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1360894992-14818-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/15 10:23:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/15 10:23:19,
	Serialize complete at 2013/02/15 10:23:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

according to ACPI SPEC v5.0, page 152,
5.2.16.1 Processor Local APIC/SAPIC Affinity Structure,
the last member of it is clock_domain.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 include/acpi/actbl1.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 0bd750e..e21d22b 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -922,7 +922,7 @@ struct acpi_srat_cpu_affinity {
 	u32 flags;
 	u8 local_sapic_eid;
 	u8 proximity_domain_hi[3];
-	u32 reserved;		/* Reserved, must be zero */
+	u32 clock_domain;
 };
 
 /* Flags */
-- 
1.7.2.5

