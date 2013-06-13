Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab3FMXIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:08:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51094 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3FMXIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:08:12 -0400
Date: Fri, 14 Jun 2013 01:08:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130613230808.GA14876@amd.pavel.ucw.cz>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
 <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
 <20130613132624.GA3464@amd.pavel.ucw.cz>
 <20130613141001.GF8164@atomide.com>
 <20130613142809.GA3775@amd.pavel.ucw.cz>
 <20130613145724.GH8164@atomide.com>
 <20130613155240.GB3775@amd.pavel.ucw.cz>
 <20130613161418.GJ8164@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613161418.GJ8164@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Now, by chance, any idea what is DT equivalent of 
> > 
> > omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
> 
> You can try the attached hack after calling the above to grep for
> pins in /sys/kernel/debug/omap_mux/board/core and you get the pins
> in DT suitable format. There's a bug where the the pins are not
> correctly split between core and wkup domains in the legacy mux fwk,
> but you probably won't need to mux many wkup domain pins.
> 
> Then you just need to add the pinctr-single entries for each device,
> but AFAIK most of the pins are muxed correctly in the bootloader
> for the Nokia boards.

Thanks a lot for the help. So far, I'm not playing with
suspend/resume, so wkup/core split should not be issue (right?).

How does it work with the devices? AFAICT omap4 groups it logically,
but that's just for easy reading, no?

I tried this, but no luck, mux is not initialized correctly, so code
in board-rx51-video fails, and later fbcon crashes.

Any ideas?
								Pavel

diff --git a/.config b/.config
index f673799..251f9dc 100644
--- a/.config
+++ b/.config
@@ -3052,8 +3052,7 @@ CONFIG_STACKTRACE=y
 # CONFIG_DEBUG_KOBJECT is not set
 # CONFIG_DEBUG_HIGHMEM is not set
 CONFIG_DEBUG_BUGVERBOSE=y
-CONFIG_DEBUG_INFO=y
-CONFIG_DEBUG_INFO_REDUCED=y
+# CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
 # CONFIG_DEBUG_MEMORY_INIT is not set
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 3918ae1..ec82189 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -81,3 +81,218 @@
 	power = <50>;
 };
 */
