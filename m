Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbbAMOMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:12:14 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:62466 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbAMOMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:12:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-pcmcia@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] pcmcia: add missing include for new pci resource handler
Date: Tue, 13 Jan 2015 15:11:55 +0100
Message-ID: <5425521.E2szj8uYq0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:QWiBK787ecv0axe3WzuZ+WZ7rr4Ks8FExhBlH1NrZPcIXU5M/6R
 xVX3ITeX06uo/6inNS1l6R6RXohBcjJ95Huqjzo0a64ivNSyovgTch/22Kjc1X6FS09vogc
 FJD6xzPNi/9JeqGoHpahsuPjAzJ2JdopuWolncvND575muToJ8wal7hAhcx+GT6PMgSjyBx
 Yc4kQ2MiCZh5Dp+D45ELQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently added rsrc_pci.c file calls pci_bus_alloc_resource without
including the header file that declares it, and that sometimes causes
a build warning on ARM:

drivers/pcmcia/rsrc_pci.c: In function 'find_io_region':
drivers/pcmcia/rsrc_pci.c:40:2: error: implicit declaration of function 'pci_bus_alloc_resource' [-Werror=implicit-function-declaration]

This adds the missing include statement.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 02b03846bb2be ("pcmcia: add a new resource manager for non ISA systems")
---
diff --git a/drivers/pcmcia/rsrc_pci.c b/drivers/pcmcia/rsrc_pci.c
index 8934d3c01f80..21c3683b1a53 100644
--- a/drivers/pcmcia/rsrc_pci.c
+++ b/drivers/pcmcia/rsrc_pci.c
@@ -1,6 +1,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/pci.h>
 
 #include <pcmcia/ss.h>
 #include <pcmcia/cistpl.h>

