Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3BWRzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 12:55:55 -0500
Received: from gloria.sntech.de ([95.129.55.99]:55885 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab3BWRzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 12:55:52 -0500
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] pinctrl or i2c-s3c2410: fix pinctrl NULL return values in stubs
Date: Sat, 23 Feb 2013 18:55:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302231855.47560.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while implementing devicetree support for the s3c2416 I noticed a fault
in the i2c-s3c2410 driver. The s3c2416 does not support pinctrl at the
moment (and will probably for a while), so the fallback functions in
pinctrl/consumer.h were used. These functions fail silently and the
relevant pinctrl_get only returns NULL but the i2c driver only checked
for real error-pointers. This resulted in the i2c gpios not getting
configured at all.

There are of course two possible solutions. Check for NULL pinctrl
handles in the driver or return meaningful error codes in the pinctrl
stubs. All other pinctrl drivers also only seem to handle real error
codes and would gladly accept NULL handles, so I'm not sure which is
the correct fix to not break to much existing code.

Therefore I implemented both variants and you get to pick :-) .
This of course means from the following patches only one is necessary.


Heiko
