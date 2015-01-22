Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbbAVCSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:18:33 -0500
Received: from ozlabs.org ([103.22.144.67]:54714 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbbAVCSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:18:24 -0500
Date: Thu, 22 Jan 2015 13:18:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Goz <ben.goz@amd.com>, Oded Gabbay <oded.gabbay@amd.com>
Subject: linux-next: manual merge of the drm tree with Linus'  tree
Message-ID: <20150122131817.3d946133@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/WFlClFErdvOI1BmEABbrIf3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WFlClFErdvOI1BmEABbrIf3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/amd/include/kgd_kfd_interface.h between commit
b64b8afcca9d ("drm/amd: Fixing typos in kfd<->kgd interface") from
Linus' tree and commit 85ea7d07e1ec ("drm/amd: Add SDMA functions to
kfd-->kgd interface") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/amd/include/kgd_kfd_interface.h
index 96a512208fad,cd3878fe6f77..000000000000
--- a/drivers/gpu/drm/amd/include/kgd_kfd_interface.h
+++ b/drivers/gpu/drm/amd/include/kgd_kfd_interface.h
@@@ -183,7 -182,9 +182,9 @@@ struct kfd2kgd_calls=20
  	int (*hqd_load)(struct kgd_dev *kgd, void *mqd, uint32_t pipe_id,
  			uint32_t queue_id, uint32_t __user *wptr);
 =20
+ 	int (*hqd_sdma_load)(struct kgd_dev *kgd, void *mqd);
+=20
 -	bool (*hqd_is_occupies)(struct kgd_dev *kgd, uint64_t queue_address,
 +	bool (*hqd_is_occupied)(struct kgd_dev *kgd, uint64_t queue_address,
  				uint32_t pipe_id, uint32_t queue_id);
 =20
  	int (*hqd_destroy)(struct kgd_dev *kgd, uint32_t reset_type,

--Sig_/WFlClFErdvOI1BmEABbrIf3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwF3uAAoJEMDTa8Ir7ZwV+p0P/iUuoivHTeaFv2KTjbNiunit
iJIIendZTp+zP12zBNEYaYVMEHbuJ9hDADICA1miFMunyx23SQOf5rUSgmqfOynY
+KKHXmxgekd87AvGrmqqU6svruZUZQLJ81Dh9Wl+7xWpfYxeBAknnanLmouFwcfM
zk3McRlAZZwgFutidqAOv7/NpNQQ4hxh85MEQcj9MbGbj3TfCdmkEA3o83cz7SJg
Ky8GMeGvC/il28ScNAy5DvH6fWaFtq0+W+IXnnpkQH0UJSEE3ieMpbj79tNJshJy
zoWdkwW5nlF7jSK73w0n6z94uMDDLs3GRrCSMBBSJNYndKw+0DJz7oEQ0HIkg83b
pvdtAXXWsOO7uqkUwrB728nOB6aO/IwMDK7bJ1BAkGMSV9+9MZHI0bmZaxat6x/B
/A0FYaFbk0d7Mph5lphzuV07GXpwDfKe30EDgqtJJLanNDMj1xl4k3ci4Xal6pLR
IhM7rcgheK0FJq2gAmwePHhA4iq6iLtZJiHr4ot7com0t/KizDpcQeovE0zUB0D4
iH/96sqGok3ASkdcKWGAPMz1I1mDZCdLjuEOLKS01JhzUoJ6oCzK77P5q97POnr1
UnJ+0RY5kVQZV7TEj3IoV2t8w4qReFIkcyVK4wT80FM4esZvmc8B0gB2mgcpZsGt
B9LmQf70OwSsXR5EqsMU
=V4gI
-----END PGP SIGNATURE-----

--Sig_/WFlClFErdvOI1BmEABbrIf3--
