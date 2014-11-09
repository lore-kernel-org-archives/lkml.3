Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaKIMXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 07:23:49 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:51310 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaKIMXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 07:23:48 -0500
Date: Sun, 9 Nov 2014 07:23:12 -0500 (EST)
From: Rodrigo Freire <rfreire@redhat.com>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
        Felix Fietkau <nbd@openwrt.org>, dwmw2@infradead.org,
        Herton Krzesinski <hkrzesin@redhat.com>,
        Brian Norris <computersforpeace@gmail.com>
Message-ID: <1874445287.7454806.1415535792984.JavaMail.zimbra@redhat.com>
In-Reply-To: <2086372266.7454667.1415535533979.JavaMail.zimbra@redhat.com>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com> <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com> <20140909170231.GA14429@logfs.org> <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com> <20141105202303.GN23619@ld-irv-0074> <2086372266.7454667.1415535533979.JavaMail.zimbra@redhat.com>
Subject: [PATCH v3 3/3] mtd: block2mtd: Removes PAGE_MASK as a index to
 partition size
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF24 (Linux)/8.0.6_GA_5922)
Thread-Topic: block2mtd: wait for device enumeration, add name support
Thread-Index: PMeTZNEFdw+DidHIeFmVdhF00sSfjNRxsKEK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

mtd: block2mtd: Removes PAGE_MASK as a index to partition size

PAGE_MASK is no longer needed with the new term.
This patch keeps the device size aligned with the erase_size.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
Signed-off-by: Herton Krzesinski <herton@redhat.com>
---
V3: Separated on a single patch
--- a/drivers/mtd/devices/block2mtd.c	2014-11-07 17:40:58.688747820 -0200
+++ b/drivers/mtd/devices/block2mtd.c	2014-11-07 17:41:28.054750893 -0200
@@ -291,8 +291,7 @@ static struct block2mtd_dev *add_device(
 		goto err_destroy_mutex;
 
 	dev->mtd.name = name;
-
-	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
+	dev->mtd.size = dev->blkdev->bd_inode->i_size & ~(erase_size - 1);
 	dev->mtd.erasesize = erase_size;
 	dev->mtd.writesize = 1;
 	dev->mtd.writebufsize = PAGE_SIZE;
---
1.7.1
