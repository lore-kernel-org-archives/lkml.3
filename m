Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3FXGik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:38:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47479 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab3FXGig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:38:36 -0400
Date: Mon, 24 Jun 2013 09:37:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 7/9] usb: musb: omap2430: use the new generic PHY
 framework
Message-ID: <20130624063752.GA7145@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-8-git-send-email-kishon@ti.com>
 <20130618094703.GV5461@arwen.pp.htv.fi>
 <51C7D9CC.8090901@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <51C7D9CC.8090901@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 24, 2013 at 11:01:56AM +0530, Kishon Vijay Abraham I wrote:
> >>@@ -397,9 +407,10 @@ static int omap2430_musb_init(struct musb *musb)
> >>  	if (glue->status !=3D OMAP_MUSB_UNKNOWN)
> >>  		omap_musb_set_mailbox(glue);
> >>
> >>-	usb_phy_init(musb->xceiv);
> >>+	phy_init(musb->phy);
> >>
> >>  	pm_runtime_put_noidle(musb->controller);
> >>+	phy_pm_runtime_put(musb->phy);
> >
> >see, weird unbalanced calls :-)
> >
> >Make it all explicit:
> >
> >phy_pm_runtime_get_sync(phy);
> >phy_init(phy);
> >phy_pm_runtime_put(phy);
>=20
> I think then it makes sense to drop get_sync from phy_init()?

maybe not, you don't know if the phy has already autosuspended or not.

--=20
balbi

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRx+lAAAoJEIaOsuA1yqRE2mIP/3MFfs1X3fV4aza7mWIZybbB
pTXhle4VoKMcHchoG6Upesa5cA7IIw/tmEcBlhWx5nhL2+N3nt6Qv3EtkHr/+HZz
rWp9cUhOWkwbqyr/fdcFfFb5vwfj7CEThtSYTDS5YIdx/A1RWrxpjHIRU7XnLriL
XAr1j1pooFLEwlpJQ9qTc8GDJ1tPVvGAW56M0rjrz3FCwIrVkd01tvPQeZxNIf8t
tnzGwtMTfGs0yyxRyqtEj/F5J8YRWvLjNYUF1QwR7omYbHStS3NAK4dK30crb5Ak
WqSqZ4ht2RzC58xPv4J+cldzTnM2+dO2Amk6O+MLSdmbA+Z9MoM6aGqnOwO7NVQa
Ap1BYEXItMygGjwuEGoHFPAlZPO9hky6RO+vl+fmPDpgKiTjBFELTXhXqM8ge5U/
iyRBPTnfMyMs9GQQ3y8vJXFp6eFFiW9tUpkSK+Xf6z2lxplHVyeoTEKi2Tp83Se2
0UxyEiZtYc19Y6KUsvh1q7BhQYEvY4aqPorEfkIDvqfHOt08BFNVAz3IgLa8By1A
pGKC3Zqtv3Yyu1+g3ZGJJD1D/af7a8OwOdJdYI5OXnt4mgKewakSNPgwRxXq4z66
u5+f521Mb5MByVBKz9ML64sEaWdaOq0aZxA/4mwixfESLhFKzhbVepaC4TE6agCY
khw/iu/CCI8ejlpuUltx
=Aff9
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
