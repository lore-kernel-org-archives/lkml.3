Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422641Ab3AXVPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:15:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:40288 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756955Ab3AXVOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 30/46] usb: musb: cppi_dma: drop __init annotation
Date: Thu, 24 Jan 2013 13:13:08 -0800
Message-Id: <20130124211147.236383876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 091a62c9b3d899d99dbf4e3dbebc8dfa3edbccdd upstream.

This patch fixes the following:

WARNING: vmlinux.o(.text+0x1e709c): Section mismatch in reference from the funct
ion dma_controller_create() to the function .init.text:cppi_controller_start()
The function dma_controller_create() references
the function __init cppi_controller_start().
This is often because dma_controller_create lacks a __init
annotation or the annotation of cppi_controller_start is wrong.

This warning is there due to the deficiency in the commit 07a67bbb (usb: musb:
Make dma_controller_create __devinit).

Since the start() method is only called from musb_init_controller() which is
not annotated, drop '__init' annotation from cppi_controller_start() and also
cppi_pool_init() since it gets called from that function, to avoid another
section mismatch warning...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/cppi_dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -105,7 +105,7 @@ static void cppi_reset_tx(struct cppi_tx
 	musb_writel(&tx->tx_complete, 0, ptr);
 }
 
-static void __init cppi_pool_init(struct cppi *cppi, struct cppi_channel *c)
+static void cppi_pool_init(struct cppi *cppi, struct cppi_channel *c)
 {
 	int	j;
 
@@ -150,7 +150,7 @@ static void cppi_pool_free(struct cppi_c
 	c->last_processed = NULL;
 }
 
-static int __init cppi_controller_start(struct dma_controller *c)
+static int cppi_controller_start(struct dma_controller *c)
 {
 	struct cppi	*controller;
 	void __iomem	*tibase;


