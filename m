Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaKKLcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:32:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57718 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaKKLK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robert Baldyga <r.baldyga@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 120/170] usb: gadget: f_fs: remove redundant ffs_data_get()
Date: Tue, 11 Nov 2014 11:07:59 +0000
Message-Id: <1415704129-12709-121-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.16: file rename:
  drivers/usb/gadget/function/f_fs.c -> drivers/usb/gadget/f_fs.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/f_fs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 8598c27c7d43..538300c05c5a 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -2297,8 +2297,6 @@ static inline struct f_fs_opts *ffs_do_functionfs_bind(struct usb_function *f,
 	func->conf = c;
 	func->gadget = c->cdev->gadget;
 
-	ffs_data_get(func->ffs);
-
 	/*
 	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
 	 * configurations are bound in sequence with list_for_each_entry,
-- 
2.1.0

