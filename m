Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaBKUCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:02:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaBKTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.12 023/107] ARM: mvebu: Fix kernel hang in mvebu_soc_id_init() when of_iomap failed
Date: Tue, 11 Feb 2014 11:04:49 -0800
Message-Id: <20140211184748.861083452@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

commit dc4910d9e93f8cc56b190dd8fc9e789135978216 upstream.

When pci_base is accessed whereas it has not been properly mapped by
of_iomap() the kernel hang. The check of this pointer made an improper
use of IS_ERR() instead of comparing to NULL. This patch fix this
issue.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reported-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Fixes: 930ab3d403ae (i2c: mv64xxx: Add I2C Transaction Generator support)
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-mvebu/mvebu-soc-id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-mvebu/mvebu-soc-id.c
+++ b/arch/arm/mach-mvebu/mvebu-soc-id.c
@@ -88,7 +88,7 @@ static int __init mvebu_soc_id_init(void
 	}
 
 	pci_base = of_iomap(child, 0);
-	if (IS_ERR(pci_base)) {
+	if (pci_base == NULL) {
 		pr_err("cannot map registers\n");
 		ret = -ENOMEM;
 		goto res_ioremap;


