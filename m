Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3JOFLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:11:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8369 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3JOFLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:11:10 -0400
X-AuditID: cbfee68f-b7fc96d000006ecb-85-525cce6ca80a
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, hs@denx.de
Cc: khali@linux-fr.org, ben-linux@fluff.org, grant.likely@secretlab.ca,
        sjg@chromium.org, naveenkrishna.ch@gmail.com, d.mueller@elsoft.ch,
        trini@ti.com, mk7.kang@samsung.com, cpgs@samsung.com
Subject: [PATCH 2/3 v3] exynos: i2c: Change FDT bus setup code to enumerate
 ports correctly
Date: Tue, 15 Oct 2013 10:43:15 +0530
Message-id: <1381813995-16050-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1380524290-9644-3-git-send-email-ch.naveen@samsung.com>
References: <1380524290-9644-3-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkTjfnXEyQQcdVU4tJ6w4wWbw8pGmx
	4HAzs8WrMxvZLHbcuc9s0fg30qLj7xdGi8u75rBZzDi/j8mi40gLo8Wibf+ZLb5t2cZoMXnx
	fGYHXo/ZDRdZPObNOsHi0bT1EbPH31UvmD12zrrL7nGl4SSbR9+WVYweP1/qeBy/sZ3J4/Mm
	uQCuKC6blNSczLLUIn27BK6MNY9eMhfMkqro33iavYHxq0gXIyeHhICJxKJ5e9ghbDGJC/fW
	s3UxcnEICSxllLh+7TIrTNGE5jWsEIlFjBKHv+9ih3B6mCRWLPkAVsUmYCZxcNFqsFEiAjkS
	r06vAutgFjjMKPG66xkbSEJYIFbi/72PLCA2i4CqRE/HEWYQm1fAVWLd9AVQ6xQlup9NAKrn
	4OAEih89xwgSFhJwkZi1/AMLyEwJgZfsElfe3GWFmCMg8W3yIRaQegkBWYlNB5ghxkhKHFxx
	g2UCo/ACRoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIERdfrfs/4djHcPWB9iTAYaN5FZ
	SjQ5HxiReSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgdGW2upIcNPu+lOEmdYZGk5o7mUoPSiOU7d7eX5oU9/GJrJch85Gvl/eUGS9nXvy3S/XG
	y6+tzmv4nomZmXfaRJm3zlKt5O5XlufM/Dzz7ayZx1WavY6unyt39pGy9ZmGudI7i6ZHp70w
	ZevmjvibFV5r/E7l6totBdLnTFqfRetVavlcvOGhxFKckWioxVxUnAgAPObq974CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgG7OuZggg5drNC0mrTvAZPHykKbF
	gsPNzBavzmxks9hx5z6zRePfSIuOv18YLS7vmsNmMeP8PiaLjiMtjBaLtv1ntvi2ZRujxeTF
	85kdeD1mN1xk8Zg36wSLR9PWR8wef1e9YPbYOesuu8eVhpNsHn1bVjF6/Hyp43H8xnYmj8+b
	5AK4ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	bldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZqx59JK5YJZURf/G0+wN
	jF9Fuhg5OSQETCQmNK9hhbDFJC7cW8/WxcjFISSwiFHi8Pdd7BBOD5PEiiUfwKrYBMwkDi5a
	zQ5iiwjkSLw6vYoVpIhZ4DCjxOuuZ2wgCWGBWIn/9z6ygNgsAqoSPR1HmEFsXgFXiXXTF0Ct
	U5TofjYBqJ6DgxMofvQcI0hYSMBFYtbyDywTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dL
	zs/dxAiO12fSOxhXNVgcYhTgYFTi4f3BGxMkxJpYVlyZe4hRgoNZSYQ3pxooxJuSWFmVWpQf
	X1Sak1p8iDEZ6KiJzFKiyfnAVJJXEm9obGJuamxqaWJhYmZJmrCSOO/BVutAIYH0xJLU7NTU
	gtQimC1MHJxSDYz2y3sLNMKrjnY/D+ZXNq354b2Fy93mmsaBqA3ZbxbwxWyWDZLdK2O++EXg
	GVuubwf4NDbY6frP4HK/Fvpst+a3zfN2FloK8M/Lla9PUGKt9ZWZ5SD+nH2GWEXq7NYXkgJ3
	m9XNOW1/CSe+e8m+fH7aepUf04IyPO1faCde1Wet6Dyy/tCTtUosxRmJhlrMRcWJAJgwzIMb	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Glass <sjg@chromium.org>

