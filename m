Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaKNG6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 01:58:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:49685 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbaKNG6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 01:58:31 -0500
Message-ID: <1415948303.666.50.camel@kernel.crashing.org>
Subject: [PATCH] of/address: Don't throw errors on absent ranges properties
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 14 Nov 2014 17:58:23 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core always tries to translate any "reg" property to construct the platform
device names. This results in a pile of "OF: no ranges; cannot translate" errors
in dmesg whenever we expose things like i2c devices that cannot directly translate
to the MMIO space.

Turn this into a pr_debug instead

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

diff --git a/drivers/of/address.c b/drivers/of/address.c
index f0541fd..bf1f79d 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -444,7 +444,7 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
 	 */
 	ranges = of_get_property(parent, rprop, &rlen);
 	if (ranges == NULL && !of_empty_ranges_quirk()) {
-		pr_err("OF: no ranges; cannot translate\n");
+		pr_debug("OF: no ranges; cannot translate\n");
 		return 1;
 	}
 	if (ranges == NULL || rlen == 0) {


