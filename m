Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaAROfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 09:35:54 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:61817 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaAROfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 09:35:18 -0500
Subject: [PATCH 1/2] Revert "EISA: Log device resources in dmesg"
To: linux-kernel@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org,
        Joseph Salisbury <joseph.salisbury@canonical.com>
Date: Sat, 18 Jan 2014 07:35:16 -0700
Message-ID: <20140118143516.32751.54245.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140118143308.32751.27410.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140118143308.32751.27410.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit a2080d0c561c546d73cb8b296d4b7ca414e6860b.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/eisa/eisa-bus.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index 8842cde69177..1b86fe0c2e80 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -288,7 +288,6 @@ static int __init eisa_request_resources(struct eisa_root_device *root,
 			edev->res[i].flags = IORESOURCE_IO | IORESOURCE_BUSY;
 		}
 
-		dev_printk(KERN_DEBUG, &edev->dev, "%pR\n", &edev->res[i]);
 		if (request_resource(root->res, &edev->res[i]))
 			goto failed;
 	}

