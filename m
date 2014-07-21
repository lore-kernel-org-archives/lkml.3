Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbaGUQAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:00:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60450 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbaGUQAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:00:22 -0400
Date: Mon, 21 Jul 2014 10:58:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
CC: Felipe Balbi <balbi@ti.com>,
        Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 0/9] usb: musb: several bugfixes for the musb driver
Message-ID: <20140721155853.GK6852@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <20140718161636.GA18460@arch.cereza>
 <20140718165044.GA30821@saruman.home>
 <20140721093430.3f528cc7@ipc1.ka-ro>
 <20140721151140.GG6852@saruman.home>
 <20140721155352.GA20226@arch.cereza>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="08ATZu8fEq0x2T3M"
Content-Disposition: inline
In-Reply-To: <20140721155352.GA20226@arch.cereza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--08ATZu8fEq0x2T3M
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 12:53:52PM -0300, Ezequiel Garcia wrote:
> On 21 Jul 10:11 AM, Felipe Balbi wrote:
> > On Mon, Jul 21, 2014 at 09:34:30AM +0200, Lothar Wa=DFmann wrote:
> > > Hi,
> > >=20
> > > Felipe Balbi wrote:
> > > > Hi,
> > > >=20
> > > > On Fri, Jul 18, 2014 at 01:16:36PM -0300, Ezequiel Garcia wrote:
> > > > > Hi Lothar,
> > > > >=20
> > > > > On 18 Jul 11:31 AM, Lothar Wa=DFmann wrote:
> > > > > > The first three patches do some source code cleanup in the file=
s that
> > > > > > are modified in the subsequent patches.
> > > > > >=20
> > > > >=20
> > > > > I've applied patches 4 and 9 on a recent -next, after fixing a co=
nflict
> > > > > due to patch 3 ("usb: musb_am335x: source cleanup"):
> > > > >=20
> > > > > > Patch 4 carries the proper fix reported in commit:
> > > > > >         7adb5c876e9c ("usb: musb: Fix panic upon musb_am335x mo=
dule removal")
> > > > > >=20
> > > > > > Patch 9 reinstates module unloading support for the musb_am335x=
 driver
> > > > > >         which was disabled due to a false failure analysis
> > > > > >=20
> > > > >=20
> > > > > For these two patches, Tested-by: Ezequiel Garcia <ezequiel@vangu=
ardiasur.com.ar>
> > > > >=20
> > > > > Tested on a beaglebone with a mass storage USB device, module loa=
d/unload
> > > > > works without issues. The module_get/put in the phy is now preven=
ting the
> > > > > musb_am335x driver unload, which seems to be the real cause of th=
e issue
> > > > > I reported. Thanks for providing a proper fix!
> > > >=20
> > > > I don't that's a good fix. The problem is that even after am335x
> > > > removing all its child, someone else tried to release the PHY. That
> > > > ordering is the one that needs to be fixed. Doing a module_get on t=
he
> > > > parent device looks like a hack to me.
> > > >=20
> > > No. It guarantees that the module cannot be unloaded when its resourc=
es
> > > are still in use!
> >=20
> > it's still a hack. You have a child incrementing the usage count on its
> > parent just because a sibbling isn't doing the right thing.
> >=20
>=20
> How about having the musb_am335x (glue driver) call request_module and
> module_get on the phy-am335x? Wouldn't this be a cleaner approach?
>=20
> I haven't checked if this possible, though.

at most, you would have the phy layer do that so that all PHYs get usage
counter incremented when they're in use. We can't have this 'fixed' for
MUSB only.

--=20
balbi

--08ATZu8fEq0x2T3M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTzTi9AAoJEIaOsuA1yqRERCMQAJZVGRdD4NN0SGZSnQglcJvx
+dzOJfWZ6Abw7ai13jD1TC1i1j6aMxoSUC+wgx0MnX+mGJi5bMpJThpxCwhsu0W9
hoMDokIsd9rmOFt3iQvo2LqRmi9YuPHfN0J8RQdl370Az2pDiIMfx+6EoTCUjwsi
A4l/NRUN0nkDkb1znKtJnU12luWuJ9QgkWgi+UAykYC+LrDGIgSUiMzBZZWevZK6
GU3uS4ca/EshzTiso1NkGR5byJJqtRVIasQiDFIVX9wxFV8kOGFDisayn9unBk+A
1X/WKVTq4rggfGUCRPTi87RHDP4+J9VK4pFCSvGboqv48ZZ1ZLIlKdWQaomZgjG2
ynl1rre+msXvVTVDOkdhJ1RFjfP2mNYs3W33tPoPn+qWQhETg1MefnKvLQ4fen6M
LeH5K6E3L6/m6PawqLlsLzfB2wGyTNtE4oedUl7+noOs9OQlmHh+2sLKQcICAFUV
wC7Jjt+oTUrCcBzaqnpbV5ba+235BjEWiAIdEMj+3b6izuKgj5ywxmscWyWNPZV2
s9akXc00OCsU6XkCaa+JUx+HN0hhPYt6cYumnvsmrqqZ4ds/z/xQHx6zKG5pBE4G
FA0lr4YBKmzrJkgDhc57F5NQqjvFv4zYH1jYeVpXkuhmmvyJvnBP7FP7PRPHti79
/xE3UlTNoDN6RxobGEth
=NGSA
-----END PGP SIGNATURE-----

--08ATZu8fEq0x2T3M--
