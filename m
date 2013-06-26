Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3FZIxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:53:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45251 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3FZIxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:53:41 -0400
Date: Wed, 26 Jun 2013 11:53:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: "B, Ravi" <ravibabu@ti.com>
CC: "Balbi, Felipe" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/3] usb: musb: core: added babble recovery func-ptr
 to musb->ops
Message-ID: <20130626085334.GP12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
 <1369832824-29071-3-git-send-email-ravibabu@ti.com>
 <20130626082620.GN12640@arwen.pp.htv.fi>
 <6C6B28D4DC342643927BEAFCE8707BF63EB18D85@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zu8lIfFVzXMVnfzp"
Content-Disposition: inline
In-Reply-To: <6C6B28D4DC342643927BEAFCE8707BF63EB18D85@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zu8lIfFVzXMVnfzp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 10:37:39AM +0200, B, Ravi wrote:
> Felipe
>=20
> >=20
> > On Wed, May 29, 2013 at 06:37:03PM +0530, Ravi Babu wrote:
> > > Adding babble_recovery operation as part of musb->ops, used to recover
> > > from babble condition during babble interrupt.
> > >
> > > Signed-off-by: Ravi Babu <ravibabu@ti.com>
> > > ---
> > >  drivers/usb/musb/musb_core.c |    6 ++++++
> > >  drivers/usb/musb/musb_core.h |    7 +++++++
> > >  2 files changed, 13 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/usb/musb/musb_core.c
> > > b/drivers/usb/musb/musb_core.c index ab6fa39..411c29d 100644
> > > --- a/drivers/usb/musb/musb_core.c
> > > +++ b/drivers/usb/musb/musb_core.c
> > > @@ -857,6 +857,12 @@ b_host:
> > >  		}
> > >  	}
> > >
> > > +	/* handle babble condition */
> > > +	if (int_usb & MUSB_INTR_BABBLE) {
> > > +		pr_info("babble: restarting the musb controller..");
> > > +		musb_babble_recovery(musb);
> > > +	}
> > > +
> > >  #if 0
> > >  /* REVISIT ... this would be for multiplexing periodic endpoints, or
> > >   * supporting transfer phasing to prevent exceeding ISO bandwidth
> > > diff --git a/drivers/usb/musb/musb_core.h
> > > b/drivers/usb/musb/musb_core.h index f96e899..bf37dc9 100644
> > > --- a/drivers/usb/musb/musb_core.h
> > > +++ b/drivers/usb/musb/musb_core.h
> > > @@ -213,6 +213,8 @@ struct musb_platform_ops {
> > >  	int	(*adjust_channel_params)(struct dma_channel *channel,
> > >  				u16 packet_sz, u8 *mode,
> > >  				dma_addr_t *dma_addr, u32 *len);
> > > +
> > > +	void	(*babble_recovery)(struct musb *musb);
> >=20
> > I don't get why can't 'babble_recovery' be generic. Why do we need each=
 glue
> > layer to implement it ?
> >=20
>=20
> Babble is generic, but recovery mechanism is nothing but "reset of
> usbss" which is SoC dependent and followed by generic restart of the
> musb controller.=20

and that's what I don't get. Why do you need to reset usbss ?

--=20
balbi

--zu8lIfFVzXMVnfzp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyqwOAAoJEIaOsuA1yqRExe8P/3AOMnsZ/7lM5huHkCcWtrKz
y/niq+Vb2/lxozsNzaO6lrKV3wetxm4NdenxQ1eHb5YlpMeT1QlRwHGCPuLhhsRM
StrxKkdx2WJwuwqcdJsn97fazIQbEw31CGcLV/PWKBuI71rwUjxOtiVRfEyaLsUX
PtMYOu0ABltLu99GJMshWImdZ8bE1OL93lC34T8N8liJD5gyjE+JV8dEqo4Eh8hZ
MwVluaH4tgxQPSWjQVNsMx3esqi7B3J4ykb/LYFg+Y9wJEVadFjb5JB0VSTAHjqO
XEBfY34C6N0O5alH1RFjXRgJNOt5rRteW8CudImOQs9hcSG1IYanl9BXk8lVAMSb
3+27qnDh03ZOYOs21qASijabcF3QqPU+sJHgQIUKeCA6ABwA/qt0qPt1/Xa5yUAj
5JvRYPJI954qEg5HGs94uMYzEjKPhkP3G3ylJpvCcpX8wmzBSHqbVTXoDpTsec8i
sb4ilp2BN1idTepL5vX+I9q3t3NXCvo5bt+9YPP7WpotqezWtXvmsVzBlSfc8aOw
KZvvjKwa5fTRc2jDbbt2dbA57158fwMdxoxIRb445TePTY1DdMFqclGV0a5kxCm8
8RngMmupxCKs03AsaukJNwxHDkn06BYKHQQcH8GAEFF8uB/UT04LN4/NcteLpzMV
fB+0bBKYoqDVmSOQwcsk
=XXQu
-----END PGP SIGNATURE-----

--zu8lIfFVzXMVnfzp--
