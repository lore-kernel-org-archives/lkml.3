Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3HMQ0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:26:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab3HMQ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:47 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=iyHTnxVFlVAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3M62RQnJyoAA:10 a=zd2uoN0lAAAA:8 a=gu6fZOg2AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=8h4w1IzGaMh34A3xk1MA:9 a=wu_e27o_rKQA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155836.670525358@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yu Liu <liuyu.ac@gmail.com>, Shane Huang <shane.huang@amd.com>,
        Tejun Heo <tj@kernel.org>
Subject: [81/88] ahci: remove pmp link online check in FBS EH
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0081-ahci-remove-pmp-link-online-check-in-FBS-EH.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Shane Huang <shane.huang@amd.com>

[ Upstream commit 912b9ac683b112615d5605686f1dc086402ce9f7 ]

ata_link_online() check in ahci_error_intr() is unnecessary, it should
be removed otherwise may lead to lockup with FBS enabled PMP.
http://marc.info/?l=linux-ide&m=137050421603272&w=2

Reported-by: Yu Liu <liuyu.ac@gmail.com>
Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/ata/libahci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 555c07a..48a946a 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1544,8 +1544,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		u32 fbs = readl(port_mmio + PORT_FBS);
 		int pmp = fbs >> PORT_FBS_DWE_OFFSET;
 
-		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links) &&
-		    ata_link_online(&ap->pmp_link[pmp])) {
+		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links)) {
 			link = &ap->pmp_link[pmp];
 			fbs_need_dec = true;
 		}
-- 
1.7.10.4


