Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaD0LeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 07:34:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:43655 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaD0LeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 07:34:06 -0400
Date: Sun, 27 Apr 2014 13:33:59 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv3 07/14] HSI: Add common DT binding for HSI client devices
Message-ID: <20140427113358.GB2092@earth.universe>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-8-git-send-email-sre@kernel.org>
 <20140419191612.GG5148@amd.pavel.ucw.cz>
 <20140425182535.GB22721@earth.universe>
 <20140425205926.GA30032@earth.universe>
 <20140427105755.GA12265@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <20140427105755.GA12265@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 27, 2014 at 12:57:55PM +0200, Pavel Machek wrote:
> On Fri 2014-04-25 22:59:27, Sebastian Reichel wrote:
> > On Fri, Apr 25, 2014 at 08:25:36PM +0200, Sebastian Reichel wrote:
> > > On Sat, Apr 19, 2014 at 09:16:12PM +0200, Pavel Machek wrote:
> > > > On Sat 2014-03-29 01:31:43, Sebastian Reichel wrote:
> > > > > Implement and document generic DT bindings for HSI clients.
> > > > >=20
> > > > > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > > >=20
> > > > Reviewed-by: Pavel Machek <pavel@ucw.cz>
> > > >=20
> > > > > diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
> > > > > index 07e1639..5973906 100644
> > > > > --- a/drivers/hsi/hsi.c
> > > > > +++ b/drivers/hsi/hsi.c
> > > > > @@ -26,8 +26,14 @@
> > > > >  #include <linux/slab.h>
> > > > >  #include <linux/string.h>
> > > > >  #include <linux/notifier.h>
> > > > > +#include <linux/of.h>
> > > > > +#include <linux/of_device.h>
> > > > >  #include "hsi_core.h"
> > > >=20
> > > >=20
> > > > > +	err =3D hsi_of_property_parse_mode(client, "hsi-mode", &mode);
> > > > > +	if (err) {
> > > > > +		err =3D hsi_of_property_parse_mode(client, "hsi-rx-mode",
> > > > > +						 &cl->rx_cfg.mode);
> > > > > +		if (err)
> > > > > +			goto err;
> > > > > +
> > > > > +		err =3D hsi_of_property_parse_mode(client, "hsi-tx-mode",
> > > > > +						 &cl->tx_cfg.mode);
> > > > > +		if (err)
> > > > > +			goto err;
> > > >=20
> > > > Will this need some #ifdef CONFIG_OF?
> > >=20
> > > It would only be needed to reduce the amount of kernel code for
> > > disabled Device Tree. I don't think its worth it, since there is no
> > > platform in the mainline kernel, which uses HSI without DT.
> >=20
> > mh actually it is needed, since there is no stub provided for
> > of_modalias_node in non DT mode (there are stubs for all other
> > of_* methods used). I will include the ifdef in PATCHv5.
>=20
> Alternatively, you can make driver depend on DT...

I would be ok with making individual HSI client or controller
drivers dependent on DT, but I don't think its a good idea to make
the whole HSI framework dependent on DT.

-- Sebastian

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTXOsmAAoJENju1/PIO/qa13EP/00riztm9sWYM+GJm/smFZDj
cNdD4rMEyh5qSn/NVXkATuJAqzLBW4u5iX4KYnk25cBc/f6Hl3JYidlHpRuT95Lb
cnAaYN9bMNdOie3vNBV+QN9bcoVtcADgq7N+Ad/vLbkoFCKX/G8yqz/bQ56nZJZG
79IBCF0SfSJ6SHZHeCwIYlqri15bWLuN+E3o2J+FjhYOOK+jfMuo718G1asOfEye
moyPsYC1sn4iWegqd4SrzYEVnyGC67uRC5CUSolsCnalyR4/KXpyB9MtV/K4Q4ew
WQsxIzmYclxCYaZzinqP3dAqSQJOaoy9vDzwyZ8QJOa3MtgWaTnkoI1roK6Sr2tq
Di2oqCWZlB8sLA/UC/wEFZMbCwKoE6EAVh5wOWimBA7veOT6fNIPxVgVZ4iQr/h6
wXgIGSmVuqvpVUetmMx2Q+nFGF/LTWMzGwANw00mefU/XygJzqFMZ8GhDjq/tabg
pGLTpXLFcQB3sp4tjpVqlDGN4s+2jr6plLyhDPq9JJknjPpOKU5kH2uawpyXO2SN
4W6WWxWpUWastkE+cBXjjXbfhvF7dhNJxRSKAFJOBTHsFkXGaxUEwZofkd46TPNo
6qkXM6/5EwUAuO9bXampWuvNEOXeTZJl20IuLFn5WWpaNKKcxQMnGwZP5blRj0em
AXTtQhrgtauTRtMeaNEO
=Dzyn
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
