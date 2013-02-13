Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab3BMD0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:26:35 -0500
Received: from mout.gmx.net ([212.227.17.21]:51583 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab3BMD0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:26:34 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX183Db4l5x43tQ51eWFO+b5Istv0vh8SuVzJG9lfz7
	ltk7sf75MjseA5
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/comedi: Fix undefined array subscript
Date: Wed, 13 Feb 2013 04:30:54 +0100
Message-Id: <1360726254-7895-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In vmk80xx_do_insn_bits the local variable reg, which is used as an
index to the tx_buf array, can be used uninitialized if
- data[0] == 0
and
- devpriv->model != VMK8061_MODEL
-> we get into the else branch without having reg initialized.

Since the driver usually differentiates between VMK8061_MODEL and
VMK8055_MODEL it's safe to assume that VMK8055_DO_REG was meant as an
initial value.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/vmk80xx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index ebf2d48..4ced56a 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -716,6 +716,7 @@ static int vmk80xx_do_insn_bits(struct comedi_device *dev,
 			retval = 2;
 		}
 	} else {
+		reg = VMK8055_DO_REG;
 		data[1] = tx_buf[reg];
 		retval = 2;
 	}
-- 
1.7.8.6

