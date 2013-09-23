Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3IWDVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 23:21:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44495 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3IWDV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 23:21:28 -0400
Date: Mon, 23 Sep 2013 13:21:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20130923132122.584a5166d14d0ec6d6f1a3a4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_13_21_22_+1000_9XhKD1TmTMv3bfnu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_13_21_22_+1000_9XhKD1TmTMv3bfnu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/iio/industrialio-event.c between commit cadc2125e140 ("iio: fix:
Keep a reference to the IIO device for open file descriptors") from the
staging.current tree and commit a646fbf0fd11 ("iio: use anon_inode_getfd
() with O_CLOEXEC flag") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/iio/industrialio-event.c
index 6be65ef,2390e3d..0000000
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@@ -163,10 -158,8 +163,10 @@@ int iio_event_getfd(struct iio_dev *ind
  		return -EBUSY;
  	}
  	spin_unlock_irq(&ev_int->wait.lock);
 -	fd =3D anon_inode_getfd("iio:event",
 -				&iio_event_chrdev_fileops, ev_int, O_RDONLY | O_CLOEXEC);
 +	iio_device_get(indio_dev);
 +
 +	fd =3D anon_inode_getfd("iio:event", &iio_event_chrdev_fileops,
- 				indio_dev, O_RDONLY);
++				indio_dev, O_RDONLY | O_CLOEXEC);
  	if (fd < 0) {
  		spin_lock_irq(&ev_int->wait.lock);
  		__clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);

--Signature=_Mon__23_Sep_2013_13_21_22_+1000_9XhKD1TmTMv3bfnu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP7O2AAoJEECxmPOUX5FE9FUP/155Xeg/5ve/SahoD0++N5tA
JmpxxCHXh+liVdduB29GiNEE6kesew3n/G8O9X+uD6xwtWXbkxzDX8++0T9pWR7A
Rr/qYemvCbQaDoxngLclcCLwAVYv4XgRZvFxUbCXkbhqLSJxUTVQjtZIln7M8QiE
UkwB7ZZOX0VMAgQ+p5zkH/h7nJw69AyveJ/aqyEyRnFMhxrhRMisGikk6Adaw5qL
TWjKTf/nks+GxE97PNPC40fmFAMQ6km3bljp2y5niYYlxzsqWhX78Lgzk2zOl9hp
ENk1JLEr0AokMixCKvctmM6q9trp4f2cTHIAX/c5fZqcCJh2GqXOHQyFY7BhNPhh
GteAhic+hZkS6VRwFq/LmS/+t9q5/jon4REbw9Oa48KC3mdNveIFlE8hdinYICdr
zZYYNDVvSHLi+rDOlj0Kqi0bwaSiBEadx07sOLFupGaCI9TnIRfvaJi/1vUqxaFl
OO19xJInMGBJJ8/9R+Tuilpfn+Axa0JzXNIKyO8vIP0JYeWPusmguYhN4F9FCgAz
9PqgxonVhcLoozj0N3Htt64svcZXNiyzqE/gX58xMcuRLlPMQ8u2pZfaC0Fg0jRE
Vilrdb01BskyfMpp0ULVlwTlR2VvgSTbSfhR3HKOV1mCCBALoE6pdrXRlkiH+bvY
+Tp6NaZsgeYAF86mk3hN
=Kvn0
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_13_21_22_+1000_9XhKD1TmTMv3bfnu--
