Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaFDXVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaFDXV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 059/228] irqchip: armada-370-xp: fix invalid cast of signed value into unsigned variable
Date: Wed,  4 Jun 2014 16:21:28 -0700
Message-Id: <20140604232349.958616680@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit da343fc776e0bcb238b65d9d24610819b95d0ef4 upstream.

The armada_370_xp_alloc_msi() function returns a signed int, which is
negative on error. However, we store the return value into an
irq_hw_number_t, which is unsigned. Therefore, we actually never test
if armada_370_xp_alloc_msi() returns an error or not, which may lead
us to use hwirq numbers of as 0xffffffe4 (when
armada_370_xp_alloc_msi() returns -ENOSPC).

This commit fixes that by storing the return value of
armada_370_xp_alloc_msi() in a signed variable.

Fixes: 31f614edb726fcc4d5aa0f2895fbdec9b04a3ca4 ('irqchip: armada-370-xp: implement MSI support')
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397823593-1932-2-git-send-email-thomas.petazzoni@free-electrons.com
Tested-by: Neil Greatorex <neil@fatboyfat.co.uk>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-armada-370-xp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -130,8 +130,7 @@ static int armada_370_xp_setup_msi_irq(s
 				       struct msi_desc *desc)
 {
 	struct msi_msg msg;
-	irq_hw_number_t hwirq;
-	int virq;
+	int virq, hwirq;
 
 	hwirq = armada_370_xp_alloc_msi();
 	if (hwirq < 0)


