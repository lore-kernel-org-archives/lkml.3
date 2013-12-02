Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab3LBU3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:29:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3LBTQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.12 003/212] ARM: sa11x0/assabet: ensure CS2 is configured appropriately
Date: Mon,  2 Dec 2013 11:13:14 -0800
Message-Id: <20131202191248.943165511@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit f3964fe1c9d9a887d65faf594669852e4dec46e0 upstream.

The CS2 region contains the Assabet board configuration and status
registers, which are 32-bit.  Unfortunately, some boot loaders do not
configure this region correctly, leaving it setup as a 16-bit region.
Fix this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-sa1100/assabet.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -512,6 +512,9 @@ static void __init assabet_map_io(void)
 	 * Its called GPCLKR0 in my SA1110 manual.
 	 */
 	Ser1SDCR0 |= SDCR0_SUS;
+	MSC1 = (MSC1 & ~0xffff) |
+		MSC_NonBrst | MSC_32BitStMem |
+		MSC_RdAcc(2) | MSC_WrAcc(2) | MSC_Rec(0);
 
 	if (!machine_has_neponset())
 		sa1100_register_uart_fns(&assabet_port_fns);


