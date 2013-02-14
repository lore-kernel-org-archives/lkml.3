Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761668Ab3BNVWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:22:45 -0500
Received: from mout.gmx.net ([212.227.17.21]:62444 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759032Ab3BNVWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:22:43 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19AJ6FRtO5A2yYp6IbBi9kwx3tUxYxScwtZvuox+j
	xujtE9AL5MwoAb
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Bill Pemberton <wfp5p@virginia.edu>, Peter Huewe <peterhuewe@gmx.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/comedi: Use && instead of & for logical comparision
Date: Thu, 14 Feb 2013 22:27:06 +0100
Message-Id: <1360877226-12014-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse complains that:
drivers/staging/comedi/drivers/adl_pci9118.c:813 pci9118_calc_divisors()
warn: maybe use && instead of &

usessh is used as a boolean flag (0 and 1) and is compared to a boolean
value so we should use && here.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index ef4dbe5..4dbac74 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -810,7 +810,7 @@ static void pci9118_calc_divisors(char mode, struct comedi_device *dev,
 		*tim2 = *div1 * devpriv->i8254_osc_base;
 							/* real convert timer */
 
-		if (usessh & (chnsshfront == 0))	/* use BSSH signal */
+		if (usessh && (chnsshfront == 0))	/* use BSSH signal */
 			if (*div2 < (chans + 2))
 				*div2 = chans + 2;
 
-- 
1.7.8.6

