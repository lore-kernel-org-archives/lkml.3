Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3GIMhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:37:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:65378 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3GIMhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:37:20 -0400
Message-ID: <51DC03EB.5030206@huawei.com>
Date: Tue, 9 Jul 2013 20:36:59 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND] drivers/pcmcia/pd6729: Convert to module_pci_driver
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/pcmcia/pd6729.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

 fix Eric Miao`s email address

diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index b29d97e..9a7fc88 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -775,15 +775,4 @@ static struct pci_driver pd6729_pci_driver = {
 	.remove		= pd6729_pci_remove,
 };

-static int pd6729_module_init(void)
-{
-	return pci_register_driver(&pd6729_pci_driver);
-}
-
-static void pd6729_module_exit(void)
-{
-	pci_unregister_driver(&pd6729_pci_driver);
-}
-
-module_init(pd6729_module_init);
-module_exit(pd6729_module_exit);
+module_pci_driver(pd6729_pci_driver);
-- 
1.7.1


