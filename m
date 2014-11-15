Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaKOSmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 13:42:40 -0500
Received: from mout.web.de ([212.227.17.11]:60134 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbaKOSmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 13:42:38 -0500
Message-ID: <54679E97.5000801@users.sourceforge.net>
Date: Sat, 15 Nov 2014 19:42:31 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] ntfs: Deletion of unnecessary checks before the function
 call "iput"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:3pfejiVjkX3PZAJW0XcnSyaij5U/puBtza1MdeozdMpVMTL3ZoV
 8M3t2J5DzBy3qsh9Yf/P+h1dgTw6EepocrP3WVYGVHxQHcOa/3ULRqbHqBqPCI1zel9UyWk
 0ELxxeTQBwY7gGwiVL0de5naZi7nIH1qgfUiW30gP89iTilEOva5odteVKRnExTHbsgxPcj
 MjjM1DrJOTzxcWPYiKpAg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 15 Nov 2014 19:35:05 +0100

The iput() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/ntfs/super.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 6c3296e..8f22a47 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2204,17 +2204,12 @@ get_ctx_vol_failed:
 	return true;
 #ifdef NTFS_RW
 iput_usnjrnl_err_out:
-	if (vol->usnjrnl_j_ino)
-		iput(vol->usnjrnl_j_ino);
-	if (vol->usnjrnl_max_ino)
-		iput(vol->usnjrnl_max_ino);
-	if (vol->usnjrnl_ino)
-		iput(vol->usnjrnl_ino);
+	iput(vol->usnjrnl_j_ino);
+	iput(vol->usnjrnl_max_ino);
+	iput(vol->usnjrnl_ino);
 iput_quota_err_out:
-	if (vol->quota_q_ino)
-		iput(vol->quota_q_ino);
-	if (vol->quota_ino)
-		iput(vol->quota_ino);
+	iput(vol->quota_q_ino);
+	iput(vol->quota_ino);
 	iput(vol->extend_ino);
 #endif /* NTFS_RW */
 iput_sec_err_out:
@@ -2223,8 +2218,7 @@ iput_root_err_out:
 	iput(vol->root_ino);
 iput_logfile_err_out:
 #ifdef NTFS_RW
-	if (vol->logfile_ino)
-		iput(vol->logfile_ino);
+	iput(vol->logfile_ino);
 iput_vol_err_out:
 #endif /* NTFS_RW */
 	iput(vol->vol_ino);
@@ -2254,8 +2248,7 @@ iput_mftbmp_err_out:
 	iput(vol->mftbmp_ino);
 iput_mirr_err_out:
 #ifdef NTFS_RW
-	if (vol->mftmirr_ino)
-		iput(vol->mftmirr_ino);
+	iput(vol->mftmirr_ino);
 #endif /* NTFS_RW */
 	return false;
 }
-- 
2.1.3


