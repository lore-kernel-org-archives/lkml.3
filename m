Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938Ab3JPUab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:30:31 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:47947 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3JPUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:30:29 -0400
Date: Wed, 16 Oct 2013 22:30:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>
Subject: Re: [PATCH -next] misc: fix various misc/mic/host/ build errors
Message-ID: <20131016203024.GA6579@mithrandir>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C481E.1010908@infradead.org>
 <20131016192648.GA19637@kroah.com>
 <525EEBD4.7070800@infradead.org>
 <20131016194440.GA14416@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20131016194440.GA14416@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 12:44:40PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 16, 2013 at 12:41:08PM -0700, Randy Dunlap wrote:
> > On 10/16/13 12:26, Greg Kroah-Hartman wrote:
> > > On Mon, Oct 14, 2013 at 12:38:06PM -0700, Randy Dunlap wrote:
> > >> From: Randy Dunlap <rdunlap@infradead.org>
> > >>
> > >> Fix various build errors (on x86_64) for drivers/misc/mic/host/:
> > >>
> > >>   drivers/misc/mic/host/mic_main.c:378:3: error: too many arguments =
to function 'sysfs_get_dirent'
> > >>   drivers/misc/mic/host/mic_intr.h:134:58: warning: 'struct pci_dev'=
 declared inside parameter list [enabled by default]
> > >>   drivers/misc/mic/host/mic_intr.h:134:58: warning: its scope is onl=
y this definition or declaration, which is probably not what you want [enab=
led by default]
> > >>   drivers/misc/mic/host/mic_intr.h:135:58: warning: 'struct pci_dev'=
 declared inside parameter list [enabled by default]
> > >>   drivers/misc/mic/host/mic_device.h:169:2: error: implicit declarat=
ion of function 'ioread32' [-Werror=3Dimplicit-function-declaration]
> > >>   drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_read':
> > >>   drivers/misc/mic/host/mic_device.h:169:2: error: implicit declarat=
ion of function 'ioread32' [-Werror=3Dimplicit-function-declaration]
> > >>   drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_write':
> > >>   drivers/misc/mic/host/mic_device.h:183:2: error: implicit declarat=
ion of function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
> > >>
> > >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > >> Cc: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
> > >> Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
> > >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >> Cc: Nikhil Rao <nikhil.rao@intel.com>
> > >> Cc: Sudeep Dutt <sudeep.dutt@intel.com>
> > >=20
> > > This is a -next issue only at this point in time, I thought it was in
> > > the -next tree as a "fixup" already?
> >=20
> > Are you asking the driver maintainers?
>=20
> No, the linux-next maintainers.
>=20
> The driver maintainers have nothing to do with this, it's a sysfs change
> in my driver-core tree that causes this issue.

Well, we do carry a patch to fix this, but that generally doesn't get
carried to Linus' tree automatically as far as I know. So I guess it's
fine for now, but when the merge window opens you'll need to make sure
that Linus merges the branches in the correct order so that the build
doesn't break in between.

I think the typical way to solve this kind of build dependencies between
trees is for one tree to provide a stable branch that can be merged into
the other. That ensures that each tree can still be built independently.

Thierry

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXvdgAAoJEN0jrNd/PrOh22MP/13nqqFWrUG0dIhc39pHa1Xm
VeMs6pDP7BEE5I0hcmK1iTdl+mWXELDcxQjn7pwAwWrsmeVrekIvid6w4wt+0qGx
/JXdo2WL9W7oW3Qjrxadt/DRPI9f9Nb+uKvCYdW7NTiGsa0IfZHz8Hoar+azn/RF
8M1Z3ANYFs50IO4axpNvxv/MGzwkTqX6IdUCG/zrPYAn8pmVgLdcbNVaxiPWH8Ex
jXmYgl166qwj8RR5B2u/CvOqyS9nG1Fb3Re2T0AjE6K64X/EyNV8JwzN667rkOP8
T98qvZc9Oht1vQX6JNQ4apUAO2zlDnZl919Zjyt0IBORZa0tiV5GXo6MtZ+BAEye
b3H6RLAAUf+4YJd50YxJYEyVIq8hubb+eQDQPohi5anA4vSzqC14g4lH1aAQNP4p
a+uoViYbuQSq4WSoZS49jv+JZSaqJ7leYtdb3rwpY1LexXdnSfj78pOvCOYZt+u4
QFifNQJiKHGiAYO5VqPQc5ayJ6cn8g7YiMrw5rSf9+OTc39zudCxZrqzyum80JTV
WqPJTm8vp4L8A2pVRbp9UGU5UQ12yFGFNCa/nITe/RxnSoMYTjCSxzDAJQaVKnpN
2vhruT6lHY5vjyXaNZ1wjXXFh8/uzQLqrZp32ZlFE/0UPrTyKp2ecTziuKF928el
jamK0jbGeElFkrKdwgbe
=67cF
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
