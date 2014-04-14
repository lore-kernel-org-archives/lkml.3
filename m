Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaDNWA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:00:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35540 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755805AbaDNWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:00:20 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 06/11] pwm: modify PWM_LOOKUP to initialize all struct pwm_lookup members
Date: Mon, 14 Apr 2014 23:59:48 +0200
Message-Id: <1397512793-10325-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that PWM_LOOKUP is not used anymore, modify it to initialize all the
members of struct pwm_lookup.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 Documentation/pwm.txt | 3 ++-
 include/linux/pwm.h   | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
index 93cb97974986..f38f99cda64f 100644
--- a/Documentation/pwm.txt
+++ b/Documentation/pwm.txt
@@ -19,7 +19,8 @@ should instead register a static mapping that can be used to match PWM
 consumers to providers, as given in the following example:
 
 	static struct pwm_lookup board_pwm_lookup[] = {
-		PWM_LOOKUP("tegra-pwm", 0, "pwm-backlight", NULL),
+		PWM_LOOKUP("tegra-pwm", 0, "pwm-backlight", NULL,
+			   50000, PWM_POLARITY_NORMAL),
 	};
 
 	static void __init board_init(void)
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 2f45e2fe5b93..e90628cac8fa 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -278,12 +278,14 @@ struct pwm_lookup {
 	enum pwm_polarity polarity;
 };
 
-#define PWM_LOOKUP(_provider, _index, _dev_id, _con_id)	\
+#define PWM_LOOKUP(_provider, _index, _dev_id, _con_id, _period, _polarity) \
 	{						\
 		.provider = _provider,			\
 		.index = _index,			\
 		.dev_id = _dev_id,			\
 		.con_id = _con_id,			\
+		.period = _period,			\
+		.polarity = _polarity			\
 	}
 
 #if IS_ENABLED(CONFIG_PWM)
-- 
1.8.3.2

