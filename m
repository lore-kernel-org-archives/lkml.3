Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaLVVBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 16:01:39 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:64048 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868AbaLVVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 16:01:38 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwPAOaFmFRXQ5YW/2dsb2JhbABbgwaBKrQEBQEBAQEBAQUBd5coBAKBHBcBAQEBAX2EaSOBGjeIMAHAMZAFLIYAiXIdhBMFlwOJZIdnIoFFAYIpPTGCQwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com
Subject: [PATCH 1/1 linux-next] ocfs2: remove unnecessary else in ocfs2_set_acl()
Date: Mon, 22 Dec 2014 22:01:26 +0100
Message-Id: <1419282086-11340-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

else is unnecessary after return

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/acl.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 7e8282d..c58a1bc 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -245,16 +245,14 @@ int ocfs2_set_acl(handle_t *handle,
 			ret = posix_acl_equiv_mode(acl, &mode);
 			if (ret < 0)
 				return ret;
-			else {
-				if (ret == 0)
-					acl = NULL;
 
-				ret = ocfs2_acl_set_mode(inode, di_bh,
-							 handle, mode);
-				if (ret)
-					return ret;
+			if (ret == 0)
+				acl = NULL;
 
-			}
+			ret = ocfs2_acl_set_mode(inode, di_bh,
+						 handle, mode);
+			if (ret)
+				return ret;
 		}
 		break;
 	case ACL_TYPE_DEFAULT:
-- 
1.9.1

