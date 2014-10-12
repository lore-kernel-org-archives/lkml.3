Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaJLMVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 08:21:21 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:55924 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaJLMVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 08:21:17 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@yahoo.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: comedi_bond.c:  Changed from using strncat to strlcat
Date: Sun, 12 Oct 2014 14:23:24 +0200
Message-Id: <1413116604-18554-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed from using strncat to strlcat to simplify the code

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/comedi_bond.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 8450c99..5d19861 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -262,12 +262,10 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
 			{
 				/* Append dev:subdev to devpriv->name */
 				char buf[20];
-				int left =
-				    MAX_BOARD_NAME - strlen(devpriv->name) - 1;
 				snprintf(buf, sizeof(buf), "%u:%u ",
 					 bdev->minor, bdev->subdev);
-				buf[sizeof(buf) - 1] = 0;
-				strncat(devpriv->name, buf, left);
+				strlcat(devpriv->name, buf,
+					sizeof(devpriv->name));
 			}
 
 		}
-- 
1.7.10.4

