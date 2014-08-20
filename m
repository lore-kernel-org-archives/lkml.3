Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaHTUcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:32:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50261 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaHTUcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:32:00 -0400
Date: Wed, 20 Aug 2014 15:31:57 -0500
From: Andy Gross <agross@codeaurora.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linus.walleij@linaro.org, galak@codeaurora.org,
        bjorn.andersson@sonymobile.com, robh+dt@kernel.org,
        mark.rutland@arm.com, grant.likely@linaro.org, sboyd@codeaurora.org,
        iivanov@mm-sol.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1 1/3] pinctrl: qcom: Add APQ8084 pinctrl support
Message-ID: <20140820203157.GB14731@qualcomm.com>
References: <1408468936-12252-1-git-send-email-gdjakov@mm-sol.com>
 <1408468936-12252-2-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408468936-12252-2-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 08:22:14PM +0300, Georgi Djakov wrote:
> This patch adds support for the TLMM (Top-Level Mode Mux) block found
> in the APQ8084 platform.

Comment in-line

<snip>

> +	PINCTRL_PIN(134, "GPIO_134"),
> +	PINCTRL_PIN(135, "GPIO_135"),
> +	PINCTRL_PIN(136, "GPIO_136"),
> +	PINCTRL_PIN(137, "GPIO_137"),
> +	PINCTRL_PIN(138, "GPIO_138"),
> +	PINCTRL_PIN(139, "GPIO_139"),
> +	PINCTRL_PIN(140, "GPIO_140"),
> +	PINCTRL_PIN(141, "GPIO_141"),
> +	PINCTRL_PIN(142, "GPIO_142"),

Add in the missing pins

+	PINCTRL_PIN(142, "GPIO_143"),
+	PINCTRL_PIN(142, "GPIO_144"),
+	PINCTRL_PIN(142, "GPIO_145"),
+	PINCTRL_PIN(142, "GPIO_146"),

> +
> +	PINCTRL_PIN(143, "SDC1_CLK"),
> +	PINCTRL_PIN(144, "SDC1_CMD"),
> +	PINCTRL_PIN(145, "SDC1_DATA"),
> +	PINCTRL_PIN(146, "SDC2_CLK"),
> +	PINCTRL_PIN(147, "SDC2_CMD"),
> +	PINCTRL_PIN(148, "SDC2_DATA"),

Shift down to accomodate 4 pins

+	PINCTRL_PIN(147, "SDC1_CLK"),
+	PINCTRL_PIN(148, "SDC1_CMD"),
+	PINCTRL_PIN(149, "SDC1_DATA"),
+	PINCTRL_PIN(150, "SDC2_CLK"),
+	PINCTRL_PIN(151, "SDC2_CMD"),
+	PINCTRL_PIN(152, "SDC2_DATA"),

> +};
> +
> +#define DECLARE_APQ_GPIO_PINS(pin) static const unsigned int gpio##pin##_pins[] = { pin }
> +

<snip>

> +DECLARE_APQ_GPIO_PINS(138);
> +DECLARE_APQ_GPIO_PINS(139);
> +DECLARE_APQ_GPIO_PINS(140);
> +DECLARE_APQ_GPIO_PINS(141);
> +DECLARE_APQ_GPIO_PINS(142);

+DECLARE_APQ_GPIO_PINS(143);
+DECLARE_APQ_GPIO_PINS(144);
+DECLARE_APQ_GPIO_PINS(145);
+DECLARE_APQ_GPIO_PINS(146);

> +
> +static const unsigned int sdc1_clk_pins[] = { 143 };
> +static const unsigned int sdc1_cmd_pins[] = { 144 };
> +static const unsigned int sdc1_data_pins[] = { 145 };
> +static const unsigned int sdc2_clk_pins[] = { 146 };
> +static const unsigned int sdc2_cmd_pins[] = { 147 };
> +static const unsigned int sdc2_data_pins[] = { 148 };

+static const unsigned int sdc1_clk_pins[] = { 147 };
+static const unsigned int sdc1_cmd_pins[] = { 148 };
+static const unsigned int sdc1_data_pins[] = { 149 };
+static const unsigned int sdc2_clk_pins[] = { 150 };
+static const unsigned int sdc2_cmd_pins[] = { 151 };
+static const unsigned int sdc2_data_pins[] = { 152 };