At present the i2c ports are enumerated in a strange way - the
fdtdec_find_aliases_for_id() function is used, but then the ID returned
is ignored and the ports are renumbered. The effect is the same provided
that the device tree has the ports in the same order, or uses aliases,
and has no gaps, but it is not correct.

Adjust the code to use the function as intended. This will allows device
tree aliases to change the device order if required.

As a result, the i2c_busses variable is dropped. We can't be sure that
there are no 'holes' in the list of buses, so must check the whole
array.

Note: it seems that non-FDT operation is now broken in this drive and
will need to be reinstated for upstream.

Signed-off-by: Simon Glass <sjg@chromium.org>
Reviewed-on: https://gerrit.chromium.org/gerrit/59369
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
Nonei

Changes since v2:
None
 drivers/i2c/s3c24x0_i2c.c |   25 ++++++++++++++++++-------
 drivers/i2c/s3c24x0_i2c.h |    1 +
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/s3c24x0_i2c.c b/drivers/i2c/s3c24x0_i2c.c
index c65360d..0e6f241 100644
--- a/drivers/i2c/s3c24x0_i2c.c
+++ b/drivers/i2c/s3c24x0_i2c.c
@@ -52,7 +52,6 @@
  */
 static unsigned int g_current_bus __attribute__((section(".data")));
 #ifdef CONFIG_OF_CONTROL
-static int i2c_busses __attribute__((section(".data")));
 static struct s3c24x0_i2c_bus i2c_bus[CONFIG_MAX_I2C_NUM]
 			__attribute__((section(".data")));
 #endif
@@ -164,8 +163,8 @@ int i2c_set_bus_num(unsigned int bus)
 {
 	struct s3c24x0_i2c *i2c;
 
-	if ((bus < 0) || (bus >= CONFIG_MAX_I2C_NUM)) {
-		debug("Bad bus: %d\n", bus);
+	i2c_bus = get_bus(bus);
+	if (!i2c_bus)
 		return -1;
 	}
 
@@ -483,19 +482,31 @@ void board_i2c_init(const void *blob)
 		if (node <= 0)
 			continue;
 		bus = &i2c_bus[i];
+		bus->active = true;
 		bus->regs = (struct s3c24x0_i2c *)
 			fdtdec_get_addr(blob, node, "reg");
 		bus->id = pinmux_decode_periph_id(blob, node);
 		bus->node = node;
-		bus->bus_num = i2c_busses++;
+		bus->bus_num = i;
 		exynos_pinmux_config(bus->id, 0);
 	}
 }
 
+/**
+ * Get a pointer to the given bus index
+ *
+ * @bus_idx: Bus index to look up
+ * @return pointer to bus, or NULL if invalid or not available
+ */
 static struct s3c24x0_i2c_bus *get_bus(unsigned int bus_idx)
 {
-	if (bus_idx < i2c_busses)
-		return &i2c_bus[bus_idx];
+	if (bus_idx < ARRAY_SIZE(i2c_bus)) {
+		struct s3c24x0_i2c_bus *bus;
+
+		bus = &i2c_bus[bus_idx];
+		if (bus->active)
+			return bus;
+	}
 
 	debug("Undefined bus: %d\n", bus_idx);
 	return NULL;
@@ -505,7 +516,7 @@ int i2c_get_bus_num_fdt(int node)
 {
 	int i;
 
-	for (i = 0; i < i2c_busses; i++) {
+	for (i = 0; i < ARRAY_SIZE(i2c_bus); i++) {
 		if (node == i2c_bus[i].node)
 			return i;
 	}
diff --git a/drivers/i2c/s3c24x0_i2c.h b/drivers/i2c/s3c24x0_i2c.h
index b4a337a..882af62 100644
--- a/drivers/i2c/s3c24x0_i2c.h
+++ b/drivers/i2c/s3c24x0_i2c.h
@@ -16,6 +16,7 @@ struct s3c24x0_i2c {
 };
 
 struct s3c24x0_i2c_bus {
+	bool active;	/* port is active and available */
 	int node;	/* device tree node */
 	int bus_num;	/* i2c bus number */
 	struct s3c24x0_i2c *regs;
-- 
1.7.10.4

