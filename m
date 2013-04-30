Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3D3KeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 06:34:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42871 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759848Ab3D3KeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 06:34:03 -0400
Date: Tue, 30 Apr 2013 13:33:18 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sam Ravnborg <sam@ravnborg.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, "Balbi, Felipe" <balbi@ti.com>
Subject: Re: Kconfig "softdepends" idea
Message-ID: <20130430103318.GB12161@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <517F9472.2030106@ti.com>
 <20130430102440.GA15522@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <20130430102440.GA15522@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 30, 2013 at 12:24:40PM +0200, Sam Ravnborg wrote:
> > So, my idea is to have a new kind of Kconfig dependency. I'll call it
> > "softdepends" in lack of better name. A driver maintainer could use
> > "softdepends on ARCH_OMAP", instead of "depends on ARCH_OMAP", to say
> > that this driver does not actually build depend on ARCH_OMAP, but for
> > all normal purposes it does.
> >=20
> > Normally, this would result in the same behavior as the normal
> > "depends", and Linus would not get a questions whether he wants to
> > enable this OMAP specific driver or not, and the driver would not be
> > visible on the menuconfig.
> >=20
> > But the user could enable the driver if he explicitly so wants. Perhaps
> > a Kconfig option such as "ignore softdepends", enabling of which would
> > allow the user to enable the drivers that use softdepends. Or, maybe
> > just require the user to add the config option manually into his .confi=
g.
>=20
> If I understand you correct this is already possible today without
> extending the kconfig language.
>=20
> config OMAP_SPECIFIC_DRIVER
> 	depends on ARCH_OMAP || SHOW_ALL_DRIVERS
>=20
>=20
> If SHOW_ALL_DRIVERS are "y" then user can say "y" to the OMAP specific
> driver too, even without ARCH_OMAP being selected.

SHOW_ALL_DRIVERS might create another set of issues. If Linus isn't
taking patches removing 'depends on ARCH_OMAP' would he take patches
adding SHOW_ALL_DRIVERS ?

I think something like 'available on ARCH_OMAP' might be useful,
however. We could start converting depends on ARCH_* into available on
ARCH_* and when build testing we could:

$ make DEBUG_IGNORE_ARCH=3Dy allmodconfig
$ make drivers/usb/host/

Would this be acceptable ?

--=20
balbi

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRf53uAAoJEIaOsuA1yqREN4UQAJDFHCDHwTz0aUJ8J7OBXb4g
wgVkO2VORJsQTKzCtVpOAO5c1LNlwhPWiQjULlwm/a3q4IOs5ev0ftSxoS+TjCMD
/evR+4rj4KJBlVagDriH8aLeoipQw2jSalKQb+zNfLWjHF+ODK4pkiQQ4B2QbCEg
ULRO9ke9gj6TzwJIS1fD3IK9WfJizAhq3XbHEbfCk2wUEXCBULzFLBkxH0H11vTr
Dydx8OXgaFgsowq6VPUkJH1fgaWhKhR+is+C0KrQgcMb8TxKUg/SLG/Yid1rBiXZ
KqZGdIoLkkAHgBWfOTTsMt7mACC0NCv9CLY1VeSX0Jes0zwJZy+PbOrfp1QVLM0e
6B847bYqoK+AxmM6jwE9tbwezmj1A8Nb7aFNiheyl//INfn+eT55dgRRrQ4SUNTw
FXnuinY48pa4YEMtlFznjdPK+00MLuJiOt/On4g2GcCN3N7WK+I3q1ko6hP10unF
UwFI7IDNpem96ZQSDW7hEr3tWyZOYFj9Jf1DmLmnJKB+znkodsnWtRKRTCWgsdZM
i+WfbpwV52rHs/x7dN2370N79hOxoiPLNEluA2zW/2dxxPvZuPQ3wTQ+yTStDp+y
RuhRLJSm72xJFK2dH4UoeZIQOvBK/J555QP3y1L7TDJJX3mcH/l3fznz7ipR7g+8
ntRzbrvfOGm+cVaFSOzL
=ttXS
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
