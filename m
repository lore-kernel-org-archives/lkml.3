Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaDYStK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:49:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:59776 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaDYStH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:49:07 -0400
Date: Fri, 25 Apr 2014 20:49:01 +0200
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
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Carlos Chinea <carlos.chinea@nokia.com>
Subject: Re: [PATCHv3 10/14] HSI: Introduce driver for SSI Protocol
Message-ID: <20140425184900.GF22721@earth.universe>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-11-git-send-email-sre@kernel.org>
 <20140419194936.GJ5148@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
Content-Disposition: inline
In-Reply-To: <20140419194936.GJ5148@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 19, 2014 at 09:49:36PM +0200, Pavel Machek wrote:
> Hi!
>=20
> > This adds a driver for the SSI McSAAB protocol as used in
> > the Nokia N900.
> >=20
> > Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
>=20
> > +#define SSIP_MIN_PN_HDR		6	/* FIXME: Revisit */
> > +#define SSIP_WDTOUT		2000	/* FIXME: has to be 500 msecs> */
>=20
> Can they be fixed now, or do they have to wait?

I would prefer to wait. The timing above works and having it in the
git history doesn't hurt.

> > +#ifdef __LITTLE_ENDIAN
> > +	((u16 *)skb->data)[2] =3D swab16(((u16 *)skb->data)[2]);
> > +	dev_dbg(&dev->dev, "RX length fixed (%04x -> %u)\n",
> > +			((u16 *)skb->data)[2], ntohs(((u16 *)skb->data)[2]));
> > +#endif
>=20
> Uh. Can this be replaced by
>     ((u16 *)skb->data)[2] =3D htons(((u16 *)skb->data)[2]);
>=20
> (without the ifdef?)

Yes.

> > +	/*
> > +	 * Modem sends Phonet messages over SSI with its own endianess...
> > +	 * Assume that modem has the same endianess as we do.
> > +	 */
> > +	if (skb_cow_head(skb, 0))
> > +		goto drop;
> > +#ifdef __LITTLE_ENDIAN
> > +	((u16 *)skb->data)[2] =3D swab16(((u16 *)skb->data)[2]);
> > +#endif
>=20
> Here, too?

Fixed in PATCHv4.

> But it looks like the comment does not match the code, because we
> swap.

The swap only converts the package length field from/to network byte
order. I think the comment still applies for the other actual message.

I added a comment for the length field and kept the other comment as
is for PATCHv4.

-- Sebastian

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTWq4cAAoJENju1/PIO/qauXgP/AkArax6cNzm05x6VkLTcVwX
sa+/H1kHdryPo8l+jiQyu6qcPA8gTnPIPXfEBN+ZwafamFlKgci47KYeCf+YDE1o
IBbfoKZ/SFrzYCCON90HbayBBG/GoSK9ycFz1gdEwb37PTsgiIgo/507o8AzAljQ
0Pl0mhLLXVi71OcevNwWA4+bO6xUl7HkNT1NoVafYZrHhTR7VDQ/D97y/4lH4mMz
tT7ApT2sgtC8UwDc76hQaB1SXjQVjUa3pNs+7B1oOO9EfGbgcnelCOlva2ImD6vh
YhIRfxb/DWpsRBMWuFkT3AB/vmIZ/aelxnvdCZryPQgdqGCKzBBAhHkkTjHa8oLT
jjnlw52k2gthzH1G3f4ZZAuAHh1ZcZ9P5YScYkjNSIHgy9x6MMrMxA+T4NEPhOoW
KBXvwpnqqhIFGn1chWTHOCd6o+LW2+/frfQwh4riD2duO4OGW8te367vaC5FNL80
EJB5RAzpdQlsywEBAwKL2975XIL4rgtjgK371dCCLTOlWOybguaMAeoER7Mdy/kc
jlkrf3MmQ+pKknR0kEX52ArvQfTLKjRrj3E3jvknkmAHWTqHinECEt3ta96QGdEb
5JLEY3TQAhacft7eHh628i7VBoICcPoNqOSxHORmKML2RYrw8vkGavuR1iWtamWg
MEb7Foi2ZH2LwxKtPK4b
=cBwO
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--
