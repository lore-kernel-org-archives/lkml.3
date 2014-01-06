Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbaAFXDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:03:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190AbaAFWlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 3.10 092/129] ceph: improve error handling in ceph_mdsmap_decode
Date: Mon,  6 Jan 2014 14:38:41 -0800
Message-Id: <20140106223902.235607416@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Goode <emilgoode@gmail.com>

commit c213b50b7dcbf06abcfbf1e4eee5b76586718bd9 upstream.

This patch makes the following improvements to the error handling
in the ceph_mdsmap_decode function:

- Add a NULL check for return value from kcalloc
- Make use of the variable err

Signed-off-by: Emil Goode <emilgoode@gmail.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/mdsmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -138,6 +138,8 @@ struct ceph_mdsmap *ceph_mdsmap_decode(v
 				m->m_info[mds].export_targets =
 					kcalloc(num_export_targets, sizeof(u32),
 						GFP_NOFS);
+				if (m->m_info[mds].export_targets == NULL)
+					goto badmem;
 				for (j = 0; j < num_export_targets; j++)
 					m->m_info[mds].export_targets[j] =
 					       ceph_decode_32(&pexport_targets);
@@ -170,7 +172,7 @@ bad:
 		       DUMP_PREFIX_OFFSET, 16, 1,
 		       start, end - start, true);
 	ceph_mdsmap_destroy(m);
-	return ERR_PTR(-EINVAL);
+	return ERR_PTR(err);
 }
 
 void ceph_mdsmap_destroy(struct ceph_mdsmap *m)


