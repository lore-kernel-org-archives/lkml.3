Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab3DEEM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:12:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56215 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3DEEMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:12:54 -0400
Date: Fri, 5 Apr 2013 15:12:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: linux-next: manual merge of the vhost tree with the kvm tree
Message-Id: <20130405151252.23846e5ad5d6ec7faa49b50f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Apr_2013_15_12_52_+1100__daEdzxNJwD+yZtu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Apr_2013_15_12_52_+1100__daEdzxNJwD+yZtu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Today's linux-next merge of the vhost tree got a conflict in
include/uapi/linux/kvm.h between commit 2b83451b45d7 ("KVM: ioeventfd for
virtio-ccw devices") from the kvm tree and commit 4697e2cddfe6 ("kvm: add
PV MMIO EVENTFD") from the vhost tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/uapi/linux/kvm.h
index 74d0ff3,61783ee..0000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -449,15 -449,20 +449,23 @@@ enum=20
  	kvm_ioeventfd_flag_nr_datamatch,
  	kvm_ioeventfd_flag_nr_pio,
  	kvm_ioeventfd_flag_nr_deassign,
 +	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
+ 	kvm_ioeventfd_flag_nr_pv_mmio,
  	kvm_ioeventfd_flag_nr_max,
  };
 =20
  #define KVM_IOEVENTFD_FLAG_DATAMATCH (1 << kvm_ioeventfd_flag_nr_datamatc=
h)
  #define KVM_IOEVENTFD_FLAG_PIO       (1 << kvm_ioeventfd_flag_nr_pio)
+ /*
+  * PV_MMIO - Guest can promise us that all accesses touching this address
+  * are writes of specified length, starting at the specified address.
+  * If not - it's a Guest bug.
+  * Can not be used together with either PIO or DATAMATCH.
+  */
+ #define KVM_IOEVENTFD_FLAG_PV_MMIO   (1 << kvm_ioeventfd_flag_nr_pv_mmio)
  #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deassign)
 +#define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
 +	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
 =20
  #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) =
- 1)
 =20

--Signature=_Fri__5_Apr_2013_15_12_52_+1100__daEdzxNJwD+yZtu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXk9EAAoJEECxmPOUX5FE9DAQAIDH8VrdLCsy10BV39x79+px
hNK9kqFtSuOfIesYnzvoNUPw/1/yHIUJ7vp4Qjt8wfEZ5q/uWEmoRqh5x6GXNk3M
od3swqOryrY9wkS6sULcB4P80WyIunoVzH7demcntOVxTtdiM1AQ86Jt0GcZcXjx
1ASaNJw6oqK0MXmFHclw3hvh19kT8IGJyFSgfO6qOi/qyz+ut4OCGHEUGei2y/Dx
XToGU2qhwep9tZo1/vSZEad9FY9/E9Qan9L0x9cZjkg17fL8MuXYvv6qxL/FkcWQ
4aVlCOgAx+cRvLbQy0MPv1W2Ht4KO479U/82ooXbejsiJEKYUXHNgPGdsAjIiq01
E8zGkxXpdLt/20/GcBoAnMMTtI6MBK1oEfJ+s/HJyshw+zeJYCpIuig43N0BT6bu
XC2J2x5pewcTK25Zx4w3ZupqZqbDkWh62I+ldT5j37MvF90q57sBw6TJjUXh37vX
eruT/qalj5Qn6ZxchOtgkI3pO7kpsM8IH01AakWwBk8tNNnC2F649XYieFVLlC/G
WXYy52UvkeK4S8HwmjsGMzN2mjXyWGid2ohcwiww43na7w2Ad9d1AVzl2tTRWYza
h6pKP0lUKJST3so6BBrn6ZqlIeromXjZ77XKvHoBQlVDjBAiFt0pHXw52JyjKfdv
WzCX/Vo+6RhBG26zevzj
=0Jhy
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Apr_2013_15_12_52_+1100__daEdzxNJwD+yZtu--
