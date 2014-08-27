Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaH0BDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:03:36 -0400
Received: from ozlabs.org ([103.22.144.67]:50118 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaH0BDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:03:35 -0400
Date: Wed, 27 Aug 2014 11:03:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Michael Welling <mwelling@emacinc.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: build failure after merge of the usb.current tree
Message-ID: <20140827110322.5f8a7742@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/9j_3kwmnoE49b=if.2x1x=p"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9j_3kwmnoE49b=if.2x1x=p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb.current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/usb/core/hub.c: In function 'hub_probe':
drivers/usb/core/hub.c:1735:21: error: 'struct dev_pm_info' has no member n=
amed 'autosuspend_delay'
  if (hdev->dev.power.autosuspend_delay >=3D 0)
                     ^

Caused by commit bdd405d2a528 ("usb: hub: Prevent hub autosuspend if
usbcore.autosuspend is -1").  CONFIG_PM_RUNTIME is not set in this
build.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/9j_3kwmnoE49b=if.2x1x=p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/S5fAAoJEMDTa8Ir7ZwV/VgQAJA0eXHY6zg3QvFK+0rRCAwH
Q01+/m9AsBdXhNo5DjcuqTllCgLAH+cKw1D39E53UATTimYwa1EQBdWrjYqrdB0W
TiMiFkOcl9l8Aalri4AHj5h5LUTdlYH2uuaVdw/IvCWUwhtIuRtQmlsL/B9PTJPA
f7hvdz7Zy6+l1ywC3ZgGXsKHxMzm4Uldbrm1U5q8BltmbUthM6uvl5DTpDj5Rbm1
FHDajofbyxW++hE/29Fk+A3ZFuLZGrv3Ta0YTaTIvzq0V5xXIfalz04oAd4Ur46M
JOhpR9MAhkB1AoTcXLh7o0nHtPJbiOdlQu5wmN/CLSAWFO/XIkht47/050ItNu6U
kOwUqFjIpaCn27bt3VwoGKYjcBBDtl/DxRSbBkkRyqhbWzBI8N8zg97J8MUhWXLq
KUe5P+oGCv47d2DdRtSwTCCG1bROGGBjTTuhVMG2MDObuAODj9GF7/ZYMc8AxPoW
MG8JM4/x+OhDcGnWpyA/hkvrtdJxwUoH8Sz/YueAZJHk5hTje78t8T9SNdzvGFHP
6TDu7C9mPRE7PU0Hp4+kRux3eHAEjpmzEewslw0a5aYj44YRFBWSBHQH7SXHM9l/
QNJYiQ0cWrJFlQIb3c6wpS5niubLOUX3IFBvQ88eFVLfs9X+YFRccnmkUFNxUrVu
UkDpnUo4cQ6HUXbACgk4
=7lQC
-----END PGP SIGNATURE-----

--Sig_/9j_3kwmnoE49b=if.2x1x=p--
