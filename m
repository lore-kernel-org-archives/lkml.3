Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab3E0Ccf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:32:35 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41132 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab3E0Ccb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:32:31 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <hverkuil@xs4all.nl>, <mchehab@redhat.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 22/24] drivers/media/radio/radio-maxiradio: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:31:59 +0800
Message-ID: <1369621919-12800-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use module_pci_driver instead of init/exit, make code clean

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/media/radio/radio-maxiradio.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index bd4d3a7..1d1c9e1 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -200,15 +200,4 @@ static struct pci_driver maxiradio_driver = {
 	.remove		= maxiradio_remove,
 };
 
-static int __init maxiradio_init(void)
-{
-	return pci_register_driver(&maxiradio_driver);
-}
-
-static void __exit maxiradio_exit(void)
-{
-	pci_unregister_driver(&maxiradio_driver);
-}
-
-module_init(maxiradio_init);
-module_exit(maxiradio_exit);
+module_pci_driver(maxiradio_driver);
-- 
1.7.1


