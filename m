Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaLYJcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 04:32:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbaLYJ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 04:28:57 -0500
Date: Thu, 25 Dec 2014 11:28:37 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: [PATCH repost 02/16] alpha/uaccess: fix sparse errors
Message-ID: <1419499661-8566-3-git-send-email-mst@redhat.com>
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
 arch/alpha/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/uaccess.h b/arch/alpha/include/asm/uaccess.h
index 766fdfd..fbe1d1e 100644
--- a/arch/alpha/include/asm/uaccess.h
+++ b/arch/alpha/include/asm/uaccess.h
@@ -96,7 +96,7 @@ extern void __get_user_unknown(void);
 	  case 8: __get_user_64(ptr); break;			\
 	  default: __get_user_unknown(); break;			\
 	}							\
-	(x) = (__typeof__(*(ptr))) __gu_val;			\
+	(x) = (__force __typeof__(*(ptr))) __gu_val;			\
 	__gu_err;						\
 })
 
@@ -115,7 +115,7 @@ extern void __get_user_unknown(void);
 		  default: __get_user_unknown(); break;			\
 		}							\
 	}								\
-	(x) = (__typeof__(*(ptr))) __gu_val;				\
+	(x) = (__force __typeof__(*(ptr))) __gu_val;				\
 	__gu_err;							\
 })
 
-- 
MST