> +
> +#define FUNCTION(fname)					\
> +	[APQ_MUX_##fname] = {				\
> +		.name = #fname,				\

<snip>

> +	"gpio64", "gpio65", "gpio66", "gpio67", "gpio68", "gpio69", "gpio70",
> +	"gpio71", "gpio72", "gpio73", "gpio74", "gpio75", "gpio76", "gpio77",
> +	"gpio78", "gpio79", "gpio80", "gpio81", "gpio82", "gpio83", "gpio84",
> +	"gpio85", "gpio86", "gpio87", "gpio88", "gpio89", "gpio90", "gpio91",
> +	"gpio92", "gpio93", "gpio94", "gpio95", "gpio96", "gpio97", "gpio98",
> +	"gpio99", "gpio100", "gpio101", "gpio102", "gpio103", "gpio104",
> +	"gpio105", "gpio106", "gpio107", "gpio108", "gpio109", "gpio110",
> +	"gpio111", "gpio112", "gpio113", "gpio114", "gpio115", "gpio116",
> +	"gpio117", "gpio118", "gpio119", "gpio120", "gpio121", "gpio122",
> +	"gpio123", "gpio124", "gpio125", "gpio126", "gpio127", "gpio128",
> +	"gpio129", "gpio130", "gpio131", "gpio132", "gpio133", "gpio134",
> +	"gpio135", "gpio136", "gpio137", "gpio138", "gpio139", "gpio140",
> +	"gpio141", "gpio142"

Add in extra pins

<snip>

> +	FUNCTION(cam_mclk3),
> +	FUNCTION(cci_async),
> +	FUNCTION(cci_async_in0),
> +	FUNCTION(cci_i2c),

split into cci_i2c0 and cci_i2c1

> +	FUNCTION(cci_timer0),
> +	FUNCTION(cci_timer1),
> +	FUNCTION(cci_timer2),
> +	FUNCTION(cci_timer3),
> +	FUNCTION(cci_timer4),
> +	FUNCTION(dll_sdc10),
> +	FUNCTION(dll_sdc11),
> +	FUNCTION(dll_sdc20),
> +	FUNCTION(dll_sdc21),
> +	FUNCTION(edp_hot),

change this to edp_hpd

> +	FUNCTION(edp_tpa),
> +	FUNCTION(gcc_gp1),
> +	FUNCTION(gcc_gp1_clk_b),

this isnt used

> +	FUNCTION(gcc_gp2),
> +	FUNCTION(gcc_gp2_clk_b),

this isnt used

> +	FUNCTION(gcc_gp3),
> +	FUNCTION(gcc_gp3_clk_b),

this isnt used

> +	FUNCTION(gcc_obt),
> +	FUNCTION(gcc_vtt),
> +	FUNCTION(gp_mn),
> +	FUNCTION(gp_pdm),
> +	FUNCTION(gp_pdm_0a),
> +	FUNCTION(gp_pdm_2a),
> +	FUNCTION(gp_pdm_1b),
> +	FUNCTION(gp_pdm_2b),

Drop a and b, there is no collision on the same pin, so unnecessary

> +	FUNCTION(gp0_clk),
> +	FUNCTION(gp1_clk),
> +	FUNCTION(gpio),
> +	FUNCTION(hdmi_cec),
> +	FUNCTION(hdmi_ddc),
> +	FUNCTION(hdmi_dtest),
> +	FUNCTION(hdmi_hot),

change this to hdmi_hpd

> +	FUNCTION(hdmi_rcv),
> +	FUNCTION(hsic),
> +	FUNCTION(ldo_en),
> +	FUNCTION(ldo_update),
> +	FUNCTION(mdp_vsync),
> +	FUNCTION(pci_e0),
> +	FUNCTION(pci_e0_rst),
> +	FUNCTION(pci_e1),
> +	FUNCTION(pci_e1_rst),
> +	FUNCTION(pci_e1_rst_n),
> +	FUNCTION(pci_e1_clkreq_n),
> +	FUNCTION(pri_mi2s),
> +	FUNCTION(qdss_cti),
> +	FUNCTION(qdss_cti_trig_out_a),
> +	FUNCTION(qdss_cti_trig_in_a),
> +	FUNCTION(qdss_cti_trig_in_b),
> +	FUNCTION(qdss_cti_trig_in_c),
> +	FUNCTION(qdss_cti_trig_out_c),

Drop all the qdss

> +	FUNCTION(qua_mi2s),
> +	FUNCTION(sata_act),
> +	FUNCTION(sata_devsleep),
> +	FUNCTION(sata_devsleep_n),
> +	FUNCTION(sd_write),

<snip>

> +	FUNCTION(uim_batt),
> +	FUNCTION(uim_clk),
> +	FUNCTION(uim_data),
> +	FUNCTION(uim_present),
> +	FUNCTION(uim_reset),

combine all the uim functions into one function uim.

> +};
> +
> +static const struct msm_pingroup apq8084_groups[] = {
> +	PINGROUP(0,   blsp_spi1, blsp_uart1, blsp_uim1, NA, NA, NA, NA),
> +	PINGROUP(1,   blsp_spi1, blsp_uart1, blsp_uim1, NA, NA, NA, NA),

<snip>

> +	PINGROUP(18,  cam_mclk3, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(19,  cci_i2c, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(20,  cci_i2c, NA, NA, NA, NA, NA, NA),

Maybe make this cci_i2c0 for this pair

> +	PINGROUP(21,  cci_i2c, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(22,  cci_i2c, NA, NA, NA, NA, NA, NA),

cci_i2c1 for this pair

> +	PINGROUP(23,  cci_timer0, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(24,  cci_timer1, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(25,  cci_timer2, gp0_clk, NA, NA, NA, NA, NA),
> +	PINGROUP(26,  cci_timer3, cci_async, gp1_clk, NA, NA, NA, NA),
> +	PINGROUP(27,  blsp_spi4, blsp_uart4, blsp_uim4, NA, NA, NA, NA),
> +	PINGROUP(28,  blsp_spi4, blsp_uart4, blsp_uim4, NA, NA, NA, NA),
> +	PINGROUP(29,  blsp_spi4, blsp_uart4, blsp_i2c4, gp_mn, NA, NA, NA),
> +	PINGROUP(30,  blsp_spi4, blsp_uart4, blsp_i2c4, NA, NA, NA, NA),
> +	PINGROUP(31,  hdmi_cec, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(32,  hdmi_ddc, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(33,  hdmi_ddc, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(34,  hdmi_hot, NA, adsp_ext, NA, NA, NA, NA),

maybe use hdmi_hpd instead.  Makes it more consistent with other pinctrls

> +	PINGROUP(35,  NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(36,  NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(37,  gcc_gp1, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(38,  gcc_gp2, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(39,  blsp_spi5, blsp_uart5, blsp_uim5, NA, NA, NA, NA),
> +	PINGROUP(40,  blsp_spi5, blsp_uart5, blsp_uim5, NA, NA, NA, NA),
> +	PINGROUP(41,  blsp_spi5, blsp_uart5, blsp_i2c5, NA, NA, NA, NA),
> +	PINGROUP(42,  blsp_spi5, blsp_uart5, blsp_i2c5, NA, NA, NA, NA),
> +	PINGROUP(43,  blsp_spi6, blsp_uart6, blsp_uim6, NA, NA, NA, NA),
> +	PINGROUP(44,  blsp_spi6, blsp_uart6, blsp_uim6, NA, NA, NA, NA),
> +	PINGROUP(45,  blsp_spi6, blsp_uart6, blsp_i2c6, NA, NA, NA, NA),
> +	PINGROUP(46,  blsp_spi6, blsp_uart6, blsp_i2c6, NA, NA, NA, NA),
> +	PINGROUP(47,  blsp_spi12, blsp_uart12, blsp_uim12, NA, NA, NA, NA),
> +	PINGROUP(48,  blsp_spi12, blsp_uart12, blsp_uim12, gp_pdm, NA, NA, NA),

should be gp_pdm0

> +	PINGROUP(49,  blsp_spi12, blsp_uart12, blsp_i2c12, NA, NA, NA, NA),
> +	PINGROUP(50,  blsp_spi12, blsp_uart12, blsp_i2c12, NA, NA, NA, NA),
> +	PINGROUP(51,  blsp_spi8, blsp_uart8, blsp_uim8, qdss_cti, NA, NA, NA),
> +	PINGROUP(52,  blsp_spi8, blsp_uart8, blsp_uim8, qdss_cti, NA, NA, NA),

Out of curiosity, none of the other qdss stuff is in here, why this
specifically?

> +	PINGROUP(53,  blsp_spi8, blsp_uart8, blsp_i2c8, NA, NA, NA, NA),
> +	PINGROUP(54,  blsp_spi8, blsp_uart8, blsp_i2c8, NA, NA, NA, NA),

<snip>

> +	PINGROUP(59,  blsp_spi10, blsp_uart10, blsp_uim10, NA, NA, NA, dll_sdc11),
> +	PINGROUP(60,  blsp_spi10, blsp_uart10, blsp_uim10, NA, NA, NA, dll_sdc10),
> +	PINGROUP(61,  blsp_spi10, blsp_uart10, blsp_i2c10, dll_sdc21, NA, NA, NA),
> +	PINGROUP(62,  blsp_spi10, blsp_uart10, blsp_i2c10, dll_sdc20, NA, NA, NA),
dll_scdxx are test pins, why include them?

> +	PINGROUP(63,  blsp_spi11, blsp_uart11, blsp_uim11, NA, qdss_cti, NA, NA),
> +	PINGROUP(64,  blsp_spi11, blsp_uart11, blsp_uim11, qdss_cti, NA, NA, NA),

why include qdss?

> +	PINGROUP(65,  blsp_spi11, blsp_uart11, blsp_i2c11, NA, NA, NA, NA),
> +	PINGROUP(66,  blsp_spi11, blsp_uart11, blsp_i2c11, NA, NA, NA, NA),
> +	PINGROUP(67,  sdc3, blsp3_spi, NA, NA, NA, NA, NA),

blsp3_spi needs to be blsp3_spi_cs1

> +	PINGROUP(68,  sdc3, pci_e0, NA, NA, NA, NA, NA),
> +	PINGROUP(69,  sdc3, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(70,  sdc3, pci_e0, pci_e0, NA, NA, NA, NA),

In previous pinctrls, we've done one group for active high and one group for
active low of the same signal.  If you follow that, one would be pci_e0 and the
other would be pci_e0_n.  You need to have them different groups.

> +	PINGROUP(71,  sdc3, blsp3_spi, NA, NA, NA, NA, NA),

needs to be blsp_spi3_cs2

> +	PINGROUP(72,  sdc3, blsp3_spi, NA, NA, NA, NA, NA),

needs to be blsp_spi3_cs3

> +	PINGROUP(73,  NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(74,  NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(75,  sd_write, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(76,  pri_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(77,  pri_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(78,  pri_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(79,  pri_mi2s, NA, NA, NA, qdss_cti, NA, NA),
> +	PINGROUP(80,  pri_mi2s, NA, NA, NA, qdss_cti, NA, NA),

don't need the qdss_cti

> +	PINGROUP(81,  sec_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(82,  sec_mi2s, sdc4, tsif1, NA, NA, NA, NA),
> +	PINGROUP(83,  sec_mi2s, sdc4, tsif1, NA, NA, NA, gp_pdm),

should be gp_pdm0

> +	PINGROUP(84,  sec_mi2s, sdc4, tsif1, NA, NA, NA, gp_pdm),

should be gp_pdm1

> +	PINGROUP(85,  sec_mi2s, sdc4, tsif1, NA, gp_pdm, NA, NA),

should be gp_pdm2

> +	PINGROUP(86,  ter_mi2s, sdc4, tsif1, NA, NA, NA, gcc_gp3),
> +	PINGROUP(87,  ter_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(88,  ter_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(89,  ter_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(90,  ter_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(91,  qua_mi2s, sdc4, tsif2, NA, NA, NA, NA),
> +	PINGROUP(92,  qua_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(93,  qua_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(94,  qua_mi2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(95,  qua_mi2s, sdc4, tsif2, NA, NA, NA, gcc_gp1),
> +	PINGROUP(96,  qua_mi2s, sdc4, tsif2, NA, NA, NA, gcc_gp2),
> +	PINGROUP(97,  qua_mi2s, sdc4, tsif2, NA, gcc_gp3, NA, NA),
> +	PINGROUP(98,  slimbus, spkr_i2s, NA, NA, NA, NA, NA),
> +	PINGROUP(99,  slimbus, spkr_i2s, NA, NA, NA, NA, NA),
> +	PINGROUP(100, audio_ref, spkr_i2s, NA, NA, NA, NA, NA),
> +	PINGROUP(101, sdc4, tsif2, gp_pdm, NA, NA, NA, NA),

should be gp_pdm1

> +	PINGROUP(102, uim_batt, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(103, edp_hot, NA, NA, NA, NA, NA, NA),

change to edp_hpd

> +	PINGROUP(104, spkr_i2s, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(105, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(106, blsp10_spi, NA, NA, NA, NA, NA, NA),

should be blsp_spi10_cs1

> +	PINGROUP(107, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(108, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(109, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(110, gp_pdm, NA, NA, NA, NA, NA, NA),

should be gp_pdm2

> +	PINGROUP(111, blsp10_spi, NA, NA, NA, NA, NA, NA),

should be blsp_spi10_cs2

> +	PINGROUP(112, blsp11_uart, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(113, blsp11_uart, NA, NA, NA, NA, NA, NA),

The above 2 need to be blsp_uart11

> +	PINGROUP(114, blsp11_i2c, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(115, blsp11_i2c, NA, NA, NA, NA, NA, NA),

The above 2 need to be blsp_i2c11

> +	PINGROUP(116, blsp1_spi, NA, NA, NA, NA, NA, NA),

needs to be blsp_spi1_cs1

> +	PINGROUP(117, blsp1_spi, NA, NA, NA, NA, NA, NA),

needs to be blsp_spi1_cs2

> +	PINGROUP(118, blsp1_spi, NA, NA, NA, NA, NA, NA),

Above 3 need to be blsp_spi3

> +	PINGROUP(119, cci_timer4, cci_async, sata_devsleep, sata_devsleep, NA, NA, NA),

sata_devsleep can't be used twice.  How about sata_sleep and sata_sleep_n, where
sata_sleep_n denotes active low?

> +	PINGROUP(120, cci_async, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(121, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(122, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(123, hdmi_dtest, qdss_cti, NA, NA, NA, NA, NA),

Do we need qdss?

> +	PINGROUP(124, spdif_tx, ldo_en, qdss_cti, edp_tpa, NA, NA, NA),

not sure we need qdss or edp.  i think these might be test

> +	PINGROUP(125, ldo_update, hdmi_rcv, NA, NA, NA, NA, NA),
> +	PINGROUP(126, gcc_vtt, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(127, gcc_obt, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(128, blsp10_spi, NA, NA, NA, NA, NA, NA),

needs to be blsp_spi10_cs3

> +	PINGROUP(129, sata_act, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(130, uim_data, blsp_spi7, blsp_uart7, blsp_uim7, NA, NA, NA),
> +	PINGROUP(131, uim_clk, blsp_spi7, blsp_uart7, blsp_uim7, NA, NA, NA),
> +	PINGROUP(132, uim_present, blsp_spi7, blsp_uart7, blsp_i2c7, NA, NA, NA),
> +	PINGROUP(133, uim_reset, blsp_spi7, blsp_uart7, blsp_i2c7, NA, NA, NA),

Above 4 uim_XXX might be shortened to uim

> +	PINGROUP(134, hsic, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(135, hsic, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(136, spdif_tx, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(137, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(138, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(139, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(140, pci_e1_rst_n, pci_e1_rst, NA, NA, NA, NA, NA),
> +	PINGROUP(141, pci_e1_clkreq_n, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(142, spdif_tx, NA, NA, NA, NA, NA, NA),

+	PINGROUP(143, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(144, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(145, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(146, sdc_emmc_mode, NA, NA, NA, NA, NA, NA),

> +
> +	SDC_PINGROUP(sdc1_clk, 0x2044, 13, 6),
> +	SDC_PINGROUP(sdc1_cmd, 0x2044, 11, 3),
> +	SDC_PINGROUP(sdc1_data, 0x2044, 9, 0),
> +	SDC_PINGROUP(sdc2_clk, 0x2048, 14, 6),
> +	SDC_PINGROUP(sdc2_cmd, 0x2048, 11, 3),
> +	SDC_PINGROUP(sdc2_data, 0x2048, 9, 0),
> +};
> +
> +#define NUM_GPIO_PINGROUPS 143

+#define NUM_GPIO_PINGROUPS 147

<snip>


So add the relevant groups/functions mentioned above to match up to the previous
pinctrl drivers.  This makes it consistent across the different chips to the
extent that we can make it consistent.


-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
