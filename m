Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaEVRej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:34:39 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:23331 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbaEVReh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:34:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQLANwzflNbsFZY/2dsb2JhbABZgwerCQoFAYM6lwGBDRd0gmYcIxiBAiQTiEUB1wCFVYh5hEcBA48/ijEBixeID4M6Ow
Date: Thu, 22 May 2014 19:34:34 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/1] lib/devres.c: use dev in devm_request_and_ioremap
Message-Id: <20140522193434.ee7b034dc707d249f0b30c2b@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_request_and_ioremap was the only function to use device
instead of dev(this fixes kernel-doc warning).

Also fix some checkpatch warnings.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/devres.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/devres.c b/lib/devres.c
index 2f16c13..7ad789b 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -157,12 +157,11 @@ EXPORT_SYMBOL(devm_ioremap_resource);
  *	if (!base)
  *		return -EADDRNOTAVAIL;
  */
-void __iomem *devm_request_and_ioremap(struct device *device,
-				       struct resource *res)
+void __iomem *devm_request_and_ioremap(struct device *dev, struct resource *res)
 {
 	void __iomem *dest_ptr;
 
-	dest_ptr = devm_ioremap_resource(device, res);
+	dest_ptr = devm_ioremap_resource(dev, res);
 	if (IS_ERR(dest_ptr))
 		return NULL;
 
@@ -194,7 +193,7 @@ static int devm_ioport_map_match(struct device *dev, void *res,
  * Managed ioport_map().  Map is automatically unmapped on driver
  * detach.
  */
-void __iomem * devm_ioport_map(struct device *dev, unsigned long port,
+void __iomem *devm_ioport_map(struct device *dev, unsigned long port,
 			       unsigned int nr)
 {
 	void __iomem **ptr, *addr;
@@ -265,7 +264,7 @@ static void pcim_iomap_release(struct device *gendev, void *res)
  * be safely called without context and guaranteed to succed once
  * allocated.
  */
-void __iomem * const * pcim_iomap_table(struct pci_dev *pdev)
+void __iomem * const *pcim_iomap_table(struct pci_dev *pdev)
 {
 	struct pcim_iomap_devres *dr, *new_dr;
 
@@ -290,7 +289,7 @@ EXPORT_SYMBOL(pcim_iomap_table);
  * Managed pci_iomap().  Map is automatically unmapped on driver
  * detach.
  */
-void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
+void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
 {
 	void __iomem **tbl;
 
-- 
1.8.4.5
