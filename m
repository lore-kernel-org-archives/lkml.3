Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaEDPld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaEDPla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 063/158] PCI: mvebu: Fix potential issue in range parsing
Date: Sun,  4 May 2014 11:39:32 -0400
Message-Id: <20140504154038.511446734@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

commit 4f4bde1df33bde076f53325bdf2c6430cf85e1bb upstream.

The second parameter of of_read_number() is not the index, but a size.  As
it happens, in this case it may work just fine because of the conversion to
u32 and the favorable endianness on this architecture.

Fixes: 11be65472a427 ("PCI: mvebu: Adapt to the new device tree layout")
Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/host/pci-mvebu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -797,7 +797,7 @@ static int mvebu_get_tgt_attr(struct dev
 
 	for (i = 0; i < nranges; i++) {
 		u32 flags = of_read_number(range, 1);
-		u32 slot = of_read_number(range, 2);
+		u32 slot = of_read_number(range + 1, 1);
 		u64 cpuaddr = of_read_number(range + na, pna);
 		unsigned long rtype;
 


