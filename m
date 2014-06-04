Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbaFEAQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:16:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaFDXWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Willy Tarreau <w@1wt.eu>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 160/228] ARM: mvebu: mvebu-soc-id: add missing clk_put() call
Date: Wed,  4 Jun 2014 16:23:09 -0700
Message-Id: <20140604232353.155864138@linuxfoundation.org>
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

commit 42a18d1cf484d02e23afadfa5dc09356e6bef9fa upstream.

The mvebu-soc-id code in mach-mvebu/ needs to enable a clock to read
the SoC device ID and revision number. To do so, it does a clk_get(),
then a clk_prepare_enable(), reads the value, and disables the clock
with clk_disable_unprepare(). However, it forgets to clk_put() the
clock. This commit fixes this issue.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1399903900-29977-2-git-send-email-thomas.petazzoni@free-electrons.com
Fixes: af8d1c63afcb ("ARM: mvebu: Add support to get the ID and the revision of a SoC")
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-mvebu/mvebu-soc-id.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-mvebu/mvebu-soc-id.c
+++ b/arch/arm/mach-mvebu/mvebu-soc-id.c
@@ -108,6 +108,7 @@ static int __init mvebu_soc_id_init(void
 
 res_ioremap:
 	clk_disable_unprepare(clk);
+	clk_put(clk);
 
 clk_err:
 	of_node_put(child);


