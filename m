Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab3D2QGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:06:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:54855 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab3D2QGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:06:02 -0400
Message-ID: <517E9A4F.1080609@infradead.org>
Date: Mon, 29 Apr 2013 09:05:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH -next] tty.h: fix build errors when PROC_FS is not enabled
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
In-Reply-To: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build error when CONFIG_PROC_FS is not enabled:

include/linux/tty.h: In function 'proc_tty_register_driver':
include/linux/tty.h:698:52: error: parameter name omitted
include/linux/tty.h: In function 'proc_tty_unregister_driver':
include/linux/tty.h:699:54: error: parameter name omitted

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 include/linux/tty.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20130429.orig/include/linux/tty.h
+++ linux-next-20130429/include/linux/tty.h
@@ -695,8 +695,8 @@ do {									\
 extern void proc_tty_register_driver(struct tty_driver *);
 extern void proc_tty_unregister_driver(struct tty_driver *);
 #else
-static inline void proc_tty_register_driver(struct tty_driver *) {}
-static inline void proc_tty_unregister_driver(struct tty_driver *) {}
+static inline void proc_tty_register_driver(struct tty_driver *d) {}
+static inline void proc_tty_unregister_driver(struct tty_driver *d) {}
 #endif
 
 #endif
