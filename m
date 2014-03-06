Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaCFCYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:24:45 -0500
Received: from ozlabs.org ([203.10.76.45]:33472 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757813AbaCFCYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:24:42 -0500
Date: Thu, 6 Mar 2014 13:24:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhao, Gang" <gamerh2o@gmail.com>, devel@driverdev.osuosl.org
Subject: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20140306132437.f6e754dd5fe316c7ed4552da@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Mar_2014_13_24_37_+1100_lS4ZrYA7avrQS6_1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2014_13_24_37_+1100_lS4ZrYA7avrQS6_1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

[I started by reverting commit 161d78555435 "Revert "Staging: rtl8812ae:
remove modules field of rate_control_ops""]

After merging the wireless-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/staging/wlan-ng/p80211netdev.c:91:0:
drivers/staging/wlan-ng/cfg80211.c: In function 'prism2_scan':
drivers/staging/wlan-ng/cfg80211.c:419:10: error: implicit declaration of f=
unction 'ieee80211_dsss_chan_to_freq' [-Werror=3Dimplicit-function-declarat=
ion]
          ieee80211_dsss_chan_to_freq(msg2.dschannel.data)),
          ^

Caused by commit 3ebe8e257307 ("ieee80211: remove function ieee80211_
{dsss_chan_to_freq, freq_to_dsss_chan}").

I disabled the staging tree driver like this:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 6 Mar 2014 13:17:16 +1100
Subject: [PATCH] staging: disable Prism2.5/3 USB driver

it is currently broken by changes in the wireless-next tree

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/wlan-ng/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wlan-ng/Kconfig b/drivers/staging/wlan-ng/Kcon=
fig
index 426d4efbabc3..56caa46e4791 100644
--- a/drivers/staging/wlan-ng/Kconfig
+++ b/drivers/staging/wlan-ng/Kconfig
@@ -1,6 +1,7 @@
 config PRISM2_USB
 	tristate "Prism2.5/3 USB driver"
 	depends on WLAN && USB && CFG80211
+	depends on BROKEN
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	default n
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2014_13_24_37_+1100_lS4ZrYA7avrQS6_1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTF9xpAAoJEMDTa8Ir7ZwVRsMP/3zuE7CC6oC8ic8XT4q3K2tJ
+apkTnpcZmzkoTKN2DGpDrbrkhvOylRc6nUEDD1xfWUJnG71cwm3yQiVK0b+D3P+
aE0dAWJInl4ANa0ftNOsuEkTCYeKkhYV55e/oB5T4Y9DvpplxQjim4g7J2adqZgv
PULQteU/lyJAn+8z8xs9rDhj5FCNamKWWvkd31+M6vCosFYJJT2UGvsSwf4phW2z
wGZTSymyBXUwehFKRInTdQgpO3j7ew0t7pYNoEaR3/lwu1yUjp+lnGcpOYMQ6sqq
ED0PCBoK4zPtefHAN5fJZqvzTciiVRc/2076KqSrcka7syWnYqqtjTK9eZ9Xtzbl
6p1tNnnVjIIrLu23P4v+dNy814Mmpp7T7y7qfjAymYYvc1A+vr5zrNGC+7Jpq2Hg
NN+9r4RtKHILpJcFVORgtJNgASfYUdcdFoMobzKGwoCrINY7MQT6izt1HDeMPLVw
hp4+VnzJGd+vKNZ6ObdHzuu+Dk2yuuDN/T8ii1Z+0SVx9QwnZs0Z8Pg5nL0SgrDX
l76l1WcD/+zCv8k7WwXWjLLfE/UdAZD4aJYhSR7SOUMi82txddwMrnIKGZc9rdEV
/C94MEWHA2ikPcr95FysSRLORLweflQWQTBpsE6IkOL4gFuzmU2irOIvqCVe2sbG
6ASY5GKKpol1+tNOSLry
=vDpz
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2014_13_24_37_+1100_lS4ZrYA7avrQS6_1--
