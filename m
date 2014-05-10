Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbaEJKrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:47:21 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:39809 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbaEJKrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:47:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUWAAQDblNXQCSg/2dsb2JhbABZgwaDPakXCgUBmhUCAoEXF3SCUxMcIxiBAiQTiEUB0U2FVoh8hEcBA48liiIBkweBd4FBOzA
Date: Sat, 10 May 2014 12:47:15 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 1/1 RESEND] drivers/pnp/resource.c: remove positive test on
 unsigned values
Message-Id: <20140510124715.e3b574aae4c8dafb0c9aefdd@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq and dma are both resource_size_t (derived from phys_addr_t <-> unsigned)

Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/pnp/resource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 01712cb..782e822 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -360,7 +360,7 @@ int pnp_check_irq(struct pnp_dev *dev, struct resource *res)
 		return 1;
 
 	/* check if the resource is valid */
-	if (*irq < 0 || *irq > 15)
+	if (*irq > 15)
 		return 0;
 
 	/* check if the resource is reserved */
@@ -424,7 +424,7 @@ int pnp_check_dma(struct pnp_dev *dev, struct resource *res)
 		return 1;
 
 	/* check if the resource is valid */
-	if (*dma < 0 || *dma == 4 || *dma > 7)
+	if (*dma == 4 || *dma > 7)
 		return 0;
 
 	/* check if the resource is reserved */
-- 
1.8.4.5

