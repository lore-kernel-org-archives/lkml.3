Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaCMTc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:32:59 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42113 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbaCMTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:32:58 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: next-20140313 - build error in e1000e driver
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1394739168_1654P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Mar 2014 15:32:48 -0400
Message-ID: <59774.1394739168@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1394739168_1654P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

My kernel has CONFIG_PM_SLEEP=3Dn, which leads to hilarity...

  CC      drivers/net/ethernet/intel/e1000e/netdev.o
drivers/net/ethernet/intel/e1000e/netdev.c:7079:13: error: 'e1000e_pm_sus=
pend' undeclared here (not in a function)
  .suspend =3D e1000e_pm_suspend,
             =5E
drivers/net/ethernet/intel/e1000e/netdev.c:7080:13: error: 'e1000e_pm_res=
ume' undeclared here (not in a function)
  .resume  =3D e1000e_pm_resume,
             =5E
make=5B5=5D: *** =5Bdrivers/net/ethernet/intel/e1000e/netdev.o=5D Error 1=

make=5B4=5D: *** =5Bdrivers/net/ethernet/intel/e1000e=5D Error 2
make=5B3=5D: *** =5Bdrivers/net/ethernet/intel=5D Error 2
make=5B2=5D: *** =5Bdrivers/net/ethernet=5D Error 2
make=5B1=5D: *** =5Bdrivers/net=5D Error 2
make: *** =5Bdrivers=5D Error 2

Commit 38a529b5d4 claims to fix a related issue, but doesn't seem to do s=
o correctly.

Author: Mika Westerberg <mika.westerberg=40linux.intel.com>
Date:   Thu Jan 16 14:39:39 2014 +0200

    e1000e: Fix compilation warning when =21CONFIG_PM_SLEEP
   =20
    Commit 7509963c703b (e1000e: Fix a compile flag mis-match for
    suspend/resume) moved suspend and resume hooks to be available when
    CONFIG_PM is set. However, it can be set even if CONFIG_PM_SLEEP is n=
ot set
    causing following warnings to be emitted:
   =20
    drivers/net/ethernet/intel/e1000e/netdev.c:6178:12: warning:
        =E2=80=98e1000_suspend=E2=80=99 defined but not used =5B-Wunused-=
function=5D
   =20
    drivers/net/ethernet/intel/e1000e/netdev.c:6185:12: warning:
        =E2=80=98e1000_resume=E2=80=99 defined but not used =5B-Wunused-f=
unction=5D



--==_Exmh_1394739168_1654P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUyIH4AdmEQWDXROgAQI+2BAAqK/1BppxvGY6/wAdKVGf4O9uEoDSPVvU
wbsUQNqideiisVhsIw7vjoFmBLfMeMOSboxNd3ToJmxIQgaIReYhTynI3dCGaHAC
yu+XhMRlVezgv8TGl5B4x3F4g9gV70HE7PQcO4/v8ndr6UzzOHgoqgn7LPjoRH87
VvxKsS8kzubHjeV6mvBxFmxHwH1yV9J3O9E5qPw5lK0XamOWUdfv9M4RJV/u7L3x
kk7QcsJRqNOR2Qu6VrsbPGfiNgKWWVjLXRyr+NTavTu2enWFzimyfa3JCfFIKIok
8NSBH5RxbpucEhLsAnjXLlROQiysLDoaHoG2hOeDmb6bw016H3FiiqqCk5SWrqlO
ACWQ3N3rjAxp052FjlcT6HtyjFDMoqA7owOAsH4Tbm4yy8BTl6g8NDaeKPmm/h1G
jfyerOI/blsBfT41LyExzBBo7/1SoMnXwgAnrb6AtdowIpqkjohO2noNrXjHjgGs
Ch0C7gYTUs8EIoHZ3CPhjwEj46IJHItGg3A2oJxVdzxTvrpsNzzWWBrrAxmEMz/0
RteF5IjFdVpJ+A5g1MeLTzld+BRZyTBoXj7oYxnPLyfzE/syqTlLHpDMicoU5CcO
/XZdVZnMjobnhqUfgrNBlzeTev9MUIEbGfRHkyzhNWrlyx/qc8gS2AgVB8qsvLyX
Or/2xPdI5L4=
=4iK+
-----END PGP SIGNATURE-----

--==_Exmh_1394739168_1654P--
