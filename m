Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaEWU3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 16:29:35 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:42776 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbaEWU3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 16:29:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiYLAHOuf1NR87wH/2dsb2JhbABbgweCRahDBAEBAQEBAQUBgzuXAoEIF3SCZj8YgQIkE4hFAdgwF4VViH2ERwEDjz6KMwGLF4gQgzo7
Date: Fri, 23 May 2014 22:29:32 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH V2 1/2] lib/devres.c: use dev in devm_request_and_ioremap
Message-Id: <20140523222932.5085d9ff9de2e5e9643bda66@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_request_and_ioremap was the only function to use device
instead of dev. This fixes kernel-doc warning.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: break original patch in 2 (suggested by Greg Kroah-Hartman)

 lib/devres.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/devres.c b/lib/devres.c
index 2f16c13..c7596bb 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -157,12 +157,12 @@ EXPORT_SYMBOL(devm_ioremap_resource);
  *	if (!base)
  *		return -EADDRNOTAVAIL;
  */
-void __iomem *devm_request_and_ioremap(struct device *device,
+void __iomem *devm_request_and_ioremap(struct device *dev,
 				       struct resource *res)
 {
 	void __iomem *dest_ptr;
 
-	dest_ptr = devm_ioremap_resource(device, res);
+	dest_ptr = devm_ioremap_resource(dev, res);
 	if (IS_ERR(dest_ptr))
 		return NULL;
 
-- 
1.9.1
