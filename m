Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaFCIiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:38:51 -0400
Received: from ozlabs.org ([103.22.144.67]:41219 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaFCIis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:38:48 -0400
Date: Tue, 3 Jun 2014 18:38:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vhost tree
Message-ID: <20140603183838.6af4c0a5@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XIFIOUyne=bMPmS4hGpceDy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XIFIOUyne=bMPmS4hGpceDy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Michael,

After merging the vhost tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

In file included from arch/powerpc/include/asm/epapr_hcalls.h:53:0,
                 from arch/powerpc/include/uapi/asm/kvm_para.h:81,
                 from arch/powerpc/include/asm/kvm_para.h:22,
                 from drivers/cpuidle/cpuidle-kvm.c:18:
arch/powerpc/include/asm/kvm_para.h: In function 'kvm_arch_para_features':
arch/powerpc/include/asm/kvm_para.h:58:40: error: 'KVM_HC_FEATURES' undecla=
red (first use in this function)
  if(epapr_hypercall0_1(KVM_HCALL_TOKEN(KVM_HC_FEATURES), &r))
                                        ^
arch/powerpc/include/uapi/asm/epapr_hcalls.h:74:51: note: in definition of =
macro '_EV_HCALL_TOKEN'
 #define _EV_HCALL_TOKEN(id, num) (((id) << 16) | (num))
                                                   ^
arch/powerpc/include/asm/kvm_para.h:58:24: note: in expansion of macro 'KVM=
_HCALL_TOKEN'
  if(epapr_hypercall0_1(KVM_HCALL_TOKEN(KVM_HC_FEATURES), &r))
                        ^
arch/powerpc/include/asm/kvm_para.h:58:40: note: each undeclared identifier=
 is reported only once for each function it appears in
  if(epapr_hypercall0_1(KVM_HCALL_TOKEN(KVM_HC_FEATURES), &r))
                                        ^
arch/powerpc/include/uapi/asm/epapr_hcalls.h:74:51: note: in definition of =
macro '_EV_HCALL_TOKEN'
 #define _EV_HCALL_TOKEN(id, num) (((id) << 16) | (num))
                                                   ^
arch/powerpc/include/asm/kvm_para.h:58:24: note: in expansion of macro 'KVM=
_HCALL_TOKEN'
  if(epapr_hypercall0_1(KVM_HCALL_TOKEN(KVM_HC_FEATURES), &r))
                        ^
drivers/cpuidle/cpuidle-kvm.c: In function 'kvm_enter_idle':
drivers/cpuidle/cpuidle-kvm.c:66:2: error: implicit declaration of function=
 'arch_safe_halt' [-Werror=3Dimplicit-function-declaration]
  safe_halt();
  ^

Caused by commit 89bfc4cdb438 ("cpuidle: kvm cpuidle").

Given that the commit message for this commit includes "Very much a
demo for now, downstream only." it should *not* be in linux-next.  It
should especially not have turned up at this point (just before the
merge window).  I also wonder about some of the other commits in that
tree :-(

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/XIFIOUyne=bMPmS4hGpceDy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjYmUAAoJEMDTa8Ir7ZwVaeYP/39TUaRmZPeji4jNcBB3A/Kr
Shjme09bff6NpDochHbQHVxkB9zB1vynkZfSXv3/+tQRjSZQyXBAK4sVkuKn21wy
NZVgJCaiJY6tExtrVVvqR83J5IfM5m0/loEFkMafD4qeo1oQY8rx8YY6DVOQCavP
a5BdZ+tpBR7Lhsr6igZ7j8qjXkFVzUMYnbeLBlqvgnoxvnByUJRSYumMQzGVrE0m
J1mLRMy332xro2WxVrqQMHQ974sIMbabnbfQ0/RTdLDBwH7tKUJvUr7AAmcEz/I4
OZlEDqfupIgvasaUr9R4iOyxaX3HvQVeuyQJBviI51/AMIMA5/oaVVwn50Kp9Mp6
40O1YFYiZljtv2P96INBDZpzf6Am5hxR/yKDdBRR8eQE1llfmOKfCjbRlIjKV9Ct
bgRxwXe93QMMtWT+Cx1roW/DqW5CxyHHFY0knie86ORxpYjoSKlAGssxVe/Ii1lq
fMXKDVOfBFchciHJoZpRtn7MHofQuzRaxvXlqoxA7fEDYl8TsI2sBgZE9DsJTipX
s+i8VRea5CgadU/uCrtxbrdWlmQJzA0WWX8eVWueUDTsqQ1NPdbx4UBRqZS9iwgk
dxRuke0DW8bBwUFDR0UoD/4FwPDeyuTICTj8KikbOYr012S3hsmRTffyxnZgI7pW
YxJ0WScEdT5a3AWVvGqX
=aXTH
-----END PGP SIGNATURE-----

--Sig_/XIFIOUyne=bMPmS4hGpceDy--
