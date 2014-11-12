Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbaKLD3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:29:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246AbaKLBcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:32:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robert Baldyga <r.baldyga@samsung.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.17 219/319] usb: gadget: f_fs: remove redundant ffs_data_get()
Date: Wed, 12 Nov 2014 10:15:57 +0900
Message-Id: <20141112011028.996991020@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Baldyga <r.baldyga@samsung.com>

commit a3058a5d82e296daaca07411c3738a9ddd79f302 upstream.

During FunctionFS bind, ffs_data_get() function was called twice
(in functionfs_bind() and in ffs_do_functionfs_bind()), while on unbind
ffs_data_put() was called once (in functionfs_unbind() function).
In result refcount never reached value 0, and ffs memory resources has
been never released.

Since ffs_data_get() call in ffs_do_functionfs_bind() is redundant
and not neccessary, we remove it to have equal number of gets ans puts,
and free allocated memory after refcount reach 0.

Fixes: 5920cda (usb: gadget: FunctionFS: convert to new function
	interface with backward compatibility)
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_fs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2626,8 +2626,6 @@ static inline struct f_fs_opts *ffs_do_f
 	func->conf = c;
 	func->gadget = c->cdev->gadget;
 
-	ffs_data_get(func->ffs);
-
 	/*
 	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
 	 * configurations are bound in sequence with list_for_each_entry,


