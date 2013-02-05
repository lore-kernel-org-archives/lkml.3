Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3BEJ0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:26:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab3BEJ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:26:38 -0500
Date: Tue, 5 Feb 2013 10:26:34 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 5/8] drm: tegra: Move drm to live under host1x
Message-ID: <20130205092634.GE20437@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-6-git-send-email-tbergstrom@nvidia.com>
 <20130204110804.GA595@avionic-0098.mockup.avionic-design.de>
 <51108E70.5000602@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5oH/S/bF6lOfqCQb"
Content-Disposition: inline
In-Reply-To: <51108E70.5000602@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:iAf8ukr3GmjwDumCmcCK0B7pwRjtvAwyfHqIxvEmlAy
 TSaP0df/oQxKrFJsSIrChDvEHvH79x+FsP1nSR/74a78+MHF1O
 QiNzJhAjXmOodX/20nrCyyAxq1KjZ6sAw8yIRo2JxNHYDIo9g2
 UiTGe+Fz1YyDVmzKk47WDj09HGFU9UBcLCQINfZo54ojE++Dny
 rXDpkeBwnj8Sj2PxDW+XPj8mdRD3HfCc5/Koz/Vw6v42rkzyp1
 OEadibfpQbxw93+DrvyJx2KarWtbcODiJh6wbL+ZGJgAHkvLot
 IbkyGHPvpSWr8zA6rW4giMxYwVDh4kEmrsCCugjj3Sh0/DTWuB
 UQUMO6kmgfO3JdW78fsoA9SkIasLHDFUeBuOqyezURON+JqRJU
 Qwqck1myXCQOjpnNfXJu2WkVi92KxEn/CSmqUnMdcFSRUQJ/dg
 H9c08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5oH/S/bF6lOfqCQb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2013 at 08:45:36PM -0800, Terje Bergstr=C3=B6m wrote:
> On 04.02.2013 03:08, Thierry Reding wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Tue, Jan 15, 2013 at 01:44:01PM +0200, Terje Bergstrom wrote:
> > [...]
> >> diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
> >> index 697d49a..ffc8bf1 100644
> >> --- a/drivers/gpu/host1x/Makefile
> >> +++ b/drivers/gpu/host1x/Makefile
> >> @@ -12,4 +12,10 @@ host1x-y =3D \
> >>  	hw/host1x01.o
> >> =20
> >>  host1x-$(CONFIG_TEGRA_HOST1X_CMA) +=3D cma.o
> >> +
> >> +ccflags-y +=3D -Iinclude/drm
> >> +ccflags-$(CONFIG_DRM_TEGRA_DEBUG) +=3D -DDEBUG
> >> +
> >> +host1x-$(CONFIG_DRM_TEGRA) +=3D drm/drm.o drm/fb.o drm/dc.o drm/host1=
x.o
> >> +host1x-$(CONFIG_DRM_TEGRA) +=3D drm/output.o drm/rgb.o drm/hdmi.o
> >>  obj-$(CONFIG_TEGRA_HOST1X) +=3D host1x.o
> >=20
> > Can this be moved into a separate Makefile in the drm subdirectory?
>=20
> I tried, and kernel build helpfully created two .ko files. As having
> cyclic dependencies between two modules isn't nice, I merged them to
> same module and that seemed to force merging Makefile.
>=20
> If anybody has an idea on how to do it otherwise, I'd be happy to keep
> the Makefiles separate.

Okay, I'll take a look.

Thierry

--5oH/S/bF6lOfqCQb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRENBKAAoJEN0jrNd/PrOh9EAQAKsBOPm3IjPH5x9X5LDZtpxw
+r9tdFT+qBnTud+k8Q+S2FsuqKqe5FIWuhTH4CWKxt1KfASq9kQpMS82bhM53Nq3
EkS5EoDhw866ErH2Eirh8BUdc4KecVj0H/qgjhobfVeAQcOX09r3czPK9/s6wNs9
oAm40Vu+/lTgmADDFltOvh5Bj7CdxY7jwfqtepZfCeVDf2VIaamZO+AQJi9+Fu4C
VhqLsio7vzZ2Cz8oqr6VAZV9lfND9rZfwNq5x18RIE6JPJ/SJztIEIfvidOnftnK
COHuuJh5DDLXVwHyULclTiCOgi25ScOPos5ghUZBR2rl3Tm2chnC1f0/EGVyKaw8
wIE9NDN4aDryzzVPC3s+AktHZxsx66Q4eFblNL3gB4t9hgWAW/9/3raDjTVevbEI
3I7AN8lQs0Q6Je9/HSiu/1dLCdI4Kf24IO1YBYqm5ClvdOtOCuNzW70J/GUvcszM
rjOzzz+cre/O4LTCxr4umTsVlVgNkg8KHZKNPyDuhNRuQ7Hdm//LdBTcziYF0OLB
GUwc6sQZtbUjJMgFZ4WU6R8fAsmUu4CHgdbKTXMbAA7Zy6r+YBBdAK4aU0UyMw/1
KTqiQ9DGF9zhL96QvSMXRPQAzjmTfoptZ3BPGu28iOXHEwFn973iTOnPXptO8nXV
aTF26tenUH5ZfrHmo9hV
=MUHd
-----END PGP SIGNATURE-----

--5oH/S/bF6lOfqCQb--
