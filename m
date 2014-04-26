Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaDZUWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 16:22:30 -0400
Received: from mout.gmx.net ([212.227.15.19]:53883 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbaDZUWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 16:22:05 -0400
Date: Sat, 26 Apr 2014 22:10:29 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: Remove unused pointer in
 rtw_wdev_free()
Message-ID: <20140426221029.33a59eff@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/E8lhfDKq+WThB5eiH4ES7+v"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:gbaqeaSLQ47v0u2uzGgd3B5Lr/vS2gOFa2HZOE4V82kI6X+3Vmm
 KZetj93eH0XoICSr7j5uxfzd5k9NHxu6WSaHuhgJBMiNmT7YBSmWuvlCz+VnJ1uAgRLoxVA
 WffQrf++meeLBMbUGSC8QxdQnpQ31JsgIOsNPzFZu/Z5fQhgL4Hm225gH34r6E2o5a4eN3E
 J3GUAJ4UjD4nouPHtPsJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E8lhfDKq+WThB5eiH4ES7+v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Pointer 'pwdev_priv' in function rtw_wdev_free() is unused - thus remove it.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against v3.15-rc2 as well as branch staging-next
of tree git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/st=
aging/rtl8723au/os_dep/ioctl_cfg80211.c
index ca100dc..be89741 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -3576,15 +3576,11 @@ exit:
=20
 void rtw_wdev_free(struct wireless_dev *wdev)
 {
-	struct rtw_wdev_priv *pwdev_priv;
-
 	DBG_8723A("%s(wdev =3D%p)\n", __func__, wdev);
=20
 	if (!wdev)
 		return;
=20
-	pwdev_priv =3D wdev_to_priv(wdev);
-
 	kfree(wdev->wiphy->bands[IEEE80211_BAND_2GHZ]);
 	kfree(wdev->wiphy->bands[IEEE80211_BAND_5GHZ]);
=20
--=20
1.9.1

--Sig_/E8lhfDKq+WThB5eiH4ES7+v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXBK1AAoJEKssnEpaPQKE2JsQAL2lASzB3asLiLlxqLKSLfzS
yZB+gNvIo9ci4H0Qm5XwgRXibhKyYVSCoNjfZiVYr+qi49MdthPw0ltES7Kc+7Xq
tKfAAzGOS4CK8JCQsX+Aq5NGQ6xGOv8ROJseJHU8hoxSc2XQZ+JMr+h7UjEvhZ0d
VAW96hHgcYbpIlADCjlQZWF87q9e4OcKxgiOh5b/6o0dWc7RzTc7dFAP5cH4XxeV
u1bQFV1BArCNM6of5UdiRiNSLpQoVSasrYPP4K7UP+pYBrbhok7hdq8Q8ahA7azN
VtOtcU6TSrf+HYcb+i/i8EcLoXBq+kX9Gcfg5LxpUo9wUdKeLGpjfdePwpfo9rUT
F19sZ0tZ9DQL/8mfcBAndzSQ9dgl5wXQASmdyMnZoYE2h1iAeufxcEC9wZ/9kMwr
m9RBv/+bQltqXB5ZjFhaMlfjtyQRTruCHYronsjkH9+EdVfOw5i7Sbgv8F4gsQEc
IaE1tLuFM4ICyBp3xsrFiWKDNw6dlhfLM5wd9zWUcxCsfjKx9ZhshtVY/yJ5NgFr
/AsxoAq8fGNLL43Jvty9HYenh7Ol0pKUNFf/nT5l8hkhON3qt+S4+ZpQL4nn83am
xQoeIMadBLUtuKxFexispvvBCkUQOCu1LmPMy9O/ZgvT4RPhfFoUZSjXqZQ4Z4we
hhbYqhc8Vm1Wxpaop5pn
=uQrj
-----END PGP SIGNATURE-----

--Sig_/E8lhfDKq+WThB5eiH4ES7+v--
