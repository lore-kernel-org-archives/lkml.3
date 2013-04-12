Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3DLHGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 03:06:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62885 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab3DLHGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 03:06:44 -0400
Date: Fri, 12 Apr 2013 09:06:35 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 17/30] pwm: samsung: repair the worst MMIO abuses
Message-ID: <20130412070635.GA16956@avionic-0098.mockup.avionic-design.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-18-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1365638712-1028578-18-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ixAQDyRsLs5XrpO+OO1suf2zkLFwRegF6FgLQU3G0Dn
 2bWBVdn4oikERI4RyfLxaq5VFzuYW9Ph+bOm4Dwy01C69Gj7Ni
 iQf4Yn+UUxaIi7vaEK2P7X8lGWQtDHJ+ZwzqdvaRTTYoMzvuTG
 gbBhD4Svzkm+mGVH+434BtCYhhDQ5xWzVHk7GLaQWbouKJvN/F
 59vRTV1TDBz1bY39fnC6kBThi/mV4x68IlXjn2b19RO2i/LgKi
 uFoJY1aa+GE8fxanCF25/ESIAysHAq9Lyu80XvUAIXsXj7ys2m
 zRPS/nkZS3iHw+jYoX/w9+j10HNRjNL38vTPgzfxiJ/vU/gPH0
 xGs60EwFfLGzeCNImBQnJMVIDqyrB6//MeiTuGv2F4GgVBPe1s
 HBc1EKwqjFRK5ZZmPAYKX0c2P6H2H6Z/eI4B0edzh0TSOj1xJO
 x7Xno
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2013 at 02:04:59AM +0200, Arnd Bergmann wrote:
> The Samsung PWM driver uses "magic" pointers that are mapped
> at boot time to point its MMIO registers. This fails horribly
> with a multiplatform kernel, which can not rely on platform
> specific header files to contain the right values, aside from
> this being a really bad idea in general.
>=20
> This changes the driver to at least pass an __iomem token
> around in the device structure to dereference that. Fixing
> the platform code is much harder, so we'll leave that
> until we have a DT binding for pwm-samsung, which may require
> other changes in this area. Since we are already touching
> every MMIO accessor in this driver, let's also use the
> proper readl_relaxed variant rather than __raw_readl.
>=20
> Tomasz Figa has a set of patches to clean this up in a proper
> way, but that might be too late for 3.10.

Joonyoung Shim (Cc'ed) posted a driver for Exynos back in December. I
had a few comments on it but never saw an updated version. Is Tomasz'
work based on that patch?

Given that this patch solves a real problem and doesn't make things any
worse, I think it's okay to use it temporarily until Tomasz has had time
to finish up the proper driver, so:

Acked-by: Thierry Reding <thierry.reding@avionic-design.de>

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRZ7J7AAoJEN0jrNd/PrOhWooP/0sH9skapnvO6em/hZeZNTbB
7zZAF+BFIihftvdoR8TIwjHJ6Ks1xPDTgh3g1YURxajk98UGse/U01iX6Us0NSFn
g8xXSpQbx/6rlLuq2dWM8uYrKV2t7MShcGDRY8BTUMRpP4PHhrNQugVkXnaSE3Ac
PXK8MfcimKEEj4RCfwjZTgUccu1FQ9/3NIrrHlH1Svd/bFqw7Gg3HeHq3lIZUxKg
QvgHD+h9XfgA/0gZLCY8nAuDw0ruvnin3DB/qIyrlcpp3gHlZhGg8sOpOSrpHI1p
UwEGEcLR74JvgQwFEy1R9/l5D2D4cF7hF5w31TY0vm9BmQoPNyL3BpbPlKNj7lAO
4XRmRzmU7yyS2CtjUrMiaEikJhU0K2v5g52fSBOKlVDM/00QSRCrXz+BP6p48Vay
5pqtN9ow6UdG0Nlyr+xitLgNXJL7b5ZKP5OhGPOkkGiiPlMw4lY0u+P88G4rt/ia
Spj5K5g7gv3ymA3GefFS6JQcE+EvJjCt91CXUCk2hwydGKwhOY15VOBQU/mKLWTV
dS84oTydGq+cUSq4Cr7zZVRsSkn7YcOyhj1kAAwhvD0S2ihX9/3tnDDWvNqsFb2P
8oOYao7VdbJMPpTWIZRlO+cjaLS09iBgrMNi1xwyJH8KgGNh5pGq9/3W1Yhs2vT0
VNEW1Ul0VQfUOuEzP3L1
=S6JW
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
