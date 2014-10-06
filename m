Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaJFTTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:19:09 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:57049 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaJFTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:19:05 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 2/4] ipmi/of: Don't use unavailable interfaces
Date: Mon,  6 Oct 2014 14:17:51 -0500
Message-Id: <1412623073-6166-3-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1412623073-6166-1-git-send-email-minyard@acm.org>
References: <1412623073-6166-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

If an IPMI controller is used by the firmware and as such marked with
a reserved status, we shouldn't use it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 5d66568..4fc8931 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2658,6 +2658,9 @@ static int ipmi_probe(struct platform_device *dev)
 	if (!match)
 		return -EINVAL;
 
+	if (!of_device_is_available(np))
+		return -EINVAL;
+
 	ret = of_address_to_resource(np, 0, &resource);
 	if (ret) {
 		dev_warn(&dev->dev, PFX "invalid address from OF\n");
-- 
1.8.3.1

