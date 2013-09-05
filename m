Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3IEEBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:01:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab3IEEBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:01:05 -0400
Date: Thu, 5 Sep 2013 00:00:52 -0400
From: Dave Jones <davej@redhat.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tvboxspy@gmail.com
Subject: [PATCH] staging/vt6656: Fix screwed up indentation in
 swGetOFDMControlRate
Message-ID: <20130905040052.GB15824@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, tvboxspy@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The indentation in the swGetOFDMControlRate function is screwed up.
At first it appears that there are missing braces on a multi-line if, but
looking at history, commit dd0a774fc727ee793780197beb3f2cf80bfefa99
("staging: vt6656: card/main_usb/device use new structure names")
incorrectly indented the two lines below.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index dbf11ec..19d3cf4 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -172,8 +172,8 @@ static u16 swGetOFDMControlRate(struct vnt_private *pDevice, u16 wRateIdx)
 	if (!CARDbIsOFDMinBasicRate(pDevice)) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"swGetOFDMControlRate:(NO OFDM) %d\n", wRateIdx);
-	if (wRateIdx > RATE_24M)
-		wRateIdx = RATE_24M;
+		if (wRateIdx > RATE_24M)
+			wRateIdx = RATE_24M;
 		return wRateIdx;
 	}
 
