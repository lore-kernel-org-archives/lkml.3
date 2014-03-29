Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaC2SGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:06:17 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60907 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaC2SGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:06:15 -0400
Date: Sat, 29 Mar 2014 23:36:40 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 21/55] scsi: Mark function as static in isci/port.c
Message-ID: <1a67e2614c800cac379c183e4ff5a6b1eda34f9d.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in isci/port.c because they are not used outside
this file.

This eliminates the following warning in isci/port.c:
drivers/scsi/isci/port.c:65:13: warning: no previous prototype for ‘port_state_name’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/isci/port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 13098b0..225d39f 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -62,7 +62,7 @@
 
 #undef C
 #define C(a) (#a)
-const char *port_state_name(enum sci_port_states state)
+static const char *port_state_name(enum sci_port_states state)
 {
 	static const char * const strings[] = PORT_STATES;
 
-- 
1.7.9.5

