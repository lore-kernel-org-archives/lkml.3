Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab3K0C1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:27:30 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60901 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab3K0C11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:27:27 -0500
Message-ID: <52955913.3060809@gmail.com>
Date: Wed, 27 Nov 2013 10:29:39 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bottomley@parallels.com, linux-scsi@vger.kernel.org
CC: rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: scsi: scsi_lib.c: add prefix "SCSILIB_" to macro
 "SP"
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>
In-Reply-To: <5294255E.7040105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the macro "SP" is too common to make conflict with some architectures,
so recommend to add prefix for it.

The related warning (with allmodconfig for hexagon):

    CC [M]  drivers/scsi/scsi_lib.o
  drivers/scsi/scsi_lib.c:46:0: warning: "SP" redefined [enabled by default]
  arch/hexagon/include/uapi/asm/registers.h:9:0: note: this is the location of the previous definition


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/scsi/scsi_lib.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bd7f0d..f78e21b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -43,28 +43,28 @@ struct scsi_host_sg_pool {
 	mempool_t	*pool;
 };
 
-#define SP(x) { x, "sgpool-" __stringify(x) }
+#define SCSILIB_SP(x) { x, "sgpool-" __stringify(x) }
 #if (SCSI_MAX_SG_SEGMENTS < 32)
 #error SCSI_MAX_SG_SEGMENTS is too small (must be 32 or greater)
 #endif
 static struct scsi_host_sg_pool scsi_sg_pools[] = {
-	SP(8),
-	SP(16),
+	SCSILIB_SP(8),
+	SCSILIB_SP(16),
 #if (SCSI_MAX_SG_SEGMENTS > 32)
-	SP(32),
+	SCSILIB_SP(32),
 #if (SCSI_MAX_SG_SEGMENTS > 64)
-	SP(64),
+	SCSILIB_SP(64),
 #if (SCSI_MAX_SG_SEGMENTS > 128)
-	SP(128),
+	SCSILIB_SP(128),
 #if (SCSI_MAX_SG_SEGMENTS > 256)
 #error SCSI_MAX_SG_SEGMENTS is too large (256 MAX)
 #endif
 #endif
 #endif
 #endif
-	SP(SCSI_MAX_SG_SEGMENTS)
+	SCSILIB_SP(SCSI_MAX_SG_SEGMENTS)
 };
-#undef SP
+#undef SCSILIB_SP
 
 struct kmem_cache *scsi_sdb_cache;
 
-- 
1.7.7.6
