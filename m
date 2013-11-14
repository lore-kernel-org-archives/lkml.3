Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3KNQQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:16:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37058 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab3KNQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:48 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 21/40] staging/lustre/mdt: HSM coordinator agent interface
Date: Fri, 15 Nov 2013 00:13:23 +0800
Message-Id: <1384445622-12346-22-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

To move data with external storage, HSM coordinator
uses a Copy Tool running on a client named agent.
This patch implements the interface for these agents.

Lustre-change: http://review.whamcloud.com/6534
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3342
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 19fa813..b6090b5 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -428,8 +428,8 @@ struct obd_uuid {
 	char uuid[UUID_MAX];
 };
 
-static inline int obd_uuid_equals(const struct obd_uuid *u1,
-				  const struct obd_uuid *u2)
+static inline bool obd_uuid_equals(const struct obd_uuid *u1,
+				   const struct obd_uuid *u2)
 {
 	return strcmp((char *)u1->uuid, (char *)u2->uuid) == 0;
 }
@@ -446,7 +446,7 @@ static inline void obd_str2uuid(struct obd_uuid *uuid, const char *tmp)
 }
 
 /* For printf's only, make sure uuid is terminated */
-static inline char *obd_uuid2str(struct obd_uuid *uuid)
+static inline char *obd_uuid2str(const struct obd_uuid *uuid)
 {
 	if (uuid->uuid[sizeof(*uuid) - 1] != '\0') {
 		/* Obviously not safe, but for printfs, no real harm done...
-- 
1.7.9.5

