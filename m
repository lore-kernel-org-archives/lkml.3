Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbbAWQ1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:27:43 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:61224 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbbAWQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:27:40 -0500
MIME-Version: 1.0
In-Reply-To: <1422029904.3017.37.camel@pengutronix.de>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
	<1420655248.3191.73.camel@pengutronix.de>
	<20150123025643.GA11412@victor>
	<CAOMZO5AYKbq34j2VnZKWqSBVfJgoOOhZX+mPgnMwZ1mzBAKGJQ@mail.gmail.com>
	<1422029904.3017.37.camel@pengutronix.de>
Date: Fri, 23 Jan 2015 14:27:40 -0200
Message-ID: <CAOMZO5D=wXFswNggf7PCK2iWsQEaO0XoUTaTV-vEUMA4VgS_2A@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] imx-drm: ipuv3-crtc: Implement mode_fixup
From: Fabio Estevam <festevam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Liu Ying <Ying.Liu@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Denis Carikli <denis@eukrea.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Fri, Jan 23, 2015 at 2:18 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> @@ -281,6 +267,9 @@ static void imx_ldb_encoder_mode_set(struct drm_encoder *encoder,
>         struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
>         struct imx_ldb *ldb = imx_ldb_ch->ldb;
>         int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
> +       unsigned long serial_clk;
> +       unsigned long di_clk = mode->clock * 1000;
> +       int mux = imx_ldb_get_mux_id(imx_ldb_ch);

I can't find imx_ldb_get_mux_id() on linux-next.
