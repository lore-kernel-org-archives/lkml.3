Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbbAYNsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:48:40 -0500
Received: from smtp-3.sys.kth.se ([130.237.48.192]:51507 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbbAYNsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:48:38 -0500
X-KTH-Auth: niso [89.233.231.155]
X-KTH-mail-from: niso@kth.se
Date: Sun, 25 Jan 2015 14:48:23 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niso@kth.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH v2 2/4] sh-pfc: Add emev2 pinmux support
Message-ID: <20150125134823.GA26657@bigcity.berto.se>
References: <1421583604-27256-1-git-send-email-niso@kth.se>
 <1421583604-27256-3-git-send-email-niso@kth.se>
 <1564701.sT8vso17XV@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564701.sT8vso17XV@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for your comments.

As note in your comments I have not grouped pins in groups where I have
been uncertain if they can be used independently or not. I have read
your input and made a v3 of the patch which address better grouping.

I am a bit uncertain on how to best submit the updated patch. I will
send just v3 of 2/4 to this thread. If you wish for me to send the
complete series fresh let me. If I am to send the complete series once
more do I add the 'Acked-by' to 1/4 and 3/4 or not?

--
Regards
// Niklas

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [2015-01-23 00:37:33 +0200]:

> Hi Niklas,
>
> Thank you for the patch.
>
> I see that you've quickly taken my remarks into account, great work. Please
> see below for a couple more comments.
>
> On Sunday 18 January 2015 13:20:02 Niklas Söderlund wrote:
> > Add PFC support for the EMMA Mobile EV2 SoC including pin groups for
> > on-chip devices.
> >
> > Signed-off-by: Niklas Söderlund <niso@kth.se>
> > ---
> >  .../bindings/pinctrl/renesas,pfc-pinctrl.txt       |    1 +
> >  drivers/pinctrl/sh-pfc/Kconfig                     |    5 +
> >  drivers/pinctrl/sh-pfc/Makefile                    |    1 +
> >  drivers/pinctrl/sh-pfc/core.c                      |    9 +
> >  drivers/pinctrl/sh-pfc/core.h                      |    1 +
> >  drivers/pinctrl/sh-pfc/pfc-emev2.c                 | 1774 +++++++++++++++++
> >  6 files changed, 1791 insertions(+)
> >  create mode 100644 drivers/pinctrl/sh-pfc/pfc-emev2.c
>
> [snip]
>
> > diff --git a/drivers/pinctrl/sh-pfc/pfc-emev2.c
> > b/drivers/pinctrl/sh-pfc/pfc-emev2.c new file mode 100644
> > index 0000000..2d2ac21
> > --- /dev/null
> > +++ b/drivers/pinctrl/sh-pfc/pfc-emev2.c
> > @@ -0,0 +1,1774 @@
> > +/*
> > + * Pin Function Controller Support
> > + *
> > + * Copyright (C) 2014 Niklas Söderlund
>
> Happy new year ;-)
>
> [snip]
>
> > +#define EMEV_MUX_PIN(name, pin, mark) \
> > +	static const unsigned int name##_pins[] = { pin }; \
> > +	static const unsigned int name##_mux[] = { mark##_MARK }
> > +
> > +/* = [ System ] =========== */
> > +EMEV_MUX_PIN(err_rst_reqb, 3, ERR_RST_REQB);
> > +EMEV_MUX_PIN(ref_clko, 4, REF_CLKO);
> > +EMEV_MUX_PIN(ext_clki, 5, EXT_CLKI);
> > +EMEV_MUX_PIN(lowpwr, 154, LOWPWR);
> > +
> > +/* = [ External Memory] === */
>
> I don't have much information on the external memory bus, would it make sense
> to group some of the pins ? I expect that at AB_AD[15:0] will always be
> needed. Maybe AB_RDB and AB_WRB too, unless someone want to interface with
> read-only or write-only memory maybe ?
>
> > +EMEV_MUX_PIN(ab_clk, 68, AB_CLK);
> > +EMEV_MUX_PIN(ab_csb0, 69, AB_CSB0);
> > +EMEV_MUX_PIN(ab_csb1, 70, AB_CSB1);
> > +EMEV_MUX_PIN(ab_csb2, 71, AB_CSB2);
> > +EMEV_MUX_PIN(ab_csb3, 72, AB_CSB3);
> > +EMEV_MUX_PIN(ab_rdb, 73, AB_RDB);
> > +EMEV_MUX_PIN(ab_wrb, 74, AB_WRB);
> > +EMEV_MUX_PIN(ab_wait, 75, AB_WAIT);
> > +EMEV_MUX_PIN(ab_adv, 76, AB_ADV);
> > +EMEV_MUX_PIN(ab_ad0, 77, AB_AD0);
> > +EMEV_MUX_PIN(ab_ad1, 78, AB_AD1);
> > +EMEV_MUX_PIN(ab_ad2, 79, AB_AD2);
> > +EMEV_MUX_PIN(ab_ad3, 80, AB_AD3);
> > +EMEV_MUX_PIN(ab_ad4, 81, AB_AD4);
> > +EMEV_MUX_PIN(ab_ad5, 82, AB_AD5);
> > +EMEV_MUX_PIN(ab_ad6, 83, AB_AD6);
> > +EMEV_MUX_PIN(ab_ad7, 84, AB_AD7);
> > +EMEV_MUX_PIN(ab_ad8, 85, AB_AD8);
> > +EMEV_MUX_PIN(ab_ad9, 86, AB_AD9);
> > +EMEV_MUX_PIN(ab_ad10, 87, AB_AD10);
> > +EMEV_MUX_PIN(ab_ad11, 88, AB_AD11);
> > +EMEV_MUX_PIN(ab_ad12, 89, AB_AD12);
> > +EMEV_MUX_PIN(ab_ad13, 90, AB_AD13);
> > +EMEV_MUX_PIN(ab_ad14, 91, AB_AD14);
> > +EMEV_MUX_PIN(ab_ad15, 92, AB_AD15);
> > +EMEV_MUX_PIN(ab_a17, 93, AB_A17);
> > +EMEV_MUX_PIN(ab_a18, 94, AB_A18);
> > +EMEV_MUX_PIN(ab_a19, 95, AB_A19);
> > +EMEV_MUX_PIN(ab_a20, 96, AB_A20);
> > +EMEV_MUX_PIN(ab_a21, 97, AB_A21);
> > +EMEV_MUX_PIN(ab_a22, 98, AB_A22);
> > +EMEV_MUX_PIN(ab_a23, 99, AB_A23);
> > +EMEV_MUX_PIN(ab_a24, 100, AB_A24);
> > +EMEV_MUX_PIN(ab_a25, 101, AB_A25);
> > +EMEV_MUX_PIN(ab_a26, 102, AB_A26);
> > +EMEV_MUX_PIN(ab_a27, 103, AB_A27);
> > +EMEV_MUX_PIN(ab_a28, 104, AB_A28);
> > +EMEV_MUX_PIN(ab_ben0, 103, AB_BEN0);
> > +EMEV_MUX_PIN(ab_ben1, 104, AB_BEN1);
> > +
> > +/* = [ CAM ] ============== */
> > +static const unsigned int cam_ctrl_pins[] = {
> > +	/* CLKO, CLKI, VS, HS */
>
> The datasheet mentions the CLKO signal but doesn't document it further. I
> believe it's optional, in which case it should be moved to a separate group.
> All the other signals (control and data) can be grouped together, as they
> can't be used separately.
>
> > +	131, 132, 133, 134,
> > +};
> > +static const unsigned int cam_ctrl_mux[] = {
> > +	CAM_CLKO_MARK, CAM_CLKI_MARK, CAM_VS_MARK, CAM_HS_MARK,
> > +};
> > +
> > +static const unsigned int cam_data_pins[] = {
> > +	/* CAM_YUV[0:7] */
> > +	135, 136, 137, 138,
> > +	139, 140, 141, 142,
> > +};
> > +static const unsigned int cam_data_mux[] = {
> > +	CAM_YUV0_MARK, CAM_YUV1_MARK, CAM_YUV2_MARK, CAM_YUV3_MARK,
> > +	CAM_YUV4_MARK, CAM_YUV5_MARK, CAM_YUV6_MARK, CAM_YUV7_MARK,
> > +};
>
> [snip]
>
> > +/* = [ JTAG ] ============= */
> > +EMEV_MUX_PIN(jt_sel, 2, JT_SEL);
> > +EMEV_MUX_PIN(jt_tdo, 151, JT_TDO);
> > +EMEV_MUX_PIN(jt_tdoen, 152, JT_TDOEN);
>
> Can the JTAG port signals be used independently ? If they always need to be
> used together you can combine the pins into a single group.
>
> [snip]
>
> > +/* = [ TP33 ] ============= */
>
> Can the trace port control and data signals be used independently ? If they
> always need to be used together you can combine the pins into a single group.
>
> > +static const unsigned int tp33_ctrl_pins[] = {
> > +	/* CLK, CTRL */
> > +	38, 39,
> > +};
> > +static const unsigned int tp33_ctrl_mux[] = {
> > +	TP33_CLK_MARK, TP33_CTRL_MARK,
> > +};
> > +
> > +static const unsigned int tp33_data_pins[] = {
> > +	/* TP33_DATA[0:15] */
> > +	40, 41, PIN_NUMBER(2, 17), PIN_NUMBER(3, 17),
> > +	PIN_NUMBER(4, 17), PIN_NUMBER(2, 16), PIN_NUMBER(3, 16),
> > +	PIN_NUMBER(4, 16),
> > +	42, 43, PIN_NUMBER(2, 15), PIN_NUMBER(3, 15),
> > +	PIN_NUMBER(4, 15), PIN_NUMBER(2, 14), PIN_NUMBER(3, 14),
> > +	PIN_NUMBER(4, 14),
> > +};
> > +static const unsigned int tp33_data_mux[] = {
> > +	TP33_DATA0_MARK, TP33_DATA1_MARK, TP33_DATA2_MARK, TP33_DATA3_MARK,
> > +	TP33_DATA4_MARK, TP33_DATA5_MARK, TP33_DATA6_MARK, TP33_DATA7_MARK,
> > +	TP33_DATA8_MARK, TP33_DATA9_MARK, TP33_DATA10_MARK, TP33_DATA11_MARK,
> > +	TP33_DATA12_MARK, TP33_DATA13_MARK, TP33_DATA14_MARK, TP33_DATA15_MARK,
> > +};
>
> [snip]
>
> > +/* = [ USI0 ] ============== */
> > +EMEV_MUX_PIN(usi0_cs1, 105, USI0_CS1);
> > +EMEV_MUX_PIN(usi0_cs2, 106, USI0_CS2);
> > +EMEV_MUX_PIN(usi0_cs3, 115, USI0_CS3);
> > +EMEV_MUX_PIN(usi0_cs4, 116, USI0_CS4);
> > +EMEV_MUX_PIN(usi0_cs5, 117, USI0_CS5);
> > +EMEV_MUX_PIN(usi0_cs6, 118, USI0_CS6);
> > +
> > +/* = [ USI1 ] ============== */
> > +static const unsigned int usi1_ctrl_pins[] = {
>
> Those are data pins, shouldn't the group be named usi1_data ?
>
> > +	/* DI, DO*/
> > +	107, 108,
> > +};
> > +static const unsigned int usi1_ctrl_mux[] = {
> > +	USI1_DI_MARK, USI1_DO_MARK,
> > +};
> > +
> > +/* = [ USI2 ] ============== */
> > +static const unsigned int usi2_ctrl_pins[] = {
>
> Same here, although there's also a clock pin.
>
> Same comment for usi[345]_ctrl* below.
>
> > +	/* CLK, DI, DO*/
> > +	109, 110, 111,
> > +};
> > +static const unsigned int usi2_ctrl_mux[] = {
> > +	USI2_CLK_MARK, USI2_DI_MARK, USI2_DO_MARK,
> > +};
>
> [snip]
>
> > +/* = [ YUV ] ============== */
>
> I believe the clock input is optional, but I think the clock output, data and
> synchronization signals should be part of the same group as they can't be used
> separately. You could also declare those groups as part of the LCD function,
> as the pins are used for LCD output.
>
> > +EMEV_MUX_PIN(yuv3_clk_o, 18, YUV3_CLK_O);
> > +EMEV_MUX_PIN(yuv3_clk_i, 20, YUV3_CLK_I);
> > +
> > +static const unsigned int yuv3_sync_pins[] = {
> > +	/* HS, VS, DE */
> > +	21, 22, 23,
> > +};
> > +static const unsigned int yuv3_sync_mux[] = {
> > +	YUV3_HS_MARK, YUV3_VS_MARK, YUV3_DE_MARK,
> > +};
> > +
> > +static const unsigned int yuv3_data_pins[] = {
> > +	/* YUV3_D[0:15] */
> > +	40, 41, PIN_NUMBER(2, 17), PIN_NUMBER(3, 17),
> > +	PIN_NUMBER(4, 17), PIN_NUMBER(2, 16), PIN_NUMBER(3, 16),
> > +	PIN_NUMBER(4, 16),
> > +	42, 43, PIN_NUMBER(2, 15), PIN_NUMBER(3, 15),
> > +	PIN_NUMBER(4, 15), PIN_NUMBER(2, 14), PIN_NUMBER(3, 14),
> > +	PIN_NUMBER(4, 14),
> > +};
> > +static const unsigned int yuv3_data_mux[] = {
> > +	YUV3_D0_MARK, YUV3_D1_MARK, YUV3_D2_MARK, YUV3_D3_MARK,
> > +	YUV3_D4_MARK, YUV3_D5_MARK, YUV3_D6_MARK, YUV3_D7_MARK,
> > +	YUV3_D8_MARK, YUV3_D9_MARK, YUV3_D10_MARK, YUV3_D11_MARK,
> > +	YUV3_D12_MARK, YUV3_D13_MARK, YUV3_D14_MARK, YUV3_D15_MARK,
> > +};
>
> --
> Regards,
>
> Laurent Pinchart
>
