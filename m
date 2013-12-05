Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab3LEL4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:56:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59988 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab3LEL4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:56:11 -0500
Date: Thu, 5 Dec 2013 12:56:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Sebastian Reichel <sre@debian.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: [patch] fix n900 bt error handling
Message-ID: <20131205115608.GA9498@amd.pavel.ucw.cz>
References: <20131127125149.GA9389@amd.pavel.ucw.cz>
 <201312021613.19521@pali>
 <20131204122204.GA10262@amd.pavel.ucw.cz>
 <201312041732.05400@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312041732.05400@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I think that we can drop "new" version, because it has several
> problems and "old" version is working. So now it not make sense
> to use hack or develop "new" version anymore.

Ok... but this seems still needed. Please apply,
							Pavel

commit 6c65774280a7095dce8b1e995d86b2e079ef5fdb
Author: Pavel <pavel@ucw.cz>
Date:   Thu Dec 5 12:54:31 2013 +0100

Cleanups should be performed even if firmware load fails.
   
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/bluetooth/hci_h4p/core.c b/drivers/bluetooth/hci_h4p/core.c
index ead25c4..e76e889 100644
--- a/drivers/bluetooth/hci_h4p/core.c
+++ b/drivers/bluetooth/hci_h4p/core.c
@@ -942,7 +942,7 @@ again:
 	err = hci_h4p_read_fw(info, &fw_queue);
 	if (err < 0) {
 		dev_err(info->dev, "Cannot read firmware\n");
-		return err;
+		goto err_clean;
 	}
 
 	err = hci_h4p_send_fw(info, &fw_queue);



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
