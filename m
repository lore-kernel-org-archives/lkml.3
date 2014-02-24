Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaBXQuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:50:11 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52022 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaBXQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:50:09 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Fix line length exceeding 80 characters
Date: Mon, 24 Feb 2014 22:19:42 +0530
Message-Id: <1393260582-10234-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index ac1edd9..7da8566 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1481,7 +1481,8 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 	async->cmd.data = NULL;
 	/* load channel/gain list */
 	async->cmd.chanlist = memdup_user(user_chanlist,
-					  async->cmd.chanlist_len * sizeof(int));
+					  async->cmd.chanlist_len
+					  * sizeof(int));
 	if (IS_ERR(async->cmd.chanlist)) {
 		ret = PTR_ERR(async->cmd.chanlist);
 		async->cmd.chanlist = NULL;
-- 
1.7.9.5

