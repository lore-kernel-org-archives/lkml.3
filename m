Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaJFPgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:36:50 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:18845 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbaJFPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:36:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvENAEC2MlRXQzrG/2dsb2JhbABfgw6BK7gQAQUBc5pnAoEDFwF7hAQBBScvIxBROR4ZiEIBsluONxiGIIolBxaENQWdPoxSiS6DZTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 5/7 linux-next] HSI: remove deprecated IRQF_DISABLED
Date: Mon,  6 Oct 2014 17:35:52 +0200
Message-Id: <1412609755-28627-6-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412609755-28627-1-git-send-email-fabf@skynet.be>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See include/linux/interrupt.h:
"This flag is a NOOP and scheduled to be removed"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/hsi/clients/nokia-modem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hsi/clients/nokia-modem.c b/drivers/hsi/clients/nokia-modem.c
index 363b780..67156c6 100644
--- a/drivers/hsi/clients/nokia-modem.c
+++ b/drivers/hsi/clients/nokia-modem.c
@@ -173,8 +173,8 @@ static int nokia_modem_probe(struct device *dev)
 
 	tasklet_init(&modem->nokia_modem_rst_ind_tasklet,
 			do_nokia_modem_rst_ind_tasklet, (unsigned long)modem);
-	err = devm_request_irq(dev, irq, nokia_modem_rst_ind_isr,
-				IRQF_DISABLED | pflags, "modem_rst_ind", modem);
+	err = devm_request_irq(dev, irq, nokia_modem_rst_ind_isr, pflags,
+			       "modem_rst_ind", modem);
 	if (err < 0) {
 		dev_err(dev, "Request rst_ind irq(%d) failed (flags %d)\n",
 								irq, pflags);
-- 
1.9.3

