Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaBRCKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:10:40 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46782 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaBRCKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:10:37 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: horms@verge.net.au, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, ben.dooks@codethink.co.uk,
        geert@linux-m68k.org, bhelgaas@google.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 18 Feb 2014 11:11:51 +0900
Message-Id: <20140218021151.14164.51263.sendpatchset@w520>
In-Reply-To: <20140218021041.14164.56411.sendpatchset@w520>
References: <20140218021041.14164.56411.sendpatchset@w520>
Subject: [PATCH 07/08] PCI: rcar: Enable BOUNCE in case of HIGHMEM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Select BOUNCE in case of HIGHMEM to enable bounce buffers in
the block layer. Without this patch the DMABOUNCE code will
error out due to lack of HIGHMEM support, and without DMABOUNCE
there will be silent errors.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/pci/host/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- 0009/drivers/pci/host/Kconfig
+++ work/drivers/pci/host/Kconfig	2014-02-04 16:11:27.000000000 +0900
@@ -30,6 +30,7 @@ config PCI_RCAR_GEN2
 	depends on ARM && (ARCH_R8A7790 || ARCH_R8A7791 || COMPILE_TEST)
 	select GENERIC_ALLOCATOR
 	select DMABOUNCE
+	select BOUNCE if HIGHMEM
 	help
 	  Say Y here if you want internal PCI support on R-Car Gen2 SoC.
 	  There are 3 internal PCI controllers available with a single
