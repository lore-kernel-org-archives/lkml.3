Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaFMPAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:00:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49942 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaFMPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:00:15 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-d5-539b11fb1863
Message-id: <539B11EB.6010304@samsung.com>
Date: Fri, 13 Jun 2014 16:59:55 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Daniel Drake <drake@endlessm.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Robin Holt <holt@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] Handle non-secure L2C initialization on Exynos4
References: <CAD8Lp46MbKZrCAMp+9T9LbWTB4uHRDdivhtjoQbkTyBbK48EgQ@mail.gmail.com>
In-reply-to: <CAD8Lp46MbKZrCAMp+9T9LbWTB4uHRDdivhtjoQbkTyBbK48EgQ@mail.gmail.com>
Content-type: multipart/mixed; boundary=------------000206000902070303060701
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t/xy7q/BWcHG8ydL2HxaP5jZov+aR2s
	Fr0LrrJZbO+cwW4x5c9yJotNj6+xWlzeNYfNYvaSfhaL25d5LV73rWG2WLXrD6PF/iteDjwe
	Lc09bB7fvk5i8bjc18vkseh7lsfOWXfZPe5c28PmsXlJvUffllWMHnevv2TyOH5jO5PH501y
	AdxRXDYpqTmZZalF+nYJXBl7F71hLnhnX9F1s5GxgXGuaRcjJ4eEgIlE77EmVghbTOLCvfVs
	XYxcHEICSxklWrsOQTmfGSU2Tb3I1MXIwcEroCUxYVYFSAOLgKrEuQ1/GUFsNgE1ic8Nj9hA
	bH6gkjVN11lAykUFIiQeXxACCfMKCEr8mHyPBcQWAWr9tbyZFWQ8s8B0ZolpN28xgySEBTwk
	vn4/AnaQkECAxPO/N8FmcgoES3yZMB3MZhbwkdi38TnLBEaBWUjmzkKSgrB1JN71PWCGsOUl
	tr+dA2RzANkpEocabVGFQc5oYJTYs28rVG+KxK37FxmxKrp/+jYrRCJW4vqZy2gWgNgZEn33
	57AvYORdxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRGSPL7uYFx6zOoQowAHoxIP78uSWcFC
	rIllxZW5hxhVgOY82rD6AqMUS15+XqqSCO+9BqA0b0piZVVqUX58UWlOavEhRiYOTqkGRqGv
	L8/Js5SldjzU+awgpfNVYvfUzYfa458/e5biJXPHZUd9anyLa2l6pc8bo2/L9yQf2lCqricV
	8vPZzMnyJVu2ajBUf9qjrf4/Y4vcwvAMyxOhynsW5bNe43r75ubRkJ+/55s4qdqqfLZYrTzT
	mzPr/eXnrum5K8VWVivJifM+jpNxzm/bpcRSnJFoqMVcVJwIAIvmbLEIAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000206000902070303060701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Daniel,

I have attached, three patches which make the kernel boot fine with L2
cache enabled on ODROID-U3. Could you test them on your setup to verify
that they indeed fix the issue?

Best regards,
Tomasz

On 12.06.2014 15:38, Daniel Drake wrote:
> Hi Tomasz,
> 
> Thanks for working on this!
> 
> I have just tried this, against Linus master
> 64b2d1fbbfda07765dae3f601862796a61b2c451.
> Added patch "ARM: dts: Initial ODROID U2 support" and booted on
> ODROID-U2. I believe this board has the security enabled.
> 
> Unfortunately, it hangs during early boot. With earlyprintk the last
> messages seen are:
> 
> L2C: platform modifies aux control register: 0x02070000 -> 0x3e470001
> L2C: platform provided aux values permit register corruption.
> L2C: DT/platform modifies aux control register: 0x02070000 -> 0x3e470001
> L2C-310 enabling early BRESP for Cortex-A9
> L2C-310: enabling full line of zeros but not enabled in Cortex-A9
> L2C-310 ID prefetch enabled, offset 1 lines
> L2C-310 dynamic clock gating enabled, standby mode enabled
> L2C-310 cache controller enabled, 16 ways, 1024 kB
> L2C-310: CACHE_ID 0x4100c4c8, AUX_CTRL 0x7e470001
> 
> I then tried to go back to the earlier patch "ARM: EXYNOS: Add secure
> firmware support for l2x0 init" (attached, needed a rebase) but that
> one also now hangs at:
> 
> L2C: platform modifies aux control register: 0x02070000 -> 0x3e470001
> 
> It did work on 3.14 though. Looking at the changelogs, many changes
> have been made to l2x0 recently. Can you confirm that you have tested
> your patches against a kernel with all of Russell King's recent
> changes?
> 
> Thanks
> Daniel
> 

--------------000206000902070303060701
Content-Type: text/x-patch;
 name="0001-ARM-EXYNOS-Invalidate-L2-cache-with-SMC-command-befo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ARM-EXYNOS-Invalidate-L2-cache-with-SMC-command-befo.pa";
 filename*1="tch"

