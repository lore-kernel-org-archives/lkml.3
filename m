Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab3LWVzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:55:51 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40613 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab3LWVz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:55:26 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 23 Dec 2013 13:55:19 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Lisa Nguyen <lisa@xenapiadmin.com>,
        Archana kumari <archanakumari959@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] staging: rts5139: Drop print of build time
Message-ID: <d7f697099a92070d98a43bfe9939c9a321555a82.1387833347.git.josh@joshtriplett.org>
References: <cover.1387833347.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387833347.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already has this information, and individual drivers
shouldn't duplicate that.  This also eliminates the use of __TIME__,
which makes the build non-deterministic.  (And, without __DATE__,
__TIME__ provided little useful information to begin with.)

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/staging/rts5139/rts51x_scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rts5139/rts51x_scsi.c b/drivers/staging/rts5139/rts51x_scsi.c
index a474eed..3a99025 100644
--- a/drivers/staging/rts5139/rts51x_scsi.c
+++ b/drivers/staging/rts5139/rts51x_scsi.c
@@ -1985,7 +1985,6 @@ static int show_info(struct seq_file *m, struct Scsi_Host *host)
 	SPRINTF("       Vendor: Realtek Corp.\n");
 	SPRINTF("      Product: RTS51xx USB Card Reader\n");
 	SPRINTF("      Version: %s\n", DRIVER_VERSION);
-	SPRINTF("        Build: %s\n", __TIME__);
 	return 0;
 }
 
-- 
1.8.5.2

