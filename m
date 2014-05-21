Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaEUEMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:12:53 -0400
Received: from ozlabs.org ([103.22.144.67]:35983 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaEUEMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:12:51 -0400
Date: Wed, 21 May 2014 14:12:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-ID: <20140521141249.6f87b7e7@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/awQA_J5v42zERPUCrAsu9.I"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/awQA_J5v42zERPUCrAsu9.I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/ldt.c between commit fa81511bb0bb ("x86-64, modify_ldt:
Make support for 16-bit segments a runtime option") from Linus' tree
and commit 34273f41d57e ("x86, espfix: Make it possible to disable
16-bit support") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/ldt.c
index dcbbaa165bde,c37886d759cc..000000000000
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@@ -231,12 -229,7 +231,7 @@@ static int write_ldt(void __user *ptr,=20
  		}
  	}
 =20
- 	/*
- 	 * On x86-64 we do not support 16-bit segments due to
- 	 * IRET leaking the high bits of the kernel stack address.
- 	 */
- #ifdef CONFIG_X86_64
- 	if (!ldt_info.seg_32bit && !sysctl_ldt16) {
 -	if (!IS_ENABLED(CONFIG_X86_16BIT) && !ldt_info.seg_32bit) {
++	if (!IS_ENABLED(CONFIG_X86_16BIT) && !ldt_info.seg_32bit && !sysctl_ldt1=
6) {
  		error =3D -EINVAL;
  		goto out_unlock;
  	}

--Sig_/awQA_J5v42zERPUCrAsu9.I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfCfBAAoJEMDTa8Ir7ZwV5MEP/iPaXkfB9NNX2gBXTw9C0Fr4
5zwzs45j7BkWcfJGyz696i45KJGcqetlJpGmgq1rj8Jtpzrbv5VQJdYVmaEOcM6+
JBMBiMfW2MsUQzUh8s5eyEpAGeUGBHkGL9VRDr4DcKdUSUoQeSGYN9ftTsrkihbq
wZO7K3PpiKDTMsMuR/ZOV1WWNJXP6Zf/JvmxqWOpovzMGUUSpcCMgySbQ5RiCvIc
tM/4+rIPyyhF1/0JARtXrpIbmuY6AUwxIIUKyAk/S+J7tU0wttWjlH/FGyNotkN3
IW0H6drOJTm8ZnqV+PjxNtQsAEJ6B8eZZS2m3/NSeMA6CIfgVs02r/fI8/MUhXeZ
Wj0PelUA4Lyrv/YRnnUGOk3NkwY0PvhVRvAnWZ+FP+ISA7X4PDq1OVykoscLzTqa
tsDBTs8MzXRQ1KSJY6m8YXayX7lGcB1RmNSvHdvSJW320k70rmi1XatyH8pOMRzl
JrctnEhffoYo0PuS/qpOyT3GITckPEQaSwEJWRKNUn2BQ+AJiGIu4Lguxw60hY9n
2H+I0mkg2m5h+CUsNy269y1mnMtvFy2mtbcdDmGOrxIEcefqOdCLzZTIyZJ//pTq
ocf6Irf8tcQeG+OhG4M/jSyODX9J5VyuNg/J/0iSKAr7hLecIh5kUertt7AM1DnX
N+yP8avKhgFnk9nNg+fe
=ZEkG
-----END PGP SIGNATURE-----

--Sig_/awQA_J5v42zERPUCrAsu9.I--
