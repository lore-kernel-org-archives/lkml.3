Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3KALtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:49:50 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:4278 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab3KALtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:49:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kz70kz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>, <nsekhar@ti.com>,
        <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <m.chehab@samsung.com>, <hjk@hansjkoch.de>,
        <gregkh@linuxfoundation.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <rmk+kernel@arm.linux.org.uk>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <dmaengine@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH][RESEND 6/8] ALSA: memalloc: use gen_pool_dma_alloc() to allocate iram buffer
Date: Fri, 1 Nov 2013 19:48:19 +0800
Message-ID: <db9e59951cdcf55b4903c0358ebe220e58155bc1.1383306365.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1383306365.git.b42378@freescale.com>
References: <cover.1383306365.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 sound/core/memalloc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 9d93f02..5e1c7bc 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -184,11 +184,7 @@ static void snd_malloc_dev_iram(struct snd_dma_buffer *dmab, size_t size)
 	/* Assign the pool into private_data field */
 	dmab->private_data = pool;
 
-	dmab->area = (void *)gen_pool_alloc(pool, size);
-	if (!dmab->area)
-		return;
-
-	dmab->addr = gen_pool_virt_to_phys(pool, (unsigned long)dmab->area);
+	dmab->area = gen_pool_dma_alloc(pool, size, &dmab->addr);
 }
 
 /**
-- 
1.8.4


