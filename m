Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3I2Ti5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:38:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3I2T3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 49/71] tg3: Expand led off fix to include 5720
Date: Sun, 29 Sep 2013 12:28:01 -0700
Message-Id: <20130929192646.827797803@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

commit 300cf9b93f74c3d969a0ad50bdac65416107c44c upstream.

Commit 989038e217e94161862a959e82f9a1ecf8dda152 ("tg3: Don't turn off
led on 5719 serdes port 0") added code to skip turning led off on port
0 of the 5719 since it powered down other ports. This workaround needs
to be enabled on the 5720 as well.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -3034,6 +3034,7 @@ static bool tg3_phy_led_bug(struct tg3 *
 {
 	switch (tg3_asic_rev(tp)) {
 	case ASIC_REV_5719:
+	case ASIC_REV_5720:
 		if ((tp->phy_flags & TG3_PHYFLG_MII_SERDES) &&
 		    !tp->pci_fn)
 			return true;


