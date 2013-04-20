Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab3DTJyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 05:54:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:43639 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848Ab3DTJyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 05:54:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,513,1363158000"; 
   d="scan'208";a="322112567"
Date: Sat, 20 Apr 2013 17:54:50 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>, linux-kernel@vger.kernel.org
Subject: [PATCH] pps: pps_kc_hardpps_lock can be static
Message-ID: <20130420095450.GA24488@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pps/kc.c:37:1: sparse: symbol 'pps_kc_hardpps_lock' was not declared. Should it be static?
drivers/pps/kc.c:39:19: sparse: symbol 'pps_kc_hardpps_dev' was not declared. Should it be static?
drivers/pps/kc.c:40:5: sparse: symbol 'pps_kc_hardpps_mode' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/pps/kc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next.orig/drivers/pps/kc.c	2012-02-23 14:54:18.218537076 +0800
+++ linux-next/drivers/pps/kc.c	2013-04-20 17:20:18.866632025 +0800
@@ -34,10 +34,10 @@
  */
 
 /* state variables to bind kernel consumer */
-DEFINE_SPINLOCK(pps_kc_hardpps_lock);
+static DEFINE_SPINLOCK(pps_kc_hardpps_lock);
 /* PPS API (RFC 2783): current source and mode for kernel consumer */
-struct pps_device *pps_kc_hardpps_dev;	/* unique pointer to device */
-int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
+static struct pps_device *pps_kc_hardpps_dev;	/* unique pointer to device */
+static int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
 
 /* pps_kc_bind - control PPS kernel consumer binding
  * @pps: the PPS source
