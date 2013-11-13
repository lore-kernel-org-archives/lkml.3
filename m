Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab3KMPUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:20:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36292 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab3KMPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:20:43 -0500
Date: Wed, 13 Nov 2013 09:20:01 -0600
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>, <paul@pwsan.com>,
        <rnayak@ti.com>, <khilman@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: OMAP2+: omap_device: maintain sane runtime pm
 status around suspend/resume
Message-ID: <20131113152001.GC29226@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384297710-29694-1-git-send-email-nm@ti.com>
 <20131113125149.GB28192@saruman.home>
 <52839306.7050701@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ghzN8eJ9Qlbqn3iT"
Content-Disposition: inline
In-Reply-To: <52839306.7050701@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ghzN8eJ9Qlbqn3iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2013 at 08:56:06AM -0600, Nishanth Menon wrote:
> On 11/13/2013 06:51 AM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Nov 12, 2013 at 05:08:30PM -0600, Nishanth Menon wrote:
> >> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/o=
map_device.c
> >> index b69dd9a..f97b34b 100644
> >> --- a/arch/arm/mach-omap2/omap_device.c
> >> +++ b/arch/arm/mach-omap2/omap_device.c
> >> @@ -621,6 +621,7 @@ static int _od_suspend_noirq(struct device *dev)
> >> =20
> >>  	if (!ret && !pm_runtime_status_suspended(dev)) {
> >>  		if (pm_generic_runtime_suspend(dev) =3D=3D 0) {
> >> +			pm_runtime_set_suspended(dev);
> >=20
> > don't you have to disable pm_runtime around status changes ? Or is
> > pm_runtime already disabled by the time we get here ?
>=20
> pm_runtime is already disabled by the time no_irq suspend is invoked.
>=20
> >=20
> >> @@ -634,10 +635,10 @@ static int _od_resume_noirq(struct device *dev)
> >>  	struct platform_device *pdev =3D to_platform_device(dev);
> >>  	struct omap_device *od =3D to_omap_device(pdev);
> >> =20
> >> -	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
> >> -	    !pm_runtime_status_suspended(dev)) {
> >> +	if (od->flags & OMAP_DEVICE_SUSPENDED) {
> >>  		od->flags &=3D ~OMAP_DEVICE_SUSPENDED;
> >>  		omap_device_enable(pdev);
> >> +		pm_runtime_set_active(dev);
> >=20
> > ditto, also pm_runtime_set_active() may fail.
> >=20
> again, pm_runtime is not yet active here yet - we just restore the pm
> runtime state with which we went down with -> and that is not expected
> to fail either - So, how about just adding a WARN if our expectation
> of balanced operation was somehow broken in the future with changes to
> runtime framework?

you mean:

WARN(pm_runtime_set_active(dev));  ?

sounds good

thanks

--=20
balbi

--ghzN8eJ9Qlbqn3iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSg5ihAAoJEIaOsuA1yqREVAEQAKeU8umlfaaU9zXv/rMfkP1+
5FxNXoix5GT+Fu1OtulAM7psTv8COEYTJ5LchnWUadBP7GXd/d2jIdX95QkiF613
f5iz8cIiJYUpciuCINChp2Y2HD/dJTEdh7ftNNBwtGZMX+mJcvQpU+ce3ujjZD4j
yUTYN7v5ZyCao2buLnaIAxROW8Qa8Dipv7sqMAG3H/zqMhcT7+9uBClwgBVQKR4l
KafModbEsB3+ZKdNcJv3augkT9uInMRGaXMlc04LPxEXmPPBiNf8E9h+VjVaDnJz
REsfJVFB5ciwGG+69Ko8NrC38kQtZq7kwV73kDAUDa9JJsX7BoUfC8e99PqzIF+d
/vie99z4/3Ei2HRiIVb6XrZt5WmAoXDhAmZq3AH9n8aaWIPDdJsHpBIXCKsdGkMT
PpLZB7FcsN8SyQJ4gsIyL5vYLkmGL39h7ru+3jrbExHZp0y/b8eeFfKCOOZYtyD1
E4ZB0kL9btpm5wia/CwEEgkV2bf4PPHMrckGT0bANt4aCT11JQFNuj/r6Oe9Idbs
E2YwF4xZcF5dZdSXhLsvmiDVNccsylpl/rA7+SSnb/Y2FhQZDmPPy0VLWEfLo1A4
k0uicJRkwQeZ7GEyfKYeKYH+4h4Qlz6IuoRpJd9PGt5ypK/+to/7rRCB7CdPsqhq
Xv3Y3ReHP7EJ2RWFuNpy
=vAA7
-----END PGP SIGNATURE-----

--ghzN8eJ9Qlbqn3iT--
