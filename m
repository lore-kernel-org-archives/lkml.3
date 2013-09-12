Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3ILR2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:28:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3ILR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:26:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 15/19] pci: frv architecture needs generic setup-bus infrastructure
Date: Thu, 12 Sep 2013 10:26:24 -0700
Message-Id: <20130912172525.823266412@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912172524.135620246@linuxfoundation.org>
References: <20130912172524.135620246@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit cd0a2bfb77a3edeecd652081e0b1a163d3b0696b upstream.

Otherwise we get this link failure for frv's defconfig:

   LD      .tmp_vmlinux1
 drivers/built-in.o: In function `pci_assign_resource':
 (.text+0xbf0c): undefined reference to `pci_cardbus_resource_alignment'
 drivers/built-in.o: In function `pci_setup':
 pci.c:(.init.text+0x174): undefined reference to `pci_realloc_get_opt'
 pci.c:(.init.text+0x1a0): undefined reference to `pci_realloc_get_opt'
 make[1]: *** [.tmp_vmlinux1] Error 1

Cc: David Howells <dhowells@redhat.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_UNICORE32) += setup-bus.o s
 obj-$(CONFIG_PARISC) += setup-bus.o
 obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
 obj-$(CONFIG_PPC) += setup-bus.o
+obj-$(CONFIG_FRV) += setup-bus.o
 obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
 obj-$(CONFIG_X86_VISWS) += setup-irq.o
 obj-$(CONFIG_MN10300) += setup-bus.o


