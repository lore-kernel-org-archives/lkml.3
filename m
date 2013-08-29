Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3H2OMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:12:15 -0400
Received: from mout.gmx.net ([212.227.15.15]:53206 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab3H2OMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:12:13 -0400
From: dl9pf@gmx.de
To: dl9pf@gmx.de, linux-kernel@vger.kernel.org
Cc: "'Jiri Kosina'" <trivial@kernel.org>
Subject: [PATCH] [TRIVIAL] Remove braces to fix build for clang. No functional change otherwise.
Date: Thu, 29 Aug 2013 16:10:36 +0200
Message-ID: <8859961.4OZEu3s9gr@aragorn.auenland.lan>
User-Agent: KMail/4.11 (Linux/3.7.10-1.16-default; KDE/4.11.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:Te282zIg1vJfWZ24NzJbkpBwa7spskwT5cN7u2lENnP/aP5Q5ye
 zyrDQxFAq94A6SHU1te1O+uV3Wr4jPwo2tXVuX+ZJ4WeTfWjM9ycNYlaDWZSo5rA49rzWdo
 jYsfnxWyKRaF0O9yvlovbsPWiiZky6hb2SFoCH7HvSivZpzGdIoXY2EN05ygRoJ8UXJ8S5D
 jMM0BCcoAjPoQJtxMJPwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Author:  PaX Team <pageexec at freemail.hu>
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
URL:     http://llvm.linuxfoundation.org

Merge:   Jan-Simon Möller <dl9pf at gmx.de>

Description:
  Clang chokes on the notation "inl (%dx)" but works for "inl %dx"; GNU as 
accepts both forms.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

CC: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
---
 drivers/misc/vmw_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index cb56e27..2421835 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -133,7 +133,7 @@ MODULE_LICENSE("GPL");
 #define VMWARE_BALLOON_CMD(cmd, data, result)		\
 ({							\
 	unsigned long __stat, __dummy1, __dummy2;	\
-	__asm__ __volatile__ ("inl (%%dx)" :		\
+	__asm__ __volatile__ ("inl %%dx" :		\
 		"a"(__stat),				\
 		"c"(__dummy1),				\
 		"d"(__dummy2),				\
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
