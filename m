Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaBJMef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:34:35 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40881 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaBJMee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:34:34 -0500
Date: Mon, 10 Feb 2014 13:34:25 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        gnurou@gmail.com
Subject: Re: [PATCH] drm/nouveau: handle -EACCES runtime PM return code
Message-ID: <20140210123424.GE20143@ulmo.nvidia.com>
References: <1392011892-4339-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0H629O+sVkh21xTi"
Content-Disposition: inline
In-Reply-To: <1392011892-4339-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0H629O+sVkh21xTi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2014 at 02:58:12PM +0900, Alexandre Courbot wrote:
> pm_runtime_get*() may return -EACCESS to indicate a device does not have

s/-EACCESS/-EACCES/

> runtime PM enabled. This is the case when the nouveau.runpm parameter is
> set to 0, and is not an error in that context. Handle this case without
> failure.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/dispnv04/crtc.c     | 2 +-
>  drivers/gpu/drm/nouveau/nouveau_connector.c | 2 +-
>  drivers/gpu/drm/nouveau/nouveau_drm.c       | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)

I'm not sure if the commit message is entirely accurate. Looking at the
various runtime power-management functions in nouveau_drm.c (such as
nouveau_pmops_runtime_suspend() for example), they seem to return
-EINVAL if the nouveau.runpm parameter is set to 0.

However it seems like -EACCES is indeed returned when runtime power-
management hasn't been enabled for a device. This is done automatically
for PCI devices, but not for platform devices. We don't support runtime
power-management on gk20a yet, therefore pm_runtime_enable() is never
called, causing disable_depth to remain at -1 and therefore runtime PM
helpers return -EACCES.

Thierry

--0H629O+sVkh21xTi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+MdQAAoJEN0jrNd/PrOhkkQP/jJqMml32+cKwH4jBvnRhFrr
FkmWJpLR9SyDK38304W7gccVfdiRfHZ83t0xxk1pJ4TIDqQgB8FpwDYRpVHaS/bL
ZL2y+5iXxt7lqjHUWz4Gp98iDe7WGPR8ISi07i2L/XH7mcZGrK6CxIoQIk0EYpOV
RDHt2zc4gDakP5bFc8SNpuStZTHIbUpOSwTr08ypEeWjid84FfNIvNGkl/NRhjsW
i8FL7zTplfjZCIfN587rROjFKRBtX1azEQBZD8onDW+rFrdGul/MEpGg/ItxLr8w
r4rNuOyLLHTJFbfh0hw6CsZp0DbRSz82giOnt3naIVqX7E8qT3yLf9PAVh3n94fk
epEzDssgjM4HarFXFE1xMhl2B1hnF73cBJ1jP5Ke1OWAhOv3FXMQmbB5QxB4g08Y
oqlwj7j/FpA6BDV8YGmesFvKZ+Qjvql1XL4BIful4EzLeTTMCEEyg9whM6JYA2Df
6VS2p6Bp0c3ewRWKA2cOs1LruC+WF3GGtyBm9fIB69Z9so2uz6JQd1kpRsL0m+d6
yooZEH6SLk2LawHdwGPoxWULZ6PVLonTq9CXHt9u4eQE2lCLsNMT2x9WWG19vWXa
py/0x8uDT8vb8GXhhEvwtChfuCq9IHRqTeFQ66+tuS+MV/cOUSfecZMj6uMbIjt9
yu2nkjb6hUAvgQZzRA80
=PAR3
-----END PGP SIGNATURE-----

--0H629O+sVkh21xTi--
