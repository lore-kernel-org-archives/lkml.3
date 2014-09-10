Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaIJCtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:49:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60605 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaIJCtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:49:12 -0400
MIME-Version: 1.0
In-Reply-To: <1410311886-4579-4-git-send-email-zyw@rock-chips.com>
References: <1410311886-4579-1-git-send-email-zyw@rock-chips.com>
	<1410311886-4579-4-git-send-email-zyw@rock-chips.com>
Date: Tue, 9 Sep 2014 19:49:11 -0700
X-Google-Sender-Auth: 3JPc421pXXztblrw0RpkhXyz3mY
Message-ID: <CAD=FV=Xht=nBBffu==py5CDhTjGKgtzNJWuz=X7=Eb0j1W7jog@mail.gmail.com>
Subject: Re: [PATCH v10 3/3] regulator: RK808: Remove pdata from the regulator
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>,
        "broonie@kernel.org" <broonie@kernel.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 9, 2014 at 6:18 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> Tested-by: Heiko Stuebner <heiko@sntech.de>
> ---
>
> Changes in v10: None

Despite the "None" above, I see that there are indeed changes between
v9 and v10:

diff --git a/drivers/regulator/rk808-regulator.c
b/drivers/regulator/rk808-regulator.c
index 0d5afc4..d91f2b6 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -3,8 +3,8 @@
  *
  * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
  *
- * Author: Chris Zhong<zyw@rock-chips.com>
- * Author: Zhang Qing<zhanqging@rock-chips.com>
+ * Author: Chris Zhong <zyw@rock-chips.com>
+ * Author: Zhang Qing <zhangqing@rock-chips.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -348,6 +348,6 @@ module_platform_driver(rk808_regulator_driver);

 MODULE_DESCRIPTION("regulator driver for the rk808 series PMICs");
 MODULE_AUTHOR("Chris Zhong<zyw@rock-chips.com>");
-MODULE_AUTHOR("Zhang Qing<zhanqging@rock-chips.com>");
+MODULE_AUTHOR("Zhang Qing<zhangqing@rock-chips.com>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:rk808-regulator");

That looks like the change requested by Dmitry for v9 (don't remove
the space) plus a typo fix (flipping g/q).  Interestingly enough the
typo fix shows that "MODULE_AUTHOR" should probably also have had a
space before the "<".


Mark: I think you could just take this (possibly fixing the
MODULE_AUTHOR yourself) to fix the linux-next breakage.  You can also
add:

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>

-Doug
