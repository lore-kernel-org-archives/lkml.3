Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab3B0AmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:42:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091Ab3BZX6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 140/150] dma: sh: Dont use ENODEV for failing slave lookup
Date: Tue, 26 Feb 2013 15:56:37 -0800
Message-Id: <20130226235538.966994059@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 7c1119bdd650fa58dad8157bc75c5fcf6ed97843 upstream.

If dmaengine driver's .device_alloc_chan_resources() method returns -ENODEV,
dma_request_channel() will decide, that the driver has been removed and will
remove the device from its list. To prevent this use ENXIO if a slave lookup
fails.

Reported-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/sh/shdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -326,7 +326,7 @@ static int sh_dmae_set_slave(struct shdm
 						    shdma_chan);
 	const struct sh_dmae_slave_config *cfg = dmae_find_slave(sh_chan, slave_id);
 	if (!cfg)
-		return -ENODEV;
+		return -ENXIO;
 
 	if (!try)
 		sh_chan->config = cfg;


