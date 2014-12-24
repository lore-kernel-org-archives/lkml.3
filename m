Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaLXNla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 08:41:30 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:1518 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641AbaLXNl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 08:41:28 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsSAIjBmlRXQ7BL/2dsb2JhbABbgwaBKrQTBQEBAQEBAQUBd5crBAKBEhcBAQEBAX2EaSOBGjeIMAG8Go9+hgCJDmQdhBMFlwiJZ4dpIoFFAYIpPTGBA4FAAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org
Subject: [PATCH 1/1 linux-next] pinctrl: use ERR_CAST instead of ERR_PTR/PTR_ERR
Date: Wed, 24 Dec 2014 14:40:49 +0100
Message-Id: <1419428449-22413-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 include/linux/pinctrl/consumer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 18eccef..d7e5d60 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -142,7 +142,7 @@ static inline struct pinctrl * __must_check pinctrl_get_select(
 	s = pinctrl_lookup_state(p, name);
 	if (IS_ERR(s)) {
 		pinctrl_put(p);
-		return ERR_PTR(PTR_ERR(s));
+		return ERR_CAST(s);
 	}
 
 	ret = pinctrl_select_state(p, s);
-- 
1.9.1

