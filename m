Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbbAWQjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:39:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37788 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbbAWQjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:39:18 -0500
Message-ID: <1422031150.3017.39.camel@pengutronix.de>
Subject: Re: [PATCH v2 0/7] imx-drm: ipuv3-crtc: Implement mode_fixup
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
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
Date: Fri, 23 Jan 2015 17:39:10 +0100
In-Reply-To: <CAOMZO5D=wXFswNggf7PCK2iWsQEaO0XoUTaTV-vEUMA4VgS_2A@mail.gmail.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
	 <1420655248.3191.73.camel@pengutronix.de> <20150123025643.GA11412@victor>
	 <CAOMZO5AYKbq34j2VnZKWqSBVfJgoOOhZX+mPgnMwZ1mzBAKGJQ@mail.gmail.com>
	 <1422029904.3017.37.camel@pengutronix.de>
	 <CAOMZO5D=wXFswNggf7PCK2iWsQEaO0XoUTaTV-vEUMA4VgS_2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 23.01.2015, 14:27 -0200 schrieb Fabio Estevam:
> Hi Philipp,
> 
> On Fri, Jan 23, 2015 at 2:18 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > @@ -281,6 +267,9 @@ static void imx_ldb_encoder_mode_set(struct drm_encoder *encoder,
> >         struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
> >         struct imx_ldb *ldb = imx_ldb_ch->ldb;
> >         int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
> > +       unsigned long serial_clk;
> > +       unsigned long di_clk = mode->clock * 1000;
> > +       int mux = imx_ldb_get_mux_id(imx_ldb_ch);
> 
> I can't find imx_ldb_get_mux_id() on linux-next.

Sorry, that should be

	int mux = imx_drm_encoder_get_mux_id(imx_ldb_ch->child, encoder);

regards
Philipp

