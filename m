Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaESP15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:27:57 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36245 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaESP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:27:55 -0400
Date: Mon, 19 May 2014 17:25:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 5/7] drm/tegra: Convert to master/component framework
Message-ID: <20140519152539.GA30978@ulmo>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
 <1399995050-28435-6-git-send-email-thierry.reding@gmail.com>
 <CAH9NwWfF_rMWqPRzr7sPFkwwME1ZXG8=Np3NHDEib1MDm1tgWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <CAH9NwWfF_rMWqPRzr7sPFkwwME1ZXG8=Np3NHDEib1MDm1tgWA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 10:56:08AM +0200, Christian Gmeiner wrote:
> 2014-05-13 17:30 GMT+02:00 Thierry Reding <thierry.reding@gmail.com>:
> > From: Thierry Reding <treding@nvidia.com>
> >
> > Instead of the current implementation, reuse the recently introduced
> > master/component framework, which is equivalent in most regards. One
> > issue is that there is no device to bind the DRM driver to. In order
> > to still allow the driver to be probed, expose an interface from the
> > host1x device and provide an interface driver to bind to that.
> >
> > The interface driver then registers (or removes) the master that will be
> > used to instantiate and bind the DRM driver. Since the drm_host1x bus
> > implementation is now gone the dummy device instantiated by it can no
> > longer be used as the parent for the DRM device. However since the
> > parent device doesn't need to be modified, the host1x parent device that
> > exposes the interface can be used instead.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> Is there a git tree somewhere to have a look at? I am interested in the u=
sage
> of the master/component framework.

I've pushed my latest working branches to gitorious[0]. staging/work is
the branch that has everything.

Thierry

[0]: https://gitorious.org/thierryreding/linux

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTeiJzAAoJEN0jrNd/PrOhsTsP/0E6ll2MhSOn+aggmPYaS7EO
DYZgGrYEq3ME+WPN0MgOLRv3H237YHMvBNV/mnZOCliVVMB5hTrwMzcdiN8GUYCh
wei3JQi0wCjwvAAQyaB2LfGJIVaNkEb66VwcgTVN0ryBJvQD5eMQmDhdoGupqtuN
EIPAGqS1EibP9RArhH8xAB4eLAHJ+q2AqUkEkBNb9Me4ASiRsr22GlSmR4IFDbUD
7eCHTyFVYVvukG5TjOz1qxlOqs69cHSFuiZyhW/EIYt0iqc2nRA/8f84+T0h83Yf
Wk9qJQZr1/DIh0jYtfG8ryvgQn+RDd+a1X7WORusjYOG0AcWs4ZHOMADMLKYFqaE
7Kw7kCKomq9qZfrkTDUeciBjijlnUKbSGIgu3xrn1UjFFqU/AXpgdKlU/aJ2Smnb
iJw2QjK0xc42dIGxzQkKj2ypRTdqpA4tGVnpzT5PVI2E31M4NgPnzjQlO00AzWkf
m9ylnl+rtrDw/v4VW2S58WQfhMwYhXjpESpNXhyRjsJP+D4BZ6zs2y/FY6WqDZGX
7fnpQDgpPA/B8ivs2rVJQB/P0mHnAjTehUnjIjKq99+RLOB5AH5W1FaifZsRbgE6
itQpOt9SWtibVHJWztD/t4eFSG6DuEZi241kfPRkeV0YEwWNFukWFJ91Y+WWBXmg
EPbw+0704BcMaQozdjN8
=qUBH
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
