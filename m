Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaH3VNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:13:55 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51556 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbaH3VNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:13:35 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 12/12] staging/lustre: remove unused som_attrs and hsm_attrs structures
Date: Sat, 30 Aug 2014 17:12:51 -0400
Message-Id: <1409433171-23572-13-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
References: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These structures are only used server-side to parse relevant
attributes.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      | 37 -----------------
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    | 48 ----------------------
 2 files changed, 85 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 88c3990..e529ad4 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -322,43 +322,6 @@ enum lma_incompat {
 #define LMA_INCOMPAT_SUPP	(LMAI_AGENT | LMAI_REMOTE_PARENT)
 
 /**
- * SOM on-disk attributes stored in a separate xattr.
- */
-struct som_attrs {
-	/** Bitfield for supported data in this structure. For future use. */
-	__u32	som_compat;
-
-	/** Incompat feature list. The supported feature mask is available in
-	 * SOM_INCOMPAT_SUPP */
-	__u32	som_incompat;
-
-	/** IO Epoch SOM attributes belongs to */
-	__u64	som_ioepoch;
-	/** total file size in objects */
-	__u64	som_size;
-	/** total fs blocks in objects */
-	__u64	som_blocks;
-	/** mds mount id the size is valid for */
-	__u64	som_mountid;
-};
-#define SOM_INCOMPAT_SUPP 0x0
-
-/**
- * HSM on-disk attributes stored in a separate xattr.
- */
-struct hsm_attrs {
-	/** Bitfield for supported data in this structure. For future use. */
-	__u32	hsm_compat;
-
-	/** HSM flags, see hsm_flags enum below */
-	__u32	hsm_flags;
-	/** backend archive id associated with the file */
-	__u64	hsm_arch_id;
-	/** version associated with the last archiving, if any */
-	__u64	hsm_arch_ver;
-};
-
-/**
  * fid constants
  */
 enum {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
index 0624420..d6d9204 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
@@ -460,54 +460,6 @@ void lustre_assert_wire_constants(void)
 	LASSERTF(OBJ_INDEX_DELETE == 11, "found %lld\n",
 		 (long long)OBJ_INDEX_DELETE);
 
-	/* Checks for struct som_attrs */
-	LASSERTF((int)sizeof(struct som_attrs) == 40, "found %lld\n",
-		 (long long)(int)sizeof(struct som_attrs));
-	LASSERTF((int)offsetof(struct som_attrs, som_compat) == 0, "found %lld\n",
-		 (long long)(int)offsetof(struct som_attrs, som_compat));
-	LASSERTF((int)sizeof(((struct som_attrs *)0)->som_compat) == 4, "found %lld\n",
-		 (long long)(int)sizeof(((struct som_attrs *)0)->som_compat));
-	LASSERTF((int)offsetof(struct som_attrs, som_incompat) == 4, "found %lld\n",
-		 (long long)(int)offsetof(struct som_attrs, som_incompat));
-	LASSERTF((int)sizeof(((struct som_attrs *)0)->som_incompat) == 4, "found %lld\n",
-		 (long long)(int)sizeof(((struct som_attrs *)0)->som_incompat));
-	LASSERTF((int)offsetof(struct som_attrs, som_ioepoch) == 8, "found %lld\n",
-		 (long long)(int)offsetof(struct som_attrs, som_ioepoch));
-	LASSERTF((int)sizeof(((struct som_attrs *)0)->som_ioepoch) == 8, "found %lld\n",
-		 (long long)(int)sizeof(((struct som_attrs *)0)->som_ioepoch));
-	LASSERTF((int)offsetof(struct som_attrs, som_size) == 16, "found %lld\n",
-		 (long long)(int)offsetof(struct som_attrs, som_size));
-	LASSERTF((int)sizeof(((struct som_attrs *)0)->som_size) == 8, "found %lld\n",
-		 (long long)(int)sizeof(((struct som_attrs *)0)->som_size));
-	LASSERTF((int)offsetof(struct som_attrs, som_blocks) == 24, "found %lld\n",
-		 (long long)(int)offsetof(struct som_attrs, som_blocks));
-	LASSERTF((int)sizeof(((struct som_attrs *)0)->som_blocks) == 8, "found %lld\n",
-		 (long long)(int)sizeof(((struct som_attrs *)0)->som_blocks));
-	LASSERTF((int)offsetof(struct som_attrs, som_mountid) == 32, "found %lld\n",
-		 (long long)(int)offsetof(struct som_attrs, som_mountid));
-	LASSERTF((int)sizeof(((struct som_attrs *)0)->som_mountid) == 8, "found %lld\n",
-		 (long long)(int)sizeof(((struct som_attrs *)0)->som_mountid));
-
-	/* Checks for struct hsm_attrs */
-	LASSERTF((int)sizeof(struct hsm_attrs) == 24, "found %lld\n",
-		 (long long)(int)sizeof(struct hsm_attrs));
-	LASSERTF((int)offsetof(struct hsm_attrs, hsm_compat) == 0, "found %lld\n",
-		 (long long)(int)offsetof(struct hsm_attrs, hsm_compat));
-	LASSERTF((int)sizeof(((struct hsm_attrs *)0)->hsm_compat) == 4, "found %lld\n",
-		 (long long)(int)sizeof(((struct hsm_attrs *)0)->hsm_compat));
-	LASSERTF((int)offsetof(struct hsm_attrs, hsm_flags) == 4, "found %lld\n",
-		 (long long)(int)offsetof(struct hsm_attrs, hsm_flags));
-	LASSERTF((int)sizeof(((struct hsm_attrs *)0)->hsm_flags) == 4, "found %lld\n",
-		 (long long)(int)sizeof(((struct hsm_attrs *)0)->hsm_flags));
-	LASSERTF((int)offsetof(struct hsm_attrs, hsm_arch_id) == 8, "found %lld\n",
-		 (long long)(int)offsetof(struct hsm_attrs, hsm_arch_id));
-	LASSERTF((int)sizeof(((struct hsm_attrs *)0)->hsm_arch_id) == 8, "found %lld\n",
-		 (long long)(int)sizeof(((struct hsm_attrs *)0)->hsm_arch_id));
-	LASSERTF((int)offsetof(struct hsm_attrs, hsm_arch_ver) == 16, "found %lld\n",
-		 (long long)(int)offsetof(struct hsm_attrs, hsm_arch_ver));
-	LASSERTF((int)sizeof(((struct hsm_attrs *)0)->hsm_arch_ver) == 8, "found %lld\n",
-		 (long long)(int)sizeof(((struct hsm_attrs *)0)->hsm_arch_ver));
-
 	/* Checks for struct ost_id */
 	LASSERTF((int)sizeof(struct ost_id) == 16, "found %lld\n",
 		 (long long)(int)sizeof(struct ost_id));
-- 
1.9.3

