Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbbA2Bvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:51:52 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:55044 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbbA2Bvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:51:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-mtd@lists.infradead.org, Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] mtd: export new mtd_mmap_capabilities
Date: Wed, 28 Jan 2015 16:19:31 +0100
Message-ID: <1900951.4yX9yJNQM5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:BXDenHKisMiCtcdexXsTW2OBCRFNk3iSEjNIuqrlshpold2b9YG
 W1eGe1frhhONndtXX5pH1pv43O1OuiWfcIdkN/MlyJnUYIBy5Ay3T5jslaM3407uvlU9Mn4
 bctprC04s14avdQ/6uP2bu68qlVDnTx+E9iy2FB+sfIP5+mI8MaRbjA+MUYGcCMx3MBk3Uh
 fTZmLBKFRDP2hxeVt8aCQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently added mtd_mmap_capabilities can be used from loadable
modules, in particular romfs, but is not exported, so we get

ERROR: "mtd_mmap_capabilities" [fs/romfs/romfs.ko] undefined!

This adds the missing export.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: b4caecd48005f ("fs: introduce f_op->mmap_capabilities for nommu mmap support")

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 1eef3b032f08..de7957681680 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -365,6 +365,7 @@ unsigned mtd_mmap_capabilities(struct mtd_info *mtd)
 		return NOMMU_MAP_COPY;
 	}
 }
+EXPORT_SYMBOL_GPL(mtd_mmap_capabilities);
 #endif
 
 /**

