Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3AUU0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:26:40 -0500
Received: from mout.gmx.net ([212.227.17.20]:55278 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab3AUU0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:26:39 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18uxLccQEAuALa7dwgg4Mh1PGPC0UDMNh+AwlNxvA
	BR7Ao4Tra+toez
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/comedi: Use bool initializations
Date: Mon, 21 Jan 2013 21:29:43 +0100
Message-Id: <1358800183-17947-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found with coccicheck.

The semantic patch that makes this output is available
in scripts/coccinelle/misc/boolinit.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/comedi_fops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 3e82ab9..dc3588a 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -58,7 +58,7 @@ MODULE_PARM_DESC(comedi_debug,
 		);
 #endif
 
-bool comedi_autoconfig = 1;
+bool comedi_autoconfig = true;
 module_param(comedi_autoconfig, bool, S_IRUGO);
 MODULE_PARM_DESC(comedi_autoconfig,
 		 "enable drivers to auto-configure comedi devices (default 1)");
@@ -2437,7 +2437,7 @@ static int __init comedi_init(void)
 	 * comedi_num_legacy_minors are zero, so we might as well adjust the
 	 * defaults in that case
 	 */
-	if (comedi_autoconfig == 0 && comedi_num_legacy_minors == 0)
+	if (!comedi_autoconfig && comedi_num_legacy_minors == 0)
 		comedi_num_legacy_minors = 16;
 
 	memset(comedi_file_info_table, 0,
-- 
1.7.8.6

