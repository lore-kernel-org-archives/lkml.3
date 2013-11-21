Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3KUUBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:01:06 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58187 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3KUUBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:01:03 -0500
From: Conrad Gomes <conrad.s.j.gomes@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Gomes <conrad.s.j.gomes@gmail.com>
Subject: [PATCH V2 1/7] Staging: comedi: fix line over 80 character warning in unioxx5.c
Date: Fri, 22 Nov 2013 01:27:52 +0530
Message-Id: <1385063878-10267-2-git-send-email-conrad.s.j.gomes@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
References: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to unioxx5.c that fixes the line over 80 character
warning found by checkpatch.pl by initializing n_subd before the
for loop

Signed-off-by: Conrad Gomes <conrad.s.j.gomes@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 93eec2f..725595f 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -435,9 +435,10 @@ static int unioxx5_attach(struct comedi_device *dev,
 
 	dev->iobase = iobase;
 	iobase += UNIOXX5_SUBDEV_BASE;
+	n_subd = 0;
 
 	/* defining number of subdevices and getting they types (it must be 'g01')  */
-	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
+	for (i = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
 		id = inb(ba + 0xE);
 		num = inb(ba + 0xF);
 
-- 
1.7.9.5

