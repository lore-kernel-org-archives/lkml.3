Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaJFPjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:39:01 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:18814 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752999AbaJFPgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:36:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvENAEC2MlRXQzrG/2dsb2JhbABfgw6BK7gQAQUBc5pnAoEDFwF7hAQBBVYjEFE5HhmIQgGyW443GIYgiiUHFoQ1BZ0+jFKJLoNlOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org
Subject: [PATCH 2/7 linux-next] ppc4xx_edac: remove deprecated IRQF_DISABLED
Date: Mon,  6 Oct 2014 17:35:49 +0200
Message-Id: <1412609755-28627-3-git-send-email-fabf@skynet.be>
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
 drivers/edac/ppc4xx_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 0f04d5e..4159353 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1120,7 +1120,7 @@ static int ppc4xx_edac_register_irq(struct platform_device *op,
 
 	status = request_irq(ded_irq,
 			     ppc4xx_edac_isr,
-			     IRQF_DISABLED,
+			     0,
 			     "[EDAC] MC ECCDED",
 			     mci);
 
@@ -1134,7 +1134,7 @@ static int ppc4xx_edac_register_irq(struct platform_device *op,
 
 	status = request_irq(sec_irq,
 			     ppc4xx_edac_isr,
-			     IRQF_DISABLED,
+			     0,
 			     "[EDAC] MC ECCSEC",
 			     mci);
 
-- 
1.9.3

