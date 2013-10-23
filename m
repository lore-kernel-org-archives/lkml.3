Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3JWSVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 14:21:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48695 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3JWSVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 14:21:48 -0400
Date: Wed, 23 Oct 2013 13:21:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Alexander Shiyan <shc_work@mail.ru>, <gregkh@linuxfoundation.org>,
        <jslaby@suse.cz>, <ning.li@intel.com>, <ivan.gorinov@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 2/2] mrst_max3110: fix SPI UART interrupt parameters
Message-ID: <20131023182143.GK25954@gimli>
Reply-To: <balbi@ti.com>
References: <1382470930-13807-1-git-send-email-david.a.cohen@linux.intel.com>
 <5266E070.2060408@linux.intel.com>
 <5267041F.2090905@linux.intel.com>
 <1382509666.28248007@f107.i.mail.ru>
 <52681128.2010404@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="00hq2S6J2Jlg6EbK"
Content-Disposition: inline
In-Reply-To: <52681128.2010404@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00hq2S6J2Jlg6EbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 23, 2013 at 11:10:48AM -0700, David Cohen wrote:
> >My idea is always use threaded irq and passing flags into request.
> >Like as:
> >unsigned long flags =3D res->flags & IORESOURCE_BITS;
> >...
> >request_threaded_irq(max->irq, serial_m3110_irq, IRQF_ONESHOT | flags, "=
max3110", max);
>=20
>=20
> Oh, maybe we were talking about different things afterall :)
> The reason this struct plat_max3110 was created is to allow platform
> code (located under arch/x86/platform/intel-mid/device_libs/) to define
> the irq edge type.
> When I saw your comment I though you were referring to struct resource
> (which has IORESOURCE_IRQ_* flags). But unlike platform_device,
> spi_device has no struct resource * to replace the need of struct
> plat_max3110.
>=20
> OTOH your suggestion can replace this piece of code:
>=20
> @@ -68,6 +69,7 @@ struct uart_max3110 {
>         u8 clock;
>         u8 parity, word_7bits;
>         u16 irq;
> +       u16 irq_edge_triggered;

max3110 is already edge triggered:

495                 ret =3D request_irq(max->irq, serial_m3110_irq,
496                                 IRQ_TYPE_EDGE_FALLING, "max3110", max);

it would be nice a threaded IRQ instead of using a singlethread
workqueue, though.

--=20
balbi

--00hq2S6J2Jlg6EbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSaBO3AAoJEIaOsuA1yqRE7QMP+gL6E9QJnOoI/l6FDtCMCRZo
IJnmTZrqz3d/tKb833gORyiH0loZhygiJBLHlgxaq2B2mCd5/fUZls+W/vuG73SW
sbgjMbeBh0uAh4yhfKqZFKmfu9emmereLAvCA2xSgEr1YL7Br6ngou10Dw+e43cy
DitYBsc9XHM9AqJPkJyRYtxCz7fRjZXOBxqArkbYG59Efg/zqcKVRiKjpdUM0iQE
hU/ky+d3WmT6d7IaHSvaC+3w/5uPWOf2P00xGJHAEAacQd38hnbla3IXEoin6MWU
O8sH7nP8LIRYnnLGpfnDEdoFmt1C2ind0bI1/XLWimCxRmG10KYIpeo1ybvvSbOA
ABq22OSZJVLRLEF6kPBDhG3OWGMqnTjVsONAma7BaVyi75CTF3mXrc3/7psnLTkO
Q/FJ1UHeX3iic2tJfKYczTlEfx/Yrr1tAoLas5CCrZOZFntsEIpXr8Qpr5IDZsRd
RIwtuWXZAu1SrivF1feqKrxa8euUSxUvaFuODH3f7uYKx0y9RJp8+gZjq7YfAiXS
fzXYakrkuftIxoPw1jSM3sJ4j1r5k5sSJtBw1sddrZ2rG8bH3/UOSbqwTzz141Ek
ON2HivMTSRsQXlRwrbyG17n4fC6vTvykhyDpRAT2Z3+y3MmW0blYCoQv4pCS+Q7k
evhNuKQ/bWUrOSd0pi+y
=y8l4
-----END PGP SIGNATURE-----

--00hq2S6J2Jlg6EbK--
