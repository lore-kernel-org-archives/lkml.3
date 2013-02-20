Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941Ab3BTFAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 00:00:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60162 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab3BTFAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:00:39 -0500
Date: Wed, 20 Feb 2013 16:00:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>
Subject: linux-next: manual merge of the vhost tree with the virtio tree
Message-Id: <20130220160028.42f2b3b94f5eea4b3f6d4779@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Feb_2013_16_00_28_+1100_r6PwDteDNtXqlT=_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2013_16_00_28_+1100_r6PwDteDNtXqlT=_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Today's linux-next merge of the vhost tree got a conflict in
drivers/vhost/Makefile between commit 4d8dc8b44748 ("vringh: host-side
implementation of virtio rings") from the virtio tree and commit
0b87bfefde9a ("vhost-blk: Add vhost-blk support v6") from the vhost tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/vhost/Makefile
index 1d37f5e,1a8a4a5..0000000
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@@ -2,5 -2,5 +2,7 @@@ obj-$(CONFIG_VHOST_NET) +=3D vhost_net.
  vhost_net-y :=3D vhost.o net.o
 =20
  obj-$(CONFIG_TCM_VHOST) +=3D tcm_vhost.o
 +
 +obj-$(CONFIG_VHOST_RING) +=3D vringh.o
+ obj-$(CONFIG_VHOST_BLK) +=3D vhost_blk.o
+ vhost_blk-y :=3D blk.o

--Signature=_Wed__20_Feb_2013_16_00_28_+1100_r6PwDteDNtXqlT=_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJFhsAAoJEECxmPOUX5FEyqkQAKRNf61wXhtn8RYI+dFlwHIr
KQmMmY9MS/v5WbCmzYG7MHMaJxExSnFrcIE31PnN+LxJSwG+58PwBgzl1MiuD1Bv
YIfwAqqmsYENGmnIRJLXfeRaq/iViOPqgW52OfRdmq8a2Tj2E3H9um1j5ATaeaCQ
wyYLv94MG0CeiHLOrnnWiUMkuo8SmAwqIhKbzy3swCdr7QIin9Gs6I71vgcLBjDf
HywIrigtYQdx40WAiLlVZ1cFkh4p7Ir3fCGaGgrp3dUahBDeW5gQzPbegZW54qMr
eceNR87yfBf1+w1NY7KrK29AeBrLUWngU8daHJHXAoIWW+/atljiM/RGOI+hFD7A
em1edabdONcGXTyzP32rTDb0kyv0N99eCgS7rAAXyQgV2ubHFCdTR2JtRLJOwcVH
YJNemonZRoT0a2HXDQVDn1MyDWdfSlqavZWkX6PIhTBbOryKDNCYUwd/YdR8Voed
3/SLQyan2HyZ7I0Y0wksPIlj1lWg72lUpJLpdBGuk+Yg4C9K+m+H8gPZwJXcwpvS
rjc6NUa/7PKaZyLLNLSFA6i5mDdikcLtLEGfYtXlJmv6+mMHFsBlGOVGATFBLWAV
fFxHZX0MDxIxu7AzzSdWf0oJTrhC+ZM6JzoVpuKr9LsNDi/3QvlWN1aqekU0U9LX
qDvKICxzuj35m2kSQPJ7
=buXj
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2013_16_00_28_+1100_r6PwDteDNtXqlT=_--
