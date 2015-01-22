Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbbAVE5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:57:51 -0500
Received: from ozlabs.org ([103.22.144.67]:39031 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbbAVE5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:57:45 -0500
Date: Thu, 22 Jan 2015 15:57:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>,
        Mario Smarduch <m.smarduch@samsung.com>
Subject: linux-next: manual merge of the kvm-arm tree with the rcu tree
Message-ID: <20150122155738.3b0e5402@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=QMFkAhsWWH5YHa5_qsHOOd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=QMFkAhsWWH5YHa5_qsHOOd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in
arch/arm/kvm/Kconfig between commit 83fe27ea5311 ("rcu: Make SRCU
optional by using CONFIG_SRCU") from the rcu tree and commit
53c810c364d7 ("KVM: arm: dirty logging write protect support") from the
kvm-arm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kvm/Kconfig
index 3afee5f40f4f,a8d1ace3ea51..000000000000
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@@ -21,9 -21,10 +21,11 @@@ config KV
  	select PREEMPT_NOTIFIERS
  	select ANON_INODES
  	select HAVE_KVM_CPU_RELAX_INTERCEPT
+ 	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
  	select KVM_MMIO
  	select KVM_ARM_HOST
+ 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 +	select SRCU
  	depends on ARM_VIRT_EXT && ARM_LPAE
  	---help---
  	  Support hosting virtualized guest machines. You will also

--Sig_/=QMFkAhsWWH5YHa5_qsHOOd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwINHAAoJEMDTa8Ir7ZwVXK4P/3OkhjVi7x3JbCKi0bGpkHPr
T8l22wdp2MqUT9+J9CBq+8kTklj5UYSXsSZ9q/46x/Fouk+Jw8B/3hKGAvHy96cT
t9/EgZpbMU0JQGhssjNrOSH0xket3BzjgDsdgQHKscGEXeD71nDJHtD86FZ2+u5i
K2EGUkRcG14T7IonwueMCN778LchRsLLGAEAkBvvj4pDjG9RewdLTenRujTxBZUp
oNwfll2GFiRb5eprtvkf1AoNWCCkCIwp5JgR323Z6VobcX1U6X7xnsLYkNhRAMeI
TzoWTuWlBEDploNVbb1Gq5/e7+n3dQ9zCDqrDgDdV7+aUwnHmDuXDCZwc23PYUng
ZXvmCp/2PKwp9cQafmauhQSb7qLwfgJCdcm0NJo4uV9ANzylk9jF7dv/XnWVGJdC
UwDgFJLVezFeKT73oXeNytFwZbN+3H1cSvRo6vLPbUYSo3ZwlTPQZJksavEEEtoF
GVVALuOZdQwQcPHJYjeYspoHXkc8QbYgpa6JuTTGu4eEUBAqcJExcsCSZfh1f7bo
Uhy/J19xI9I11thp293YABd6oNrnDPSel3p0DqnKS5NyFs16DQnXe0ERHt9uyDsX
mGpn4AFwGulo+4RoNkg2aGVbSDSWEpfVGcxTLCj4UQVDW9qzKfyrcHP4E/C8o3aw
tyPGY1ClApuhvmvKAw4m
=VRt/
-----END PGP SIGNATURE-----

--Sig_/=QMFkAhsWWH5YHa5_qsHOOd--
