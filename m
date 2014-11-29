Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaK2Psr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 10:48:47 -0500
Received: from mout.web.de ([212.227.15.14]:50782 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaK2Psq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 10:48:46 -0500
Message-ID: <5479EAD6.1080706@users.sourceforge.net>
Date: Sat, 29 Nov 2014 16:48:38 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] fs-notify: Deletion of an unnecessary check before the
 function call "iput"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:w00Z4HVY6IgBlO6ejIDx14WZ1BrygbYEZLN4bFeE5ddZE2O+R51
 afa5X2/l3FDg2UzpTh6x4B0EkzjYmtVQgf6b5h1W97wIn+G0tUeQ53t/D19OKvAl/m9L/xy
 jzn1FPjU/Tfb4QVidfN1RyYfZuUTC9ElemjXMHFbeBwdvcjG6hDqi+r/VN/GZuoalgnU359
 iOpRJb25LUxEYUWKs+3pg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 29 Nov 2014 16:42:50 +0100

The iput() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/notify/inode_mark.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 3daf513..d8157a6 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -231,8 +231,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 		 */
 		spin_unlock(&inode_sb_list_lock);
 
-		if (need_iput_tmp)
-			iput(need_iput_tmp);
+		iput(need_iput_tmp);
 
 		/* for each watch, send FS_UNMOUNT and then remove it */
 		fsnotify(inode, FS_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
-- 
2.1.3

