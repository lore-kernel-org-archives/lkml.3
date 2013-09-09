Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3IICdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:33:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47376 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3IICdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:33:45 -0400
Date: Mon, 9 Sep 2013 12:33:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20130909123328.123599b5147d68276bccea1a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Sep_2013_12_33_28_+1000_CBLYvXLeo32lV6dk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Sep_2013_12_33_28_+1000_CBLYvXLeo32lV6dk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/autofs4/dev-ioctl.c: In function 'find_autofs_mount':
fs/autofs4/dev-ioctl.c:193:2: error: implicit declaration of function 'user=
_path_mntpointat' [-Werror=3Dimplicit-function-declaration]
  int err =3D user_path_mntpointat(AT_FDCWD, pathname, 0, &path);
  ^

Caused by commit b3a19b078049 ("autofs4 - fix device ioctl mount lookup").

I have used the vfs tree form next-20130906 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__9_Sep_2013_12_33_28_+1000_CBLYvXLeo32lV6dk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLTN/AAoJEECxmPOUX5FEJK4P/jwdARAr+wgSg09ZWil96HQt
f5TdlAD1CNGMEA1Ks17D2zXBVd6vkUwqkjamZ1/nQril0twrB6HLjvnF4YvTK8C5
WBja1UYflFV2cgQuWmfhMIMeQOCX91MVGCbilPUr0z2uN+yOAAMBm9HeyAhnqisq
4HhaVCDNumGDSYN7R3w2UWdcQSF+W3oU/73siiLMYCKdkC/EIzEpqJk+dqSn2Ce0
UVuf6C5+v9nKnZZfNhjJqvHdq5j0fvHgbKgyZ58Vw4ZXknrLXQ8dE0ZCaT0lGDUB
9G+l7eAYTztcZsXqdipVHo3yIDTKt2wSSlSzfagWD02M6kxKt+5iv6iB8H4tU797
zpCqlRtE5b07+POib5xBdcIKd4wpW8DWtQD25MGjMDIqpHchp1lXX4Zat/sOdTRv
lp+9kb7dlpuWGrevyw2uykvzDXFKNmGYPr2slHsWykmnMJECjHLikFqM78Sc6X9s
tuDPmBaotGW46YNjGJ3J0QxpiKSU2wEBUUy/PZGDdZk1yuNJF8I4dmuaAhrMAZGL
dgvFCZbkqXRaJHrJRytpplZ4qG9jgej9IPDnlG9A/09ilIjf9u6Ay0uJnLOVMJP9
PayLvQ0kLLctVtyq7ultvGe7OaPsTHCnlV1NdGnfQQjJkP0eLMe5vM+KxtEbQdxh
o4CPY3wDErn7PjfPyxUy
=Aymm
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Sep_2013_12_33_28_+1000_CBLYvXLeo32lV6dk--
