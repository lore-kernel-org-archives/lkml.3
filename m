Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3JCXyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:54:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56361 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3JCXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:54:51 -0400
Date: Fri, 4 Oct 2013 00:54:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>, Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Message-ID: <20131003235419.GG27287@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y/IXGmCbwaJEfeoX"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Build failure after merge of the char-misc tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y/IXGmCbwaJEfeoX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

After merging the char-misc tree into -next an x86 allmodconfig build fails
with:

drivers/misc/mic/host/mic_main.c: In function =E2=80=98mic_probe=E2=80=99:
drivers/misc/mic/host/mic_main.c:320:3: error: too many arguments to functi=
on =E2=80=98sysfs_get_dirent=E2=80=99
   NULL, "state");
   ^
In file included from include/linux/kobject.h:21:0,
                 from include/linux/module.h:16,
                 from drivers/misc/mic/host/mic_main.c:26:
include/linux/sysfs.h:465:1: note: declared here
 sysfs_get_dirent(struct sysfs_dirent *parent_sd, const unsigned char
*name)
 ^
make[4]: *** [drivers/misc/mic/host/mic_main.o] Error 1

caused by an interaction between the addition of the Intel MIC host
driver and commit 388975cccaaf1 (sysfs: clean up sysfs_get_dirent())
=66rom the driver-current tree.

I've applied the patch below and can carry it for the time being.

=46rom abbabb4580f45accf74f95aed6fe35b26ae8d009 Mon Sep 17 00:00:00 2001
=46rom: Mark Brown <broonie@linaro.org>
Date: Fri, 4 Oct 2013 00:53:01 +0100
Subject: [PATCH] misc: mic: Update for sysfs_get_dirent() cleanups

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/misc/mic/host/mic_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_m=
ain.c
index ca06aa9..50c2ea3 100644
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -316,8 +316,7 @@ static int mic_probe(struct pci_dev *pdev,
 			"device_create_with_groups failed rc %d\n", rc);
 		goto smpt_uninit;
 	}
-	mdev->state_sysfs =3D sysfs_get_dirent(mdev->sdev->kobj.sd,
-		NULL, "state");
+	mdev->state_sysfs =3D sysfs_get_dirent(mdev->sdev->kobj.sd, "state");
 	if (!mdev->state_sysfs) {
 		rc =3D -ENODEV;
 		dev_err(&pdev->dev, "sysfs_get_dirent failed rc %d\n", rc);
--=20
1.8.4.rc3


--Y/IXGmCbwaJEfeoX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTgOoAAoJELSic+t+oim9pu4P/A81KazEwflTp2vj009woy6O
/VcefakTqw7aMzolJCO+yV8hLe4LFX6en/jvGHsg38EksyM+Qa1pBRVkxOlDWQjd
NMQ0ATUGhte+0tmhBaHZAKKO30LsvjkzRF4QjpLX//7ljFbUUZae/YIjEkjwG6E4
AbuinSVrBUQxEIk0imfRrGyEZicDSZgp+KouJ02VEDnAU8i8mE//eo2uJ/YrPgo7
z0uGVcdTxBYCRXdtiilZgUsVuk+gAbxnFMTIEXpBGJv64qIrn+45WiCxCpBdyDLy
j2p1gWiZ0NnvLcTgloF5g5W26tIGKHneqdiZdjqU+2K6wbyJBwgwr8wI6YVy0zZ+
hPXiEri2qlhdGgXWf9EZKL2m5WE23Ldu0R2nH/SalytFlSSy/PboOXGh/Wew/TEd
hnjfRTvryDpo/MLhsN7MSbjyzYOF1hBp+CBZN7oEngRlVSwy43vdreh5OoUvZ6Tx
YxWxwcRODklKNW/R1WjmMWGTCchju22AlTAx+W3NzlMViEU+fPDWSIZB8POgul7Z
XgTIYNKfTJHh4A/jRRCeGsmjUdE+kO6Uq9OWg4Cb9VDKtFsvLK4NNEcXi2JOjBRn
Zr83t2amGjG9s93LIepPPlsOCReUp8qP0Wx20x+NjQ0nDoH+86mlOjXrvrA4NyWy
S199uDL8ZP13uH/6YFd0
=K33k
-----END PGP SIGNATURE-----

--Y/IXGmCbwaJEfeoX--
