Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161207Ab3BOIqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:46:30 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16487 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161154Ab3BOIq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:46:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 15 Feb 2013 00:46:24 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [v3 6/6] ARM: tegra114: convert device tree files to use CLK defines
Date: Fri, 15 Feb 2013 10:43:17 +0200
Message-ID: <1360917814-27236-7-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com>
References: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace magic number in tegra_car:

-               clocks = <&tegra_car 28>;
+               clocks = <&tegra_car CLK_HOST1X>;

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 .../bindings/clock/nvidia,tegra114-car.txt         |  261 +-------------------
 arch/arm/boot/dts/tegra114.dtsip                   |   13 +-
 2 files changed, 8 insertions(+), 266 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra114-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra114-car.txt
index 25e088d..c8956ed 100644
--- a/Documentation/devicetree/bindings/clock/nvidia,tegra114-car.txt
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra114-car.txt
@@ -14,265 +14,6 @@ Required properties :
 - #clock-cells : Should be 1.
   In clock consumers, this cell represents the clock ID exposed by the CAR.
 
-  The first 160 clocks are numbered to match the bits in the CAR's CLK_OUT_ENB
-  registers. These IDs often match those in the CAR's RST_DEVICES registers,
-  but not in all cases. Some bits in CLK_OUT_ENB affect multiple clocks. In
-  this case, those clocks are assigned IDs above 160 in order to highlight
-  this issue. Implementations that interpret these clock IDs as bit values
-  within the CLK_OUT_ENB or RST_DEVICES registers should be careful to
-  explicitly handle these special cases.
-
-  The balance of the clocks controlled by the CAR are assigned IDs of 160 and
-  above.
-
-  0	cpu
-  1	unassigned
-  2	unassigned
-  3	unassigned
-  4	rtc
-  5	timer
-  6	uarta
-  7	unassigned	(register bit affects uartb and vfir)
-  8	unassigned
-  9	sdmmc2
-  10	unassigned	(register bit affects spdif_in and spdif_out)
-  11	i2s1
-  12	i2c1
-  13	ndflash
-  14	sdmmc1
-  15	sdmmc4
-  16	unassigned
-  17	pwm
-  18	i2s2
-  19	epp
-  20	unassigned	(register bit affects vi and vi_sensor)
-  21	2d
-  22	usbd
-  23	isp
-  24	3d
-  25	unassigned
-  26	disp2
-  27	disp1
-  28	host1x
-  29	vcp
-  30	i2s0
-  31	unassigned
-
-  32	unassigned
-  33	unassigned
-  34	apbdma
-  35	unassigned
-  36	kbc
-  37	unassigned
-  38	unassigned
-  39	unassigned	(register bit affects fuse and fuse_burn)
-  40	kfuse
-  41	sbc1
-  42	nor
-  43	unassigned
-  44	sbc2
-  45	unassigned
-  46	sbc3
-  47	i2c5
-  48	dsia
-  49	unassigned
-  50	mipi
-  51	hdmi
-  52	csi
-  53	unassigned
-  54	i2c2
-  55	uartc
-  56	mipi-cal
-  57	unassigned
-  58	usb2
-  59	usb3
-  60	msenc
-  61	vde
-  62	bsea
-  63	bsev
-
-  64	unassigned
-  65	uartd
-  66	unassigned
-  67	i2c3
-  68	sbc4
-  69	sdmmc3
-  70	unassigned
-  71	owr
-  72	afi
-  73	csite
-  74	unassigned
-  75	unassigned
-  76	la
-  77	trace
-  78	soc_therm
-  79	dtv
-  80	ndspeed
-  81	i2cslow
-  82	dsib
-  83	tsec
-  84	unassigned
-  85	unassigned
-  86	unassigned
-  87	unassigned
-  88	unassigned
-  89	xusb_host
-  90	unassigned
-  91	msenc
-  92	csus
-  93	unassigned
-  94	unassigned
-  95	unassigned	(bit affects xusb_dev and xusb_dev_src)
-
-  96	unassigned
-  97	unassigned
-  98	unassigned
-  99	mselect
-  100	tsensor
-  101	i2s3
-  102	i2s4
-  103	i2c4
-  104	sbc5
-  105	sbc6
-  106	d_audio
-  107	apbif
-  108	dam0
-  109	dam1
-  110	dam2
-  111	hda2codec_2x
-  112	unassigned
-  113	audio0_2x
-  114	audio1_2x
-  115	audio2_2x
-  116	audio3_2x
-  117	audio4_2x
-  118	spdif_2x
-  119	actmon
-  120	extern1
-  121	extern2
-  122	extern3
-  123	unassigned
-  124	unassigned
-  125	hda
-  126	unassigned
-  127	se
-
-  128	hda2hdmi
-  129	unassigned
-  130	unassigned
-  131	unassigned
-  132	unassigned
-  133	unassigned
-  134	unassigned
-  135	unassigned
-  136	unassigned
-  137	unassigned
-  138	unassigned
-  139	unassigned
-  140	unassigned
-  141	unassigned
-  142	unassigned
-  143	unassigned	(bit affects xusb_falcon_src, xusb_fs_src,
-			 xusb_host_src and xusb_ss_src)
-  144	cilab
-  145	cilcd
-  146	cile
-  147	dsialp
-  148	dsiblp
-  149	unassigned
-  150	dds
-  151	unassigned
-  152	dp2
-  153	amx
-  154	adx
-  155	unassigned
-  156	xusb_ss
-
-  192	uartb
-  193	vfir
-  194	spdif_in
-  195	spdif_out
-  196	vi
-  197	vi_sensor
-  198	fuse
-  199	fuse_burn
-  200	clk_32k
-  201	clk_m
-  202	clk_m_div2
-  203	clk_m_div4
-  204	pll_ref
-  205	pll_c
-  206	pll_c_out1
-  207	pll_c2
-  208	pll_c3
-  209	pll_m
-  210	pll_m_out1
-  211	pll_p
-  212	pll_p_out1
-  213	pll_p_out2
-  214	pll_p_out3
-  214	mipi_cal_fast
-  214	dsi1_fixed
-  214	dsi2_fixed
-  215	pll_p_out4
-  216	pll_a
-  217	pll_a_out1
-  218	pll_d
-  219	pll_d_out0
-  220	pll_d2
-  221	pll_d2_out0
-  222	pll_u
-  223	pll_u_480M
-  224	pll_u_60M
-  225	pll_u_48M
-  226	pll_u_12M
-  227	pll_x
-  228	pll_x_out0
-  229	pll_re_vco
-  230	pll_re_out
-  231	pll_e_out0
-  232	spdif_in_sync
-  233	i2s0_sync
-  234	i2s1_sync
-  235	i2s2_sync
-  236	i2s3_sync
-  237	i2s4_sync
-  238	vimclk_sync
-  239	audio0
-  240	audio1
-  241	audio2
-  242	audio3
-  243	audio4
-  244	spdif
-  245	clk_out_1
-  246	clk_out_2
-  247	clk_out_3
-  248	blink
-  252	xusb_host_src
-  253	xusb_falcon_src
-  254	xusb_fs_src
-  255	xusb_ss_src
-  256	xusb_dev_src
-  257	xusb_dev
-  258	xusb_hs_src
-  259	sclk
-  260	hclk
-  261	pclk
-  262	cclk_g
-  263	cclk_lp
-
-Mux clocks
-
-  300	audio0_mux
-  301	audio1_mux
-  302	audio2_mux
-  303	audio3_mux
-  304	audio4_mux
-  305	spdif_mux
-  306	clk_out_1_mux
-  307	clk_out_2_mux
-  308	clk_out_3_mux
-
 Example SoC include file:
 
 / {
@@ -283,7 +24,7 @@ Example SoC include file:
 	};
 
 	usb@c5004000 {
-		clocks = <&tegra_car 58>; /* usb2 */
+		clocks = <&tegra_car TEGRA114_CLK_USB2>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/tegra114.dtsip b/arch/arm/boot/dts/tegra114.dtsip
index df01b15..8308196 100644
--- a/arch/arm/boot/dts/tegra114.dtsip
+++ b/arch/arm/boot/dts/tegra114.dtsip
@@ -1,6 +1,7 @@
 #include "skeleton.dtsi"
 #include "tegra-gpio.h"
 #include "arm-gic.h"
+#include "tegra114-car.h"
 
 / {
 	compatible = "nvidia,tegra114";
@@ -27,7 +28,7 @@
 			     <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 5>;
+		clocks = <&tegra_car TEGRA114_CLK_TIMER>;
 	};
 
 	tegra_car: clock {
@@ -70,7 +71,7 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
-		clocks = <&tegra_car 6>;
+		clocks = <&tegra_car TEGRA114_CLK_UARTA>;
 	};
 
 	serial@70006040 {
@@ -79,7 +80,7 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
-		clocks = <&tegra_car 192>;
+		clocks = <&tegra_car TEGRA114_CLK_UARTB>;
 	};
 
 	serial@70006200 {
@@ -88,7 +89,7 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
-		clocks = <&tegra_car 55>;
+		clocks = <&tegra_car TEGRA114_CLK_UARTC>;
 	};
 
 	serial@70006300 {
@@ -97,14 +98,14 @@
 		reg-shift = <2>;
 		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
-		clocks = <&tegra_car 65>;
+		clocks = <&tegra_car TEGRA114_CLK_UARTD>;
 	};
 
 	rtc {
 		compatible = "nvidia,tegra114-rtc", "nvidia,tegra20-rtc";
 		reg = <0x7000e000 0x100>;
 		interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&tegra_car 4>;
+		clocks = <&tegra_car TEGRA114_CLK_RTC>;
 	};
 
 	pmc {
-- 
1.7.9.5

