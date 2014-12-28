Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaL1Unn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 15:43:43 -0500
Received: from mout.web.de ([212.227.15.3]:61666 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaL1Unm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 15:43:42 -0500
Message-ID: <54A06B70.20707@users.sourceforge.net>
Date: Sun, 28 Dec 2014 21:43:28 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 3/8] fs/9p: One function call less in v9fs_vfs_atomic_open()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net>
In-Reply-To: <54A01326.3050306@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:jeZMoXd+UpG+HR6OyZAeoosN7MeQpPGw+0F02Nvt3aSIBusjdvy
 6BriiQT/U5FNFayMtfRSsPHEs9G3UiksHlGIByjDtSId0JSu8XIUWeSAgQA2/Mb3HupfkzZ
 aaNA5K8Yro3qoThhTmrDyJ9SX4q6omhubZWRMIH0BccXPJoQnjGL7QMiNIwMKbcQ7s74YMo
 7sBQ7aOg4RE4U/+G2bkuw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 28 Dec 2014 08:45:31 +0100

The p9_client_clunk() function was called in one case by the
v9fs_vfs_atomic_open() function during error handling even if the passed
variable "fid" contained a null pointer.

This implementation detail could be improved by the adjustment of a jump target.
Let us delete also an unnecessary variable assignment there.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/9p/vfs_inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 81b945a..f568427 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -873,8 +873,7 @@ v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
 						v9fs_proto_dotu(v9ses)));
 	if (IS_ERR(fid)) {
 		err = PTR_ERR(fid);
-		fid = NULL;
-		goto error;
+		goto out;
 	}
 
 	v9fs_invalidate_inode_attr(dir);
-- 
2.2.1

