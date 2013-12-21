Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3LUKY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:24:56 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51409 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3LUKYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:24:54 -0500
Date: Sat, 21 Dec 2013 15:52:38 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        josh@joshtriplett.org
Subject: [PATCH] drivers: dgnc: Include appropriate header file in
 dgnc_trace.c
Message-ID: <20131221102238.GA3197@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file dgnc/dgnc_trace.h in dgnc_trace.c
because function dgnc_tracer_free() has its prototype declaration in the
header file.

This eliminates the following warning in dgnc_trace.c:
drivers/staging/dgnc/dgnc_trace.c:180:6: warning: no previous prototype for ‘dgnc_tracer_free’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/staging/dgnc/dgnc_trace.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/dgnc/dgnc_trace.c b/drivers/staging/dgnc/dgnc_trace.c
index a98b7d4..e2164e4 100644
--- a/drivers/staging/dgnc/dgnc_trace.c
+++ b/drivers/staging/dgnc/dgnc_trace.c
@@ -35,6 +35,7 @@
 #include <linux/vmalloc.h>
 
 #include "dgnc_driver.h"
+#include "dgnc_trace.h"
 
 #define TRC_TO_CONSOLE 1
 
-- 
1.7.9.5

