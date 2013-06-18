Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab3FRUgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:36:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59759 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab3FRUgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:36:00 -0400
Date: Tue, 18 Jun 2013 22:35:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: gregkh@linuxfoundation.org, kernel list <linux-kernel@vger.kernel.org>
Subject: [uio 2/2] allow binding uio_pdrv_genirq.c to devices using command
 line option
Message-ID: <20130618203558.GB18503@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds ability to bind uio driver to given open firmware device
using command line option. Thus, userspace driver can be developed and
used without modifying the kernel.

Signed-off-by: Pavel Machek <pavel@denx.de>
Tested-by: Detlev Zundel <dzu@denx.de>

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index d594dd9..9741549 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -258,10 +258,14 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
 };
 
 #ifdef CONFIG_OF
-static const struct of_device_id uio_of_genirq_match[] = {
-	{ /* empty for now */ },
+static struct of_device_id uio_of_genirq_match[] = {
+	{ /* This is filled with module_parm */ },
+	{ /* Sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
+
+module_param_string(of_id, uio_of_genirq_match[0].compatible, 128, 0);
+MODULE_PARM_DESC(of_id, "Openfirmware id of the device to be handled by uio");
 #else
 # define uio_of_genirq_match NULL
 #endif


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

