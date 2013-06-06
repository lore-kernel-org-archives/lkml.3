Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3FFQLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:11:39 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47575 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab3FFQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:11:36 -0400
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Laura Lawniczak <laura.lawniczak@googlemail.com>,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/6] keucr: use more specific max_t(int, ..
Date: Thu,  6 Jun 2013 18:10:46 +0200
Message-Id: <1370535050-7167-3-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
References: <20130605094517.GS28112@mwanda>
 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as advised by checkpatch, changed generic max(..) to max_t(int, ..

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
---
 drivers/staging/keucr/transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index 1a8837d..ab1eccd 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -708,8 +708,8 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		} else {
 			residue = min(residue, transfer_length);
-			scsi_set_resid(srb, max(scsi_get_resid(srb),
-							(int) residue));
+			scsi_set_resid(srb, max_t(int, scsi_get_resid(srb),
+							residue));
 		}
 	}
 
-- 
1.7.10.4

