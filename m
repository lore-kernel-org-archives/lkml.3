Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaAEPYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 10:24:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaAEPYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 10:24:07 -0500
Date: Sun, 5 Jan 2014 10:24:01 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Paul Durrant <Paul.Durrant@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, ian.campbell@citrix.com, wei.liu2@citrix.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xen-netback: Include header for vmalloc
Message-ID: <20140105152401.GF18517@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ac3d5ac27735 ("xen-netback: fix guest-receive-side array sizes")
added calls to vmalloc and vfree in the interface.c file without including
<linux/vmalloc.h>.  This causes build failures if the
-Werror=implicit-function-declaration flag is passed.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 drivers/net/xen-netback/interface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 34ca4e5..fff8cdd 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -34,6 +34,7 @@
 #include <linux/ethtool.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_vlan.h>
+#include <linux/vmalloc.h>
 
 #include <xen/events.h>
 #include <asm/xen/hypercall.h>
-- 
1.8.4.2

