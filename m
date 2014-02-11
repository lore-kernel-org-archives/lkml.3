Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaBKTMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:12:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbaBKTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.4 08/30] mtd: mxc_nand: remove duplicated ecc_stats counting
Date: Tue, 11 Feb 2014 11:06:08 -0800
Message-Id: <20140211184647.385771504@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 0566477762f9e174e97af347ee9c865f908a5647 upstream.

The ecc_stats.corrected count variable will already be incremented in
the above framework-layer just after this callback.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/mxc_nand.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -596,7 +596,6 @@ static int mxc_nand_correct_data_v2_v3(s
 		ecc_stat >>= 4;
 	} while (--no_subpages);
 
-	mtd->ecc_stats.corrected += ret;
 	pr_debug("%d Symbol Correctable RS-ECC Error\n", ret);
 
 	return ret;


