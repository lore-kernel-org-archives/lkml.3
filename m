Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3FGH16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:27:58 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52486 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3FGH15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:27:57 -0400
From: Daniel Hamacher <danielhamacher.dh@gmail.com>
To: greg@kroah.com
Cc: abotti@mev.co.uk, fmhess@users.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Daniel Hamacher <danielhamacher.dh@gmail.com>
Subject: [PATCH] staging: comedi: proc.c Fixed warning and brace code style issue [kernel: linux-next:	next-20130607]
Date: Fri,  7 Jun 2013 01:27:03 -0600
Message-Id: <1370590023-5647-1-git-send-email-danielhamacher.dh@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch provided a warning on line 38. It recommended seq_puts instead of seq_printf.
Since the return value of printf is ignored, I decided to switch to the seq_puts
function since it is just regular character output.
source:: http://lwn.net/Articles/22355/

I also added braces on a for loop, since loops should be in braces.
source:: Documentation/CodingStyle

Signed-off-by: Daniel Hamcher <danielhamacher.dh@gmail.com>
---
 drivers/staging/comedi/proc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/proc.c b/drivers/staging/comedi/proc.c
index 8ee9442..5cf19b3 100644
--- a/drivers/staging/comedi/proc.c
+++ b/drivers/staging/comedi/proc.c
@@ -34,11 +34,11 @@ static int comedi_read(struct seq_file *m, void *v)
 	int devices_q = 0;
 	struct comedi_driver *driv;
 
-	seq_printf(m,
-		     "comedi version " COMEDI_RELEASE "\n"
-		     "format string: %s\n",
-		     "\"%2d: %-20s %-20s %4d\", i, "
-		     "driver_name, board_name, n_subdevices");
+	seq_puts(m,
+		"comedi version " COMEDI_RELEASE "\n"
+		"format string: %s\n",
+		"\"%2d: %-20s %-20s %4d\", i, "
+		"driver_name, board_name, n_subdevices");
 
 	for (i = 0; i < COMEDI_NUM_BOARD_MINORS; i++) {
 		struct comedi_device *dev = comedi_dev_from_minor(i);
@@ -57,10 +57,11 @@ static int comedi_read(struct seq_file *m, void *v)
 
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		seq_printf(m, "%s:\n", driv->driver_name);
-		for (i = 0; i < driv->num_names; i++)
+		for (i = 0; i < driv->num_names; i++) {
 			seq_printf(m, " %s\n",
 				   *(char **)((char *)driv->board_name +
 					      i * driv->offset));
+		}
 
 		if (!driv->num_names)
 			seq_printf(m, " %s\n", driv->driver_name);
-- 
1.7.11.7

