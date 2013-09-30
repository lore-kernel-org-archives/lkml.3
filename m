Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3I3NJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:09:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54478 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab3I3NJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:09:33 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-77-5249780ba46d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] MIPS: Alchemy: MTX-1: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 15:09:20 +0200
Message-id: <1426447.xVtcA00boF@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAV2eCs8ggxnPWS3ONr1ht7i8aw6b
	xYSpk9gtLu1RcWDxOLpyLZNH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZVyef4254AZbxckZ
	4g2MV1i7GDk5JARMJOZcWscGYYtJXLi3Hsjm4hASWMQo8bWrkRnCaWGSeNX5kAmkik3ASmJi
	+ypGEFtEQE3i1bfNYJOYBTIkXu/qZwaxhQUCJJ6d+MMCYrMIqEr8ujUFrJ5XQFPizpJ1YDWi
	Ap4SnyYtZYaIC0r8mHyPBWKOvMS+/VOhZmpJrN95nGkCI98sJGWzkJTNQlK2gJF5FaNoakFy
	QXFSeq6hXnFibnFpXrpecn7uJkZwAD6T2sG4ssHiEKMAB6MSD++E5R5BQqyJZcWVuYcYJTiY
	lUR4xcs8g4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUw
	mrleb/V8dTHNKLLjg2/ikdfyjXdtX+/jsjDhKNjRdT7uyX1HBuYyJ8spD75sqXIwXvf0pCrf
	+UPMM/ykBNlYp1tynXrg2V45gXFNyX6deOdYG/d3rybMOKnN4LJ9+5qw0uArWTpnDvS+tvR1
	jEu+aPdQchnDpVbxNZM+Wn04J+13pX21lWm0EktxRqKhFnNRcSIAiq1oEzwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/mips/alchemy/board-mtx1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/alchemy/board-mtx1.c b/arch/mips/alchemy/board-mtx1.c
index 4a9baa9..9969dba 100644
--- a/arch/mips/alchemy/board-mtx1.c
+++ b/arch/mips/alchemy/board-mtx1.c
@@ -276,7 +276,7 @@ static struct platform_device mtx1_pci_host = {
 	.resource	= alchemy_pci_host_res,
 };
 
-static struct __initdata platform_device * mtx1_devs[] = {
+static struct platform_device *mtx1_devs[] __initdata = {
 	&mtx1_pci_host,
 	&mtx1_gpio_leds,
 	&mtx1_wdt,
-- 
1.8.2.3


