Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab3FQPMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:12:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57844 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab3FQPMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:12:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] pinctrl: export pinctrl_pm_select_*_state
Date: Mon, 17 Jun 2013 17:12:28 +0200
Message-ID: <3037061.7rG6iWz9IX@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TmT+mZphSmb5+CQmTNKfbjk+ZqaV9ktiODaJgXuLWeJ
 0nfBbu9SwqTRWaI+stA7nrvL2RRGp2nOgXHs/quu8kP+iASpB9
 T6r/TYbsmMZMcmjOjbDgxb72SpvB0iy+qjtflBdAagRUlWp8LQ
 UePFv0nUv4wesuYTmv+6JS88EVSLyGFNhSvFc8mML2rb5WojV0
 JcXiBioFYhznyAIk5rw6RVruLhyINOAOj4prpW1qQNrhMDZ7JB
 T3bOIiFwo/UZ0oaPeQkR55y+vdlGigJOhzACKMf18PtLm9xn8X
 8++/addOPDwfRPYz+qe8TlFvD97N4wNxg6hwywia9wd2QMl/Rl
 xNr7lqD1rynkDj5GCc/o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The three functions pinctrl_pm_select_default_state,
pinctrl_pm_select_sleep_state, and pinctrl_pm_select_idle_state
are used in drivers that can be loadable modules, and should
be exported.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 33710b5..32eb7e2 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1245,6 +1245,7 @@ int pinctrl_pm_select_default_state(struct device *dev)
 		dev_err(dev, "failed to activate default pinctrl state\n");
 	return ret;
 }
+EXPORT_SYMBOL_GPL(pinctrl_pm_select_default_state);
 
 /**
  * pinctrl_pm_select_sleep_state() - select sleep pinctrl state for PM
@@ -1264,6 +1265,7 @@ int pinctrl_pm_select_sleep_state(struct device *dev)
 		dev_err(dev, "failed to activate pinctrl sleep state\n");
 	return ret;
 }
+EXPORT_SYMBOL_GPL(pinctrl_pm_select_sleep_state);
 
 /**
  * pinctrl_pm_select_idle_state() - select idle pinctrl state for PM
@@ -1283,7 +1285,7 @@ int pinctrl_pm_select_idle_state(struct device *dev)
 		dev_err(dev, "failed to activate pinctrl idle state\n");
 	return ret;
 }
-
+EXPORT_SYMBOL_GPL(pinctrl_pm_select_idle_state);
 #endif
 
 #ifdef CONFIG_DEBUG_FS

