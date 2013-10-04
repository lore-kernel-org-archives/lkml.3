Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3JDAaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 20:30:52 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1653 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab3JDAap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 20:30:45 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Sherman Yin" <syin@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Christian Daudt" <bcm@fixthebug.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>
cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        "Sherman Yin" <syin@broadcom.com>
Subject: [PATCH 2/4] pinctrl: Add pinctrl binding for Broadcom Capri
 SoCs
Date: Thu, 3 Oct 2013 17:23:17 -0700
Message-ID: <1380846199-12829-3-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380846199-12829-1-git-send-email-syin@broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E50D3AD2L891410616-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds pinctrl driver devicetree binding for Broadcom Capri (BCM281xx) SoCs.

Signed-off-by: Sherman Yin <syin@broadcom.com>
Reviewed-by: Christian Daudt <bcm@fixthebug.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 .../bindings/pinctrl/brcm,capri-pinctrl.txt        |  419 ++++++++++++++++++++
 1 file changed, 419 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt
new file mode 100644
index 0000000..79e0e5a
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt
@@ -0,0 +1,419 @@
+Broadcom Capri Pin Controller
+
+This is a pin controller for the Broadcom BCM281xx SoC family, which includes
+BCM11130, BCM11140, BCM11351, BCM28145, and BCM28155 SoCs.
+
+=== Pin Controller Node ===
+
+Required Properties:
+
+- compatible:	Must be "brcm,capri-pinctrl".
+- reg:		Base address of the PAD Controller register block and the size
+		of the block.
+
+For example, the following is the bare minimum node:
+
+	pinctrl@35004800 {
+		compatible = "brcm,capri-pinctrl";
+		reg = <0x35004800 0x430>;
+	};
+
+As a Pin Controller Device, in addition to the required properties, this node
+should also contain the pin configuration nodes that client devices reference,
+if any.
+
+=== Pin Configuration Node ===
+
+Each pin configuration node is a sub-node of the pin controller node and is a
+container of an arbitrary number of subnodes, called group nodes.
+
+Please refer to the pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the definition of a
+"pin configuration node".
+
+=== Group Node ===
+
+A group node specifies the desired pin mux and/or pin configuration for an
+arbitrary number of pins.  The group node only affect the properties specified
+in the node, and has no effect on any properties that are omitted.
+
+The names of the group nodes are optional and not used. The group nodes have
+the following properties:
+
+Required Properties:
+
+- brcm,pins:	Multiple strings.  Specifies the name(s) of one or more pins to
+		be configured by this node.
+
+Optional Properties:
+
+- brcm,function: Multiple strings.  Specifies the pin mux selection.  Values are:
+		"alt1", "alt2", "alt3", "alt4"
+- brcm,hysteresis: Multiple integers, applicable to standard pins only.  Turns
+		on hysteresis of input.
+		0: TTL input, 1: Schmitt Trigger input
+- brcm,pull:	Multiple integers, applicable to standard pins only.  Specifies
+		pull-up or pull-down.
+		0: neither, 1: pull-up, 2: pull-down, 3: both
+- brcm,input_dis: Multiple integers, applicable to all pins.  Input disable
+		control.
+		0: off, 1: input disabled
+- brcm,slew:	Multiple integers.  Slew rate of output.
+		0: fast output, 1: normal output (most pins)
+		0: normal output, 1: fast output (IC_DM and IC_DP)
+		0: Fast mode, 1: High speed mode (I2C)
+- brcm,drive_str: Multiple integers.  Drive strength.
+		0: 2 mA
+		1: 4 mA
+		2: 6 mA
+		3: 8 mA
+		4: 10 mA
+		5: 12 mA
+		6: 14 mA
+		7: 16 mA
+- brcm,pull_up_str: Multiple integers.  Pull Up strength.
+		0: No pull-up
+		1: 1.2 kOhm
+		2: 1.8 kOhm
+		3: 720 Ohm
+		4: 2.7 kOhm
+		5: 831 Ohm
+		6: 1.08 kOhm
+		7: 568 Ohm
+- brcm,mode:	Multiple integers.  Mode select.
+		0: Fast mode, 1: High Speed mode (I2C)
+
+Any optional property must have 1 or n values, where n is the number of pins
+specified in the brcm,pins property:
+- If 1 value is specified for a property, this value is applied to all pins
+  listed in the brcm,pins property.
+- If n values are specified, the i th value is applied to the i th pin, where
+  i is the index in the array of values and pins, and (0 <= i < n).  This
+  provides an easy way to set different values for different pins in the same
+  group.
+
+Example:
+
+	// pin configuration node
+	dev_a_active {
+		//group node
+		grp_1 {
+			brcm,pins	= "pin1", "pin2", "pin3";
+			brcm,function	= "alt1";
+			brcm,drive_str	= <2 4 6>;
+			brcm,slew	= <1>;
+		};
+
+		grp_2 {
+			...
+		};
+
+		...
+	};
+
+In the example above, "dev_a_active" is a pin configuration node and has a
+number of sub-nodes.  In the group node "grp_1", 3 pins are defined in the
+"brcm,pins" property.  Thus, any optional properties must have either 1 or 3
+values.  The "brcm,function" property has only one value, "alt1", therefore the
+pin mux selection for all 3 pins is "alt1".  Similarly, "brcm,slew" has only one
+value, <1>, so all 3 pins are configured with a slew rate setting of <1>.
+"brcm,drive_str" has 3 values, and they are applied in the same order of the pins
+listed in "brcm,pins": the drive strength of "pin1" is set to <2>, <4> for
+"pin2", and <6> for "pin3".  Finally, no other parameters are sepcified,
+implying no changes to any other parameters for these pins.
+
+=== Pin Names and Type ===
+
+There are 3 types of pins in the BCM281xx SoC family, each type can be
+configured by different properties in a group node.  The following is a list of
+node properties applicable to different pin types.
+
+Standard pins:
+- brcm,function
+- brcm,hysteresis
+- brcm,pull
+- brcm,input_dis
+- brcm,slew
+- brcm,drive_str
+
+I2C pins:
+- brcm,function
+- brcm,input_dis
+- brcm,slew
+- brcm,pull_up_str
+
+HDMI pins:
+- brcm,function
+- brcm,input_dis
+- brcm,mode
+
+The following are valid pin names and their pin types:
+
+	"adcsync",		std
+	"bat_rm",		std
+	"bsc1_scl",		i2c
+	"bsc1_sda",		i2c
+	"bsc2_scl",		i2c
+	"bsc2_sda",		i2c
+	"classgpwr",		std
+	"clk_cx8",		std
+	"clkout_0",		std
+	"clkout_1",		std
+	"clkout_2",		std
+	"clkout_3",		std
+	"clkreq_in_0",		std
+	"clkreq_in_1",		std
+	"cws_sys_req1",		std
+	"cws_sys_req2",		std
+	"cws_sys_req3",		std
+	"digmic1_clk",		std
+	"digmic1_dq",		std
+	"digmic2_clk",		std
+	"digmic2_dq",		std
+	"gpen13",		std
+	"gpen14",		std
+	"gpen15",		std
+	"gpio00",		std
+	"gpio01",		std
+	"gpio02",		std
+	"gpio03",		std
+	"gpio04",		std
+	"gpio05",		std
+	"gpio06",		std
+	"gpio07",		std
+	"gpio08",		std
+	"gpio09",		std
+	"gpio10",		std
+	"gpio11",		std
+	"gpio12",		std
+	"gpio13",		std
+	"gpio14",		std
+	"gps_pablank",		std
+	"gps_tmark",		std
+	"hdmi_scl",		hdmi
+	"hdmi_sda",		hdmi
+	"ic_dm",		std
+	"ic_dp",		std
+	"kp_col_ip_0",		std
+	"kp_col_ip_1",		std
+	"kp_col_ip_2",		std
+	"kp_col_ip_3",		std
+	"kp_row_op_0",		std
+	"kp_row_op_1",		std
+	"kp_row_op_2",		std
+	"kp_row_op_3",		std
+	"lcd_b_0",		std
+	"lcd_b_1",		std
+	"lcd_b_2",		std
+	"lcd_b_3",		std
+	"lcd_b_4",		std
+	"lcd_b_5",		std
+	"lcd_b_6",		std
+	"lcd_b_7",		std
+	"lcd_g_0",		std
+	"lcd_g_1",		std
+	"lcd_g_2",		std
+	"lcd_g_3",		std
+	"lcd_g_4",		std
+	"lcd_g_5",		std
+	"lcd_g_6",		std
+	"lcd_g_7",		std
+	"lcd_hsync",		std
+	"lcd_oe",		std
+	"lcd_pclk",		std
+	"lcd_r_0",		std
+	"lcd_r_1",		std
+	"lcd_r_2",		std
+	"lcd_r_3",		std
+	"lcd_r_4",		std
+	"lcd_r_5",		std
+	"lcd_r_6",		std
+	"lcd_r_7",		std
+	"lcd_vsync",		std
+	"mdmgpio0",		std
+	"mdmgpio1",		std
+	"mdmgpio2",		std
+	"mdmgpio3",		std
+	"mdmgpio4",		std
+	"mdmgpio5",		std
+	"mdmgpio6",		std
+	"mdmgpio7",		std
+	"mdmgpio8",		std
+	"mphi_data_0",		std
+	"mphi_data_1",		std
+	"mphi_data_2",		std
+	"mphi_data_3",		std
+	"mphi_data_4",		std
+	"mphi_data_5",		std
+	"mphi_data_6",		std
+	"mphi_data_7",		std
+	"mphi_data_8",		std
+	"mphi_data_9",		std
+	"mphi_data_10",		std
+	"mphi_data_11",		std
+	"mphi_data_12",		std
+	"mphi_data_13",		std
+	"mphi_data_14",		std
+	"mphi_data_15",		std
+	"mphi_ha0",		std
+	"mphi_hat0",		std
+	"mphi_hat1",		std
+	"mphi_hce0_n",		std
+	"mphi_hce1_n",		std
+	"mphi_hrd_n",		std
+	"mphi_hwr_n",		std
+	"mphi_run0",		std
+	"mphi_run1",		std
+	"mtx_scan_clk",		std
+	"mtx_scan_data",	std
+	"nand_ad_0",		std
+	"nand_ad_1",		std
+	"nand_ad_2",		std
+	"nand_ad_3",		std
+	"nand_ad_4",		std
+	"nand_ad_5",		std
+	"nand_ad_6",		std
+	"nand_ad_7",		std
+	"nand_ale",		std
+	"nand_cen_0",		std
+	"nand_cen_1",		std
+	"nand_cle",		std
+	"nand_oen",		std
+	"nand_rdy_0",		std
+	"nand_rdy_1",		std
+	"nand_wen",		std
+	"nand_wp",		std
+	"pc1",			std
+	"pc2",			std
+	"pmu_int",		std
+	"pmu_scl",		i2c
+	"pmu_sda",		i2c
+	"rfst2g_mtsloten3g",	std
+	"rgmii_0_rx_ctl",	std
+	"rgmii_0_rxc",		std
+	"rgmii_0_rxd_0",	std
+	"rgmii_0_rxd_1",	std
+	"rgmii_0_rxd_2",	std
+	"rgmii_0_rxd_3",	std
+	"rgmii_0_tx_ctl",	std
+	"rgmii_0_txc",		std
+	"rgmii_0_txd_0",	std
+	"rgmii_0_txd_1",	std
+	"rgmii_0_txd_2",	std
+	"rgmii_0_txd_3",	std
+	"rgmii_1_rx_ctl",	std
+	"rgmii_1_rxc",		std
+	"rgmii_1_rxd_0",	std
+	"rgmii_1_rxd_1",	std
+	"rgmii_1_rxd_2",	std
+	"rgmii_1_rxd_3",	std
+	"rgmii_1_tx_ctl",	std
+	"rgmii_1_txc",		std
+	"rgmii_1_txd_0",	std
+	"rgmii_1_txd_1",	std
+	"rgmii_1_txd_2",	std
+	"rgmii_1_txd_3",	std
+	"rgmii_gpio_0",		std
+	"rgmii_gpio_1",		std
+	"rgmii_gpio_2",		std
+	"rgmii_gpio_3",		std
+	"rtxdata2g_txdata3g1",	std
+	"rtxen2g_txdata3g2",	std
+	"rxdata3g0",		std
+	"rxdata3g1",		std
+	"rxdata3g2",		std
+	"sdio1_clk",		std
+	"sdio1_cmd",		std
+	"sdio1_data_0",		std
+	"sdio1_data_1",		std
+	"sdio1_data_2",		std
+	"sdio1_data_3",		std
+	"sdio4_clk",		std
+	"sdio4_cmd",		std
+	"sdio4_data_0",		std
+	"sdio4_data_1",		std
+	"sdio4_data_2",		std
+	"sdio4_data_3",		std
+	"sim_clk",		std
+	"sim_data",		std
+	"sim_det",		std
+	"sim_resetn",		std
+	"sim2_clk",		std
+	"sim2_data",		std
+	"sim2_det",		std
+	"sim2_resetn",		std
+	"sri_c",		std
+	"sri_d",		std
+	"sri_e",		std
+	"ssp_extclk",		std
+	"ssp0_clk",		std
+	"ssp0_fs",		std
+	"ssp0_rxd",		std
+	"ssp0_txd",		std
+	"ssp2_clk",		std
+	"ssp2_fs_0",		std
+	"ssp2_fs_1",		std
+	"ssp2_fs_2",		std
+	"ssp2_fs_3",		std
+	"ssp2_rxd_0",		std
+	"ssp2_rxd_1",		std
+	"ssp2_txd_0",		std
+	"ssp2_txd_1",		std
+	"ssp3_clk",		std
+	"ssp3_fs",		std
+	"ssp3_rxd",		std
+	"ssp3_txd",		std
+	"ssp4_clk",		std
+	"ssp4_fs",		std
+	"ssp4_rxd",		std
+	"ssp4_txd",		std
+	"ssp5_clk",		std
+	"ssp5_fs",		std
+	"ssp5_rxd",		std
+	"ssp5_txd",		std
+	"ssp6_clk",		std
+	"ssp6_fs",		std
+	"ssp6_rxd",		std
+	"ssp6_txd",		std
+	"stat_1",		std
+	"stat_2",		std
+	"sysclken",		std
+	"traceclk",		std
+	"tracedt00",		std
+	"tracedt01",		std
+	"tracedt02",		std
+	"tracedt03",		std
+	"tracedt04",		std
+	"tracedt05",		std
+	"tracedt06",		std
+	"tracedt07",		std
+	"tracedt08",		std
+	"tracedt09",		std
+	"tracedt10",		std
+	"tracedt11",		std
+	"tracedt12",		std
+	"tracedt13",		std
+	"tracedt14",		std
+	"tracedt15",		std
+	"txdata3g0",		std
+	"txpwrind",		std
+	"uartb1_ucts",		std
+	"uartb1_urts",		std
+	"uartb1_urxd",		std
+	"uartb1_utxd",		std
+	"uartb2_urxd",		std
+	"uartb2_utxd",		std
+	"uartb3_ucts",		std
+	"uartb3_urts",		std
+	"uartb3_urxd",		std
+	"uartb3_utxd",		std
+	"uartb4_ucts",		std
+	"uartb4_urts",		std
+	"uartb4_urxd",		std
+	"uartb4_utxd",		std
+	"vc_cam1_scl",		i2c
+	"vc_cam1_sda",		i2c
+	"vc_cam2_scl",		i2c
+	"vc_cam2_sda",		i2c
+	"vc_cam3_scl",		i2c
+	"vc_cam3_sda",		i2c
-- 
1.7.9.5


