Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaBPIli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 03:41:38 -0500
Received: from nm48-vm2.bullet.mail.gq1.yahoo.com ([67.195.87.190]:44978 "EHLO
	nm48-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbaBPIlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 03:41:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=UVhZKxolizbL0RKI6gs2BTul+oE/8cgM7uwpui5qSL2PzO85Gh3ZvZbX6moD9VN0DYm47Iio6edgzqDTf0ifv04m42smQ0wSJicA8QVE/D9G3fwFrtQSfFmy5c1HpBIAssihaMxAS9eo0DYxwzgenN2nrPgXqgXkjeXNTiFrerA=;
X-Yahoo-Newman-Id: 896686.5025.bm@smtp230.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: R4CW7TMVM1mS_ERPetI32GfuT2ogAuTyxnSyi9AGv7H3_av
 hS65JbZ1YL0vG8NVYB2kvfoZxkfUluU4TQeeP6Nlw9cfzqQI4NYUX6KgQ8Cr
 0cS6fV81utpBz1F7y7ATj4qPb_pAdsuYt9buSI1j6qrNWrrX2spaK2rfoE3n
 EKTD4AGFr2CIqjSKNJMYtkyOkgO.242HfZAhXxIeuKG_D.a0jQZaUBHFj8Ro
 9ClxVqUId8z46A2J7LZ0Z0Crnw4PRDN4KBLvOMSqsr9iVW3v9drFHAzWmTKO
 ivqcGjDOxwYve653A_cUeLsglLxsPCPKi2kzXHZm9AhVdNLzl.I4jq1Vqzsv
 h2fOQ0N5ew38.Zy3sAC.kF3ZNw9HsNZJOe.vNG8XkXUlXKo.nAxM48PjK8B_
 KI2qPjnD.RyaHQ51lzf3zQAuPbQHmtDjF4.yn.JYsJq9EtntcdUpKtc4chM4
 .MyxwBHqhNxbX8xb0y68.Z5I7HDg6Ijcm6cpCxzJPuaTqSAHSpkoszn4MzKA
 dyVewlDlgxUCGv.yH0TX3Hv1DA1fRN0EbrzWt
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp230.mail.gq1.yahoo.com with SMTP; 16 Feb 2014 08:41:35 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 4/4] Staging: comedi: addi-data: do not initialize statics to 0 in hwdrv_apci035.c
Date: Sun, 16 Feb 2014 02:41:32 -0600
Message-Id: <1392540092-26109-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com>
References: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for hwdrv_apci035.c removes a zero initialization from two
static variables.  Static variables are initialized to zero by default,
so doing so explicitly is not necessary.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
I purposely made this patch the last in the series, because while it is
technically true that static variables need not be initialized to zero,
and checkpatch doesn't much like the practice, I didn't know if, for
readability's sake, you wanted these to stay in as-is. Since this is the
last patch, feel free to drop it if you don't like it.

 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index f02b714..10e02e5 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -106,8 +106,8 @@ static struct comedi_lrange range_apci035_ai = {
 	}
 };
 
-static int i_WatchdogNbr = 0;
-static int i_Temp = 0;
+static int i_WatchdogNbr;
+static int i_Temp;
 static int i_Flag = 1;
 /*
 +----------------------------------------------------------------------------+
-- 
1.8.5.3

