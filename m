Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbaDWPwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:52:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60578 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbaDWPv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:51:57 -0400
Date: Wed, 23 Apr 2014 10:49:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Fabio Estevam <festevam@gmail.com>, Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>, <gustavo@padovan.org>,
        <johan.hedberg@gmail.com>, <jslaby@suse.cz>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 08/13] tty: serial: omap: switch over to
 platform_get_resource
Message-ID: <20140423154927.GK9593@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
 <1398265117-11793-8-git-send-email-balbi@ti.com>
 <CAOMZO5AUn7FsUXbY4NBfkZyZUbRNm3hcP3DC6vOYHi89xbaVYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2pR2RtFp0tAjF3C"
Content-Disposition: inline
In-Reply-To: <CAOMZO5AUn7FsUXbY4NBfkZyZUbRNm3hcP3DC6vOYHi89xbaVYw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J2pR2RtFp0tAjF3C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 12:27:59PM -0300, Fabio Estevam wrote:
> On Wed, Apr 23, 2014 at 11:58 AM, Felipe Balbi <balbi@ti.com> wrote:
>=20
> > @@ -1658,12 +1657,9 @@ static int serial_omap_probe(struct platform_dev=
ice *pdev)
> >                 omap_up_info =3D of_get_uart_port_info(&pdev->dev);
> >                 pdev->dev.platform_data =3D omap_up_info;
> >         } else {
> > -               irq =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > -               if (!irq) {
> > -                       dev_err(&pdev->dev, "no irq resource?\n");
> > -                       return -ENODEV;
> > -               }
> > -               uartirq =3D irq->start;
> > +               uartirq =3D platform_get_irq(pdev, 0);
> > +               if (uartirq < 0)
> > +                       return -EPROBE_DEFER;
>=20
>=20
> Maybe you could just do a 'return uartirq' here instead.

I don't mind either way, I'm only returning -EPROBE_DEFER because that's
what the other branch of this conditional returns. Tony, what do you
prefer ?

--=20
balbi

--J2pR2RtFp0tAjF3C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV+EHAAoJEIaOsuA1yqREsN4P/i0xuTdhVsrVgVr3HvUFVmnZ
TUTkZEwE6xdUhrL26PxI7VBepAbyG3B6LdWXiVzGTcItIeaOQ8+J70OnRLZWY403
GVUXYCXj2zd7sQBrhVIvtVUpnAkkUe3cFvxvzVYxFQ7ahM6HQuqOr93kP+cZN0rS
BcuxeWcU9xK/hLnj1Chf973MoO7m8iLZ+sQtIu1B/73wBL+VYWKeShQr/620kidb
6ZWld6hJ5PyN1rQmdwZh+elbSnzKl0gu4Iqr5lXSjyNzWgZKdibBzjmP2e4RbGea
IkJwWDyuI0P0u5n/xajonLv7fZFa53+psGMK2wmAYIaPP94K6qirkvivbCtvDsLA
dERAYcMnJEMlSJtPDS1YVDeyKjoSGdiL4qF2GVi5XY0rKDH4VVLqqkCxfDRQNyYJ
OcW06+x7A7ItZhZwpbnex9Ne8Md0tczYyaLaMSx3n2HCHMJFN9ceyN+GG7WT2eCD
NvhWpo70w34k5seba57pcLoCm1e7xxNAbq8CEIBbHIcQ6qxi4uIuYCZjTkpLeAhV
bs3mzXwXLXj18rP4K8/UGo8ammjeOAJ8Ar51UG6fsPUnJtDbr0Xrqe/tSJfBTkxO
ejJONva8Gt5DRwiWyySUDSGU5S2cCTXuGLgs4ZYzB1k+7zdOQ6sbcCVaJUeoyITe
2duSUx/J3t00jwDzS8CU
=wEnj
-----END PGP SIGNATURE-----

--J2pR2RtFp0tAjF3C--
