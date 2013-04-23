Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab3DWWMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:12:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab3DWVxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:53:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [ 33/42] userns: Check uid_maps openers fsuid, not the current fsuid
Date: Tue, 23 Apr 2013 14:52:31 -0700
Message-Id: <20130423215208.854280588@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit e3211c120a85b792978bcb4be7b2886df18d27f0 upstream.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/user_namespace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -763,12 +763,12 @@ static bool new_idmap_permitted(const st
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
 			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, current_fsuid()))
+			if (uid_eq(uid, file->f_cred->fsuid))
 				return true;
 		}
 		else if (cap_setid == CAP_SETGID) {
 			kgid_t gid = make_kgid(ns->parent, id);
-			if (gid_eq(gid, current_fsgid()))
+			if (gid_eq(gid, file->f_cred->fsgid))
 				return true;
 		}
 	}