+
+
+
+&omap3_pmx_core {
+		pinctrl-names = "default";
+		pinctrl-0 = <
+			&all_pins
+		>;
+
+		all_pins: pinmux_all_pins {
+		    pinctrl-single,pins = <
+			0xe6 0x4104	/* cam_d0.gpio_99 gpio99 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xe8 0x11c	/* cam_d1.gpio_100 gpio100 INPUT_PULLUP | MODE4 */
+			0xfa 0x7	/* cam_d10.safe_mode gpio109 OUTPUT | MODE7 */
+			0xfc 0x4104	/* cam_d11.gpio_110 gpio110 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xea 0xc104	/* cam_d2.gpio_101 gpio101 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xec 0x4	/* cam_d3.gpio_102 gpio102 OUTPUT | MODE4 */
+			0xee 0x7	/* cam_d4.safe_mode gpio103 OUTPUT | MODE7 */
+			0xf0 0x4	/* cam_d5.gpio_104 gpio104 OUTPUT | MODE4 */
+			0xf2 0x100	/* cam_d6.cam_d6 gpio105 INPUT | MODE0 */
+			0xf4 0x100	/* cam_d7.cam_d7 gpio106 INPUT | MODE0 */
+			0xf6 0x100	/* cam_d8.cam_d8 gpio107 INPUT | MODE0 */
+			0xf8 0x100	/* cam_d9.cam_d9 gpio108 INPUT | MODE0 */
+			0xe4 0x4	/* cam_fld.gpio_98 gpio98 OUTPUT | MODE4 */
+			0xdc 0x7	/* cam_hs.safe_mode gpio94 OUTPUT | MODE7 */
+			0xe2 0x4	/* cam_pclk.gpio_97 gpio97 OUTPUT | MODE4 */
+			0x102 0x0	/* cam_strobe.cam_strobe gpio126 OUTPUT | MODE0 */
+			0xde 0x7	/* cam_vs.safe_mode gpio95 OUTPUT | MODE7 */
+			0x100 0x104	/* cam_wen.gpio_167 gpio167 INPUT | MODE4 */
+			0xe0 0x0	/* cam_xclka.cam_xclka gpio96 OUTPUT | MODE0 */
+			0xfe 0x7	/* cam_xclkb.safe_mode gpio111 OUTPUT | MODE7 */
+			0x104 0x7	/* csi2_dx0.safe_mode gpio112 OUTPUT | MODE7 */
+			0x108 0x7	/* csi2_dx1.safe_mode gpio114 OUTPUT | MODE7 */
+			0x106 0x4104	/* csi2_dy0.gpio_113 gpio113 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x10a 0x7	/* csi2_dy1.safe_mode gpio115 OUTPUT | MODE7 */
+			0xaa 0x4104	/* dss_acbias.gpio_69 gpio69 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xac 0x4	/* dss_data0.gpio_70 gpio70 OUTPUT | MODE4 */
+			0xae 0x4114	/* dss_data1.gpio_71 gpio71 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xc0 0x1	/* dss_data10.(null) gpio80 OUTPUT | MODE1 */
+			0xc2 0x1	/* dss_data11.(null) gpio81 OUTPUT | MODE1 */
+			0xc4 0x1	/* dss_data12.(null) gpio82 OUTPUT | MODE1 */
+			0xc6 0x1	/* dss_data13.(null) gpio83 OUTPUT | MODE1 */
+			0xc8 0x7	/* dss_data14.safe_mode gpio84 OUTPUT | MODE7 */
+			0xca 0x7	/* dss_data15.safe_mode gpio85 OUTPUT | MODE7 */
+			0xcc 0x4	/* dss_data16.gpio_86 gpio86 OUTPUT | MODE4 */
+			0xce 0x4	/* dss_data17.gpio_87 gpio87 OUTPUT | MODE4 */
+			0xd0 0x4	/* dss_data18.gpio_88 gpio88 OUTPUT | MODE4 */
+			0xd2 0x4104	/* dss_data19.gpio_89 gpio89 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xd4 0x4	/* dss_data20.gpio_90 gpio90 OUTPUT | MODE4 */
+			0xd6 0x4	/* dss_data21.gpio_91 gpio91 OUTPUT | MODE4 */
+			0xd8 0x1	/* dss_data22.(null) gpio92 OUTPUT | MODE1 */
+			0xda 0x1	/* dss_data23.(null) gpio93 OUTPUT | MODE1 */
+			0xb0 0x4104	/* dss_data2.gpio_72 gpio72 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0xb2 0x4	/* dss_data3.gpio_73 gpio73 OUTPUT | MODE4 */
+			0xb4 0x10c	/* dss_data4.gpio_74 gpio74 INPUT_PULLDOWN | MODE4 */
+			0xb6 0x371c	/* dss_data5.gpio_75 gpio75 INPUT_PULLUP | OFF_OUTPUT_LOW | MODE4 */
+			0xb8 0x7	/* dss_data6.safe_mode gpio76 OUTPUT | MODE7 */
+			0xba 0x7	/* dss_data7.safe_mode gpio77 OUTPUT | MODE7 */
+			0xbc 0x7	/* dss_data8.safe_mode gpio78 OUTPUT | MODE7 */
+			0xbe 0x7	/* dss_data9.safe_mode gpio79 OUTPUT | MODE7 */
+			0xa6 0x4	/* dss_hsync.gpio_67 gpio67 OUTPUT | MODE4 */
+			0xa4 0x7	/* dss_pclk.safe_mode gpio66 OUTPUT | MODE7 */
+			0xa8 0x104	/* dss_vsync.gpio_68 gpio68 INPUT | MODE4 */
+			0x5a8 0x114	/* etk_clk.gpio_12 gpio12 INPUT | MODE4 */
+			0x5aa 0x7	/* etk_ctl.(null) gpio13 OUTPUT | MODE7 */
+			0x5ac 0x7	/* etk_d0.(null) gpio14 OUTPUT | MODE7 */
+			0x5ae 0x7	/* etk_d1.(null) gpio15 OUTPUT | MODE7 */
+			0x5c0 0x11b	/* etk_d10.hsusb2_clk gpio24 INPUT_PULLUP | MODE3 */
+			0x5c2 0x7	/* etk_d11.(null) gpio25 OUTPUT | MODE7 */
+			0x5c4 0x17	/* etk_d12.(null) gpio26 OUTPUT | MODE7 */
+			0x5c6 0x11b	/* etk_d13.hsusb2_nxt gpio27 INPUT_PULLUP | MODE3 */
+			0x5c8 0x114	/* etk_d14.gpio_28 gpio28 INPUT | MODE4 */
+			0x5ca 0x114	/* etk_d15.gpio_29 gpio29 INPUT | MODE4 */
+			0x5b0 0x7	/* etk_d2.(null) gpio16 OUTPUT | MODE7 */
+			0x5b2 0x7	/* etk_d3.(null) gpio17 OUTPUT | MODE7 */
+			0x5b4 0x17	/* etk_d4.(null) gpio18 OUTPUT | MODE7 */
+			0x5b6 0x7	/* etk_d5.(null) gpio19 OUTPUT | MODE7 */
+			0x5b8 0x7	/* etk_d6.(null) gpio20 OUTPUT | MODE7 */
+			0x5ba 0x7	/* etk_d7.(null) gpio21 OUTPUT | MODE7 */
+			0x5bc 0x7	/* etk_d8.(null) gpio22 OUTPUT | MODE7 */
+			0x5be 0x7	/* etk_d9.(null) gpio23 OUTPUT | MODE7 */
+			0x4a 0x0	/* gpmc_a1.gpmc_a1 gpio34 OUTPUT | MODE0 */
+			0x5c 0x411c	/* gpmc_a10.gpio_43 gpio43 INPUT_PULLUP | OFF_WAKEUPENABLE | MODE4 */
+			0x4c 0x0	/* gpmc_a2.gpmc_a2 gpio35 OUTPUT | MODE0 */
+			0x4e 0x0	/* gpmc_a3.gpmc_a3 gpio36 OUTPUT | MODE0 */
+			0x50 0x4	/* gpmc_a4.gpio_37 gpio37 OUTPUT | MODE4 */
+			0x52 0x7	/* gpmc_a5.safe_mode gpio38 OUTPUT | MODE7 */
+			0x54 0x7	/* gpmc_a6.safe_mode gpio39 OUTPUT | MODE7 */
+			0x56 0x4	/* gpmc_a7.gpio_40 gpio40 OUTPUT | MODE4 */
+			0x58 0x4	/* gpmc_a8.gpio_41 gpio41 OUTPUT | MODE4 */
+			0x5a 0x4104	/* gpmc_a9.gpio_42 gpio42 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x8e 0x100	/* gpmc_clk.gpmc_clk gpio59 INPUT | MODE0 */
+			0x72 0x100	/* gpmc_d10.gpmc_d10 gpio46 INPUT | MODE0 */
+			0x74 0x100	/* gpmc_d11.gpmc_d11 gpio47 INPUT | MODE0 */
+			0x76 0x100	/* gpmc_d12.gpmc_d12 gpio48 INPUT | MODE0 */
+			0x78 0x100	/* gpmc_d13.gpmc_d13 gpio49 INPUT | MODE0 */
+			0x7a 0x100	/* gpmc_d14.gpmc_d14 gpio50 INPUT | MODE0 */
+			0x7c 0x100	/* gpmc_d15.gpmc_d15 gpio51 INPUT | MODE0 */
+			0x6e 0x100	/* gpmc_d8.gpmc_d8 gpio44 INPUT | MODE0 */
+			0x70 0x100	/* gpmc_d9.gpmc_d9 gpio45 INPUT | MODE0 */
+			0x96 0x4	/* gpmc_nbe0_cle.gpio_60 gpio60 OUTPUT | MODE4 */
+			0x98 0x4104	/* gpmc_nbe1.gpio_61 gpio61 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x80 0x18	/* gpmc_ncs1.gpmc_ncs1 gpio52 OUTPUT | MODE0 */
+			0x82 0x410c	/* gpmc_ncs2.gpio_53 gpio53 INPUT_PULLDOWN | OFF_WAKEUPENABLE | MODE4 */
+			0x84 0x10c	/* gpmc_ncs3.gpio_54 gpio54 INPUT_PULLDOWN | MODE4 */
+			0x86 0x4104	/* gpmc_ncs4.gpio_55 gpio55 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x88 0x7	/* gpmc_ncs5.safe_mode gpio56 OUTPUT | MODE7 */
+			0x8a 0x7	/* gpmc_ncs6.safe_mode gpio57 OUTPUT | MODE7 */
+			0x8c 0x7	/* gpmc_ncs7.safe_mode gpio58 OUTPUT | MODE7 */
+			0x9a 0x104	/* gpmc_nwp.gpio_62 gpio62 INPUT | MODE4 */
+			0x9e 0x7	/* gpmc_wait1.safe_mode gpio63 OUTPUT | MODE7 */
+			0xa0 0x7	/* gpmc_wait2.safe_mode gpio64 OUTPUT | MODE7 */
+			0xa2 0x11c	/* gpmc_wait3.gpio_65 gpio65 INPUT_PULLUP | MODE4 */
+			0x196 0x7	/* hdq_sio.safe_mode gpio170 OUTPUT | MODE7 */
+			0x172 0x100	/* hsusb0_clk.hsusb0_clk gpio120 INPUT | MODE0 */
+			0x17a 0x100	/* hsusb0_data0.hsusb0_data0 gpio125 INPUT | MODE0 */
+			0x17c 0x100	/* hsusb0_data1.hsusb0_data1 gpio130 INPUT | MODE0 */
+			0x17e 0x100	/* hsusb0_data2.hsusb0_data2 gpio131 INPUT | MODE0 */
+			0x180 0x100	/* hsusb0_data3.hsusb0_data3 gpio169 INPUT | MODE0 */
+			0x182 0x100	/* hsusb0_data4.hsusb0_data4 gpio188 INPUT | MODE0 */
+			0x184 0x100	/* hsusb0_data5.hsusb0_data5 gpio189 INPUT | MODE0 */
+			0x186 0x100	/* hsusb0_data6.hsusb0_data6 gpio190 INPUT | MODE0 */
+			0x188 0x100	/* hsusb0_data7.hsusb0_data7 gpio191 INPUT | MODE0 */
+			0x176 0x100	/* hsusb0_dir.hsusb0_dir gpio122 INPUT | MODE0 */
+			0x178 0x100	/* hsusb0_nxt.hsusb0_nxt gpio124 INPUT | MODE0 */
+			0x174 0x0	/* hsusb0_stp.hsusb0_stp gpio121 OUTPUT | MODE0 */
+			0x18e 0x100	/* i2c2_scl.i2c2_scl gpio168 INPUT | MODE0 */
+			0x190 0x100	/* i2c2_sda.i2c2_sda gpio183 INPUT | MODE0 */
+			0x192 0x100	/* i2c3_scl.i2c3_scl gpio184 INPUT | MODE0 */
+			0x194 0x100	/* i2c3_sda.i2c3_sda gpio185 INPUT | MODE0 */
+			0x9d0 0x100	/* i2c4_scl.i2c4_scl gpio0 INPUT | MODE0 */
+			0x9d2 0x100	/* i2c4_sda.i2c4_sda gpio0 INPUT | MODE0 */
+			0x9f4 0x100	/* jtag_emu0.jtag_emu0 gpio11 INPUT | MODE0 */
+			0x9f6 0x100	/* jtag_emu1.jtag_emu1 gpio31 INPUT | MODE0 */
+			0x15c 0x109	/* mcbsp1_clkr.mcspi4_clk gpio156 INPUT_PULLDOWN | MODE1 */
+			0x168 0x14	/* mcbsp1_clkx.gpio_162 gpio162 OUTPUT | MODE4 */
+			0x162 0x109	/* mcbsp1_dr.mcspi4_somi gpio159 INPUT_PULLDOWN | MODE1 */
+			0x160 0x1	/* mcbsp1_dx.mcspi4_simo gpio158 OUTPUT | MODE1 */
+			0x15e 0x7	/* mcbsp1_fsr.safe_mode gpio157 OUTPUT | MODE7 */
+			0x166 0x1	/* mcbsp1_fsx.mcspi4_cs0 gpio161 OUTPUT | MODE1 */
+			0x10e 0x100	/* mcbsp2_clkx.mcbsp2_clkx gpio117 INPUT | MODE0 */
+			0x110 0x100	/* mcbsp2_dr.mcbsp2_dr gpio118 INPUT | MODE0 */
+			0x112 0x0	/* mcbsp2_dx.mcbsp2_dx gpio119 OUTPUT | MODE0 */
+			0x10c 0x100	/* mcbsp2_fsx.mcbsp2_fsx gpio116 INPUT | MODE0 */
+			0x140 0x100	/* mcbsp3_clkx.mcbsp3_clkx gpio142 INPUT | MODE0 */
+			0x13e 0x100	/* mcbsp3_dr.mcbsp3_dr gpio141 INPUT | MODE0 */
+			0x13c 0x0	/* mcbsp3_dx.mcbsp3_dx gpio140 OUTPUT | MODE0 */
+			0x142 0x100	/* mcbsp3_fsx.mcbsp3_fsx gpio143 INPUT | MODE0 */
+			0x154 0x101	/* mcbsp4_clkx.(null) gpio152 INPUT | MODE1 */
+			0x156 0x101	/* mcbsp4_dr.(null) gpio153 INPUT | MODE1 */
+			0x158 0x1	/* mcbsp4_dx.(null) gpio154 OUTPUT | MODE1 */
+			0x15a 0x1	/* mcbsp4_fsx.(null) gpio155 OUTPUT | MODE1 */
+			0x164 0x11c	/* mcbsp_clks.gpio_160 gpio160 INPUT_PULLUP | MODE4 */
+			0x198 0x100	/* mcspi1_clk.mcspi1_clk gpio171 INPUT | MODE0 */
+			0x19e 0x0	/* mcspi1_cs0.mcspi1_cs0 gpio174 OUTPUT | MODE0 */
+			0x1a0 0x7	/* mcspi1_cs1.safe_mode gpio175 OUTPUT | MODE7 */
+			0x1a2 0x0	/* mcspi1_cs2.mcspi1_cs2 gpio176 OUTPUT | MODE0 */
+			0x1a4 0x4114	/* mcspi1_cs3.gpio_177 gpio177 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x19a 0x0	/* mcspi1_simo.mcspi1_simo gpio172 OUTPUT | MODE0 */
+			0x19c 0x108	/* mcspi1_somi.mcspi1_somi gpio173 INPUT_PULLDOWN | MODE0 */
+			0x1a6 0x7	/* mcspi2_clk.safe_mode gpio178 OUTPUT | MODE7 */
+			0x1ac 0x4114	/* mcspi2_cs0.gpio_181 gpio181 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x1ae 0x14	/* mcspi2_cs1.gpio_182 gpio182 OUTPUT | MODE4 */
+			0x1a8 0x1	/* mcspi2_simo.gpt9_pwm_evt gpio179 OUTPUT | MODE1 */
+			0x1aa 0x4114	/* mcspi2_somi.gpio_180 gpio180 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x114 0x118	/* sdmmc1_clk.sdmmc1_clk gpio120 INPUT_PULLUP | MODE0 */
+			0x116 0x118	/* sdmmc1_cmd.sdmmc1_cmd gpio121 INPUT_PULLUP | MODE0 */
+			0x118 0x118	/* sdmmc1_dat0.sdmmc1_dat0 gpio122 INPUT_PULLUP | MODE0 */
+			0x11a 0x118	/* sdmmc1_dat1.sdmmc1_dat1 gpio123 INPUT_PULLUP | MODE0 */
+			0x11c 0x118	/* sdmmc1_dat2.sdmmc1_dat2 gpio124 INPUT_PULLUP | MODE0 */
+			0x11e 0x118	/* sdmmc1_dat3.sdmmc1_dat3 gpio125 INPUT_PULLUP | MODE0 */
+			0x120 0x7	/* sdmmc1_dat4.safe_mode gpio126 OUTPUT | MODE7 */
+			0x122 0x7	/* sdmmc1_dat5.safe_mode gpio127 OUTPUT | MODE7 */
+			0x124 0x7	/* sdmmc1_dat6.safe_mode gpio128 OUTPUT | MODE7 */
+			0x126 0x7	/* sdmmc1_dat7.safe_mode gpio129 OUTPUT | MODE7 */
+			0x128 0x118	/* sdmmc2_clk.sdmmc2_clk gpio130 INPUT_PULLUP | MODE0 */
+			0x12a 0x118	/* sdmmc2_cmd.sdmmc2_cmd gpio131 INPUT_PULLUP | MODE0 */
+			0x12c 0x118	/* sdmmc2_dat0.sdmmc2_dat0 gpio132 INPUT_PULLUP | MODE0 */
+			0x12e 0x118	/* sdmmc2_dat1.sdmmc2_dat1 gpio133 INPUT_PULLUP | MODE0 */
+			0x130 0x118	/* sdmmc2_dat2.sdmmc2_dat2 gpio134 INPUT_PULLUP | MODE0 */
+			0x132 0x118	/* sdmmc2_dat3.sdmmc2_dat3 gpio135 INPUT_PULLUP | MODE0 */
+			0x134 0x118	/* sdmmc2_dat4.sdmmc2_dat4 gpio136 INPUT_PULLUP | MODE0 */
+			0x136 0x118	/* sdmmc2_dat5.sdmmc2_dat5 gpio137 INPUT_PULLUP | MODE0 */
+			0x138 0x118	/* sdmmc2_dat6.sdmmc2_dat6 gpio138 INPUT_PULLUP | MODE0 */
+			0x13a 0x118	/* sdmmc2_dat7.sdmmc2_dat7 gpio139 INPUT_PULLUP | MODE0 */
+			0x232 0x100	/* sdrc_cke0.sdrc_cke0 gpio0 INPUT | MODE0 */
+			0x234 0x100	/* sdrc_cke1.sdrc_cke1 gpio0 INPUT | MODE0 */
+			0x9da 0x100	/* sys_boot0.sys_boot0 gpio2 INPUT | MODE0 */
+			0x9dc 0x100	/* sys_boot1.sys_boot1 gpio3 INPUT | MODE0 */
+			0x9de 0x100	/* sys_boot2.sys_boot2 gpio4 INPUT | MODE0 */
+			0x9e0 0x100	/* sys_boot3.sys_boot3 gpio5 INPUT | MODE0 */
+			0x9e2 0x100	/* sys_boot4.sys_boot4 gpio6 INPUT | MODE0 */
+			0x9e4 0x104	/* sys_boot5.gpio_7 gpio7 INPUT | MODE4 */
+			0x9e6 0x100	/* sys_boot6.sys_boot6 gpio8 INPUT | MODE0 */
+			0x9ea 0x17	/* sys_clkout1.safe_mode gpio10 OUTPUT | MODE7 */
+			0x1b2 0x17	/* sys_clkout2.safe_mode gpio186 OUTPUT | MODE7 */
+			0x9d6 0x0	/* sys_clkreq.sys_clkreq gpio1 OUTPUT | MODE0 */
+			0x1b0 0xc118	/* sys_nirq.sys_nirq gpio0 INPUT_PULLUP | OFF_WAKEUPENABLE | MODE0 */
+			0x9d8 0x118	/* sys_nreswarm.sys_nreswarm gpio30 INPUT_PULLUP | MODE0 */
+			0x9e8 0x0	/* sys_off_mode.sys_off_mode gpio9 OUTPUT | MODE0 */
+			0x150 0x111	/* uart1_cts.ssi1_rdy_tx gpio150 INPUT | MODE1 */
+			0x14e 0x1	/* uart1_rts.ssi1_flag_tx gpio149 OUTPUT | MODE1 */
+			0x152 0x4104	/* uart1_rx.gpio_151 gpio151 INPUT | OFF_WAKEUPENABLE | MODE4 */
+			0x14c 0x1	/* uart1_tx.ssi1_dat_tx gpio148 OUTPUT | MODE1 */
+			0x144 0x118	/* uart2_cts.uart2_cts gpio144 INPUT_PULLUP | MODE0 */
+			0x146 0x0	/* uart2_rts.uart2_rts gpio145 OUTPUT | MODE0 */
+			0x14a 0x100	/* uart2_rx.uart2_rx gpio147 INPUT | MODE0 */
+			0x148 0x0	/* uart2_tx.uart2_tx gpio146 OUTPUT | MODE0 */
+			0x16a 0x4	/* uart3_cts_rctx.gpio_163 gpio163 OUTPUT | MODE4 */
+			0x16c 0x4	/* uart3_rts_sd.gpio_164 gpio164 OUTPUT | MODE4 */
+			0x16e 0x100	/* uart3_rx_irrx.uart3_rx_irrx gpio165 INPUT | MODE0 */
+			0x170 0x0	/* uart3_tx_irtx.uart3_tx_irtx gpio166 OUTPUT | MODE0 */
+		>;
+	};
+};
\ No newline at end of file
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 597ade9..1acfd6c 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -129,8 +129,8 @@ void __init omap_generic_init(void)
 #if 1
 		regulator_use_dummy_regulator();
 
