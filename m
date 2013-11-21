Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3KUUBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:01:23 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59034 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3KUUBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:01:20 -0500
From: Conrad Gomes <conrad.s.j.gomes@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Gomes <conrad.s.j.gomes@gmail.com>
Subject: [PATCH V2 4/7] Staging: comedi: change pr_err to dev_err in __unioxx5_analog_read
Date: Fri, 22 Nov 2013 01:27:55 +0530
Message-Id: <1385063878-10267-5-git-send-email-conrad.s.j.gomes@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
References: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch which subsitutes pr_err with dev_err in
__unioxx5_analog_read as it is the preferred way to log in device
drivers

Signed-off-by: Conrad Gomes <conrad.s.j.gomes@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 31736ed..7edbd5e 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -175,7 +175,7 @@ static int __unioxx5_analog_read(struct comedi_subdevice *s,
 
 	/* defining if given module can work on input */
 	if (usp->usp_module_type[module_no] & MODULE_OUTPUT_MASK) {
-		pr_err("comedi%d: module in position %d with id 0x%02x is for output only",
+		dev_err(csdev, "comedi%d: module in position %d with id 0x%02x is for output only",
 		       minor, module_no, usp->usp_module_type[module_no]);
 		return 0;
 	}
-- 
1.7.9.5

