Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaBILBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 06:01:52 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37162 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaBILBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 06:01:50 -0500
Date: Sun, 9 Feb 2014 16:31:46 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        josh@joshtriplett.org
Subject: [PATCH 2/4] drivers: xen: Include appropriate header file in pcpu.c
Message-ID: <a7672a06595d907ce9aacc65b3cbe0179684f5e0.1391943416.git.rashika.kheria@gmail.com>
References: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file in xen/pcpu.c because include/xen/acpi.h
contains prototype declaration of functions defined in the file.

This eliminates the following warning in xen/pcpu.c:
drivers/xen/pcpu.c:336:6: warning: no previous prototype for ‘xen_pcpu_hotplug_sync’ [-Wmissing-prototypes]
drivers/xen/pcpu.c:346:5: warning: no previous prototype for ‘xen_pcpu_id’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/xen/pcpu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
index 79e1dff..0aac403 100644
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -40,6 +40,7 @@
 #include <linux/capability.h>
 
 #include <xen/xen.h>
+#include <xen/acpi.h>
 #include <xen/xenbus.h>
 #include <xen/events.h>
 #include <xen/interface/platform.h>
-- 
1.7.9.5