-		omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
 #if 0
+		omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
 		spi_register_board_info(rx51_peripherals_spi_board_info,
 				ARRAY_SIZE(rx51_peripherals_spi_board_info));
 #endif
diff --git a/dmesg.qemu b/dmesg.qemu
index 16267c5..a49d10e 100644
--- a/dmesg.qemu
+++ b/dmesg.qemu
@@ -117,11 +117,11 @@ Booting secondary
  OMAP GPIO hardware version 2.5

  platform 49022000.mcbsp: alias fck already exists

  platform 49024000.mcbsp: alias fck already exists

- omap_mux_init: Add partition: #1: core, flags: 4

  No ATAGs?

  hw-breakpoint: debug architecture 0x0 unsupported.

  OMAP DMA hardware revision 4.0

   arm-pmu: alias fck already exists

+ rx51_video_init cannot configure MUX for LCD RESET

  bio: create slab <bio-0> at 0

  omap-dma-engine omap-dma-engine: OMAP DMA engine driver

  usbcore: registered new interface driver usbfs

@@ -170,28 +170,6 @@ Booting secondary
  msgmni has been set to 489

  io scheduler noop registered

  io scheduler cfq registered (default)

-------------

- WARNING: at drivers/video/omap2/dss/dss.c:495 dss_set_clock_div+0x90/0xbc()

