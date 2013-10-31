Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3JaHk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:40:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40585 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3JaHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:40:27 -0400
Date: Thu, 31 Oct 2013 18:40:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philippe Proulx <philippe.proulx@savoirfairelinux.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20131031184015.adc000259e9931fd0b5d5cf7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Oct_2013_18_40_15_+1100_9Qu7nDNPJ7_4YSFw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Oct_2013_18_40_15_+1100_9Qu7nDNPJ7_4YSFw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/tty/serial/omap-serial.c: In function 'serial_omap_probe':
drivers/tty/serial/omap-serial.c:1724:22: error: expected ')' before numeri=
c constant
drivers/tty/serial/omap-serial.c:1724:22: warning: format '%d' expects a ma=
tching 'int' argument [-Wformat]

Caused by commit e5f9bf72efbc ("serial: omap: fix a few checkpatch
warnings").  There is a missing ',' in the dev_warn() ...

I have used the version of the tty tree from next-20131030 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_Oct_2013_18_40_15_+1100_9Qu7nDNPJ7_4YSFw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScglkAAoJEMDTa8Ir7ZwVZO0P/0jjp55VkKU5FlGBCVuQD+Hl
WVUT2xJmLgfKhOfpsmHRGziCiC9dfBBJA7/WUci5QfJPA6FrQwnO0bpiKgYGNzHk
2uCb6Wq7+g0G61LHB5hE85n5+8b/kfNB9elUModUFHerkj7oS0enGV3vF0VCB4Zh
19OmZ+1owdAx2PgULLytLcixpPBgoV1fAfsYHguoHKuiljAWGsxikzi4YMrFjlVv
8pvA32i19PAumwKdxcKrbpgvUpoiibLjyxFxSK9vn4AzyO4vwkv8Uls2tgUOEXnG
kwn64oTphf7OGXY49tfSokdu2HnSZOe6HIb/+hMKdviYt/etu65wa9v7R2/lHhB6
HMXpRvlbfr2vr7aVNlRMBhtEcRl6G+M9YZeaOE4jdixtS4e7OvDmwYmNsMkraeGw
YSON5QqiV+iES65Wjk79CAxQhRDAwnLmbFrv/6kLjIknNzz26j2lkLWGB9ASf3Xu
XP28zBcslw/9EHDyKIGekN7xDGrbceDSccuATW57NQ3jIlobPWvpJ9ur73RcfEmF
wnpLpMT912PTK80QsRK/qWoeG/ZZ/eiikyDXDISP1Uif0ZtPE5O6LnHijKlPmzIE
IehGOA61jidtn/uhnVIFoHjCCdg7ESv27+53aZqsAFt5Dzpdo5QpiSZzqcOzVuQQ
Toh+wVIVky38mSgRSUcE
=9+yQ
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Oct_2013_18_40_15_+1100_9Qu7nDNPJ7_4YSFw--
