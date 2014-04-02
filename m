Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbaDBPZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:25:51 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:63803 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbaDBPZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:25:50 -0400
Date: Wed, 2 Apr 2014 11:25:47 -0400
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Himanshu Madhani <himanshu.madhani@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>
Cc: linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: qlcnic: include irq.h for irq definitions
Message-ID: <20140402152547.GD20438@zod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The qlcnic driver fails to build on ARM with errors like:

In file included from drivers/net/ethernet/qlogic/qlcnic/qlcnic.h:36:0,
                 from drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c:8:
drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h:585:1: error: unknown type name 'irqreturn_t'
 irqreturn_t qlcnic_83xx_clear_legacy_intr(struct qlcnic_adapter *);
 ^

Nothing in the driver is explicitly including the irq definitions, so we
add an include of linux/irq.h to pick them up.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
index f19f81cde134..cbc897e6bb8f 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
@@ -23,6 +23,7 @@
 #include <linux/ethtool.h>
 #include <linux/mii.h>
 #include <linux/timer.h>
+#include <linux/irq.h>
 
 #include <linux/vmalloc.h>
 
-- 
1.8.5.3

