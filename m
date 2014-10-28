Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaJ1Qht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:37:49 -0400
Received: from mail-bn1on0097.outbound.protection.outlook.com ([157.56.110.97]:3360
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753727AbaJ1Qhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:37:47 -0400
Date: Tue, 28 Oct 2014 09:37:32 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Lothar =?utf-8?Q?Wa=C3=9Fmann?= <LW@KARO-electronics.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 1/8] pinctrl: Add driver for Zynq
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
 <1413479495-14206-2-git-send-email-soren.brinkmann@xilinx.com>
 <20141028161656.6fb55199@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141028161656.6fb55199@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21058.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <ed83381607d7493bafde4b881b37a3ab@BN1BFFO11FD017.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(199003)(377424004)(24454002)(189002)(51704005)(107046002)(104016003)(47776003)(77096002)(106466001)(46102003)(85306004)(80022003)(108616004)(85182001)(110136001)(87936001)(20776003)(33646002)(95666004)(53416004)(44976005)(6806004)(19580395003)(64706001)(83506001)(120916001)(76176999)(86362001)(4396001)(102836001)(50986999)(99396003)(50466002)(85202003)(21056001)(74316001)(19580405001)(31966008)(85852003)(23676002)(76482002)(92566001)(54356999)(107986001)(24736002)(217873001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB004;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:3;LANG:;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB004;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 04:16PM +0100, Lothar Waßmann wrote:
> Hi,
> 
> Soren Brinkmann wrote:
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > changes since RFC:
> >  - use syscon/regmap to access registers in SLCR space
> >  - add pinctrl to zc702 DT
> >  - rebase to 3.18: rename enable -> set_mux
> >  - add kernel-doc
> >  - support pinconf
> >    - supported attributes
> >      - pin-bias: pull up, tristate, disable
> >      - slew-rate: 0 == slow, 1 == fast; generic pinconf does not display
> >        argument
> > 
> [...]
> > +struct zynq_pctrl_group zynq_pctrl_groups[] = {
> > +	DEFINE_ZYNQ_PINCTRL_GRP(ethernet0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(ethernet1_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(mdio0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(mdio1_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(qspi0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(qspi1_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(qspi_fbclk),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(qspi_cs1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(spi0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(spi0_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(spi0_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(spi1_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(spi1_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(spi1_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(spi1_3),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio0_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio0_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_3),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio0_emio_wp),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio0_emio_cd),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_emio_wp),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(sdio1_emio_cd),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(smc0_nor),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(smc0_nor_cs1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(smc0_nor_addr25),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(smc0_nand),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_3),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_4),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_5),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_6),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_7),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_8),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_9),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can0_10),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_3),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_4),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_5),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_6),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_7),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_8),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_9),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_10),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(can1_11),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_3),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_4),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_5),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_6),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_7),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_8),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_9),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart0_10),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_3),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_4),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_5),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_6),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_7),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_8),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_9),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_10),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(uart1_11),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_3),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_4),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_5),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_6),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_7),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_8),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_9),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c0_10),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_3),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_4),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_5),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_6),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_7),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_8),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_9),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(i2c1_10),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(ttc0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(ttc0_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(ttc0_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(ttc1_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(ttc1_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(ttc1_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(swdt0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(swdt0_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(swdt0_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(swdt0_3),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(swdt0_4),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_0),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_1),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_2),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_3),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_4),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_5),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_6),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_7),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_8),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_9),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_10),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_11),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_12),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_13),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_14),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_15),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_16),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_17),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_18),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_19),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_20),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_21),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_22),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_23),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_24),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_25),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_26),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_27),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_28),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_29),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_30),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_31),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_32),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_33),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_34),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_35),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_36),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_37),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_38),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_39),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_40),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_41),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_42),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_43),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_44),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_45),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_46),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_47),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_48),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_49),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_50),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_51),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_52),
> > +	DEFINE_ZYNQ_PINCTRL_GRP(gpio0_53)
> dto.
> 
> [...]
> > +#define DEFINE_ZYNQ_PINMUX_FUNCTION(fname, mval)	\
> > +	[ZYNQ_PMUX_##fname] = {				\
> > +		.name = #fname,				\
> > +		.groups = fname##_groups,		\
> > +		.ngroups = ARRAY_SIZE(fname##_groups),	\
> > +		.mux_val = mval				\
> > +	}
> > +
> dto.
> 
> [...]
> > +#define DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(fname, mval, mux, mask, shift)	\
> > +	[ZYNQ_PMUX_##fname] = {				\
> > +		.name = #fname,				\
> > +		.groups = fname##_groups,		\
> > +		.ngroups = ARRAY_SIZE(fname##_groups),	\
> > +		.mux_val = mval,			\
> > +		.mux_mask = mask,			\
> > +		.mux_shift = shift			\
> dto.
> 
> [...]
> > +static const struct zynq_pinmux_function zynq_pmux_functions[] = {
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(ethernet0, 1),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(ethernet1, 1),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(mdio0, 0x40),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(mdio1, 0x50),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(qspi0, 1),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(qspi1, 1),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(qspi_fbclk, 1),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(qspi_cs1, 1),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(spi0, 0x50),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(spi1, 0x50),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(sdio0, 0x40),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(sdio0_pc, 0xc),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio0_wp, 0, 130, ZYNQ_SDIO_WP_MASK,
> > +					ZYNQ_SDIO_WP_SHIFT),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio0_cd, 0, 130, ZYNQ_SDIO_CD_MASK,
> > +					ZYNQ_SDIO_CD_SHIFT),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(sdio1, 0x40),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(sdio1_pc, 0xc),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio1_wp, 0, 134, ZYNQ_SDIO_WP_MASK,
> > +					ZYNQ_SDIO_WP_SHIFT),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio1_cd, 0, 134, ZYNQ_SDIO_CD_MASK,
> > +					ZYNQ_SDIO_CD_SHIFT),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nor, 4),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nor_cs1, 8),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nor_addr25, 4),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nand, 8),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(can0, 0x10),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(can1, 0x10),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(uart0, 0x70),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(uart1, 0x70),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(i2c0, 0x20),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(i2c1, 0x20),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(ttc0, 0x60),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(ttc1, 0x60),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(swdt0, 0x30),
> > +	DEFINE_ZYNQ_PINMUX_FUNCTION(gpio0, 0)
> dto.
> 
> [...]
> > +static const struct pinctrl_ops zynq_pctrl_ops = {
> > +	.get_groups_count = zynq_pctrl_get_groups_count,
> > +	.get_group_name = zynq_pctrl_get_group_name,
> > +	.get_group_pins = zynq_pctrl_get_group_pins,
> > +	.dt_node_to_map = pinconf_generic_dt_node_to_map_group,
> > +	.dt_free_map = pinctrl_utils_dt_free_map
> dto.

Can we please use full sentences? But at least real words? I have no
idea what you're trying to tell me.

	Thanks,
	Sören
