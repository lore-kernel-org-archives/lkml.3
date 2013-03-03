Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3CCX6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 18:58:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51486 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3CCX6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 18:58:49 -0500
Date: Mon, 4 Mar 2013 10:58:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the pm tree
Message-Id: <20130304105841.39ba4afbd1b45cf0b31e4449@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Mar_2013_10_58_41_+1100_fm+2neOn1GiXb+lt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Mar_2013_10_58_41_+1100_fm+2neOn1GiXb+lt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/base/power/qos.c: In function '__dev_pm_qos_flags':
drivers/base/power/qos.c:64:2: error: implicit declaration of function 'IS_=
ERR_OR_NULL' [-Werror=3Dimplicit-function-declaration]
drivers/base/power/qos.c: In function 'dev_pm_qos_constraints_destroy':
drivers/base/power/qos.c:248:2: error: implicit declaration of function 'ER=
R_PTR' [-Werror=3Dimplicit-function-declaration]
drivers/base/power/qos.c:248:17: warning: assignment makes pointer from int=
eger without a cast [enabled by default]
drivers/base/power/qos.c: In function 'dev_pm_qos_add_request':
drivers/base/power/qos.c:294:2: error: implicit declaration of function 'IS=
_ERR' [-Werror=3Dimplicit-function-declaration]
drivers/base/power/qos.c: At top level:
drivers/base/power/qos.c:202:13: warning: '__dev_pm_qos_hide_latency_limit'=
 used but never defined [enabled by default]
drivers/base/power/qos.c:203:13: warning: '__dev_pm_qos_hide_flags' used bu=
t never defined [enabled by default]

Caused by commit 1e3b5df683e2 ("PM / QoS: Remove device PM QoS sysfs
attributes at the right place").

I have used the pm tree from next-20130301 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Mar_2013_10_58_41_+1100_fm+2neOn1GiXb+lt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRM+OxAAoJEECxmPOUX5FE8+IP/i0b0yx95vC2GyNfnivRg58A
lLa/+jJdS3HgQ0taNzlUnjO0h5I7nWYSeoNZl92flB2KVu/Q0nMfScpm1fJDdhqD
7WWXvXbyNb9vWFXz49JwoyWQY1VoKQDaktkNXf2B9a4x4XJQqfdGpMl4PHhAE656
jAtZeNhQOqoZYHgTJVM9BPvCoLXN50pFSl0SQbOKld+L6zgUk+za8WUQjj77BHpt
OdIMsx4HWzM0lAKaLDbuhaEr0u9WQ88sY2hjGBu7RZlKBn11HGn+Ts18Y7Ohj5I6
roEpJrdCI7wwN1UrTP7EA176XgNkzgVEyx6daMZJemhEq6ob0seapTpiBYDuq/Fu
1MuFrErjDdVI1vsRQjnYqMdwKfxeX4QER04NUab4F6jbddC4dT51kv9JSDYj7m9D
HqxGJTxIptj+ybVKfzVDuFLmHcnvBouE2dLL4jVVmRq8mMjj6+kaiSW3HG4QiXtY
cMMnZV/xu1N0C8qvCj21LiF+n1Cu488WXhYRiqNmPONJT28W6okrmOAaH6Sc2Jtl
XpZhI5zFrrZ0z10yAl5lDXDwX3xK/5Lx+oUjKRhZiRjvE7ACJ1iOF37/OQ2wUHjd
creMhE6fMtlMlWH11RiF/xr3OpDjJpuVj2wE5j3Pnh+o7/EYNBZrgOMt7bhodZ0t
WxCLINCUm5WBNVt+mH/R
=GkuH
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Mar_2013_10_58_41_+1100_fm+2neOn1GiXb+lt--
