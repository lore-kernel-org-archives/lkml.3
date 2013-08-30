Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3H3F0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 01:26:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59652 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3H3F0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 01:26:50 -0400
Date: Fri, 30 Aug 2013 15:26:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        David Graham White <dgwhite11@gmail.com>
Subject: linux-next: manual merge of the driver-core tree with the pm tree
Message-Id: <20130830152640.33496a2559431eb1c10b6f8e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Aug_2013_15_26_40_+1000_bzWTzBWcWtGD9K30"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Aug_2013_15_26_40_+1000_bzWTzBWcWtGD9K30
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/base/core.c between commit 5e33bc4165f3 ("driver core / ACPI:
Avoid device hot remove locking issues") from the  tree and commit
86df26870569 ("drivers:base:core: Moved sym export macros to respective
functions") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/core.c
index ac419a1,c7b0925..0000000
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@@ -1489,21 -1450,18 +1475,6 @@@ int __init devices_init(void
  	return -ENOMEM;
  }
 =20
- EXPORT_SYMBOL_GPL(device_for_each_child);
- EXPORT_SYMBOL_GPL(device_find_child);
-=20
- EXPORT_SYMBOL_GPL(device_initialize);
- EXPORT_SYMBOL_GPL(device_add);
- EXPORT_SYMBOL_GPL(device_register);
 -static DEFINE_MUTEX(device_hotplug_lock);
--
- EXPORT_SYMBOL_GPL(device_del);
- EXPORT_SYMBOL_GPL(device_unregister);
- EXPORT_SYMBOL_GPL(get_device);
- EXPORT_SYMBOL_GPL(put_device);
 -void lock_device_hotplug(void)
 -{
 -	mutex_lock(&device_hotplug_lock);
 -}
--
- EXPORT_SYMBOL_GPL(device_create_file);
- EXPORT_SYMBOL_GPL(device_remove_file);
 -void unlock_device_hotplug(void)
 -{
 -	mutex_unlock(&device_hotplug_lock);
 -}
--
  static int device_check_offline(struct device *dev, void *not_used)
  {
  	int ret;

--Signature=_Fri__30_Aug_2013_15_26_40_+1000_bzWTzBWcWtGD9K30
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSIC0UAAoJEECxmPOUX5FE4p4P/3ipWJlrd3+dPCvcljnD9KSS
J3Cdi6GfQGDc4jDTej9/gkna2i22iLnzvCgfhulcbo9ymN8y8NHWo/m4olKym0MU
2fQspQWYAtyYZhVtvA1jUKPl5sAr6C3uhtklUyUYk7O2k+01D5t4FmJqvrs4inAl
gimXKTRgjq/xyjfpjuq/+vu0/f1ovldK1quDN+DQm9vL8u/f1eKOh1xZ32hkAxZ0
s5dUaLUgrU1sQi96tGxcHf8mOL0qphcJoO6DEyDRr9+yxL4j5vVUEG+698Uwxuoo
LcTiuD8jUBDjlq0dsh4yL0pDTXl2BAg5BaGEKUjOsdaxX7m3V8m6KdeGzbHWyS+U
37T63j4Pm/16uagHUSe6Jdeq5IOwADbtP42U+bDEXG2hJcwr6+iJI2pZugKVYYuT
bC+lDDnBobCR+cHUhkxfCiQEfpIomgyHXc0cicTtyWrrkL1mkBcwMTGB7jbc87f3
nYtH/2nJznbpJ3Z9vZRpRcRX/TsU2j8xSaXV5KHEF6O+X8yP2CkxaFGSsMm2bNk5
oPOxcrHMH+1mdoDeWNzdRPNaMBAmTSDTBfikt3w3o4R9J+MtSb04PoQFD9dk9s0B
0/2vgfOuezg2jnGiYdmDWs7YUJzPJd1jTTJdw59lYOA7ZMd9j9awpAqW2B/h5a2o
KR000VPXlMdKVx/93fXK
=IzwA
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Aug_2013_15_26_40_+1000_bzWTzBWcWtGD9K30--
