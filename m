Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3LSPRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:17:44 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:59579 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab3LSPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:04 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 02/38] powerpc: qe_lib: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:13 +0100
Message-Id: <1387465429-3568-3-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/powerpc/sysdev/qe_lib/qe_ic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index b2b87c3..2e15262 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -493,6 +493,7 @@ static int __init init_qe_ic_sysfs(void)
 	rc = device_register(&device_qe_ic);
 	if (rc) {
 		printk(KERN_ERR "Failed registering qe_ic sys device\n");
+		put_device(&device_qe_ic);
 		return -ENODEV;
 	}
 	return 0;
-- 
1.8.3.1

