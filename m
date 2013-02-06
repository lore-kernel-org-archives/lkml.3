Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3BFAD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 19:03:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48438 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab3BFADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:03:54 -0500
Date: Wed, 6 Feb 2013 11:03:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>
Subject: linux-next: manual merge of the metag tree with the arc tree
Message-Id: <20130206110346.edff1db373e5badee7df04c4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Feb_2013_11_03_46_+1100_jhUXbvvQJVA2HfxB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Feb_2013_11_03_46_+1100_jhUXbvvQJVA2HfxB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the metag tree got a conflict in
tools/perf/perf.h between commit 12bf48ef6194 ("perf, ARC: Enable
building perf tools for ARC") from the arc tree and commit 6c4a2bebec36
("perf: Enable building perf tools for Meta") from the metag tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc tools/perf/perf.h
index 8a68ad3,768507e..0000000
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@@ -98,12 -98,12 +98,18 @@@ void get_term_dimensions(struct winsiz
  #define CPUINFO_PROC	"cpu model"
  #endif
 =20
 +#ifdef __arc__
 +#define rmb()		asm volatile("" ::: "memory")
 +#define cpu_relax()	rmb()
 +#define CPUINFO_PROC	"Processor"
 +#endif
 +
+ #ifdef __metag__
+ #define rmb()		asm volatile("" ::: "memory")
+ #define cpu_relax()	asm volatile("" ::: "memory")
+ #define CPUINFO_PROC	"CPU"
+ #endif
+=20
  #include <time.h>
  #include <unistd.h>
  #include <sys/types.h>

--Signature=_Wed__6_Feb_2013_11_03_46_+1100_jhUXbvvQJVA2HfxB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREZ3iAAoJEECxmPOUX5FE19MQAKIJAhE3qql0vAYyqRkWAf19
E0ZLR7knKQOfvbcqR71X2wjDx669VaJkdS7BEtlcPmtMH7ex4ePfPTrT73xoR2Od
wVcG4LrCm3hI64JWJmeP061KRuhSXstVK4y555Tu56h0E+setJZ/TDW++ZTWnKC0
osQlMgODlki0GA/5/UER3cYrSC9pE9f2jOQcMAWxyiNtzJz04uQ/wBVkX98yHsQ9
WPo2RVVg/FmcVK96ZLqR5LJvyjdubip3jBNN7lrvG3k4PQgRla/kyHfouGsMx89b
unP/BEogpwKfZSMXSGJ2aeJGhmPhqfUMsR8nOmWmRej4guAFFyj1wCSXMG6iMRIs
CwG4+yzZidlA4HEShbIw6L6QS6mxQC/xummgBUE13wIulXq0z0jkguSHoUJ2vJ8G
O2/2K/JG5ukmRkrpqimbCaQuI+Qoqryw9x3Xf4alVrtDlw0sdRp02w5nDiO6ah1R
s16Is2p6Mhj6QM63O6WLZLaj29jvpJH8sKvDGEGVO9vqYir/DU6wSRb9LJRy84Oq
beVnhwipiP0Lvk2q2ob5g3EBNUzg16QXdQCFHXW1EuvKdgxSxwzY6oZJ+tbcWjJ6
2iNGQ7tinh3H1HMEmACCIG4sqsFzCvkxhwtg+SUWJdFTyBaMmMl96AgS3I5+5ClI
beCi9IUp/RaiKPMIKjL7
=EJm+
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Feb_2013_11_03_46_+1100_jhUXbvvQJVA2HfxB--
