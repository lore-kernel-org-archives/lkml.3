Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaEWUax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 16:30:53 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:8321 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbaEWUaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 16:30:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhULABOvf1NR87wH/2dsb2JhbABbgwerCQQBAQEBAQEFAYM7lwKBCBd0gmY/GIECJBOIRQHYSIVViH2ERwEDjz6KMwGTJ4M6Ow
Date: Fri, 23 May 2014 22:30:50 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH V2 2/2] lib/devres.c: fix checkpatch warnings
Message-Id: <20140523223050.59937c3d2496e3f83b98f9d2@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 3 checkpatch warnings:
'ERROR: "foo * const * bar" should be "foo * const *bar"'

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/devres.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/devres.c b/lib/devres.c
index c7596bb..f562bf6 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -194,7 +194,7 @@ static int devm_ioport_map_match(struct device *dev, void *res,
  * Managed ioport_map().  Map is automatically unmapped on driver
  * detach.
  */
-void __iomem * devm_ioport_map(struct device *dev, unsigned long port,
+void __iomem *devm_ioport_map(struct device *dev, unsigned long port,
 			       unsigned int nr)
 {
 	void __iomem **ptr, *addr;
@@ -265,7 +265,7 @@ static void pcim_iomap_release(struct device *gendev, void *res)
  * be safely called without context and guaranteed to succed once
  * allocated.
  */
-void __iomem * const * pcim_iomap_table(struct pci_dev *pdev)
+void __iomem * const *pcim_iomap_table(struct pci_dev *pdev)
 {
 	struct pcim_iomap_devres *dr, *new_dr;
 
@@ -290,7 +290,7 @@ EXPORT_SYMBOL(pcim_iomap_table);
  * Managed pci_iomap().  Map is automatically unmapped on driver
  * detach.
  */
-void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
+void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
 {
 	void __iomem **tbl;
 
-- 
1.9.1
