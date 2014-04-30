Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbaD3BAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:00:30 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37261 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbaD3BAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:00:21 -0400
Subject: [PATCH 6/7] resources: Clarify sanity check message
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 19:00:19 -0600
Message-ID: <20140430010019.13138.61238.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The resource map sanity check message is a bit confusing.  Change it to be
more readable:

  -resource map sanity check conflict: 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff pnp 00:01
  +resource sanity check: requesting [mem 0xfed10000-0xfed15fff], which spans more than pnp 00:01 [mem 0xfed10000-0xfed13fff]

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 kernel/resource.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 8957d686e29b..3c2237ac32db 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1288,13 +1288,10 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 		if (p->flags & IORESOURCE_BUSY)
 			continue;
 
-		printk(KERN_WARNING "resource map sanity check conflict: "
-		       "0x%llx 0x%llx 0x%llx 0x%llx %s\n",
+		printk(KERN_WARNING "resource sanity check: requesting [mem %#010llx-%#010llx], which spans more than %s %pR\n",
 		       (unsigned long long)addr,
 		       (unsigned long long)(addr + size - 1),
-		       (unsigned long long)p->start,
-		       (unsigned long long)p->end,
-		       p->name);
+		       p->name, p);
 		err = -1;
 		break;
 	}

