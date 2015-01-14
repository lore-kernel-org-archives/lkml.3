Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbbANTir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:38:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60015 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbbANTip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:38:45 -0500
Date: Wed, 14 Jan 2015 13:37:54 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <paulz@synopsys.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dinguyen@opensource.altera.com>, <yousaf.kaukab@intel.com>,
        <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Message-ID: <20150114193754.GQ16533@saruman>
Reply-To: <balbi@ti.com>
References: <1421217931-23722-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNrVs/mD1E3KQVoV"
Content-Disposition: inline
In-Reply-To: <1421217931-23722-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cNrVs/mD1E3KQVoV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 07:45:31AM +0100, Robert Baldyga wrote:
> This patch fixes bug described here:
> https://lkml.org/lkml/2014/12/22/185
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>=20
> Changelog:
>=20
> v2:
> - fixed comment from Paul Zimmerman
>=20
> v1: https://lkml.org/lkml/2015/1/13/186
>=20
>  drivers/usb/dwc2/core_intr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
> index ad43c5b..02e3e2d 100644
> --- a/drivers/usb/dwc2/core_intr.c
> +++ b/drivers/usb/dwc2/core_intr.c
> @@ -476,13 +476,13 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *=
dev)
>  	u32 gintsts;
>  	irqreturn_t retval =3D IRQ_NONE;
> =20
> +	spin_lock(&hsotg->lock);
> +
>  	if (!dwc2_is_controller_alive(hsotg)) {

This is really, really odd. Register accesses are atomic, so the lock
isn't really doing anything. Besides, you're calling
dwc2_is_controller_alive() from within the IRQ handler, so IRQs are
already disabled.

When the problem happens, do you see this "Controller is dead" message ?

--=20
balbi

--cNrVs/mD1E3KQVoV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtsWSAAoJEIaOsuA1yqRET7QP/1zSU9oBgsuyI4o+elu14eUs
7ZyP8xLPfLL1mgs3p59oZFrDVKIbXKJaG7BvK1HXqlc/j9A4RGpiwloSAhu6tm/L
R6oeiaMjCq+YUNYa6Y4Q/Or9objsWPIansHjsF4pkHS584TAf2moElWSOnYiaLRm
Wq0WeB5j8PLz516bKJ8TuEZ3yn8ny+dgpvfRc9ZhHaU4iVRK4NNBbIIOdvRyMiOG
DK5DCJrADcfr6bxpT6caT1SPyijBY4aFpmvM0oho7bsUcdZzIM/bSfaJ7lLulKzu
82X7J1EKjKN/ZsTHZv7TZjNPrxjkVYzK5wUYpftAKL2+PIWsdxAS7qmUi81FP63K
L7Jcs9CjDZD7sGaMABCs7ThGNZBZmtrKjpEGSn3dKwptnWqRX/W4DgYpjeLPn8Ma
xBro7XcwHU4KtVuAWNJjE3Kab03muN6WSk66bHiNcXHEC1sYLNemNRgzAbm7IU5h
wGAFH6in6Xdg5yRsbVUAFqz0kukiHqfv87QClUeT36GBVXfC9+1wzM3h/RNoEFmL
Rt0+BKB91o48c+fO96SleeGi2KabdJSGgpBhhXGonQTZWrtmGzVXJ8tQ/UzrJ161
uEw3jj3zW3gdZliJ88DRRiTTvQIfnhryBiHtvrExg4xkwz2jwGZw3TV+t1U7zaUJ
HxujDLvzmgaGSjnjiu47
=i92z
-----END PGP SIGNATURE-----

--cNrVs/mD1E3KQVoV--
