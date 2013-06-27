Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3F0HO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:14:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54377 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3F0HOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:14:25 -0400
Date: Thu, 27 Jun 2013 17:14:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the driver-core tree with the pm tree
Message-Id: <20130627171418.6293697ff334ecc1a79608da@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Jun_2013_17_14_18_+1000_z0cqa8usfkqWy_Vd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Jun_2013_17_14_18_+1000_z0cqa8usfkqWy_Vd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
include/linux/device.h between commit 4f3549d72d1b ("Driver core: Add
offline/online device operations") from the pm tree and commit
bfd63cd24df6 ("driver core: device.h: fix doc compilation warnings") from
the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/device.h
index eeb3331,9d4835a..0000000
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@@ -655,8 -650,7 +657,9 @@@ struct acpi_dev_node=20
   * @release:	Callback to free the device after all references have
   * 		gone away. This should be set by the allocator of the
   * 		device (i.e. the bus driver that discovered the device).
+  * @iommu_group: IOMMU group the device belongs to.
 + * @offline_disabled: If set, the device is permanently online.
 + * @offline:	Set after successful invocation of bus type's .offline().
   *
   * At the lowest level, every device in a Linux system is represented by =
an
   * instance of struct device. The device structure contains the informati=
on

--Signature=_Thu__27_Jun_2013_17_14_18_+1000_z0cqa8usfkqWy_Vd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRy+ZOAAoJEECxmPOUX5FEggcQAIItFcYSkPiOhNNPSn57KODr
VaSQAvnwTXk787MaKsITQS4/27gQwPsstWXwMdFYa8v5a2lRB+RUDZCLcMNL24sU
Gflohn2NT8vNPQBbjcUQyCsMjVUsozZVMD0uHPvAdt6mXsg09iF3SrNPnFgnoH7w
Z1iDOaxILWiOaCnosgC4C0M0oexcqN/w7JSduYZI0zA7hK967Ng63rS+V0aSukxV
J48S+oXDIXCkL1PGB7IJ+MjyU7QUxekz7Bv19H4J4v2qLQjpt7loywlEKFaYvKrZ
XS1ujBNNbnUJzHdhv++0JLgAIxliTYdv5/+csGLFFkR0oaFZMN2oPXtrJcNivkY1
ifHD+8AbP5LIvcGI1L1WxhOBfpHsrrVWCf/VLWqmyCoNTejH0PRK8dsOYUyTvnNk
aGSvtuYUWtSrJIRCH5UxIpb+8cvJ4pAIVdn/YOjV3mg5gOjBuKPEK/k8E6wA8iz3
GVCISX/iACOn+682MhyKLtXwxGwmJF857xg8+4YP1HgE6vdGB5tz2+gsz+02wYdm
r5TmeiOFGdevFKiCNWDga6KDPW8TuP8afU81ii/V1N+fRgLRCF9/Kzk9mVlRzYCm
taLKtcJnPoEZiM0YfUNIthUj5AwZsxE862zbRFmwRy/VHn3adzzJYyJ7At/FdYL/
mY/1m6st9iJ6YtYqS9Gv
=ZPdR
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Jun_2013_17_14_18_+1000_z0cqa8usfkqWy_Vd--
