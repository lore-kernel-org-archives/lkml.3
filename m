Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaBSHia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:38:30 -0500
Received: from nm2-vm5.bullet.mail.gq1.yahoo.com ([98.136.218.132]:46388 "EHLO
	nm2-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbaBSHi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:38:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=U3vVGsJh4WHq5HwQ5clCLHasYQbMEW6pZognmPTJ5oAOHN/Re2KjCe6wDCmHz2GQWOfVeRQEoG5LvwZ1cLGZVUENW/roWNbfTbFIrOgFbl+4lupSBi2hnk84y5Vi86/sO//+mddMySXivX0fOEc8rzxYjcidJeyNWsgqyQM5nOQ=;
X-Yahoo-Newman-Id: 20269.80474.bm@smtp205.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2eV8J.QVM1kPo9G7Fg2UEcKoaO.YH4t5tiKDVnELCMVeXov
 0HUzWBgOk0CjzHrndjorrGhKXOClevVN9ucjYvdT3s8FcwPQm8NXk6U1_Hh4
 trV7uSLycrUfOavPyiaxDN.7jAj5WjekzidilHt6qDQaChOCBF61XKwMoyeP
 RGqbFneP6_WnfF7zuQ8qWaNwF0LGPtx3yeYNirKIAbNy3Za7_XeRlPtAbb33
 HeTANLFm3652I2aisvr04B43NFUVYXvLWCbkEJZnnpazpgeooQKUo8XbpiA_
 aAcWXARiLhZ2Tip4WkmS9_Bn99YO85y7bgrp3OwdQgkXSY.iVsRCZlTcUALB
 TvrSidxR0fj9jbu79YbRQfyi.uIc0QlR5IsU_XHtREcBNo2zIo5G3kgyLESl
 jq9y6bFgCAJM24EKXnjFZx.0U.cwuup88NV2qKZ4mwfLq8QdnX_Isn3r0Wdi
 T8natZnLw2iG4GZ2vBFfRcB1MzjrVHA7XcNYeS5N.sOMvDD6ogee_CLNcVmn
 Vchlv6qrXKBV_C7f.i6yTYQ1SJEVIXn7zDvom
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp205.mail.gq1.yahoo.com with SMTP; 18 Feb 2014 23:38:13 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 4/4] Staging: comedi: addi-data: don't initialize a static variable to 0
Date: Wed, 19 Feb 2014 01:38:10 -0600
Message-Id: <1392795490-8758-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
References: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hwdrv_apci1564.c, one static variable is zero initialized.  This is
unneeded and redundant, so we remove the initialization.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 21dd028..2b47fa1 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -100,7 +100,7 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_TCW_WARN_TIMEBASE			28
 
 /* Global variables */
-static unsigned int ui_InterruptStatus_1564 = 0;
+static unsigned int ui_InterruptStatus_1564;
 static unsigned int ui_InterruptData, ui_Type;
 
 /*
-- 
1.8.5.3

