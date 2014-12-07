Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaLGAAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 19:00:20 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50765 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaLGAAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 19:00:19 -0500
From: Tristan Lelong <tristan@lelong.xyz>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, tristan@lelong.xyz, standby24x7@gmail.com,
        askb23@gmail.com, john.hammond@intel.com, bergwolf@gmail.com,
        di.wang@intel.com, mike.pershin@intel.com, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: lustre: replace static value with define
Date: Sat,  6 Dec 2014 16:00:30 -0800
Message-Id: <1417910430-20849-1-git-send-email-tristan@lelong.xyz>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace the value '80' used in several files in the lustre source code
with a define LUSTRE_MDT_MAXNAMELEN.

This value is used in 4 different structures as the maximum len for a service name.
According to the comments, these names follow a convention which make it possible
to use the same define for LCS, LSS, LCF, and LSF.

Signed-off-by: Tristan Lelong <tristan@lelong.xyz>
---
Notes:
        This modification answers Joe Perches suggestion: https://lkml.org/lkml/2014/12/5/107

Changes in v2:
		Remove check on LUSTRE_MDT_MAXNAMELEN for fh_name which is not a MDT service, 
		per Andreas Dilger comment.
---
 drivers/staging/lustre/lustre/fld/fld_internal.h          | 2 +-
 drivers/staging/lustre/lustre/include/lustre/lustre_idl.h | 5 +++++
 drivers/staging/lustre/lustre/include/lustre_fid.h        | 4 ++--
 drivers/staging/lustre/lustre/include/lustre_fld.h        | 4 ++--
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fld/fld_internal.h b/drivers/staging/lustre/lustre/fld/fld_internal.h
index 8806b60..6125bbe 100644
--- a/drivers/staging/lustre/lustre/fld/fld_internal.h
+++ b/drivers/staging/lustre/lustre/fld/fld_internal.h
@@ -111,7 +111,7 @@ struct fld_cache {
 
 	/**
 	 * Cache name used for debug and messages. */
-	char		     fci_name[80];
+	char		     fci_name[LUSTRE_MDT_MAXNAMELEN];
 	unsigned int		 fci_no_shrink:1;
 };
 
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 7b7457c..305ecbe 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -105,6 +105,11 @@
  * FOO_BULK_PORTAL    is for incoming bulk on the FOO
  */
 
+/* Lustre service names are following the format
+ * service name + MDT + seq name
+ */
+#define LUSTRE_MDT_MAXNAMELEN	80
+
 #define CONNMGR_REQUEST_PORTAL	  1
 #define CONNMGR_REPLY_PORTAL	    2
 //#define OSC_REQUEST_PORTAL	    3
diff --git a/drivers/staging/lustre/lustre/include/lustre_fid.h b/drivers/staging/lustre/lustre/include/lustre_fid.h
index 2d6fbb4..0a0929f 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fid.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fid.h
@@ -358,7 +358,7 @@ struct lu_client_seq {
 	 * Service uuid, passed from MDT + seq name to form unique seq name to
 	 * use it with procfs.
 	 */
-	char		    lcs_name[80];
+	char		    lcs_name[LUSTRE_MDT_MAXNAMELEN];
 
 	/*
 	 * Sequence width, that is how many objects may be allocated in one
@@ -408,7 +408,7 @@ struct lu_server_seq {
 	 * Service uuid, passed from MDT + seq name to form unique seq name to
 	 * use it with procfs.
 	 */
-	char		    lss_name[80];
+	char		    lss_name[LUSTRE_MDT_MAXNAMELEN];
 
 	/*
 	 * Allocation chunks for super and meta sequences. Default values are
diff --git a/drivers/staging/lustre/lustre/include/lustre_fld.h b/drivers/staging/lustre/lustre/include/lustre_fld.h
index 64c5048..5ee4b1e 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fld.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fld.h
@@ -93,7 +93,7 @@ struct lu_server_fld {
 
 	/**
 	 * Fld service name in form "fld-srv-lustre-MDTXXX" */
-	char		     lsf_name[80];
+	char		     lsf_name[LUSTRE_MDT_MAXNAMELEN];
 
 };
 
@@ -124,7 +124,7 @@ struct lu_client_fld {
 
 	/**
 	 * Client fld proc entry name. */
-	char		     lcf_name[80];
+	char		     lcf_name[LUSTRE_MDT_MAXNAMELEN];
 
 	int		      lcf_flags;
 };
-- 
2.1.1

