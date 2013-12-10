Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3LJQcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:32:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58224 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab3LJQcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:32:39 -0500
Date: Tue, 10 Dec 2013 10:31:24 -0600
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 03/15] mfd: menelaus: Convert to threaded irq
Message-ID: <20131210163124.GD22750@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
 <1386606085-26838-3-git-send-email-balbi@ti.com>
 <20131210093213.GV12675@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
In-Reply-To: <20131210093213.GV12675@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 10, 2013 at 09:32:13AM +0000, Lee Jones wrote:
> On Mon, 09 Dec 2013, Felipe Balbi wrote:
>=20
> > We don't need that extra workqueue when we have generic threaded irq
> > handlers support. This patch just moves over to threaded irqs and
> > deletes the unnecessary workqueue.
> >=20
> > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/mfd/menelaus.c | 29 ++++-------------------------
> >  1 file changed, 4 insertions(+), 25 deletions(-)
>=20
> <snip>
>=20
> > -		err =3D request_irq(client->irq, menelaus_irq, 0,
> > -				  DRIVER_NAME, menelaus);
> > +		err =3D request_threaded_irq(client->irq, NULL, menelaus_irq,
> > +				IRQF_ONESHOT, DRIVER_NAME, menelaus);
>=20
> devm_* managed resources please.

that would be subject to another patch. One that converts to devm_* on
the entire driver.

--=20
balbi

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSp0HcAAoJEIaOsuA1yqREVtIP/A6dvkfZjLgRH0nFlRectd3C
zIus1jKv6TPfbtM6HRRO5B7adTgrXULFLEQAWdB6JHhdrFBRh4xQC6897Hr7/vIt
3r/4YqXlI0MYVVsgIpumHngkZcbCsxUHBj8xatfjp62AcVhtduxofMilP9DDh+qf
AJ/PHif4q0bLjbc66UB1RCUtFP1gT20nfCafsbWZHJR2OmcpHurpSQT1r9YV3lwP
CTpeEyvct7yJsCN+PdPl6y7J53+GjhihixCtU9h4Ylzd9qy8twCotSoK1Vg/PMHB
92HPoqWB2wYrbZTFd122Ae3JhMJAsYjoxeaXQaCuHsHR3DYqTeDb8SnS+TxrGzVS
nsWWLRQ9gWPGAeceL6Vz/wm726oUeenFPEwROcqnqIC+xq2AYp9UQLKDmoHbhGE5
itsk3aqZnojkbGIp1CMx5YLU+bIUiomvU51iVP7w7GZw0IOB8uu9JKghVnL6sGl/
0xDrDGZDX8bZK4Q/PF7ezgaq+1qzlbahYRBP/bWDaJ2tv/lf/wh51YhaMQmxUDX0
oHlLQjJvPRFbDUSzFoEpM0IkR2g9ZMwhscq3knUrutvYe4CcVadOS8xoeJ81NWJA
8KCMTyjPc2sbBCE1xWqwLjxpLb/do+5iRMy11YxWESH8WwiOKRF3uKAsz7jN0Vzd
SkT8a5tW3ybdBQnW1Snk
=iLfe
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
