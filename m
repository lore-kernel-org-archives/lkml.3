Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbbAFP4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:56:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbbAFPoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:00 -0500
Date: Tue, 6 Jan 2015 17:43:44 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: [PATCH v2 04/40] avr32/uaccess: fix sparse errors
Message-ID: <1420558883-10131-5-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio wants to read bitwise types from userspace using get_user.  At the
moment this triggers sparse errors, since the value is passed through an
integer.

Fix that up using __force.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/include/asm/uaccess.h b/arch/avr32/include/asm/uaccess.h
index 245b2ee..ccd07c4 100644
--- a/arch/avr32/include/asm/uaccess.h
+++ b/arch/avr32/include/asm/uaccess.h
@@ -191,7 +191,7 @@ extern int __put_user_bad(void);
 	default: __gu_err = __get_user_bad(); break;			\
 	}								\
 									\
-	x = (typeof(*(ptr)))__gu_val;					\
+	x = (__force typeof(*(ptr)))__gu_val;				\
 	__gu_err;							\
 })
 
@@ -222,7 +222,7 @@ extern int __put_user_bad(void);
 	} else {							\
 		__gu_err = -EFAULT;					\
 	}								\
-	x = (typeof(*(ptr)))__gu_val;					\
+	x = (__force typeof(*(ptr)))__gu_val;				\
 	__gu_err;							\
 })
 
-- 
MST

