Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab3KZPH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:07:56 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46082 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab3KZPHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:07:46 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 03/12] staging/lustre: constify uuid argument of obd_uuid2str
Date: Tue, 26 Nov 2013 23:04:37 +0800
Message-Id: <1385478286-5525-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385478286-5525-1-git-send-email-bergwolf@gmail.com>
References: <1385478286-5525-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

This is only part of the original Lustre tree commit.
Main part of the original commit changes server code and is
unneeded at client side.

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
 .../lustre/lustre/include/lustre/lustre_user.h     |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 9436166..ff825d8 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
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

