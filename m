Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab3GVQUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:20:46 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64145 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab3GVQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:25 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, jcl <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 19/48] staging/lustre/mdt: add macros for fid string len
Date: Tue, 23 Jul 2013 00:06:40 +0800
Message-Id: <1374509230-3324-20-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jcl <jacques-charles.lafoucriere@cea.fr>

add 2 macros for the length of a fid string 0xSEQ:0xOID:0xVER
and it's brace version (FID_NOBRACE_LEN, and FID_LEN)

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2782
Lustre-change: http://review.whamcloud.com/5299
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 7e9f575..f72b2e4 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -462,6 +462,8 @@ static inline void obd_uuid2fsname(char *buf, char *uuid, int buflen)
 
 /* printf display format
    e.g. printf("file FID is "DFID"\n", PFID(fid)); */
+#define FID_NOBRACE_LEN 40
+#define FID_LEN (FID_NOBRACE_LEN + 2)
 #define DFID_NOBRACE LPX64":0x%x:0x%x"
 #define DFID "["DFID_NOBRACE"]"
 #define PFID(fid)     \
-- 
1.7.9.5

