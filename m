Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab3BNEdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 23:33:37 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51039 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab3BNEda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 23:33:30 -0500
Date: Thu, 14 Feb 2013 15:33:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>,
        Clark Williams <williams@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20130214153327.ca438c354f9c64d3d0b6f102@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Feb_2013_15_33_27_+1100__qgMuiqNeVLGz/vz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Feb_2013_15_33_27_+1100__qgMuiqNeVLGz/vz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/sched.h between commit cf4aebc292fa ("sched: Move sched.h
sysctl bits into separate header") from the tip tree and commit "aio:
don't include aio.h in sched.h" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/sched.h
index fe38049,f0e3a11..0000000
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@@ -326,8 -339,23 +326,6 @@@ extern int mutex_spin_on_owner(struct m
  struct nsproxy;
  struct user_namespace;
 =20
- #include <linux/aio.h>
-=20
 -/*
 - * Default maximum number of active map areas, this limits the number of =
vmas
 - * per mm struct. Users can overwrite this number by sysctl but there is a
 - * problem.
 - *
 - * When a program's coredump is generated as ELF format, a section is cre=
ated
 - * per a vma. In ELF, the number of sections is represented in unsigned s=
hort.
 - * This means the number of sections should be smaller than 65535 at core=
dump.
 - * Because the kernel adds some informative sections to a image of progra=
m at
 - * generating coredump, we need some margin. The number of extra sections=
 is
 - * 1-3 now and depends on arch. We use "5" as safe margin, here.
 - */
 -#define MAPCOUNT_ELF_CORE_MARGIN	(5)
 -#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 -
 -extern int sysctl_max_map_count;
 -
  #ifdef CONFIG_MMU
  extern void arch_pick_mmap_layout(struct mm_struct *mm);
  extern unsigned long

--Signature=_Thu__14_Feb_2013_15_33_27_+1100__qgMuiqNeVLGz/vz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHGkXAAoJEECxmPOUX5FEs9YQAJ6bBu3KiP7rS6m3TNosBju+
muIj010XNuBZtT5ixtOvB/bo0PFTv5L2h1kGBvgZxM/HMH49H9gNncmrhPJzylPx
hPD7W/79VkAFfvmN6keP2DFtqXhkCU7FtJuZ3wE+aKmdTSDtmJnp83m86CpiMaPp
Ybnyv5Hk3QOZXOUhRAny8zk+4aTMcPF6vnP3rCEwARwa074VyWZ2vU49mtPDSaum
bJmyALtVVQD+wwr6oixSr8GSJH/I26HV+Jgi4EZNZjOKGIM+mGHdXfiCqUzJphr5
GwadlzXOj2II/y72sUcnDVL2zLQ3ODysm8SLG/BTS0bji15M3FQ56GCVYQDkcuB+
hFlFtiGt+XE4jf1+EbFiDnAimZa1XKh2SuozVbumSmhkryddrhV/fpv5BasfcQI6
Cpr5TAkEqWgSgFFjGOMqSa+270KI33OPNLIc7GVMqZ0Z86MxYpks7MD9BMjgukeo
k3UGqGKMZnJFiEBjioQeHbvbeuXnRNg7y5kuS90RqjGEIS9ctx1gWwc/2aS36Cld
EctPbmaT+QHyHxM2ru4xaQ8DcGP0uM5As4VBIzgKcZNamo60LPfqshp9meI1EZDC
kpMAWpQm4LyeLb47YMUMEVq8FVFiH4+I6a8q/BRhm+msfFl2GZJJtgn5SnGyJ0SS
xSTxim9QgJbLokBMAyBp
=4ekj
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Feb_2013_15_33_27_+1100__qgMuiqNeVLGz/vz--
