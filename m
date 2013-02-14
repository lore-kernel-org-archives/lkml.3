Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030244Ab3BNVcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:32:03 -0500
Received: from mout.gmx.net ([212.227.17.21]:61178 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab3BNVcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:32:00 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/UTDAZhYTUbGsSKofDvUlS3CwYHPAAQyvOQzpBKX
	UI8WITLYzhqgJ3
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Bill Pemberton <wfp5p@virginia.edu>, Peter Huewe <peterhuewe@gmx.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/comedi: Fix if(); by adding proper code
Date: Thu, 14 Feb 2013 22:36:24 +0100
Message-Id: <1360877784-12144-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch warns about:
staging/comedi/drivers/cb_pcidas64.c:3304 prep_ao_dma() warn: if();

So the check currently does nothing and could be removed, but the better
alternative is to activate the check again and return -1; if it
evaluates to true.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index d33fc32..782498f 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -3301,7 +3301,8 @@ static int prep_ao_dma(struct comedi_device *dev, const struct comedi_cmd *cmd)
 	num_bytes = load_ao_dma_buffer(dev, cmd);
 	if (num_bytes == 0)
 		return -1;
-	if (num_bytes >= DMA_BUFFER_SIZE) ;
+	if (num_bytes >= DMA_BUFFER_SIZE)
+		return -1;
 	load_ao_dma(dev, cmd);
 
 	dma_start_sync(dev, 0);
-- 
1.7.8.6

