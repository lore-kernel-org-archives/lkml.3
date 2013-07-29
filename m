Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3G2FBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:01:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42670 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3G2FBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:01:42 -0400
Date: Mon, 29 Jul 2013 15:01:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: linux-next: manual merge of the char-misc tree with Linus' tree
Message-Id: <20130729150129.76a9fab4023ee22c940b7920@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Jul_2013_15_01_29_+1000_+A8He6yoynWsVV0n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Jul_2013_15_01_29_+1000_+A8He6yoynWsVV0n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/misc/mei/init.c between commit 99f22c4ef24c ("mei: don't have to
clean the state on power up") from Linus' tree and commit b950ac1dabfc
("mei: don't get stuck in select during reset") from the char-misc tree.

(Unrelated white space changes are a pest :-()

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/misc/mei/init.c
index e6f16f8,557eed2..0000000
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@@ -148,8 -148,8 +148,9 @@@ void mei_reset(struct mei_device *dev,=20
 =20
  	dev->hbm_state =3D MEI_HBM_IDLE;
 =20
 -	if (dev->dev_state !=3D MEI_DEV_INITIALIZING) {
 +	if (dev->dev_state !=3D MEI_DEV_INITIALIZING &&
 +	    dev->dev_state !=3D MEI_DEV_POWER_UP) {
+=20
  		if (dev->dev_state !=3D MEI_DEV_DISABLED &&
  		    dev->dev_state !=3D MEI_DEV_POWER_DOWN)
  			dev->dev_state =3D MEI_DEV_RESETTING;

--Signature=_Mon__29_Jul_2013_15_01_29_+1000_+A8He6yoynWsVV0n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9fctAAoJEECxmPOUX5FE8REP/iDnz7kVzm3MQL676aATMay3
mzEdcfM41nYPbtLeN/fly6WL2Q2JJb4VBrmoFtMth8dB7Xt/3OLSfOe2qi+ptgnz
LzitsCdw6sn94IS6XiBgwLjwZNhAdzii7wdC4PBd6sv/IskwchBRxwrWd2vvrEaJ
6Djhvz3ac0Xwwx6JXLHcRTQHoc75+Cr7rUDFWHBSy8xtmq6+ex1EibWNDTtScuN7
geZBCQbvw6X1eeGUuq9XMAqKZe+NU4t+OEHAbCaT8kjjB2h2M5sR/pJUWJKQqn7M
OIc4lfkbOLTbN94mqOnd6BpkvmH3+CULFFfvXl2Akihxx1kRtxFWt0HYM0eMrPlc
hfYuOWYr4N8oFJPJjrvA/gd9wfJgqDrgaloJ3rQGZqyjBuJwsCHOWBjnYi3WwGvA
QKiYcnktbAoHttNI+tLu/0TezxxC644TqWN/aWm67/O9BL0MkQa1089Q4HrISkh7
kbiWATyPW68cRcQ/uY7SQ6JOqxjdsJwpHLUI4LHSqNORX8m6+eVJkfj73fNemASq
JhNrVpT85g8irl0hNzNySQOeH8AmcF+KGDVsG9ZfaXj89S/I9olCojkIvG9Odvag
knlGp/E+Hm8qguHq8uvOeAbNkZfL9yzygJc3bqjRrLLyAoImm8g5OkwL6zNPRNKu
1B/FGRqIE4wuRVV0xfLO
=vb/Z
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Jul_2013_15_01_29_+1000_+A8He6yoynWsVV0n--
