Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab3I3Peu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:34:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20511 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3I3Pes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:34:48 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-42-52499a160f50
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2] ARM: shmobile: ape6evm: fix incorrect placement of
 __initdata tag
Date: Mon, 30 Sep 2013 17:34:36 +0200
Message-id: <1959578.PFsrHiTtYY@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t9jQV3xWZ5BBlt2s1k0b/3KaHG26Q27
	RefEJewWmx5fY7W4vGsOm8WcP1OYLR6sfsvmwO6xc9Zddo/ZHTNZPTYvqffo27KK0WPOz28s
	Hp83yQWwRXHZpKTmZJalFunbJXBl7G/MLHjEXrH12S/GBsazbF2MnBwSAiYSdy9vZoSwxSQu
	3FsPFOfiEBKYzigx/epyFpCEkEALk0Tvq2oQm03ASmJi+yqwBhEBVYnfR76B1TALvGGUmPTA
	DcQWFgiXOHTrPDOIzQJUc3zBZ7BlvAKaEvsnLQezRQU8JT5NWsoMEReU+DH5HtQceYl9+6ey
	QthaEut3HmeawMg3C0nZLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHLrP
	pHYwrmywOMQowMGoxMNrUO8ZJMSaWFZcmXuIUYKDWUmE9/UEoBBvSmJlVWpRfnxRaU5q8SFG
	aQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGtdZT+g/xGWdPlLtXsfyoxT2Wu1smzKpN
	1dlzeNL1eR9qN7AdULi/877go6k/F647k6r963HEFeX9iY553MGvbV5M+GT6bf5O3kWWLywS
	GCs+Lltns/rKrv8ruBOvREXfTVXary1QuN058qFH+r+t09cdfmH28P4a6c+Zlinzf1V76N5/
	az+BU0GJpTgj0VCLuag4EQAW1KRyWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2:
- use __initdata as it is OK to do it

 arch/arm/mach-shmobile/board-ape6evm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/board-ape6evm.c b/arch/arm/mach-shmobile/board-ape6evm.c
index 7627385..8954f55 100644
--- a/arch/arm/mach-shmobile/board-ape6evm.c
+++ b/arch/arm/mach-shmobile/board-ape6evm.c
@@ -86,7 +86,7 @@ static struct gpio_keys_button gpio_buttons[] = {
 	GPIO_KEY(KEY_VOLUMEDOWN,	329,	"S21"),
 };
 
-static struct __initdata gpio_keys_platform_data ape6evm_keys_pdata = {
+static struct gpio_keys_platform_data ape6evm_keys_pdata __initdata = {
 	.buttons	= gpio_buttons,
 	.nbuttons	= ARRAY_SIZE(gpio_buttons),
 };
-- 
1.8.2.3


