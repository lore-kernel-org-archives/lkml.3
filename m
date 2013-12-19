Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3LSIdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:33:17 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58355 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3LSIdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:33:15 -0500
Date: Thu, 19 Dec 2013 14:03:07 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        linux-pcmcia@lists.infradead.org, josh@joshtriplett.org
Subject: [PATCH 1/3] drivers: pcmcia: Include appropriate header file in
 cistpl.c
Message-ID: <7fc39fa8a73bfcca6f379c6cd53cdb1659fc9d12.1387387468.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file include/pcmcia/ds.h in cistpl.c because
function pcmcia_parse_tuple() has its prototype declaration in
include/pcmcia/ds.h.

This eliminates the following warning in cistpl.c:
drivers/pcmcia/cistpl.c:1288:5: warning: no previous prototype for ‘pcmcia_parse_tuple’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/pcmcia/cistpl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 884a984..5448c21 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -30,6 +30,7 @@
 #include <pcmcia/ss.h>
 #include <pcmcia/cisreg.h>
 #include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
 #include "cs_internal.h"
 
 static const u_char mantissa[] = {
-- 
1.7.9.5

