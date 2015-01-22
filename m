Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbbAVFHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:07:07 -0500
Received: from ozlabs.org ([103.22.144.67]:59875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbbAVFHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:07:03 -0500
Date: Thu, 22 Jan 2015 16:06:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Huang <wei@redhat.com>, Mark Rutland <mark.rutland@arm.com>
Subject: linux-next: manual merge of the kvm-arm tree with the arm64 tree
Message-ID: <20150122160657.5a2eb77e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ONXl23aLkknIcZW=bQQiPWf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ONXl23aLkknIcZW=bQQiPWf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in
arch/arm64/kvm/handle_exit.c between commit c6d01a947a51 ("arm64: kvm:
move to ESR_ELx macros") from the arm64 tree and commit 0d97f8848104
("arm/arm64: KVM: add tracing support for arm64 exit handler") from the
kvm-arm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/kvm/handle_exit.c
index 29b184a8f3f8,6a7eb3ce7027..000000000000
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@@ -63,10 -67,13 +69,13 @@@ static int handle_smc(struct kvm_vcpu *
   */
  static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
  {
- 	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE)
 -	if (kvm_vcpu_get_hsr(vcpu) & ESR_EL2_EC_WFI_ISS_WFE) {
++	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
+ 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
  		kvm_vcpu_on_spin(vcpu);
- 	else
+ 	} else {
+ 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
  		kvm_vcpu_block(vcpu);
+ 	}
 =20
  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 =20

--Sig_/ONXl23aLkknIcZW=bQQiPWf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwIV1AAoJEMDTa8Ir7ZwVjYEP/RaEwKmveZcTNwqpzq/xsWWI
J6koMCCT1HCfDjME5kvZgwuev0QTyp/xP0XDpCnyizdpH4p2nlSnUrZJpUVqiakK
zrqSyP1sQqbp+wHw5l/9tjRZEY0DZWa6RNjeHY8hh/+XEREk94ZewrH2xiIW5kkR
Zp56g2R4GOcwfu2kI6vRXhKhvN8IsctFqrNmrBAzubt4afiKZfoKvVYhY4QY7D+y
ehK46eCg6dkMWXQb0NQiEynVr9gHVCLHhpq+8DK6Lo1eafpbfFx1gWlNl1qa11Hz
vJf46gO7T+iDQhnuM4YIyu0+Bpv/yfowPmV5C8XWxYZRqZLUcRY8uzCcInvhWI7o
w4/EL2bUm4/fCWb+Pw89soKSjuny41aAFvKKpqewA0VKLbID4iIeHGoKFfBLAn13
N+jiaKUhTCQb0p8VrSGcF4rdyUIJDlNvPkM3KjDUKN6xUMm8NuGaddD607G5HcMG
vND15mAmEkAMGCI/b22Se3EPIs2eZzZFDOkdFDc6OmOEo23MAbaSBw4MzUJTVoT5
U+IaNbly1d45Lz2yk/KVP1jkmQLOjvy1+QnPFR1WXcimDVaJRChO3rzlUQ+zClbl
6vt7Jjdk/MODuXQpjk8ogfgWC4vAiupc4kgJyGCWBmqWYJLMXP+7UxLoZb0HispQ
NeELxEj75XAV9FUeyDe1
=ebAR
-----END PGP SIGNATURE-----

--Sig_/ONXl23aLkknIcZW=bQQiPWf--
