Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3CUGXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:23:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42687 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3CUGXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:23:49 -0400
Date: Thu, 21 Mar 2013 17:23:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>,
        Linus <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build failure after merge of the final tree (linus'
 tree related)
Message-Id: <20130321172334.068a89406c4dede83d3e9c66@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_17_23_34_+1100_ei_NwUE.DwvcoY9C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_17_23_34_+1100_ei_NwUE.DwvcoY9C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc64
allnoconfig) failed like this:

In file included from arch/powerpc/include/asm/kvm_ppc.h:33:0,
                 from arch/powerpc/kernel/setup_64.c:67:
arch/powerpc/include/asm/kvm_book3s.h:65:20: error: field 'pte' has incompl=
ete type
arch/powerpc/include/asm/kvm_book3s.h:69:18: error: field 'vcpu' has incomp=
lete type
arch/powerpc/include/asm/kvm_book3s.h:98:34: error: 'HPTEG_HASH_NUM_PTE' un=
declared here (not in a function)
arch/powerpc/include/asm/kvm_book3s.h:99:39: error: 'HPTEG_HASH_NUM_PTE_LON=
G' undeclared here (not in a function)
arch/powerpc/include/asm/kvm_book3s.h:100:35: error: 'HPTEG_HASH_NUM_VPTE' =
undeclared here (not in a function)
arch/powerpc/include/asm/kvm_book3s.h:101:40: error: 'HPTEG_HASH_NUM_VPTE_L=
ONG' undeclared here (not in a function)
arch/powerpc/include/asm/kvm_book3s.h:129:4: error: 'struct kvm_run' declar=
ed inside parameter list [-Werror]
arch/powerpc/include/asm/kvm_book3s.h:129:4: error: its scope is only this =
definition or declaration, which is probably not what you want [-Werror]

And it went downhill form there.  This build does not have CONFIG_KVM
defined.

Caused by commit f445f11eb2cc ("KVM: allow host header to be included
even for !CONFIG_KVM") which clearly never saw the light of day in
linux-next :-(

It would have been nice if the "compile failure when KVM is not enabled"
was included in the commit log so that we could figure out exactly what
needed to be protected instead of just effectively removing the whole
file.

I just reverted that commit for today.  Can someone please supply a
better solution or even just more information about what that commit was
solving.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Mar_2013_17_23_34_+1100_ei_NwUE.DwvcoY9C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSqdmAAoJEECxmPOUX5FEtTMP/i4dRcADUbW6eJo9NjP5cK1j
CpHGLg3JCH3veWBGCRgF+fHTzVHSV/UWcytW+sq8rfvbnP8HCeh+Nk3bgRzRQXKT
FGDbT0m2QrbrRQ8co5IHCNxAY7ihA9ScaRBiKBPm6rfN03QsXH3gLLoTJQhuhmao
omRVJb0NuOJgHaGPQQldnZkhg56dTGi0RyNzEwOHVZOST/HLJKdwuUQAv7O9TJnU
Ww553aKisDFW7gEf/BCigdEwGVcOpbfPlFQawhV/HbQwFk+YjNNebrAV3Je45Fe/
tDVcGbAlnEStcpsH3XT2QZ5ks05y4RwdgehjOuIA1LOEv3Kb3Ec0ElvNQxKosOlc
9mzpytdnD3dbGhS5jfttR5Y1tZa4rJ+VbzDjGXfKJIIWNMERniS77DY81/BeXNND
Dvbv+K79bL/p6FOVARXopLtll6TbFdNU8PlafDHTGsT/iXdrs78m3jhACjLXLXgI
1xa00NJE/XoHxL0LHchCwNJMSDCHMfnyZ2WfNd9vSEcBm4n/hFaViWLUUyr47Y3F
879PClJpd6zDb/XuAT1xeNEfW8pU1RnfkZNqCOIJmXfb4e58fdLTewfjhjuQvLL9
vTEJlgDXuO0V77+aomNwLDM9z++B4fqWsmSsvzqT+iDTibT9k/iqFy1V5YahxX04
TzvJBbE0lENqO2ZfBZHQ
=i4Hb
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_17_23_34_+1100_ei_NwUE.DwvcoY9C--
