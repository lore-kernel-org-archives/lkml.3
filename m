Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaEBPSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:18:54 -0400
Received: from mout.gmx.net ([212.227.17.22]:54996 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaEBPSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:18:53 -0400
Date: Fri, 2 May 2014 17:18:30 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        ebru.akagunduz@gmail.com, hemaklnce@gmail.com, peter.senna@gmail.com,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6656: fix potential leak in
 vt6656_hostap_ioctl()
Message-ID: <20140502171830.30f53ce7@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/9Ry=IX8Wj33F8q3PVzE5Qfh"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:QxSRci1aubkQTLB/9vW3AHpUaiafLMCdjCX6Ohev0wW97sPTWy+
 w0QzZBOoTw7GdxT5JHuVN533BJM1cMNUSJEhiCfQUy15V0exmKwUnoVLD0tLZ3O4LFFc2fn
 D1ym/EeZTlUempYiXMpSkWXXCZBuGAfCT5pfVKq6y5F83HxWEKzCLBWMfgrBVPg1mhEVeDG
 yDKRgjY9+gkUWOZcET5Nw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9Ry=IX8Wj33F8q3PVzE5Qfh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Commit fb841d67 (staging: vt6656: don't leak 'param' in vt6656_hostap_ioctl=
()
when returning -EOPNOTSUPP) cleaned up direct returns in the ioctl switch
statement that leaked already allocated memory. Fix the same issue for
VIAWGET_HOSTAPD_SCAN_REQ and VIAWGET_HOSTAPD_MLME that are also not support=
ed
by this driver. Detected by Coverity - CID 144381.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/vt6656/hostap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hosta=
p.c
index 67ba48b..a0d9fff 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -742,7 +742,8 @@ int vt6656_hostap_ioctl(struct vnt_private *pDevice, st=
ruct iw_point *p)
=20
 	case VIAWGET_HOSTAPD_MLME:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_MLME \n");
-	    return -EOPNOTSUPP;
+	    ret =3D -EOPNOTSUPP;
+	    goto out;
=20
 	case VIAWGET_HOSTAPD_SET_GENERIC_ELEMENT:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_GENERIC_ELEME=
NT \n");
@@ -751,7 +752,8 @@ int vt6656_hostap_ioctl(struct vnt_private *pDevice, st=
ruct iw_point *p)
=20
 	case VIAWGET_HOSTAPD_SCAN_REQ:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SCAN_REQ \n");
-	    return -EOPNOTSUPP;
+	    ret =3D -EOPNOTSUPP;
+	    goto out;
=20
 	case VIAWGET_HOSTAPD_STA_CLEAR_STATS:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_STA_CLEAR_STATS \=
n");
--=20
1.9.1

--Sig_/9Ry=IX8Wj33F8q3PVzE5Qfh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTY7dGAAoJEKssnEpaPQKE4o0QAI4hhcam1goNtzto3eT8MTaA
lC7hGmirEKYWTExlsAd3NRUeckYFXjEwICDbMqCnOL7/hLcXpXJgdZpDI9WMR4Mb
oYY2j5SPnaHJq0uitfTliRAdWDDrPWwJAwpJ3TmW5irwVCs4rhnWq1yNSGxlVMIM
yPBTTBdeceYIDQPyOtipEqdD4pN6nJe/nF7rmYhhO1QIa7zrc8qRrf/A3d8GF1i6
T8hvbU0SvaK4DBmCYt66CA5HEdjATmP5U+VKmjSWfTL6JLkHiq+A6mJfz92H+8l4
qPkFlcGPovbOYVmuH7CsgMBDaRJ29z/WgkV9IDGQaJ66hx2Mok0mp8KLE2lofR1g
TBOjz7othFqpl5Gi9xkzddaVrmMLM+40N36YonMS/edFK24r44SsmDKlpljnt9JO
16hzmE0FAFyXPlgSGZWu7sDKuYZN8uWnIsJC0W2X3cz02+9CdvmXzJ5iojQb3UFV
xWYVl84j0NxRpq10ZsfcQ9rst66YW1jwPIbQ/moa0zNmI4uZszvZve3Xz3JAEdWH
LaJ3pXo2P9lxkLVPc4e4hYqh2R+zU8Z4wTdIYtk/AT3zldncSbcV5c8OuiHMdsVC
DcbecgkgGjhrKl8exhILoQIWVK4NjQK3G22Y50kDKKuK/VQj2Ong3g4EI4ShM7pI
eqGdalcg7jqbPjEYNlnE
=zeGx
-----END PGP SIGNATURE-----

--Sig_/9Ry=IX8Wj33F8q3PVzE5Qfh--
