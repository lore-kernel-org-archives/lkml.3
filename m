Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbaANBHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:07:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaANA1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 3.10 03/62] gpio-rcar: R-Car GPIO IRQ share interrupt
Date: Mon, 13 Jan 2014 16:26:28 -0800
Message-Id: <20140114002710.563580021@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit c234962b808f289237a40e4ce5fc1c8066d1c9d0 upstream.

R-Car H1 or Gen2 GPIO interrupts are assigned per each GPIO domain,
but, Gen1 E1/M1 GPIO interrupts are shared for all GPIO domain.
gpio-rcar driver needs IRQF_SHARED flags for these.
This patch was tested on Bock-W board

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-rcar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -333,7 +333,7 @@ static int gpio_rcar_probe(struct platfo
 	}
 
 	if (devm_request_irq(&pdev->dev, irq->start,
-			     gpio_rcar_irq_handler, 0, name, p)) {
+			     gpio_rcar_irq_handler, IRQF_SHARED, name, p)) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
 		ret = -ENOENT;
 		goto err1;


