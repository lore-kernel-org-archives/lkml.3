Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab3FSBWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:22:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44865 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687Ab3FSBWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:22:18 -0400
Date: Wed, 19 Jun 2013 11:22:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Elder <elder@inktank.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20130619112207.e7c50605c8f93bce4ccdcae0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_11_22_07_+1000_vcoj0R6CTxskVvx3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_11_22_07_+1000_vcoj0R6CTxskVvx3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
drivers/block/rbd.c between commit db2a144bedd5
("block_device_operations->release() should return void") from Linus'
tree and commit 87f11b7221f7 ("rbd: don't hold ctl_mutex to get/put
device") from the ceph tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

BTW, Sage, there is no Signed-off-by for you in the ceph tree commit (and
several others - even though you committed them).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/block/rbd.c
index 3063452,f24e241..0000000
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@@ -507,9 -505,9 +505,7 @@@ static void rbd_release(struct gendisk=20
  	spin_unlock_irq(&rbd_dev->lock);
  	rbd_assert(open_count_before > 0);
 =20
- 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
  	put_device(&rbd_dev->dev);
- 	mutex_unlock(&ctl_mutex);
 -
 -	return 0;
  }
 =20
  static const struct block_device_operations rbd_bd_ops =3D {

--Signature=_Wed__19_Jun_2013_11_22_07_+1000_vcoj0R6CTxskVvx3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwQfDAAoJEECxmPOUX5FERNkP/i43oPdkJjhOT7P3Lxf5fGux
8P66eXYljBHI4HvSOc+3obLXk63iFBefqfcdNP+WoAy5QYhq+hzxBexxE7Jzm29C
X4AnR76ua7/T8PzMTfkfIVlRkgsW2JDIXTnUwR7RUz2hKDhi+RA4AeUYwCyh8i+x
LFafcwKi1fSYGG7Ar8p+3UWs2N/RzxkdxtoheiDlhUg0RqgbY7eJW7spWgfUJ2Sg
GOoha7VQv3m6usPUxflBhW7gipzEPFJXoPJFG3IAKAp/JxhKDxF6AR2xACjUSQjN
WGarJbaoo4wR7n4ekApF7rci/XgRmX4OOZPRlGaI08skCan4RPR6dho6D1mfeFO8
B3Xf5lG8JVIp47kauvZj5zlLEj8wOG1srv+XJdwU45V/VL5i1E/MYtMO8eIndiLe
AQVDwSU7vdBTECURARRFjo77Cna5ryCwacvqQeAbQp7NWgZOXBJJVA5Uqfcnnyph
1LDNYxlSF50nm+IF1sN3uaUiL1Z+ZxFzRg53SQtDkt/Sm488V8n1dnuIjj6WTDtL
apIdnJUuwEJyi3AHWC/bzhuh3MD87W0i9IFkaR+oO6tpWofdmHkYtFs6Za/VVYnR
Vz6rN86c22mNV1/GClZ+xSS0E47WgVTBm6SLFhaHGItAPahYgb6B/FxRF3eVRvpM
oGmSZX1x2s7WjBFyhcZ/
=Jed+
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_11_22_07_+1000_vcoj0R6CTxskVvx3--
