Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3EXOSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:18:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab3EXOSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:18:00 -0400
Date: Fri, 24 May 2013 17:18:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Subject: [PATCH v3 06/11] mn10300: uaccess s/might_sleep/might_fault/
Message-ID: <1369404522-12927-6-git-send-email-mst@redhat.com>
References: <cover.1368702323.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1368702323.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/mn10300/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mn10300/include/asm/uaccess.h b/arch/mn10300/include/asm/uaccess.h
index 780560b..107508a 100644
--- a/arch/mn10300/include/asm/uaccess.h
+++ b/arch/mn10300/include/asm/uaccess.h
@@ -471,13 +471,13 @@ extern unsigned long __generic_copy_from_user(void *, const void __user *,
 
 #define __copy_to_user(to, from, n)			\
 ({							\
-	might_sleep();					\
+	might_fault();					\
 	__copy_to_user_inatomic((to), (from), (n));	\
 })
 
 #define __copy_from_user(to, from, n)			\
 ({							\
-	might_sleep();					\
+	might_fault();					\
 	__copy_from_user_inatomic((to), (from), (n));	\
 })
 
-- 
MST
