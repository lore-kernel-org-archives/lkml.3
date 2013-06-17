Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3FQAh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 20:37:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56676 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3FQAhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 20:37:25 -0400
Date: Mon, 17 Jun 2013 10:37:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, Gleb Natapov <gleb@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: linux-next: manual merge of the arm64 tree with Linus' tree
Message-Id: <20130617103715.3c97aaeb932d8f69e31c0039@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_10_37_15_+1000_mlfmfFAD=8JA1b62"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_10_37_15_+1000_mlfmfFAD=8JA1b62
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

Today's linux-next merge of the arm64 tree got a conflict in
include/uapi/linux/kvm.h between commit 2a8fedd0c142 ("kvm: Add
definition of KVM_REG_MIPS") from Linus' tree and commit 7c8c5e6a9101
("arm64: KVM: system register handling") from the arm64 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/uapi/linux/kvm.h
index d88c8ee,aac2764..0000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -783,7 -784,7 +784,8 @@@ struct kvm_dirty_tlb=20
  #define KVM_REG_IA64		0x3000000000000000ULL
  #define KVM_REG_ARM		0x4000000000000000ULL
  #define KVM_REG_S390		0x5000000000000000ULL
+ #define KVM_REG_ARM64		0x6000000000000000ULL
 +#define KVM_REG_MIPS		0x7000000000000000ULL
 =20
  #define KVM_REG_SIZE_SHIFT	52
  #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL

--Signature=_Mon__17_Jun_2013_10_37_15_+1000_mlfmfFAD=8JA1b62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvlo/AAoJEECxmPOUX5FEJCAP/3bwMqDgXby35sORzZB7GBxl
TgvHmXDOm0SDJyGhZrGCvfrcjY028nS92SKk9izywZTWT0NJffgrwWoTSfrVsrW/
QYQuUb19lOZdNx6upcfH6nFsDLSIjOSB44F/PpWpN+NBiQ+Zm7BQTkCPgjAXAOdh
g4LpuEGadAl6Ppm3BHby7ncjZhFAtkN0+0pLhIPu86JTXz3xaiVgk6f9EnY8CEzw
vncAxw8Jl8G50kUojVaXqaZCnv0qphhyONPtIHN/zIbETa/TVTC71B9BVV9HtJcy
LnFtfSeDDldnvF8/3xOphPrbuRE5aNhk2dYMVpdNKtSOsgPJzhz6OZehk9B67yYJ
7RUVrgdBBcCs/kOYrlCefnrapWKTVe1SfD6rjlrDhmQEbDunQJyD6dzm4TVErINq
8/YBzwCmvqN1ucS8yRJtMZWsHpUjzSp71h4/ZXp0lihO04bt1rMa5mrgXGjC3ud8
O/rBGYt8N/Q/rPBimGtgkEbEzAjlXUeLc0AnrQLexzN+dLj//08+kvPurs9vxDeb
psV8Y/Sv+3mudYNLl+6/arvU3oscqRGZpAfiqFrO32DNZnHyyqLmsGpwmTzM28kE
e6RHrZxky6+K2rg96Sh/Qavyvd0HfrQnLU6dGImidXftaFFtIOuDGzcOQhnGPDyE
ui/kddi4fLFP2wmkSO7u
=rjKO
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_10_37_15_+1000_mlfmfFAD=8JA1b62--
