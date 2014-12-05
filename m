Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaLEXru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:47:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaLEWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianqun <jay.xu@rock-chips.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 038/122] ASoC: rockchip-i2s: fix infinite loop in rockchip_snd_rxctrl
Date: Fri,  5 Dec 2014 14:43:32 -0800
Message-Id: <20141205223311.158398175@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianqun <jay.xu@rock-chips.com>

commit 29f95bd76f6ec1eff88eec6a04191104a11a7f97 upstream.

We can get into an infinite loop if the I2S_CLR register fails to
clear due to a missing break statement, so add that.

Signed-off-by: Jianqun <jay.xu@rock-chips.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/rockchip/rockchip_i2s.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -152,8 +152,10 @@ static void rockchip_snd_rxctrl(struct r
 			while (val) {
 				regmap_read(i2s->regmap, I2S_CLR, &val);
 				retry--;
-				if (!retry)
+				if (!retry) {
 					dev_warn(i2s->dev, "fail to clear\n");
+					break;
+				}
 			}
 		}
 	}