- clk rate mismatch

- Modules linked in:

- (warn_slowpath_common+0x4c/0x68)

- (warn_slowpath_fmt+0x30/0x40)

- (dss_set_clock_div+0x90/0xbc)

- (omap_dsshw_probe+0x220/0x348)

- (platform_drv_probe+0x1c/0x24)

- (driver_probe_device+0xc0/0x21c)

- (__driver_attach+0x60/0x84)

- (bus_for_each_dev+0x50/0x98)

- (bus_add_driver+0xc0/0x228)

- (driver_register+0xa4/0x144)

- (platform_driver_probe+0x18/0xa4)

- (omap_dss_init2+0x1c/0xb0)

- (do_one_initcall+0x94/0x15c)

- (kernel_init_freeable+0xe0/0x1b8)

- (kernel_init+0x8/0x15c)

- (ret_from_fork+0x14/0x3c)

----

- OMAP DSS rev 2.0

  Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled

  serial.10: ttyO0 at MMIO 0x4806a000 (irq = 88) is a OMAP UART0

  serial.11: ttyO1 at MMIO 0x4806c000 (irq = 89) is a OMAP UART1

@@ -202,7 +180,6 @@ Booting secondary
  OneNAND driver initializing

  omap-dma-engine omap-dma-engine: allocating channel for 40

  omap-dma-engine omap-dma-engine: allocating channel for 39

