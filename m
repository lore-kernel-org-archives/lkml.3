Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3KZCGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:06:17 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52020 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab3KZCGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:06:12 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 08/16] staging/lustre/mdt: HSM coordinator agent interface
Date: Tue, 26 Nov 2013 10:05:02 +0800
Message-Id: <1385431510-18988-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
References: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
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
index 9436166..631f026 100644
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

