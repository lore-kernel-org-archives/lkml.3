Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaJAUbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:31:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37711 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbaJAUbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:31:05 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: sre@kernel.org
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] HSI: remove deprecated IRQF_DISABLED
Date: Wed,  1 Oct 2014 22:28:55 +0200
Message-Id: <1412195335-9437-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the use of the IRQF_DISABLED flag
from drivers/hsi/clients/nokia-modem.c

It's a NOOP since 2.6.35 and it will be removed soon.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/hsi/clients/nokia-modem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hsi/clients/nokia-modem.c b/drivers/hsi/clients/nokia-modem.c
index 363b780dacea..e43c3c9acec1 100644
--- a/drivers/hsi/clients/nokia-modem.c
+++ b/drivers/hsi/clients/nokia-modem.c
@@ -174,7 +174,7 @@ static int nokia_modem_probe(struct device *dev)
 	tasklet_init(&modem->nokia_modem_rst_ind_tasklet,
 			do_nokia_modem_rst_ind_tasklet, (unsigned long)modem);
 	err = devm_request_irq(dev, irq, nokia_modem_rst_ind_isr,
-				IRQF_DISABLED | pflags, "modem_rst_ind", modem);
+				pflags, "modem_rst_ind", modem);
 	if (err < 0) {
 		dev_err(dev, "Request rst_ind irq(%d) failed (flags %d)\n",
 								irq, pflags);
-- 
1.9.1

