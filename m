Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3JWSY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 14:24:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48795 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3JWSYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 14:24:24 -0400
Date: Wed, 23 Oct 2013 13:23:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: David Cohen <david.a.cohen@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>, <gregkh@linuxfoundation.org>,
        <jslaby@suse.cz>, <ning.li@intel.com>, <ivan.gorinov@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 2/2] mrst_max3110: fix SPI UART interrupt parameters
Message-ID: <20131023182351.GL25954@gimli>
Reply-To: <balbi@ti.com>
References: <1382470930-13807-1-git-send-email-david.a.cohen@linux.intel.com>
 <5266E070.2060408@linux.intel.com>
 <5267041F.2090905@linux.intel.com>
 <1382509666.28248007@f107.i.mail.ru>
 <52681128.2010404@linux.intel.com>
 <20131023182143.GK25954@gimli>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jB+02Y6wHc2pEa2x"
Content-Disposition: inline
In-Reply-To: <20131023182143.GK25954@gimli>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jB+02Y6wHc2pEa2x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Wed, Oct 23, 2013 at 01:21:43PM -0500, Felipe Balbi wrote:
> On Wed, Oct 23, 2013 at 11:10:48AM -0700, David Cohen wrote:
> > >My idea is always use threaded irq and passing flags into request.
> > >Like as:
> > >unsigned long flags =3D res->flags & IORESOURCE_BITS;
> > >...
> > >request_threaded_irq(max->irq, serial_m3110_irq, IRQF_ONESHOT | flags,=
 "max3110", max);
> >=20
> >=20
> > Oh, maybe we were talking about different things afterall :)
> > The reason this struct plat_max3110 was created is to allow platform
> > code (located under arch/x86/platform/intel-mid/device_libs/) to define
> > the irq edge type.
> > When I saw your comment I though you were referring to struct resource
> > (which has IORESOURCE_IRQ_* flags). But unlike platform_device,
> > spi_device has no struct resource * to replace the need of struct
> > plat_max3110.
> >=20
> > OTOH your suggestion can replace this piece of code:
> >=20
> > @@ -68,6 +69,7 @@ struct uart_max3110 {
> >         u8 clock;
> >         u8 parity, word_7bits;
> >         u16 irq;
> > +       u16 irq_edge_triggered;
>=20
> max3110 is already edge triggered:
>=20
> 495                 ret =3D request_irq(max->irq, serial_m3110_irq,
> 496                                 IRQ_TYPE_EDGE_FALLING, "max3110", max=
);
>=20
> it would be nice a threaded IRQ instead of using a singlethread
> workqueue, though.

making it clearer, you only converted to threaded IRQ when
edge_triggered isn't set, why don't you *always* use threaded IRQs ?

--=20
balbi

--jB+02Y6wHc2pEa2x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSaBQ3AAoJEIaOsuA1yqREY94P/2OL11IzPxPzNKKMcDjF4vhr
NilV0l+840ZOrFNsB+hY6cwLQvXUU/fLi9W4NTmrNX0jgRflgHHjM0aXeDFUc4xP
iUJWFg469IKyrzStpoPnKCJlThdLLleLjSFN9DJbxIeXFRS134Y1cEqI6i2nnP1Z
NaxUbIL41qNboB4WP0nzaJ74REbfw1YQPOhh3CJbslFm7YHIlUzuK5E5sj7MQ7Sd
bw9gV/c8EHs2ndpjluaFAOYDajY9zV+tLWLJYRMur3r0yG84IpaPm0v7WgNi4ubv
Yek4uHX5rfPOiXXusmPPkTlGVttF3FKpr6nc6q7eVwX8L2zEaQJA2UfH5xvDsLkw
El5IbQrtj9UghSPN/fqkEujrXYfJbs2BuxfsMEb9JpFLGqWXNX8ZlLjzneVVOgIQ
9HF0BUJLkAoinZ2Z8aumroH9ORfkZNiiwQs68dSWPSNJmJ8TZJ6ybCbs8XyNSexq
pXNkCLaMCF+s8WaxiO2kED+mbOyTPhmzTuoLG37WTYMiIhGIGWCKA24eqS0VhEoL
NX0QH8VOSqLvIESxsLjkrnlZscB5gwzGf4IHT6kK5zGHaBwOw8rWEocm+GtNW67G
HGuaKn1rLeLPF3mEW6rugY1KIWtXP66gY/moy1EJGfBIwoabmbc/juGmf6TXfEQ8
3YygOTkQ9LBbm9mZplIK
=odHM
-----END PGP SIGNATURE-----

--jB+02Y6wHc2pEa2x--
