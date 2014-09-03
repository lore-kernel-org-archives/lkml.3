Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbaICMun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:50:43 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44690 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713AbaICMqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:23 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/37] staging: comedi: adl_pci9118: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:48 +0100
Message-Id: <1409748360-17063-26-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of the `TRIG_ROUND_...` macros with the new names
`CMDF_ROUND_...`.  The numeric values are unchanged.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/adl_pci9118.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 3e16b5f..b71b0cf 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -761,7 +761,7 @@ static void pci9118_calc_divisors(char mode, struct comedi_device *dev,
 			*tim2 = this_board->ai_ns_min;
 		i8253_cascade_ns_to_timer(I8254_OSC_BASE_4MHZ,
 					  div1, div2,
-					  tim2, flags & TRIG_ROUND_NEAREST);
+					  tim2, flags & CMDF_ROUND_NEAREST);
 		break;
 	case 2:
 		if (*tim2 < this_board->ai_ns_min)
-- 
2.1.0

