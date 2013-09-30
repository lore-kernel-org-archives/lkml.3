Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3I3NON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:14:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54792 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3I3NOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:14:11 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-34-52497922c8eb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Marcelo Tosatti <marcelo@kvack.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] powerpc/8xx: tqm8xx: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 15:13:55 +0200
Message-id: <1589399.KSlGuZSdd2@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jQV2lSs8gg6vThC3ONr1ht7i8aw6b
	xe/v/1gtdn/qZ7KYufkfkwOrR8+bFlaPTZ8msXucn7GQ0aNvyypGj8+b5AJYo7hsUlJzMstS
	i/TtErgydl48wljwlbNiZcNq9gbGFRxdjJwcEgImEgfvHWeEsMUkLtxbzwZiCwlMZ5Q4Mtew
	i5ELyG5hkmg98JEFJMEmYCUxsX0VUAMHh4iAjsSZfckgNcwCExkl9n6azQxSIyzgLzHr6iMw
	m0VAVaJpUQPYUF4BTYnN2+eB2aICnhKfJi1lhogLSvyYfA9sPrOAvMS+/VNZIWwtifU7jzNN
	YOSbhaRsFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDtBnUjsYVzZYHGIU
	4GBU4uGdsNwjSIg1say4MvcQowQHs5IIr3iZZ5AQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt
	1oFCAumJJanZqakFqUUwWSYOTqkGxoObJLqX3j8m0uY2XW3Sg5Nrp/lN3fjKTHOL3GFBZufW
	LRpN7s9s+hY/k3XLU2SsPPT99JPj8pKqz0L8P2s1/pz7z3nlwwbD4IXHwuOm9Zs8U3++SXij
	XsLafPU/W+VkNd2OaRZdfMy9QfLl+fsTXJN13aX0Upoeq389Vf5AZcLENR9O6ukf8VNiKc5I
	NNRiLipOBABzm6l4TAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/powerpc/platforms/8xx/tqm8xx_setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/8xx/tqm8xx_setup.c b/arch/powerpc/platforms/8xx/tqm8xx_setup.c
index 8d21ab7..ef0778a 100644
--- a/arch/powerpc/platforms/8xx/tqm8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/tqm8xx_setup.c
@@ -48,7 +48,7 @@ struct cpm_pin {
 	int port, pin, flags;
 };
 
-static struct __initdata cpm_pin tqm8xx_pins[] = {
+static struct cpm_pin tqm8xx_pins[] __initdata = {
 	/* SMC1 */
 	{CPM_PORTB, 24, CPM_PIN_INPUT}, /* RX */
 	{CPM_PORTB, 25, CPM_PIN_INPUT | CPM_PIN_SECONDARY}, /* TX */
@@ -63,7 +63,7 @@ static struct __initdata cpm_pin tqm8xx_pins[] = {
 	{CPM_PORTC, 11, CPM_PIN_INPUT | CPM_PIN_SECONDARY | CPM_PIN_GPIO},
 };
 
-static struct __initdata cpm_pin tqm8xx_fec_pins[] = {
+static struct cpm_pin tqm8xx_fec_pins[] __initdata = {
 	/* MII */
 	{CPM_PORTD, 3, CPM_PIN_OUTPUT},
 	{CPM_PORTD, 4, CPM_PIN_OUTPUT},
-- 
1.8.2.3


