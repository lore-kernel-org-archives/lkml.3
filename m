Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967793Ab3HICQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:16:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967521Ab3HIB6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bo Shi <cnshibo@gmail.com>, Oleksij Rempel <linux@rempel-privat.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 035/102] ath9k_htc: do some initial hardware configuration
Date: Thu,  8 Aug 2013 18:57:11 -0700
Message-Id: <20130809015018.124314102@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <linux@rempel-privat.de>

commit dc2a87f519a4d8cb376ab54f22b6b98a943b51ce upstream.

Currently we configure harwdare and clock, only after
interface start. In this case, if we reload module or
reboot PC without configuring adapter, firmware will freeze.
There is no software way to reset adpter.

This patch add initial configuration and set it in
disabled state, to avoid this freeze. Behaviour of this patch
should be similar to: ifconfig wlan0 up; ifconfig wlan0 down.

Bug: https://github.com/qca/open-ath9k-htc-firmware/issues/1
Tested-by: Bo Shi <cnshibo@gmail.com>
Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -846,6 +846,7 @@ static int ath9k_init_device(struct ath9
 	if (error != 0)
 		goto err_rx;
 
+	ath9k_hw_disable(priv->ah);
 #ifdef CONFIG_MAC80211_LEDS
 	/* must be initialized before ieee80211_register_hw */
 	priv->led_cdev.default_trigger = ieee80211_create_tpt_led_trigger(priv->hw,


