Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab3DYJIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:08:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49653 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3DYJIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:08:35 -0400
Date: Thu, 25 Apr 2013 12:07:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: multi: Mark {cdc,rndis}_config_register()
 __init
Message-ID: <20130425090754.GM7889@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366802195-15479-1-git-send-email-geert@linux-m68k.org>
 <xa1t4nevc105.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x38akuY2VS0PywU3"
Content-Disposition: inline
In-Reply-To: <xa1t4nevc105.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--x38akuY2VS0PywU3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2013 at 10:05:46AM -0700, Michal Nazarewicz wrote:
> On Wed, Apr 24 2013, Geert Uytterhoeven wrote:
> > If gcc (e.g. 4.1.2) decides not to inline cdc_config_register() and
> > rndis_config_register(), this will cause section mismatch warnings:
> >
> > WARNING: drivers/usb/gadget/g_multi.o(.text+0x32f6): Section mismatch i=
n reference from the function cdc_config_register() to the function .init.t=
ext:cdc_do_config()
> > The function cdc_config_register() references
> > the function __init cdc_do_config().
> > This is often because cdc_config_register lacks a __init
> > annotation or the annotation of cdc_do_config is wrong.
> >
> > WARNING: drivers/usb/gadget/g_multi.o(.text+0x3326): Section mismatch i=
n reference from the function rndis_config_register() to the function .init=
=2Etext:rndis_do_config()
> > The function rndis_config_register() references
> > the function __init rndis_do_config().
> > This is often because rndis_config_register lacks a __init
> > annotation or the annotation of rndis_do_config is wrong.
> >
> > Fortunately they're harmless, as {cdc,rndis}_config_register() are only
> > called from multi_bind(), which is annotated with __ref.
> >
> > Mark {cdc,rndis}_config_register() with the __init annotation to kill t=
he
> > warning.
> >
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>=20
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>=20
> With transition to configfs all those __inits and __refs will probably
> go away in the long term though.

that's what I thought. Wouldn't it be better to remove them all already?

--=20
balbi

--x38akuY2VS0PywU3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRePJqAAoJEIaOsuA1yqREYK8P/0B0m8a/C0xPUP46duL4PUq4
UZ0HrkpBW3ZMKrfZF/tGLP/hDmpWUHzfdbO/Ss5XQdw/LPaKS9VrEi2aM1LgYYnx
OwlC4xzs8Cfn240WEDCFjIFHV1MzcpRR3U8COt6ZFZRFK1MCGEm0TS4Oo2CnuVF3
xc4dFuop8e9oL9fqhub0Dt6HZTkSpZPpzMG7BKLS5qbQhR6TrAc0/jmNAfEZlkfo
cXjKkjPNpeJW+PiAf7qrMgXjgHxS4QRcLVSSLZKLjpxLgn9sOKen/aigGRwb8F77
yzpjGqXq16LU0v5a6ssq2z666/Rw7KVz7j6DFwFOGg/AyyYT0aqi6K63IQV6GQbf
EPuCkEsmAxfcoH48p7mlJ+xXXbLi4C/bSpk8MRx1KNZSCoB6pk5IXMH7gmVU2pcY
axEd3WLnwO0YcdaNPBrTedRT7gNt0NF4x7GUITbM0VNZAIZaXx2NkTr3wDhoV7nv
cXL1HTf03E0IN/U2KNZVv5IpOQ1P1X350QZYykN8qLvUSATRpCtFrPCF1flBYwQh
IpyrvwZrsX0Slgc9KhVkGqDbGNK0PTjgAZnZwaOH54OhyOy4W2EZT+9KAav23hm4
LW7gZ6lPo3U31QPsMNqi7QjMpDGR/9Sbx3wOMa6vQyYhurgy0919ylxM3QF6qY++
ZHkSQ/CHWnj9Fb51ovLh
=AOfH
-----END PGP SIGNATURE-----

--x38akuY2VS0PywU3--
