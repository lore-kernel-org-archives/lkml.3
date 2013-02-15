Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab3BOMKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:10:06 -0500
Received: from mout.gmx.net ([212.227.15.18]:63632 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab3BOMKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:10:04 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+mpAJqDBmmACV4XfKPZomreF8tszbUk3rxleMBa3
	qrj5CAlbnOE081
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Bill Pemberton <wfp5p@virginia.edu>, Peter Huewe <peterhuewe@gmx.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging/comedi: Remove if(); statement without effect
Date: Fri, 15 Feb 2013 13:14:26 +0100
Message-Id: <1360930466-3521-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <511E05F3.2020505@mev.co.uk>
References: <511E05F3.2020505@mev.co.uk>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch warns about:
staging/comedi/drivers/cb_pcidas64.c:3304 prep_ao_dma() warn: if();

So the check currently does nothing and can be removed, as indicated by
Ian.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
v1 was staging/comedi: Fix if(); by adding proper code
which was unfortunately wrong.

 drivers/staging/comedi/drivers/cb_pcidas64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index d33fc32..9f3112c 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -3301,7 +3301,6 @@ static int prep_ao_dma(struct comedi_device *dev, const struct comedi_cmd *cmd)
 	num_bytes = load_ao_dma_buffer(dev, cmd);
 	if (num_bytes == 0)
 		return -1;
-	if (num_bytes >= DMA_BUFFER_SIZE) ;
 	load_ao_dma(dev, cmd);
 
 	dma_start_sync(dev, 0);
-- 
1.7.8.6

