Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaFDXtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:49:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:48796 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbaFDXsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:48:51 -0400
Date: Thu, 5 Jun 2014 01:48:46 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Carlos Chinea <carlos.chinea@nokia.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hsi: omap_ssi_port: use normal module refcounting
Message-ID: <20140604234846.GA16356@earth.universe>
References: <7426698.eEpYu3o0WK@wuerfel>
 <4579153.ES6XlsZ43F@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <4579153.ES6XlsZ43F@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 04, 2014 at 10:00:59AM +0200, Arnd Bergmann wrote:
> The ref_module() function is used for internal housekeeping of the
> module code, it's not normally used by subsystems or device drivers,
> and the use of ref_module in the omap_ssi_port driver causes a link
> build error when modules are disabled:
>=20
> hsi/controllers/omap_ssi_port.c: In function 'ssi_port_probe':
> hsi/controllers/omap_ssi_port.c:1119:2: error: implicit declaration of fu=
nction 'ref_module' [-Werror=3Dimplicit-function-declaration]
>=20
> This changes the omap_ssi_port driver to use try_module_get()
> and module_put() instead, which is the normal way to ensure that
> the driver providing a device used in another module does not
> go away.

Thanks, applied:

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/commit/?h=3D=
for-next&id=3Db357d7b58f379ebe8038cd97b6204f2f5c52220d

-- Sebastian

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTj7BeAAoJENju1/PIO/qac5YP/3iVFD6UynjVHKWwkRFmiUgS
+iJntl+MclSfLiXdeEGnlxyqd0faSrG2hbJLen7d5Cr+968q8NGBqaFRuXFbg5S9
+RkE2oudi4j2TgIvYTfOf9iOLXpesWvV8pugLGVTUdZWmXmp6r5fyBgVfRgh0+T4
nF/5ZSZSYBbdqEXTokyLVLuFS/DRB6QqBxG40IFhwiTMj56mQFWSO9LTJpkPumKf
JOvAJfOTG9pto9tidpgNr85SyJOkszfJlTNrfTOGyA1zSFuFUF0htEdCFdmTdL7K
wfAl024qBFq85WN2q4ULP1oWmkk7OPjDqCFAUDQMhNiCQ51l74oHyRta29m/pIWP
mdMKsJ+07mkoyip0dc8hEsWboabdFCknrC3eTu4WYBoGJcjquEhE+7BlAeMGxhBP
c7fAG243urI+z6qwF26yXXBbNioUbLnZymNRNev/M1su6NabC05Wj0B7isCtobN2
o4AdwF+yTeaklHsRFsRzkiOVFISzQqdkyIybNDVYci7Jl0/vNW60J/bU2n0oH2fL
RmDaN5fKUAChHq+EUa/aEwF9fj4tEyuKhZYe2iAcX6yXBFbF0RLkDrh8zogELQL1
UidJ4+ZrcHu8Em8b79X+wQvQubth7PmS1ukAXXmGJe85Fzl+XV10PGHY5ChAWci4
DnoifoX3xorsSIBIJlEg
=uzPR
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
