Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbaDWHSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:18:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55364 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaDWHSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:18:37 -0400
Date: Wed, 23 Apr 2014 09:17:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [RFC 4/5] drm: Introduce drm_set_unique()
Message-ID: <20140423071714.GB31226@ulmo>
References: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
 <1398179373-29966-5-git-send-email-thierry.reding@gmail.com>
 <20140422154807.GT10722@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <20140422154807.GT10722@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 05:48:07PM +0200, Daniel Vetter wrote:
> On Tue, Apr 22, 2014 at 05:09:32PM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Add a helper function that allows drivers to statically set the unique
> > name of the device. This will allow platform and USB drivers to get rid
> > of their DRM bus implementations and directly use drm_dev_alloc() and
> > drm_dev_register().
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/gpu/drm/drm_ioctl.c | 37 +++++++++++++++++++++++++++++++------
> >  drivers/gpu/drm/drm_stub.c  |  1 +
> >  include/drm/drmP.h          |  3 +++
> >  3 files changed, 35 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
> > index 2dd3a6d8382b..371db3bef60c 100644
> > --- a/drivers/gpu/drm/drm_ioctl.c
> > +++ b/drivers/gpu/drm/drm_ioctl.c
> > @@ -42,6 +42,20 @@
> >  #include <asm/mtrr.h>
> >  #endif
> > =20
> > +int drm_set_unique(struct drm_device *dev, const char *fmt, ...)
>=20
> Can you please add a bit of kerneldoc for this? drm_ioctl.c isn't yet
> pulled into the drm reference docbook, but better to have it there
> already.

On second thought, wouldn't this be better located in drm_stub.c? It
isn't really related to the IOCTL code except that one of the IOCTLs now
uses the information set by this function. Logically I think it belongs
with the likes of drm_dev_alloc() and drm_dev_register().

Thierry

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTV2j6AAoJEN0jrNd/PrOhns8QAKJMDsLDrjshdO63vOCPEEtm
YvHN0a/NBTOSlSME16RVmSH9QQWXavWPSGhmT9N+w41VMOdz2VU1veclIfTAjcP4
u51UHEInfXEX/42Orc08df/5uq303Phr0snMFI+/aZZ1sDFjyye3TMlGRnMCRFSt
FARi9z/sh0r/hp2VVpVe62yrHskOfcNbfvgvqOx5rb35nH8bUuK8mp6BALu8xMJO
vF7ZT4OQo2lbY5R+L4kxiMAbViROGNcjnY4g6wVjwNUfsQV6syI7UYFE9nudPj2O
zJOakx84nL2wx5k0PNX31MN7uCoNHvnaulmIDLnV2AxOdldlSZG+CLGWkT752gFY
uyEGmUmrcvF76x63CmNIGIyYsqC0dp2AuHIxBbYGeSX7gQ5qL6dcTLiCZPrSQ7mS
HZIg+so6CQ3EiSOC71oKJWoMwWeq69GUZ7DO/H7O1C5GGhbxMuqKtFywMIQ0V76u
lRlkKgZOnEIqRgikTY30O0+Ox5rsTdDLIMIDNaBaLTUJtDCE4tDmleTCzAacCL0c
XLBmf94ZPfaMTd+ilsMaklhABcuNTPOuOtCbmaHe8+2MuUna/egTVssbtXGYRm2m
TEGDTte/EXQX2UZyp0G2yEDn4aT69wFQIrr5J1KdIrUqk6eaPC4nFU5WzYf7lAGp
cqYUU2Sp1ng5GO5drUur
=5lee
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
