Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3LSPEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:04:10 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:35769 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3LSPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:06 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 03/38] powerpc: cell: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:14 +0100
Message-Id: <1387465429-3568-4-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/powerpc/platforms/cell/spu_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index f85db3a..f7fb0d9 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -597,6 +597,7 @@ static int spu_create_dev(struct spu *spu)
 	if (ret) {
 		printk(KERN_ERR "Can't register SPU %d with sysfs\n",
 				spu->number);
+		put_device(&spu->dev);
 		return ret;
 	}
 
-- 
1.8.3.1

