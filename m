Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162600AbaDCIcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:32:21 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52691 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162498AbaDCIcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:32:19 -0400
Message-ID: <1396513937.31985.14.camel@x220>
Subject: [PATCH] staging: fpgaboot: clean up Makefile
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Insop Song <Insop.Song@gainspeed.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2014 10:32:17 +0200
In-Reply-To: <7731bd53be4b49e2924a7002f74dc090@BY2PR07MB011.namprd07.prod.outlook.com>
References: <20140401184817.GA21855@kroah.com>
	 <1396427043.18431.20.camel@x220> <20140402200428.GE26966@kroah.com>
	 <7731bd53be4b49e2924a7002f74dc090@BY2PR07MB011.namprd07.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2014 08:32:17.0764 (UTC) FILETIME=[39165240:01CF4F17]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This Makefile tries to set the DEBUG macro but it uses an unknown
Kconfig macro to do so. Since no code appears to even care about the
DEBUG macro this line can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Completely untested.

By the way, do devel@driverdev.osuosl.org and
devel@linuxdriverproject.org deliver to the same list?

 drivers/staging/gs_fpgaboot/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/gs_fpgaboot/Makefile b/drivers/staging/gs_fpgaboot/Makefile
index 34cb606..d2f0211 100644
--- a/drivers/staging/gs_fpgaboot/Makefile
+++ b/drivers/staging/gs_fpgaboot/Makefile
@@ -1,4 +1,2 @@
 gs_fpga-y	+= gs_fpgaboot.o io.o
 obj-$(CONFIG_GS_FPGABOOT)	+= gs_fpga.o
-
-ccflags-$(CONFIG_GS_FPGA_DEBUG)	:= -DDEBUG
-- 
1.9.0

