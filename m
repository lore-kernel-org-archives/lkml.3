Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbbAWOo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:44:26 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64945 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbAWOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:44:23 -0500
MIME-Version: 1.0
In-Reply-To: <1422010236.3017.12.camel@pengutronix.de>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
	<1420655248.3191.73.camel@pengutronix.de>
	<20150123025643.GA11412@victor>
	<1422010236.3017.12.camel@pengutronix.de>
Date: Fri, 23 Jan 2015 12:44:21 -0200
Message-ID: <CAOMZO5AjsjW=F7_8yS03uBtq0qKMmmNYUn-5Z+KGXOnm4up2RQ@mail.gmail.com>
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

On Fri, Jan 23, 2015 at 8:50 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:

> What are this panel timings? The adjustment should increase the vertical
> back porch by up to two lines (so it is at least two lines), reducing
> the front porch or vsync length by the same amount. Does this panel use
> the HSYNC/VSYNC signals embedded in the LVDS stream?

The panel on this board is a Hannstar HSD100PXN1. The timings we use
are described in imx6qdl-sabresd.dtsi:

        display-timings {
            native-mode = <&timing0>;
            timing0: hsd100pxn1 {
                clock-frequency = <65000000>;
                hactive = <1024>;
                vactive = <768>;
                hback-porch = <220>;
                hfront-porch = <40>;
                vback-porch = <21>;
                vfront-porch = <7>;
                hsync-len = <60>;
                vsync-len = <10>;
            };
