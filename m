Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaAONwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:52:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbaAONwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:52:19 -0500
From: Mateusz Guzik <mguzik@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Gabriellla Schmidt <gsc@bruker.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] ipc: fix compat msgrcv with negative msgtyp
Date: Wed, 15 Jan 2014 14:52:12 +0100
Message-Id: <1389793932-7549-1-git-send-email-mguzik@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compat function takes msgtyp argument as u32 and passes it down to
do_msgrcv which results in casting to long, thus the sign is lost
and we get a big positive number instead.

Cast the argument to signed type before passing it down.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Reported-by: Gabriellla Schmidt <gsc@bruker.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 ipc/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/compat.c b/ipc/compat.c
index 892f658..d3b3760 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -381,7 +381,7 @@ COMPAT_SYSCALL_DEFINE6(ipc, u32, call, int, first, int, second,
 			uptr = compat_ptr(ipck.msgp);
 			fifth = ipck.msgtyp;
 		}
-		return do_msgrcv(first, uptr, second, fifth, third,
+		return do_msgrcv(first, uptr, second, (s32)fifth, third,
 				 compat_do_msg_fill);
 	}
 	case MSGGET:
-- 
1.8.3.1

