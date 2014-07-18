Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793AbaGRQv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:51:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33371 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaGRQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:51:27 -0400
Date: Fri, 18 Jul 2014 11:50:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
CC: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 0/9] usb: musb: several bugfixes for the musb driver
Message-ID: <20140718165044.GA30821@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <20140718161636.GA18460@arch.cereza>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20140718161636.GA18460@arch.cereza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 18, 2014 at 01:16:36PM -0300, Ezequiel Garcia wrote:
> Hi Lothar,
>=20
> On 18 Jul 11:31 AM, Lothar Wa=DFmann wrote:
> > The first three patches do some source code cleanup in the files that
> > are modified in the subsequent patches.
> >=20
>=20
> I've applied patches 4 and 9 on a recent -next, after fixing a conflict
> due to patch 3 ("usb: musb_am335x: source cleanup"):
>=20
> > Patch 4 carries the proper fix reported in commit:
> >         7adb5c876e9c ("usb: musb: Fix panic upon musb_am335x module rem=
oval")
> >=20
> > Patch 9 reinstates module unloading support for the musb_am335x driver
> >         which was disabled due to a false failure analysis
> >=20
>=20
> For these two patches, Tested-by: Ezequiel Garcia <ezequiel@vanguardiasur=
=2Ecom.ar>
>=20
> Tested on a beaglebone with a mass storage USB device, module load/unload
> works without issues. The module_get/put in the phy is now preventing the
> musb_am335x driver unload, which seems to be the real cause of the issue
> I reported. Thanks for providing a proper fix!

I don't that's a good fix. The problem is that even after am335x
removing all its child, someone else tried to release the PHY. That
ordering is the one that needs to be fixed. Doing a module_get on the
parent device looks like a hack to me.

--=20
balbi

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTyVBkAAoJEIaOsuA1yqRE/e4P/3lLygcxiWcLu6PrQiQjtRqY
QEcXy3gShdCL0350zKevXXuQz0H61Xeu0OLuD91vFuaLC6DKe8+BQ0XnmRMAQdXz
3eXQV9e12QieFgmuNuP856seg07Q/Jtc+pAXrFlumkXXZ3PPZRRgIUytczHTNh8W
PvMddWdjd/NsK9IvZMAuq2rMIAmQy2Z3gwFOD+psOg3fj8fLojb6UVP/ncM2RrGH
ni4gHj21f6emlIxsPnhgna/8njiduTSyF1/Ms9Js32VXmRJISZjsnFqtopYFv69y
49PPvRu8e2kYurPODMK65tmiaqRkALyxA3vKVMZMFxY5LrzLZ6QgIeZkQ9d3IUIr
D/3aziqeUexxpCi5NwN3BuxrPe0CiEa7zXDjv3W1NiDndunjscisV4hif/0m4svg
PH0NuMvyz96rqcdLpoFgLRMx+4XlOjQuofqGRF+nyw47d7lEfEQHrTpvyyR31WRz
+Vb5Og2PSOh4ftbLa3l+9Bf2nt4V/ZIp3hy10km/zpEoWoQe2hO0S22vF/+bdE1d
hYoBADqqhUBmwMYArBKFcO+gJH01BKMUIRgZAPUUEMrcxPBBPwHqHZbyYU0hheyd
Tzlz39YbQUCgxL/yXJnY+0Vnr0sIB43wYENrE9zFNHG97inPaL7TZsqkvCNzMxcg
a/CMU5DGBIxurWj0uPAp
=6bc6
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
