Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161982AbaKNWGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:06:42 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63432 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161814AbaKNWGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:06:41 -0500
Date: Fri, 14 Nov 2014 14:06:37 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HIS: nokia-modem: fix error handling of irq_of_parse_and_map
Message-ID: <20141114220637.GA33546@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return value of irq_of_parse_and_map() is unsigned int, with 0
indicating failure, so testing for negative result never works.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---

Not tested, found by casual code inspection.

 drivers/hsi/clients/nokia-modem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hsi/clients/nokia-modem.c b/drivers/hsi/clients/nokia-modem.c
index e43c3c9..32cc9af 100644
--- a/drivers/hsi/clients/nokia-modem.c
+++ b/drivers/hsi/clients/nokia-modem.c
@@ -164,9 +164,9 @@ static int nokia_modem_probe(struct device *dev)
 	dev_set_drvdata(dev, modem);
 
 	irq = irq_of_parse_and_map(np, 0);
-	if (irq < 0) {
+	if (!irq) {
 		dev_err(dev, "Invalid rst_ind interrupt (%d)\n", irq);
-		return irq;
+		return -EINVAL;
 	}
 	modem->nokia_modem_rst_ind_irq = irq;
 	pflags = irq_get_trigger_type(irq);
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
