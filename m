Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbaJ1H33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:29:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaJ1DmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:42:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.16 010/127] fs: Add a missing permission check to do_umount
Date: Tue, 28 Oct 2014 11:34:05 +0800
Message-Id: <20141028033421.370870760@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit a1480dcc3c706e309a88884723446f2e84fedd5b upstream.

Accessing do_remount_sb should require global CAP_SYS_ADMIN, but
only one of the two call sites was appropriately protected.

Fixes CVE-2014-7975.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1374,6 +1374,8 @@ static int do_umount(struct mount *mnt,
 		 * Special case for "unmounting" root ...
 		 * we just try to remount it readonly.
 		 */
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
 		down_write(&sb->s_umount);
 		if (!(sb->s_flags & MS_RDONLY))
 			retval = do_remount_sb(sb, MS_RDONLY, NULL, 0);


