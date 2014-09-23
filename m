Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaIWEXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:23:21 -0400
Received: from ozlabs.org ([103.22.144.67]:49567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbaIWEXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:23:20 -0400
Date: Tue, 23 Sep 2014 14:23:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>
Subject: linux-next: manual merge of the tiny tree with the tip tree
Message-ID: <20140923142312.24cc9580@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4.1ByTylJ5RRsHZOniYkIWp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4.1ByTylJ5RRsHZOniYkIWp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

Today's linux-next merge of the tiny tree got a conflict in
arch/x86/kernel/cpu/common.c between commit ce4b1b16502b ("x86/smpboot:
Initialize secondary CPU only if master CPU will wait for it") from the
tip tree and commit e4a191d1e05b ("x86: Support compiling out userspace
I/O (iopl and ioperm)") from the tiny tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/cpu/common.c
index 3d05d4699dbd,11e08cefdb6e..000000000000
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@@ -1294,10 -1281,7 +1294,9 @@@ void cpu_init(void
  	struct task_struct *me;
  	struct tss_struct *t;
  	unsigned long v;
 -	int cpu;
 +	int cpu =3D stack_smp_processor_id();
- 	int i;
 +
 +	wait_for_master_cpu(cpu);
 =20
  	/*
  	 * Load microcode on this cpu if a valid microcode is available.

--Sig_/4.1ByTylJ5RRsHZOniYkIWp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUIPW1AAoJEMDTa8Ir7ZwVdrYQAIzYXybDQ2kD0l7OwbNcnWOZ
uVEsvn3FNETyyAMM79bOCIJWXqsdDqx1pCyWrw6DBsiqli1FeD3pA1HHLovCXqyZ
y9xBEPVVjwVeko0K3gJDlqrsxzXIvqfk8gVpeUKreQXVUkBzTrvazoqTijx4itju
is1YEup9xM2t+97opVHhKlyDcSVIlQ88rT+Dnox+zIPjmx+3MLxyj2OOcmRe+Rh5
/Q1WWIZSw8/eqUYrx4rA/SNzJDKAJTGDQny9cu/eiB+MvmePals5CfoFTG729pfe
D4MrR4S5PnNnLYqX4+bwUWaub44B+bGPexeP95/x6d74QXEM9pKM6lJzww1a4+JU
aFzU3+hsrxBmgXPluz2NKABweMtEbX2A7qbN82q5YPcMM1oO2/7bUEXnhHzBENr9
FcAAPXHurpiPbY4ssWAVob82OdiNjx6AMinutyRO9BTwI/VOCdP9WQ3Ab22yhqrS
FHeYqD0iji+KovhvCJtadrxlsoTdRrHMxXV4SqzxitEf/OS8YgpBmB9DGefvPI7E
ReiAH1h2Uman+RNmluTZjNV+u+8PP3odeVQHyVlcpz+bUkQW1LpUWyx8hxrXSflh
mSet8GppTha7Dh67a6/9i0I38H1e17LNxrJtN7u5FFFqaZyjDB5MQyiRDkbhp80q
YQZ+f8yN61tsZB3vFmsq
=wqH1
-----END PGP SIGNATURE-----

--Sig_/4.1ByTylJ5RRsHZOniYkIWp--
