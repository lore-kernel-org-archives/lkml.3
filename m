Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3AXVNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:13:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:39858 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791Ab3AXVNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:13:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>,
        Barry Davis <Barry-Davis@stormagic.com>
Subject: [ 01/46] make sure that /linuxrc has std{in,out,err}
Date: Thu, 24 Jan 2013 13:12:39 -0800
Message-Id: <20130124211136.234762767@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 43b16820249396aea7eb57c747106e211e54bed5 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Davis <Barry-Davis@stormagic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 init/do_mounts_initrd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -36,6 +36,10 @@ __setup("noinitrd", no_initrd);
 static int init_linuxrc(struct subprocess_info *info, struct cred *new)
 {
 	sys_unshare(CLONE_FS | CLONE_FILES);
+	/* stdin/stdout/stderr for /linuxrc */
+	sys_open("/dev/console", O_RDWR, 0);
+	sys_dup(0);
+	sys_dup(0);
 	/* move initrd over / and chdir/chroot in initrd root */
 	sys_chdir("/root");
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);


