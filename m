Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674Ab3BYCnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:43:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:46306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759611Ab3BYCm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:42:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,731,1355068800"; 
   d="scan'208";a="6760672"
From: liguang <lig.fnst@cn.fujitsu.com>
To: tglx@linutronix.de, hpa@zytor.com, pavel@ucw.cz, rjw@sisk.pl,
        lv.zheng@intel.com, jarkko.sakkinen@intel.com, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [rebased-again][PATCH 3/4] acpi: add clock_domain field to acpi_srat_cpu_affinity
Date: Mon, 25 Feb 2013 10:38:36 +0800
Message-Id: <1361759917-5195-4-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1361759917-5195-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1361759917-5195-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/25 10:38:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/25 10:38:51,
	Serialize complete at 2013/02/25 10:38:51
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

