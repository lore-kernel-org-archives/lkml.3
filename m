Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaJHU1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:27:32 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:50380 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbaJHU1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:27:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkSAPCcNVRbsGtC/2dsb2JhbABfgw65BwUBc5oCBAKBCxcBe4QxLyOBGjeIQgG3NY5qhiCKJB2ENQWdRZYNg2U7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Sage Weil <sage@inktank.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH 1/1 linux-next] ceph: return error code directly.
Date: Wed,  8 Oct 2014 22:27:27 +0200
Message-Id: <1412800047-19818-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing err before returning value is not needed.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ceph/ioctl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index a822a6e..b2d777a 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -54,10 +54,7 @@ static long __validate_layout(struct ceph_mds_client *mdsc,
 			break;
 		}
 	mutex_unlock(&mdsc->mutex);
-	if (err)
-		return err;
-
-	return 0;
+	return err;
 }
 
 static long ceph_ioctl_set_layout(struct file *file, void __user *arg)
-- 
1.9.1

