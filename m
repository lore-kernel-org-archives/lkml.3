Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441Ab3DCPSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:18:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3DCPSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:18:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: fix crash_notes_size build warning
Date: Wed, 3 Apr 2013 15:18:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Simon Horman <horms@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201304031518.24455.arnd@arndb.de>
X-Provags-ID: V02:K0:nZbCbHZ8iVoo8Bna0gODUL3rWD+l9Fm6QVlRoB8iq89
 LPlXuDhIS/BzfJOTxF4ulP/1buHUERwDWOI8G9y0obYkn3umnJ
 dOcWyz+Jhbz1AwrXgr4ZMUByxSBvJdOpdKhbFL5+nDgdssJEuv
 kMTcH9RIJTwpVMZJ6I4gTM23ypmkCkpoAAzltExdJJfFjB86Gy
 OvsUqrGLSuxOjcMmfEcxeA3uqABavz+M/GPdGhiaX1Rc3TqYQt
 lDdmAjQWvYzbPqc0cEGV2f7KdiG5gGIA7X1eoaGUHHnQDdGmDw
 TAJBGbmQSZjts5py8cLwfZSno5mX+76SC2VQWi6b1Wvmah9Og5
 cwp5b5w+JCSRlcfN1LmU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b60d17603df3225d9f51c4f8168e8e00a1090911 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 3 Apr 2013 17:14:32 +0200
Subject: [PATCH] sysfs: fix crash_notes_size build warning

commit eca4549f57 "sysfs: Add crash_notes_size to export percpu
note size" adds a printk that outputs a size_t value as %lu
when it should be %zu, resulting in this warning.

drivers/base/cpu.c: In function 'show_crash_notes_size':
drivers/base/cpu.c:142:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat=]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index a55b590..d8c7f3e 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -139,7 +139,7 @@ static ssize_t show_crash_notes_size(struct device *dev,
 {
 	ssize_t rc;
 
-	rc = sprintf(buf, "%lu\n", sizeof(note_buf_t));
+	rc = sprintf(buf, "%zu\n", sizeof(note_buf_t));
 	return rc;
 }
 static DEVICE_ATTR(crash_notes_size, 0400, show_crash_notes_size, NULL);
