Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaJROdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 10:33:00 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:54270 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaJROc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 10:32:57 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@yahoo.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: comedi: drivers: comedi_bond.c:  Changed from using strncat to strlcat
Date: Sat, 18 Oct 2014 16:35:08 +0200
Message-Id: <1413642908-3633-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed from using strncat to strlcat to simplify the code

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/comedi_bond.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 8450c99..85b2f4a 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -61,8 +61,7 @@ struct bonded_device {
 };
 
 struct comedi_bond_private {
-# define MAX_BOARD_NAME 256
-	char name[MAX_BOARD_NAME];
+	char name[256];
 	struct bonded_device **devs;
 	unsigned ndevs;
 	unsigned nchans;
@@ -262,12 +261,10 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
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

