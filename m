Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3KNQkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:40:17 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37777 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab3KNQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:16 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Henri Doreau <henri.doreau@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 12/39] staging/lustre/utils: Posix copytool fixes.
Date: Fri, 15 Nov 2013 00:32:35 +0800
Message-Id: <1384446782-13741-13-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henri Doreau <henri.doreau@cea.fr>

Fixed several defects in the HSM posix copytool.
- Fixed two invalid format strings.
- Made --daemon optional.
- Remove .lov entries from the archive when removing the corresponding
  files.
- When restoring a file for which no LOV EA has been saved we must not
  create the volatile with O_LOV_DELAY_CREATE. Additionally, the
  caller should be able to specify the MDT index where to create the
  volatile file. Added parameters to llapi_hsm_action_begin()
  accordingly.

Lustre-change: http://review.whamcloud.com/7237
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3693
Signed-off-by: Henri Doreau <henri.doreau@cea.fr>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustreapi.h       |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustreapi.h b/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
index 0bb3c9f..e6ce238 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
@@ -307,11 +307,12 @@ extern int llapi_hsm_copytool_unregister(struct hsm_copytool_private **priv);
 extern int llapi_hsm_copytool_recv(struct hsm_copytool_private *priv,
 				   struct hsm_action_list **hal, int *msgsize);
 extern void llapi_hsm_action_list_free(struct hsm_action_list **hal);
-extern int llapi_hsm_action_begin(struct hsm_copyaction_private **hcp,
-				  const struct hsm_copytool_private *ct_priv,
+extern int llapi_hsm_action_begin(struct hsm_copyaction_private **phcp,
+				  const struct hsm_copytool_private *ct,
 				  const struct hsm_action_item *hai,
+				  int restore_mdt_index, int restore_open_flags,
 				  bool is_error);
-extern int llapi_hsm_action_end(struct hsm_copyaction_private **hcp,
+extern int llapi_hsm_action_end(struct hsm_copyaction_private **phcp,
 				const struct hsm_extent *he, int flags,
 				int errval);
 extern int llapi_hsm_action_progress(struct hsm_copyaction_private *hcp,
-- 
1.7.9.5

