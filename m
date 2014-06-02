Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaFBGeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:34:37 -0400
Received: from ozlabs.org ([103.22.144.67]:42741 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaFBGeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:34:36 -0400
Date: Mon, 2 Jun 2014 16:34:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>, Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anup Patel <anup.patel@linaro.org>
Subject: linux-next: manual merge of the kvm-ppc tree with the  tree
Message-ID: <20140602163429.357cf678@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/d=DQypsFZSJn/uQjH9HeZYC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/d=DQypsFZSJn/uQjH9HeZYC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
include/uapi/linux/kvm.h between commit 717abd208dff ("KVM: Add
capability to advertise PSCI v0.2 support") from the kvm-arm tree and
commit f2e91042a807 ("KVM: PPC: Add CAP to indicate hcall fixes") from
the kvm-ppc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/uapi/linux/kvm.h
index 32cf446f1911,16c923de85e7..000000000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -756,7 -748,7 +756,8 @@@ struct kvm_ppc_smmu_info=20
  #define KVM_CAP_S390_IRQCHIP 99
  #define KVM_CAP_IOEVENTFD_NO_LENGTH 100
  #define KVM_CAP_VM_ATTRIBUTES 101
 -#define KVM_CAP_PPC_FIXUP_HCALL 102
 +#define KVM_CAP_ARM_PSCI_0_2 102
++#define KVM_CAP_PPC_FIXUP_HCALL 103
 =20
  #ifdef KVM_CAP_IRQ_ROUTING
 =20

--Sig_/d=DQypsFZSJn/uQjH9HeZYC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjBr5AAoJEMDTa8Ir7ZwVGhQP/RS5zAlJj/XeLOSzLoZ3LdKu
Wfr0Ful5I+L2OhLurFnlYQFSQ2ileGWb2InqBSb1Hy4GLhrJD3Q5djMLV3KY4ZzE
DWqREXN6a+xXAhwFPpx2HHHmpVKAREIUnc4Bm8XIhXG7Fbd6Eor/SYp8KfteoXBU
7TaACqutS6zhcpv7O+ha17XNezj+bQAo3orPsONBMZJMIAsjDV0JWENnuDLkXMXE
MzrbQbHU/Zz6D7IT6lvxIxl0XXCIojluFlNzoijgNiaIuCqKH/L99ZyJAdkbCraC
PNP9AycEpc+TWGypLZFQR0Xgy2lcHgOPD/okfg6ETNLKT0/pxGlI3+gTGVHMrcS7
K4Szqv+l0w7Gsj/rbkAIo+wQ1gv4anHkpuQ6+XWMnDhmyPvnZOPQSn08MkhEfDJF
i1xlQ+YsXTKkcugWqU+bHaDkHM37vhcNMM5wdmBB+M+ydNHl4QQ9rOaZfuNnbADu
/NXzrYu144DTbff9r3WCR2HYAHfo441s3NLa0Jfq9dEm0paf2eYWhoYq5XSZ7PCo
X4tzJUT5y6LSur0saHZS1mhbv7pOekfSxqbTrIodoMgrtEb0XfacW5xrujA7YFHO
d4FF4zafP5f83Kk7aKSeHkpt80DSwRNqYUERGomcpwWVzV3BjIGVsf3c9NH29weL
ybkI9yBMJrJbTRuRvH6M
=Up5Y
-----END PGP SIGNATURE-----

--Sig_/d=DQypsFZSJn/uQjH9HeZYC--
