Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaLCQIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:08:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26299 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaLCQIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:08:43 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-14-547f3543e5e1
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH/RFC v9 04/19] mfd: max77693: adjust max77693_led_platform_data
Date: Wed, 03 Dec 2014 17:06:39 +0100
Message-id: <1417622814-10845-5-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQV1n0/oQgwU9phYbZ6xntTi6cyKT
	xfUvz1kt+t8sZLU492olo0Xv1eeMFmeb3rBb3P96lNHi8q45bBZb36xjtOjZsJXVYun1i0wW
	d08dZbOYMH0ti0Xr3iPsFrt3PWW1OPymndXizP6VbA5CHmvmrWH0uNzXy+Sxc9Zddo+Vy7+w
	eRz+upDFY9OqTjaPO9f2sHnsmf+D1aNvyypGjxWrv7N7fN4kF8AdxWWTkpqTWZZapG+XwJXx
	bdIt1oJfHBULJnQzNTCuY+9i5OCQEDCR6FoS18XICWSKSVy4t56ti5GLQ0hgOqNEw/J2dgin
	nUmi/9xvFpAqNgFDiZ8vXjOBNIsIREtcOlYPUsMs0M0s8aZhLyNIjbCAn8Sf5StZQWwWAVWJ
	5xcWMYPU8wp4SFxYZACxV0FiziQbkApOAU+Jpz/ug50jBFRxcKL/BEbeBYwMqxhFUwuSC4qT
	0nON9IoTc4tL89L1kvNzNzGCA/+Z9A7GVQ0WhxgFOBiVeHgt4upChFgTy4orcw8xSnAwK4nw
	PvsGFOJNSaysSi3Kjy8qzUktPsQozcGiJM5742ZuiJBAemJJanZqakFqEUyWiYNTqoGxjcl0
	qVLHro4JW8/Mmb7qfN6sgrv3w/Xdpt5g3L1i3asDXsFTz3ROEbnk0TTRcz/7HQt+mfeLzXNn
	bdfZ929FjF+vyxHX9JCCtMYP9RoX6i59W/w/bfprCb6rR5qj73PZNj374Z2xQvjs7E9y85w2
	zJDlqbFfWFrkZeT1ojzmsf73Iva7D+8oKbEUZyQaajEXFScCAB0xOWR4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "label" array for Device Tree strings with the name of a LED device
and make flash_timeout a two element array, for caching the sub-led
related flash timeout. Added is also an array for caching pointers to the
sub-nodes representing sub-leds.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/max77693.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index f0b6585..c80ee99 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -88,16 +88,18 @@ enum max77693_led_boost_mode {
 };
 
 struct max77693_led_platform_data {
+	const char *label[2];
 	u32 fleds[2];
 	u32 iout_torch[2];
 	u32 iout_flash[2];
 	u32 trigger[2];
 	u32 trigger_type[2];
+	u32 flash_timeout[2];
 	u32 num_leds;
 	u32 boost_mode;
-	u32 flash_timeout;
 	u32 boost_vout;
 	u32 low_vsys;
+	struct device_node *sub_nodes[2];
 };
 
 /* MAX77693 */
-- 
1.7.9.5

