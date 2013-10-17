Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3JQOEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:04:47 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:42286 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab3JQOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:04:45 -0400
Date: Thu, 17 Oct 2013 16:02:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>
Subject: Re: [PATCH -next] misc: fix various misc/mic/host/ build errors
Message-ID: <20131017140224.GA32734@ulmo.nvidia.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C481E.1010908@infradead.org>
 <20131016192648.GA19637@kroah.com>
 <525EEBD4.7070800@infradead.org>
 <20131016194440.GA14416@kroah.com>
 <20131016203024.GA6579@mithrandir>
 <20131016203727.GB1633@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20131016203727.GB1633@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 01:37:27PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 16, 2013 at 10:30:25PM +0200, Thierry Reding wrote:
> > On Wed, Oct 16, 2013 at 12:44:40PM -0700, Greg Kroah-Hartman wrote:
> > > On Wed, Oct 16, 2013 at 12:41:08PM -0700, Randy Dunlap wrote:
> > > > On 10/16/13 12:26, Greg Kroah-Hartman wrote:
> > > > > On Mon, Oct 14, 2013 at 12:38:06PM -0700, Randy Dunlap wrote:
> > > > >> From: Randy Dunlap <rdunlap@infradead.org>
> > > > >>
> > > > >> Fix various build errors (on x86_64) for drivers/misc/mic/host/:
> > > > >>
> > > > >>   drivers/misc/mic/host/mic_main.c:378:3: error: too many argume=
nts to function 'sysfs_get_dirent'
> > > > >>   drivers/misc/mic/host/mic_intr.h:134:58: warning: 'struct pci_=
dev' declared inside parameter list [enabled by default]
> > > > >>   drivers/misc/mic/host/mic_intr.h:134:58: warning: its scope is=
 only this definition or declaration, which is probably not what you want [=
enabled by default]
> > > > >>   drivers/misc/mic/host/mic_intr.h:135:58: warning: 'struct pci_=
dev' declared inside parameter list [enabled by default]
> > > > >>   drivers/misc/mic/host/mic_device.h:169:2: error: implicit decl=
aration of function 'ioread32' [-Werror=3Dimplicit-function-declaration]
> > > > >>   drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_read=
':
> > > > >>   drivers/misc/mic/host/mic_device.h:169:2: error: implicit decl=
aration of function 'ioread32' [-Werror=3Dimplicit-function-declaration]
> > > > >>   drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_writ=
e':
> > > > >>   drivers/misc/mic/host/mic_device.h:183:2: error: implicit decl=
aration of function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
> > > > >>
> > > > >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > > > >> Cc: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
> > > > >> Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
> > > > >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > >> Cc: Nikhil Rao <nikhil.rao@intel.com>
> > > > >> Cc: Sudeep Dutt <sudeep.dutt@intel.com>
> > > > >=20
> > > > > This is a -next issue only at this point in time, I thought it wa=
s in
> > > > > the -next tree as a "fixup" already?
> > > >=20
> > > > Are you asking the driver maintainers?
> > >=20
> > > No, the linux-next maintainers.
> > >=20
> > > The driver maintainers have nothing to do with this, it's a sysfs cha=
nge
> > > in my driver-core tree that causes this issue.
> >=20
> > Well, we do carry a patch to fix this, but that generally doesn't get
> > carried to Linus' tree automatically as far as I know. So I guess it's
> > fine for now, but when the merge window opens you'll need to make sure
> > that Linus merges the branches in the correct order so that the build
> > doesn't break in between.
>=20
> Yes, I'll do that as part of my normal tree submission process.

Actually, ensuring correct merge order won't be enough, will it? That
doesn't magically fixes that the function's signature actually changed.

Shouldn't the update of the sysfs_get_dirent() call be fixed within the
same patch that updates the sysfs_get_dirent() signature?

Thierry

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSX+3wAAoJEN0jrNd/PrOhk4QQAKdty12NACyeHpBQMH076LRf
zLwiG1gBPNypH9l1h/1skYUa2crRXrKcPrH3MW/8kIsC6WpxOSjvSPgzZs/qH6iE
TpOJL5nZ7KArr9aivUmZr7drK4JS1H1osfV2aO/n0+C2XuB/N9ryx5gsq7a6rWhz
qO1LvkBkYJyeFoqZL9YxKlKhWpJyWkVqfc5lVHX0lQvFEF5BeEWUGdv+Dnrw4uKx
BRxYPI98ZxLXRktRa6ebEESMoiaDbvJwiz0ImgSG9rj2Bc0cszgXJNEp+Y7/6kCw
U38cN13IzR7GbvCE2ipOCrLMqzDWFDVI4LrfqBWG1OMSTWTPRY8c2pMCjkJymS6m
rS7Rc6WWs0sXCNPNlKzCyuE5vRJbv3Co5dMN2SpSdNR56vCy8OIvgpJLjAs3G/jA
r9E9KQ/txuf+n++RPEJPAqSMjRtVSEjb6nt8fefANbRTbUdHXcq/6h66ZpythHtP
tgLuge2e6orZrpXFosz8NRPAaoyQxWVUfdrRX3jP9UhE/8NczreueAyZr/eFOQWd
eoSANGMMV+TL2w5EH6sCjFAi2hqEM0vKja/1JoP7U4swNQRn7oVcbYKrjPgq798a
oBHvk5B3dyNvVHkw0UQGeGUif6nWBAnvSP/IbOfH9QmiDj4uerSQki0uRyzdvHs8
BGpXovHhxjtJwKZWgCiw
=iASK
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
