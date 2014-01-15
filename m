Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaAOFGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:06:16 -0500
Received: from ozlabs.org ([203.10.76.45]:46103 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaAOFGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:06:15 -0500
Date: Wed, 15 Jan 2014 16:06:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jayachandran C <jchandra@broadcom.com>,
        John Crispin <blogic@openwrt.org>
Subject: linux-next: manual merge of the tip tree with the mips tree
Message-Id: <20140115160608.5bf8571204de731b2c8d5e66@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_Jan_2014_16_06_08_+1100_hMHhg5_K_7enrf7e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jan_2014_16_06_08_+1100_hMHhg5_K_7enrf7e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/mips/netlogic/xlp/setup.c between commit 8e4857962d97 ("MIPS:
Netlogic: Core wakeup improvements") from the mips tree and commit
7972e966b032 ("MIPS: Remove panic_timeout settings") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/netlogic/xlp/setup.c
index c3af2d8772cf,54e75c77184b..000000000000
--- a/arch/mips/netlogic/xlp/setup.c
+++ b/arch/mips/netlogic/xlp/setup.c
@@@ -96,15 -92,6 +96,14 @@@ static void __init xlp_init_mem_from_ba
 =20
  void __init plat_mem_setup(void)
  {
 +#ifdef CONFIG_SMP
 +	nlm_wakeup_secondary_cpus();
 +
 +	/* update TLB size after waking up threads */
 +	current_cpu_data.tlbsize =3D ((read_c0_config6() >> 16) & 0xffff) + 1;
 +
 +	register_smp_ops(&nlm_smp_ops);
 +#endif
- 	panic_timeout	=3D 5;
  	_machine_restart =3D (void (*)(char *))nlm_linux_exit;
  	_machine_halt	=3D nlm_linux_exit;
  	pm_power_off	=3D nlm_linux_exit;

--Signature=_Wed__15_Jan_2014_16_06_08_+1100_hMHhg5_K_7enrf7e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1hdEAAoJEMDTa8Ir7ZwV5ssP/iLE9hFCdG2XrLJ+eY8tZ5QK
kBsMJLzElIxud0qOgv8QtrI9DnIzAzilISObfLY1aFgwAp8bQcagvYYTBohLQNpJ
M6HyyUUxoVYxxxc6eWEF+rUnVMtwPLTWmewiMesrqZBqv504g939huY3WjvefCkH
NqdrbhkuWDB1HZ6DS+2+R67qTcMAnqTQ2hlBOi+8gSpjfFleM+RGVD24DM+t54PX
LgR0ltYUTaSKhHtI4JE+5QBo/o6MBsSxfsjef7KwDNM9AdFkyHeWx6TkeTfhpWB5
qq5FUScblaRdpsD+Vz3GpVTHJI4eFSWZGbCStd8W0C4o/ikn2scMn1tZTZlZ0y7d
jighwYr7/v7JOfqlg+tDdmk9l1QjdtWQlY7Rsos7Zqn4aDM0UIgebB/JiZ9VYNfo
x+Yt3o5DS5uzXmvYnmMnJJEUT/hD+9WA/8kKwu+A4/dBlEVLLtaJssQpCRA/hsDj
pN5Cr3Fsyqaog+ZAktu8dAUjCRpXkdlje6EfRQgZJG7ikwJSRrFqE3sYTzU13pyy
S6rNetw+NZ2Mxr4fgxVjEgO1Uwq2Ygvcz0MUJXlLF6WR9qoylxpjicGuILP/uuXv
MpBlH3vyiTjItAhbHcpisSYYjN91ZlUeOFJmDbjL12/mHt5nJniDLvKhy+zhCI5B
5X/LJwX1mVvJj0T6vIv0
=IaUT
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jan_2014_16_06_08_+1100_hMHhg5_K_7enrf7e--
