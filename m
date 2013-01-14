Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab3ANWQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:16:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55724 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3ANWQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:16:16 -0500
Date: Mon, 14 Jan 2013 23:15:51 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130114221551.GA30020@avionic-0098.adnet.avionic-design.de>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
 <1357371910-3164-3-git-send-email-ldewangan@nvidia.com>
 <20130105080658.GA1315@core.coreip.homeip.net>
 <20130106192739.GA11566@avionic-0098.adnet.avionic-design.de>
 <20130106195748.GA28212@core.coreip.homeip.net>
 <20130109070745.GA12782@avionic-0098.adnet.avionic-design.de>
 <20130109091939.GA4369@core.coreip.homeip.net>
 <20130109092352.GA28037@avionic-0098.adnet.avionic-design.de>
 <20130114154959.GA25049@avionic-0098.adnet.avionic-design.de>
 <20130114161644.GC14721@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20130114161644.GC14721@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:zit8yfsI44HGVAhUbvHiXAvqdrxMUlqRM8oksc+p8cU
 H0jtDD7H3P4Mdky3AEIOPWqZYOWkhOpSoHuCgU2yToUqgF27nz
 yjnT12uCpA7IYG9c0VPvksH4eg9W4OjtfFqkTWib9UZZQfYdQR
 oRLSo90mH8IWA7Iy3QIMIERHFXeYihZ0JyyGsvoe/gVqpDaxIy
 Lx7DkA5jyZZih54uhm0f7FvC7Wc4KrUhljlpAHcTELAC3Kw6LZ
 iXB5UD+vGKQSPXH6GX9vkYcrNHbnCdI1qlze6Oi3+nCCnDKF/0
 8XEQ8flAuaB/gGm83Bpbd/SG9TN0/cFBlOHRkal75Ji+33aU+H
 Gz44Bf1cp128tDU7W/NYptCGKJDy0/PptfRQKz3R9DvmMFbRPb
 zLkBw/RtYq2yNeE0XI4Ta+jD84xrJFcDtMoptMw89M3LXB+iqe
 rV1Du
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 14, 2013 at 08:16:44AM -0800, Greg Kroah-Hartman wrote:
> On Mon, Jan 14, 2013 at 04:49:59PM +0100, Thierry Reding wrote:
> > On Wed, Jan 09, 2013 at 10:23:52AM +0100, Thierry Reding wrote:
> > > On Wed, Jan 09, 2013 at 01:19:39AM -0800, Dmitry Torokhov wrote:
> > > > On Wed, Jan 09, 2013 at 08:07:45AM +0100, Thierry Reding wrote:
> > > > > On Sun, Jan 06, 2013 at 11:57:48AM -0800, Dmitry Torokhov wrote:
> > > > > > On Sun, Jan 06, 2013 at 08:27:39PM +0100, Thierry Reding wrote:
> > > > > > > On Sat, Jan 05, 2013 at 12:06:58AM -0800, Dmitry Torokhov wro=
te:
> > > > > > > > On Sat, Jan 05, 2013 at 01:15:08PM +0530, Laxman Dewangan w=
rote:
> > > > > > > [...]
> > > > > > > > > @@ -735,25 +738,16 @@ static int tegra_kbc_probe(struct p=
latform_device *pdev)
> > > > > > > > >  	spin_lock_init(&kbc->lock);
> > > > > > > > >  	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (uns=
igned long)kbc);
> > > > > > > > > =20
> > > > > > > > > -	res =3D request_mem_region(res->start, resource_size(re=
s), pdev->name);
> > > > > > > > > -	if (!res) {
> > > > > > > > > -		dev_err(&pdev->dev, "failed to request I/O memory\n");
> > > > > > > > > -		err =3D -EBUSY;
> > > > > > > > > -		goto err_free_mem;
> > > > > > > > > -	}
> > > > > > > > > -
> > > > > > > > > -	kbc->mmio =3D ioremap(res->start, resource_size(res));
> > > > > > > > > +	kbc->mmio =3D devm_request_and_ioremap(&pdev->dev, res);
> > > > > > > > >  	if (!kbc->mmio) {
> > > > > > > > > -		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> > > > > > > > > -		err =3D -ENXIO;
> > > > > > > > > -		goto err_free_mem_region;
> > > > > > > > > +		dev_err(&pdev->dev, "Cannot request memregion/iomap ad=
dress\n");
> > > > > > > > > +		return -EADDRNOTAVAIL;
> > > > > > > >=20
> > > > > > > > Erm, no, -EBUSY please.
> > > > > > >=20
> > > > > > > EADDRNOTAVAIL is the canonical error for devm_request_and_ior=
emap()
> > > > > > > failure. The kerneldoc comment in lib/devres.c even gives a s=
hort
> > > > > > > example that uses this error code.
> > > > > >=20
> > > > > > I am sorry, but I do not consider a function that was added a l=
ittle
> > > > > > over a year ago as a canon. If you look at the uses of EADDRNOT=
AVAIL it
> > > > > > is used predominantly in networking code to indicate that attem=
pted
> > > > > > _network_ address is not available.
> > > > >=20
> > > > > EBUSY might be misleading, though. devm_request_and_ioremap() can=
 fail
> > > > > in both the request_mem_region() and ioremap() calls. Furthermore=
 it'd
> > > > > be good to settle on a consistent error-code instead of doing it
> > > > > differently depending on subsystem and/or driver. Currently the v=
arious
> > > > > error codes used are:
> > > > >=20
> > > > > 	EBUSY, EADDRNOTAVAIL, ENXIO, ENOMEM, ENODEV, ENOENT, EINVAL,
> > > > > 	EIO, EFAULT, EADDRINUSE
> > > > >=20
> > > > > Also if we can settle on one error code we should follow up with =
a patch
> > > > > to make it consistent across the tree and also update that kernel=
doc
> > > > > comment. I volunteer to do that if nobody else steps up. I'm also=
 Cc'ing
> > > > > Wolfram (the original author), maybe he has some thoughts on this.
> > > > >=20
> > > >=20
> > > > If you going to change all drivers make devm_request_and_ioremap()
> > > > return ERR_PTR()-encoded errors and then we can differentiate what
> > > > part of it failed.
> > >=20
> > > Yeah, that thought also crossed my mind. I'll give other people some
> > > time to comment before hurling myself into preparing patches.
> >=20
> > I've prepared a patch that changes devm_request_and_ioremap() to return
> > ERR_PTR()-encoded errors and adjusts all callers. As you can imagine it
> > is a bit on the huge side. scripts/get_maintainer.pl lists 156 people
> > and mailing lists. I've gone through the list, and as far as I can tell
> > everyone on that list is actually affected by the patch, so there's not
> > much potential for tuning it down.
> >=20
> > There is also the issue of whose tree this should go into. Unfortunately
> > the patch can't be broken down into smaller chunks because it changes
> > how the devm_request_and_ioremap() function's return value is handled in
> > an incompatible way, so it won't be possible to gradually phase this in.
> > Furthermore I can imagine that until the end of the release cycle new
> > code may be added on which the same transformations need to be done. I
> > have a semantic patch to do the bulk of the work, but quite a bit of
> > coordination will be required.
> >=20
> > I'm adding Arnd and Greg on Cc, maybe they can advise on how best to
> > handle this kind of patch.
>=20
> You should provide a "wrapper" function that does the correct return
> value, convert drivers over to it, and then, when everyone is changed,
> drop the old call.  To change 156 different drivers all at once, in a
> way that is not detectable by the compiler breaking the build, is not a
> good thing to do at all.
>=20
> By doing it in this manner, it will take longer, but you can push the
> patches through the different maintainer's trees.  If they are slow,
> I'll be glad to take the remaining patches in my driver-core tree to do
> the final bits.

It certainly sounds like a less complicated way to do it. But it also
involves adding a function with a made up name and drop a function with
a perfectly good name instead. I wouldn't even know what name to choose
for the new API.

Thierry

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9IOXAAoJEN0jrNd/PrOhpzIP/1nnZVmPvoVuQmLXjf0NZ7rf
5WIrjY9B5LSpCr1vqt2KIPAoYuOwM6PPTU2jmk7yl0TV2ZMzAj4l7ooTPQqrGhYy
3Q9jwdrO2MLPRT2jW+/6c4UFBbK0M++gLw5AWBkDNPlocAyd2LlqJQIcJZBekfaI
UNeZnVGaXCd8oHDKQeYzzet+LG486eBjX3HwxlnsCHyLSjA/HM/x4UG10EvM3+qA
2xmUFuEKfIvqVEeQg1zNIyXeHnU47rMb9LmpANyau1rjE9EZtvgyBt9fDhutpEcj
cg9SQWjQakZ67tTz3WP9NBKFaWXi7gMZiyw448E1LM+NABM+qTmzQCDHTDoenCyq
PxLeMOhctSBSHva9uT2hoOycFOS8hLR0twKWxwpakSAQqMv6S/NRZnnsiWDftmeT
pKgjwQb6XkSNT+01lAA044+Lnhn7Lk4JGN2uE0bXiq4zO1n0Iknyp9BwWWzmInEM
6S+fTfelg5npfm02NgvzLDY9sVCqyqZYNQzNvpVsd2kHpEugAd+eAAwaOna8Troh
zM6FWeLtp0YP3NceFsNn4txDdbi9G6UANiKiMPdspglOSSp7ldN+60JG25SKF1Wy
0YO2a3kynWVGRi5njTAArt0LdHmYqLvHeuJKTvrQ3sDBEaXiKhLhspqveNqO9JGz
Qx3E80c9Yj6B66x9jmeY
=1of4
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
