Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaLYJbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 04:31:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaLYJbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 04:31:12 -0500
Date: Thu, 25 Dec 2014 11:30:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH repost 16/16] m68k/uaccess: fix sparse errors
Message-ID: <1419499661-8566-17-git-send-email-mst@redhat.com>
References: <1419499661-8566-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419499661-8566-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio wants to read bitwise types from userspace using get_user.  At the
moment this triggers sparse errors, since the value is passed through an
integer.

Fix that up using __force.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/m68k/include/asm/uaccess_mm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/uaccess_mm.h b/arch/m68k/include/asm/uaccess_mm.h
index 15901db..c31f53f 100644
--- a/arch/m68k/include/asm/uaccess_mm.h
+++ b/arch/m68k/include/asm/uaccess_mm.h
@@ -146,7 +146,7 @@ asm volatile ("\n"					\
 		"	.previous"				\
 		: "+d" (res), "=&" #reg (__gu_val)		\
 		: "m" (*(ptr)), "i" (err));			\
-	(x) = (typeof(*(ptr)))(unsigned long)__gu_val;		\
+	(x) = (__force typeof(*(ptr)))(__force unsigned long)__gu_val;		\
 })
 
 #define __get_user(x, ptr)						\
@@ -188,7 +188,7 @@ asm volatile ("\n"					\
 			  "+a" (__gu_ptr)				\
 			: "i" (-EFAULT)					\
 			: "memory");					\
-		(x) = (typeof(*(ptr)))__gu_val;				\
+		(x) = (__force typeof(*(ptr)))__gu_val;				\
 		break;							\
 	    }	*/							\
 	default:							\
-- 
MST

