Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3I3NIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:08:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12460 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3I3NH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:07:58 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-cc-524977ad72f1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] ARM: shmobile: ape6evm: fix incorrect placement of __initdata
 tag
Date: Mon, 30 Sep 2013 15:07:47 +0200
Message-id: <26068642.Hn7T63a6ac@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jQd215Z5BBjM+yFg0b/3KaHG26Q27
	xabH11gtLu+aw2Yx588UZosHq9+yObB57Jx1l91j85J6j74tqxg95vz8xuLxeZNcAGsUl01K
	ak5mWWqRvl0CV8bxNdNYCk5yVOybfIy9gXEZexcjJ4eEgInEnCsnmCFsMYkL99azdTFycQgJ
	TGeU+LzgESNIQkighUmi46kXiM0mYCUxsX0VWFxEQFXi95FvLCANzAJbGCVmN3SCTRIWCJHY
	8aMdrIgFqOjn2S1gcV4BLYn2Q5vBNosKeEp8mrQUKi4o8WPyPRYQm1lAXmLf/qmsELaWxPqd
	x5kmMPLNQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEh+oz6R2Mqxos
	DjEKcDAq8fBaLPUIEmJNLCuuzD3EKMHBrCTCK17mGSTEm5JYWZValB9fVJqTWnyIUZqDRUmc
	92CrdaCQQHpiSWp2ampBahFMlomDU6qBcfWWxJ3fk5//Oj/hB/9PWeuMnKlWJYpt8X+dln4I
	3iBX8fzbUZvD1ip8m7deY295e/uE3lJhDg6BtaGvXA8y2b65oPYwXHhxdrDn/fyk2NtS604p
	mHKb8mWJMHLPOqj74dekfq5nymxZ/zMvbTnN0b3laKWQT9+eKzvvHPFPD9i52zu1xOjBDiWW
	4oxEQy3mouJEADewPzVRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

In this particular case __initdata is incorrect as ape6evm_keys_pdata
can be used as a platform data for gpio-keys driver which can be
compiled as module.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
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
+static struct gpio_keys_platform_data ape6evm_keys_pdata = {
 	.buttons	= gpio_buttons,
 	.nbuttons	= ARRAY_SIZE(gpio_buttons),
 };
-- 
1.8.2.3


