Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934704Ab3GWW1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934608Ab3GWW1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabor Juhos <juhosg@openwrt.org>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 056/103] rt2x00: rt2800lib: fix default TX power check for RT55xx
Date: Tue, 23 Jul 2013 15:26:07 -0700
Message-Id: <20130723220424.829748157@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit 0847beb2865f5ef1c8626ec1a37def18f3d6c41a upstream.

The code writes the default_power2 value into the TX field
of the RFCSR50 register, however the condition in the if
statement uses default_power1. Due to this, wrong TX power
value might be written into the register.

Use the correct value in the condition to fix the issue.

Compile tested only.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2392,7 +2392,7 @@ static void rt2800_config_channel_rf55xx
 	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
-	if (info->default_power1 > power_bound)
+	if (info->default_power2 > power_bound)
 		rt2x00_set_field8(&rfcsr, RFCSR50_TX, power_bound);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR50_TX, info->default_power2);


