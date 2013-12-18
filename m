Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3LRQHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:07:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49051 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3LRQHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:07:21 -0500
Date: Wed, 18 Dec 2013 10:06:11 -0600
From: Felipe Balbi <balbi@ti.com>
To: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
CC: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <kgene.kim@samsung.com>, <linux-usb@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>, <balbi@ti.com>,
        <gautam.vivek@samsung.com>, <joshi@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: Re: [RFC 5/5] usb: dwc3: enable async suspend/resume
Message-ID: <20131218160611.GC4970@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387363174-25942-1-git-send-email-yuvaraj.cd@samsung.com>
 <1387363174-25942-5-git-send-email-yuvaraj.cd@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
In-Reply-To: <1387363174-25942-5-git-send-email-yuvaraj.cd@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2013 at 04:09:34PM +0530, Yuvaraj Kumar C D wrote:
> From: Andrew Bresticker <abrestic@chromium.org>
>=20
> In addition to enabling async suspend/resume on the xhci-plat device,
> we must enable it for the dwc3 device (the parent of xhci-plat) in order
> to make the full USB stack resume asynchronously.  Like the xhci-plat,
> ehci-s5p, and ohci-exynos drivers, there are no outside dependencies
> which would make resuming the dwc3 driver asynchronously unsafe.
>=20
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Reviewed-by: Julius Werner <jwerner@chromium.org>
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> ---
>  drivers/usb/dwc3/core.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 59bb8d2..9c8a273 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -586,6 +586,8 @@ static int dwc3_probe(struct platform_device *pdev)
> =20
>  	pm_runtime_allow(dev);
> =20
> +	device_enable_async_suspend(dev);

how has this series been tested ? Let me rephrase this: was this series
tested at all ? Note that if we are in gadget mode, we will disable
physical endpoints 0 and 1, which will break USB communication requiring
a new enumeration later. On top of that, for versions of the core which
are configured without hibernation support - in fact for all cores
currently, since we don't have hibernation support implemented in this
driver -, we will loose communication with the far end (be it a host or
a device).

You mention there are no external dependencies to make async suspend
work on this driver, but that's far from the truth. As it is today, this
driver needs a lot of work to learn about all the details about all
different versions of this IP when it comes to supporting async PM.

I suppose this was tested with 500 other out-of-tree patches and you
simply cherry-picked this patch to send upstream ? Am I right ? It
certainly looks like it.

Please let us know how has this been tested ? Did you run USB30CV ? Did
you make sure to run through USB Certification interoperability tests ?

Did you leave some stress test running for weeks before sending this
patch out ? Is Exynos 5 working fine out of mainline ?

cheers

--=20
balbi

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSscfzAAoJEIaOsuA1yqREggMP/jTPmI/Y6HfD6DFMR+6Yd99e
cov+LuHmFFc12YOhTs3JwRjXKlzmSqGEFaEtLqGSiias3d6jlsB9EpAXW9sfRCJQ
tc0vy6YhxouL8Jr66hN9dT3NOCEZkzl5ytFZ7sHW96a4hzbjuuv7QJamKfF02eNq
s7kaFYak+IdKL1wHqM5yiDfuR36bnzqcgNgPWPGcFOhyZ+pCFl7qYZAyXA9m2iuo
sPS/rZtCNui8bEkqg11YqaTzYxHIhm732Elho3DTIxb5vNMgeNiozvcxIyj82OWD
rKFS9PuRRaHyo+ye3DaejDuOGtZS9cNV+msCPzQVLgmnDk19tl/0xpS26AQJvNbr
u1F2/Nv0sPkUEioiENceS7jWMF8FYfcNPiIz63wzb+dw1Px6lkcmZwRBTtbVy6kk
C6MB1rk0CWrAZiZl0NHVvShwriR3gO02NET77jQOfN/mNfj7qFh6s89+CDGkCQn3
eyVKjCLZdmkjulcTQ94ukOtOjuE7FGSbEOHwJYdiq77SEgzATL95kQc0DujnCMxF
Ka6lQqNEiREN/ghi0cl++Sg/X6l1lGEAA3PhLGQItZ3QaQuTBUCJmzkk83gmj9z3
6XV3nrAiQhCAV8TuEN6AgVlr0nRhr1/K31VBjFRR6THC08ue6bszkSVErkjB/IvJ
BDbSaTorpy6ry2gMBuct
=kszb
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--