- acx565akm spi1.2: omapfb: acx565akm rev 12 LCD detected

  OMAP SSI hw driver loaded

   port0: No Wake in support

  musb-hdrc: version 6.0, ?dma?, otg (peripheral+host)

@@ -228,10 +205,58 @@ Booting secondary
  Bootup reason: pwr_key

  OMAP GPIO switch handler initializing

  registered taskstats version 1

- Console: switching to colour frame buffer device 100x30

- VPLL2: disabling

- drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

- ALSA device list:

-   No soundcards found.

- Waiting for root device /dev/mmcblk0p6...

+ Unable to handle kernel NULL pointer dereference at virtual address 00000014

+ pgd = c0004000

+ *pgd=00000000

+ PREEMPT ARM

+ Modules linked in:

+ CPU: 0    Not tainted  (3.9.0+ #143)

+ PC is at dss_feat_get_num_ovls+0x8/0x14

+ LR is at omapdss_compat_init+0x34/0x2b8

+    psr: 60000153

+ sp : cf847db8  ip : c0773c90  fp : c07be280

+ r10: c0748528  r9 : 00000000  r8 : c07be28c

+ r7 : cf81c010  r6 : 00000000  r5 : c0773c90  r4 : c081701c

+ r3 : 00000000  r2 : c0816eac  r1 : 00000000  r0 : c079cb38

+ Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel

+ Control: 10c53c7d  Table: 80004059  DAC: 00000015

+ Process swapper (pid: 1, stack limit = 0xcf846238)

+ Stack: (0xcf847db8 to 0xcf848000)

+ 7da0:                                                       c0773c90 c081701c

+ 7dc0: c0773c90 00000000 cf81c010 c07be28c 00000000 c0748528 c07be280 c07485e4

+ 7de0: c0809800 000000b6 00000009 cf847e34 36215305 cf831950 c0773c90 c0773c80

+ 7e00: cfac5ec0 00000000 cf8dcc40 c014905c cf8dcbc0 cfac5ec0 cf847e70 c01493d4

+ 7e20: 0000a1ff cfac5e80 cf847e34 c01495d4 00000000 cfac5cc0 cfac5ec0 cf847e70

+ 7e40: 00000000 c0149490 00000000 cfac5ec0 cfab7f00 00000000 cf8dcbc0 c014a620

+ 7e60: 00000000 c0059034 00000000 c07be28c cf8dcbc0 00000000 00000000 c0773c90

+ 7e80: c0773c90 00000000 c079cd3c c07be28c 00000000 c0748528 c07be280 c02ba920

+ 7ea0: 00000000 c02b95c0 c07a1d00 c0773c90 c0773cc4 c079cd3c c079cd3c c02b977c

+ 7ec0: 00000000 c02b971c cf847ed0 c02b7e5c cf83a34c cf8d4b30 cfab7f34 cfab7f00

+ 7ee0: c079cd28 c079cd3c c07a1d00 c02b8644 c066c9d1 c07656fc c0765700 c0765700

+ 7f00: c079cd28 c079cd3c 0000007e c02b9da8 c07be280 c0765700 c079cd28 00000008

+ 7f20: 0000007e c02baca4 c0765700 c075a944 00000008 c074853c c07656f8 c00087d0

+ 7f40: c0702e14 c0a22b1c 00000000 00000007 c0765700 c075a944 00000008 0000007e

+ 7f60: c07be28c c075a904 c072a36c c072a294 00000007 00000007 c072a36c 00000000

+ 7f80: cf846000 00000000 c052afd0 00000000 00000000 00000000 00000000 00000000

+ 7fa0: 00000000 c052afd8 00000000 c000db18 00000000 00000000 00000000 00000000

+ 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

+ 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000

+ (omapdss_compat_init+0x34/0x2b8)

+ (omapfb_probe+0x80/0x10c8)

+ (platform_drv_probe+0x1c/0x24)

+ (driver_probe_device+0xc0/0x21c)

+ (__driver_attach+0x60/0x84)

+ (bus_for_each_dev+0x50/0x98)

+ (bus_add_driver+0xc0/0x228)

+ (driver_register+0xa4/0x144)

+ (platform_driver_probe+0x18/0xa4)

+ (omapfb_init+0x14/0x3c)

+ (do_one_initcall+0x94/0x15c)

+ (kernel_init_freeable+0xe0/0x1b8)

+ (kernel_init+0x8/0x15c)

+ (ret_from_fork+0x14/0x3c)

+ Code: e12fff1e c08159f0 e59f3008 e5933000 (e5930014) 

+---

+ Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

+ 

 



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