>From b574212db2c1c226212c74b475acceb7fa507c27 Mon Sep 17 00:00:00 2001
From: Tomasz Figa <t.figa@samsung.com>
Date: Fri, 13 Jun 2014 16:40:29 +0200
Subject: [PATCH 1/3] ARM: EXYNOS: Invalidate L2 cache with SMC command before
 enabling

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index d8544537..a688757 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -110,6 +110,8 @@ static void exynos_l2_write_sec(unsigned long val, void __iomem *base,
 {
 	switch (reg) {
 	case L2X0_CTRL:
+		if (val & L2X0_CTRL_EN)
+			exynos_smc(SMC_CMD_L2X0INVALL, 0, 0, 0);
 		exynos_smc(SMC_CMD_L2X0CTRL, val, 0, 0);
 		break;
 
-- 
1.9.3


--------------000206000902070303060701
Content-Type: text/x-patch;
 name="0002-ARM-mm-l2x0-Add-support-for-overriding-prefetch-sett.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-ARM-mm-l2x0-Add-support-for-overriding-prefetch-sett.pa";
 filename*1="tch"

>From 0803df887262849ab8ef905f15fdbe2b34598dde Mon Sep 17 00:00:00 2001
From: Tomasz Figa <t.figa@samsung.com>
Date: Fri, 13 Jun 2014 16:48:47 +0200
Subject: [PATCH 2/3] ARM: mm: l2x0: Add support for overriding prefetch
 settings

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 Documentation/devicetree/bindings/arm/l2cc.txt | 10 ++++++
 arch/arm/mm/cache-l2x0.c                       | 46 ++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
index b513cb8..8096fcd 100644
--- a/Documentation/devicetree/bindings/arm/l2cc.txt
+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
@@ -44,6 +44,16 @@ Optional properties:
 - cache-id-part: cache id part number to be used if it is not present
   on hardware
 - wt-override: If present then L2 is forced to Write through mode
+- arm,double-linefill : Override double linefill enable setting. Enable if
+  non-zero, disable if zero.
+- arm,double-linefill-incr : Override double linefill on INCR read. Enable
+  if non-zero, disable if zero.
+- arm,double-linefill-wrap : Override double linefill on WRAP read. Enable
+  if non-zero, disable if zero.
+- arm,prefetch-drop : Override prefetch drop enable setting. Enable if non-zero,
+  disable if zero.
+- arm,prefetch-offset : Override prefetch offset value. Valid values are
+  0-7, 15, 23, and 31.
 
 Example:
 
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index c25cc13..de39865 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1018,9 +1018,12 @@ static const struct l2c_init_data of_l2c220_data __initconst = {
 static void __init l2c310_of_parse(const struct device_node *np,
 	u32 *aux_val, u32 *aux_mask)
 {
+	bool set_prefetch = false;
 	u32 data[3] = { 0, 0, 0 };
 	u32 tag[3] = { 0, 0, 0 };
 	u32 filter[2] = { 0, 0 };
+	u32 prefetch;
+	u32 val;
 
 	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
 	if (tag[0] && tag[1] && tag[2])
@@ -1047,6 +1050,49 @@ static void __init l2c310_of_parse(const struct device_node *np,
 		writel_relaxed((filter[0] & ~(SZ_1M - 1)) | L310_ADDR_FILTER_EN,
 			       l2x0_base + L310_ADDR_FILTER_START);
 	}
+
+	prefetch = readl_relaxed(l2x0_base + L310_PREFETCH_CTRL);
+
+	if (!of_property_read_u32(np, "arm,double-linefill", &val)) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL;
+		set_prefetch = true;
+	}
+
+	if (!of_property_read_u32(np, "arm,double-linefill-incr", &val)) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
+		set_prefetch = true;
+	}
+
+	if (!of_property_read_u32(np, "arm,double-linefill-wrap", &val)) {
+		if (!val)
+			prefetch |= L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_DBL_LINEFILL_WRAP;
+		set_prefetch = true;
+	}
+
+	if (!of_property_read_u32(np, "arm,prefetch-drop", &val)) {
+		if (val)
+			prefetch |= L310_PREFETCH_CTRL_PREFETCH_DROP;
+		else
+			prefetch &= ~L310_PREFETCH_CTRL_PREFETCH_DROP;
+		set_prefetch = true;
+	}
+
+	if (!of_property_read_u32(np, "arm,prefetch-offset", &val)) {
+		prefetch &= ~L310_PREFETCH_CTRL_OFFSET_MASK;
+		prefetch |= val & L310_PREFETCH_CTRL_OFFSET_MASK;
+		set_prefetch = true;
+	}
+
+	if (set_prefetch)
+		l2c_write_sec(prefetch, l2x0_base, L310_PREFETCH_CTRL);
 }
 
 static const struct l2c_init_data of_l2c310_data __initconst = {
-- 
1.9.3


--------------000206000902070303060701
Content-Type: text/x-patch;
 name="0003-ARM-dts-exynos4x12-Override-prefetch-settings.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-ARM-dts-exynos4x12-Override-prefetch-settings.patch"

>From 032125d7f099d9160ad98371313a829131ebed8c Mon Sep 17 00:00:00 2001
From: Tomasz Figa <t.figa@samsung.com>
Date: Fri, 13 Jun 2014 16:49:09 +0200
Subject: [PATCH 3/3] ARM: dts: exynos4x12: Override prefetch settings.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 9487f9c..ddffefe 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -67,6 +67,11 @@
 		cache-level = <2>;
 		arm,tag-latency = <2 2 1>;
 		arm,data-latency = <3 2 1>;
+		arm,double-linefill = <1>;
+		arm,double-linefill-incr = <0>;
+		arm,double-linefill-wrap = <1>;
+		arm,prefetch-drop = <1>;
+		arm,prefetch-offset = <7>;
 	};
 
 	clock: clock-controller@10030000 {
-- 
1.9.3


--------------000206000902070303060701--
