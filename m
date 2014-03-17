Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaCQHqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:46:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbaCQHqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:46:16 -0400
Date: Mon, 17 Mar 2014 08:48:51 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: kbuild-all@01.org, kbuild test robot <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: [PATCH] xen: declare notifier_block on xen-ops.h
Message-ID: <20140317074850.GB1767@redhat.com>
References: <5323aab1.r24xwrkmR/N+a3KK%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5323aab1.r24xwrkmR/N+a3KK%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch fixes below warnings:

   In file included from arch/x86/xen/xen-ops.h:7:0,
                    from arch/x86/xen/vga.c:9:
>> include/xen/xen-ops.h:19:42: warning: 'struct notifier_block' declared inside parameter list [enabled by default]
    void xen_resume_notifier_register(struct notifier_block *nb);
                                             ^
>> include/xen/xen-ops.h:19:42: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
>> include/xen/xen-ops.h:20:44: warning: 'struct notifier_block' declared inside parameter list [enabled by default]
    void xen_resume_notifier_unregister(struct notifier_block *nb);

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/xen/manage.c  | 1 -
 include/xen/xen-ops.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 96e4173..fc6c94c 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -13,7 +13,6 @@
 #include <linux/freezer.h>
 #include <linux/syscore_ops.h>
 #include <linux/export.h>
-#include <linux/notifier.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index cc8b4cb..acc7b7a 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -2,6 +2,7 @@
 #define INCLUDE_XEN_OPS_H
 
 #include <linux/percpu.h>
+#include <linux/notifier.h>
 #include <asm/xen/interface.h>
 
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
-- 
1.7.11.7

