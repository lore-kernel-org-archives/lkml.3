Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaBIK7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 05:59:37 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58643 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaBIK7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 05:59:35 -0500
Date: Sun, 9 Feb 2014 16:29:30 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        josh@joshtriplett.org
Subject: [PATCH 1/4] drivers: xen: Mark function as static in platform-pci.c
Message-ID: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in xen/platform-pci.c because it is not used
outside this file.

This eliminates the following warning in xen/platform-pci.c:
drivers/xen/platform-pci.c:48:15: warning: no previous prototype for ‘alloc_xen_mmio’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/xen/platform-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index a1361c3..3454973 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -45,7 +45,7 @@ static unsigned long platform_mmio_alloc;
 static unsigned long platform_mmiolen;
 static uint64_t callback_via;
 
-unsigned long alloc_xen_mmio(unsigned long len)
+static unsigned long alloc_xen_mmio(unsigned long len)
 {
 	unsigned long addr;
 
-- 
1.7.9.5

