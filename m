Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbaJCXfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:35:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591AbaJCWDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 109/238] spi: dw-pci: fix bug when regs left uninitialized
Date: Fri,  3 Oct 2014 14:30:24 -0700
Message-Id: <20141003212917.163556557@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit c9d5d6fe168fd45a4dfdd0116affe708789b4702 upstream.

The commit 04f421e7 "spi: dw: use managed resources" changes drivers to use
managed functions, but seems wasn't properly tested in PCI case. The regs field
of struct dw_spi left uninitialized. Thus, kernel crashes when tries to access
to the SPI controller registers. This patch fixes the issue.

Fixes: 04f421e7 (spi: dw: use managed resources)
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-dw-pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/spi/spi-dw-pci.c
+++ b/drivers/spi/spi-dw-pci.c
@@ -62,6 +62,8 @@ static int spi_pci_probe(struct pci_dev
 	if (ret)
 		return ret;
 
+	dws->regs = pcim_iomap_table(pdev)[pci_bar];
+
 	dws->bus_num = 0;
 	dws->num_cs = 4;
 	dws->irq = pdev->irq;


