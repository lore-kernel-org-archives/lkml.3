Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3LGBXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:23:49 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:50023 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3LGBXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:23:48 -0500
MIME-Version: 1.0
In-Reply-To: <20131206.162606.2277176361893801778.davem@davemloft.net>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-3-git-send-email-wens@csie.org> <20131206.162606.2277176361893801778.davem@davemloft.net>
From: Chen-Yu Tsai <wens@csie.org>
Date: Sat, 7 Dec 2013 09:23:27 +0800
X-Google-Sender-Auth: 5rok_OUY0loEbXcrfy1uQwk3Tf4
Message-ID: <CAGb2v67ZNtbQm+ZW5v_3wNbz1=oLhXks6gbTSjLYa=Nnoz8w-A@mail.gmail.com>
Subject: Re: [PATCH 02/10] net: stmmac: Honor DT parameter to force DMA store
 and forward mode
To: David Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        "rob.herring" <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        "maxime.ripard" <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending reply due to incorrect MIME type.

On Sat, Dec 7, 2013 at 5:26 AM, David Miller <davem@davemloft.net> wrote:
>
> From: Chen-Yu Tsai <wens@csie.org>
> Date: Sat,  7 Dec 2013 01:29:35 +0800
>
> > @@ -47,6 +47,7 @@ static int stmmac_probe_config_dt(struct platform_device *pdev,
> >               plat->bus_id = 0;
> >
> >       of_property_read_u32(np, "snps,phy-addr", &plat->phy_addr);
> > +     plat->force_sf_dma_mode = of_property_read_bool(np, "snps,force_sf_dma_mode");
>
> Will this do the right thing for when the property is not present?
> Right now the force_sf_dma_mode value is always false.

of_property_read_bool will return false when the property is not present.

> In fact won't it override the explicit settings done elsewhere in the
> driver?

Point taken. The current implementation will override settings passed from
platform data. ORing the two would be better.


Thanks
