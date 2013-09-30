Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab3I3NSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:18:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13543 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab3I3NSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:18:39 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-3a-52497a2efabd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Jonas Jensen <jonas.jensen@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] ethernet: moxa: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 15:18:27 +0200
Message-id: <172588984.DhoE4BmVdc@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQV29Ks8gg+07pCzmnG9hsZj8Yx+L
	xdmmN+wWl3fNYbM4tkDMgdVjy8qbTB47Z91l9+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	TUv/sBSs5Kj4tmkzewNjC3sXIyeHhICJxNsTv1ggbDGJC/fWs3UxcnEICUxnlHgxtZsdwmlh
	kvgyfS9YFZuAlcTE9lWMILaIgLbEugM9rCBFzAI9jBJX/q1h7mLk4BAW8JJovcUCYrIIqErs
	mp0DUs4LVP55UhsziC0q4CnxadJSZoi4oMSPyffAxjMLyEvs2z+VFcLWkli/8zjTBEa+WUjK
	ZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4KB8JrWDcWWDxSFGAQ5GJR7e
	Ccs9goRYE8uKK3MPMUpwMCuJ8IqXeQYJ8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCe
	WJKanZpakFoEk2Xi4JRqYDzLKH3eQHYT45elaR3Ojr0ik1O63Y5Z/bx6QPzuotvBb9VXfrzO
	5Xgs1HfR66Q9k3P+7pHL6Pj0a95BV7Z4f6llkee3ec0XzHl+tqvI20xoQdTmlvyLcyaJr1Xm
	6UtYIBloZ7vjrmNmpnhx0Gz2l+Fqfp5W88RPRiY8v/wxf03xlNRJvo93lSmxFGckGmoxFxUn
	AgD6kvj3RgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

In this particular case __initdata is incorrect as moxart_mac_driver
can be used after the driver gets initialized.

Also while at it static-ize moxart_mac_driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 83c2091..bd1a2d2 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -543,7 +543,7 @@ static const struct of_device_id moxart_mac_match[] = {
 	{ }
 };
 
-struct __initdata platform_driver moxart_mac_driver = {
+static struct platform_driver moxart_mac_driver = {
 	.probe	= moxart_mac_probe,
 	.remove	= moxart_remove,
 	.driver	= {
-- 
1.8.2.3


