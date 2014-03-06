Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaCFIWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:22:51 -0500
Received: from ozlabs.org ([203.10.76.45]:54942 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaCFIWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:22:50 -0500
Date: Thu, 6 Mar 2014 19:22:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20140306192234.62ad3ac104a2adc16752b033@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Mar_2014_19_22_34_+1100_deuh57OeUCGCG1zr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2014_19_22_34_+1100_deuh57OeUCGCG1zr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (sparc64 defconfig)
failed like this:

arch/sparc/kernel/time_64.c: In function 'timer_interrupt':
arch/sparc/kernel/time_64.c:735:28: error: lvalue required as increment ope=
rand
arch/sparc/kernel/traps_64.c: In function '__cheetah_flush_icache':
arch/sparc/kernel/traps_64.c:963:2: error: 'pscr_ret__.icache_size' is used=
 uninitialized in this function [-Werror=3Duninitialized]
arch/sparc/kernel/traps_64.c: In function 'cheetah_flush_dcache':
arch/sparc/kernel/traps_64.c:1002:2: error: 'pscr_ret__.dcache_size' is use=
d uninitialized in this function [-Werror=3Duninitialized]
arch/sparc/kernel/traps_64.c: In function 'cheetah_plus_parity_error':
arch/sparc/kernel/traps_64.c:1023:2: error: 'pscr_ret__.dcache_size' may be=
 used uninitialized in this function [-Werror=3Duninitialized]
arch/sparc/kernel/traps_64.c:1020:16: note: 'pscr_ret__.dcache_size' was de=
clared here
arch/sparc/kernel/traps_64.c:1033:33: error: 'pscr_ret__.dcache_line_size' =
may be used uninitialized in this function [-Werror=3Duninitialized]
arch/sparc/kernel/traps_64.c:1021:21: note: 'pscr_ret__.dcache_line_size' w=
as declared here
cc1: all warnings being treated as errors
kernel/softirq.c: In function '__do_softirq':
kernel/softirq.c:252:1: error: lvalue required as left operand of assignment
kernel/softirq.c: In function '__raise_softirq_irqoff':
kernel/softirq.c:427:1: error: lvalue required as left operand of assignment
arch/sparc/kernel/ptrace_64.c: In function 'flush_ptrace_access':
arch/sparc/kernel/ptrace_64.c:91:20: error: 'pscr_ret__.dcache_line_size' m=
ay be used uninitialized in this function [-Werror=3Duninitialized]
arch/sparc/kernel/ptrace_64.c:113:20: error: 'pscr_ret__.icache_line_size' =
may be used uninitialized in this function [-Werror=3Duninitialized]

Caused by commit 5aa661aa13d4 ("sparc: replace __get_cpu_var uses").

I have reverted that commit for today.

I suspect that this whole series may need more review and work.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2014_19_22_34_+1100_deuh57OeUCGCG1zr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTGDBYAAoJEMDTa8Ir7ZwVRV8P/RoogxsLH6OhpmiASeMe2d3d
BcxdlxCsV6V/scBZAoerFWrHc6g+dB6Yvsn1YaumPjiit6/9FHYXTg/kHD8XnGt7
i0okg1KzXkCsDunwfT6honEycQ5Kk5AQLibPAiP5uTFYZxGJ2zhZyMKJHlAUMgjG
SF4Co1ww1Wa5P8RiFIOVfT0L6hzpfv+vpSLVCq+HuGiF29ueGesd6cy5Xp5DicEa
W0vSO8vOl8PeDowA9IjCqUs8ai7qRm10/2MJCY48qxWC5wP71+filtY4LFJ4nSdZ
BO9y6yJv2Cbu5blpsEq2vZF27A3MxsimDqSIO2p+9AwFgn2GVInUdWCfh2iX64I/
p6ZYQCMoIdm6o9gncoMLyCjQBvFOLkgUhxDOd6Bm8K/vjPfkxzfgYeiq6eSSHzO2
bdc473CUf2COBvLMYl6Lftl4v5J8oXLShrPyfMSv7P2UDM1BB33eExZ8UufGi/n7
S5Nlfrf4gtrQprJdlSYP50/Y9BVBJaHUCoeFIR/AeW+N7drVBlJSOIY80B00Uhid
s0V55KzP5xNuax3U3+7VjM7jY4xb/dXTCfsrnelGbwBX4TGCLk11j+coZR0JmFqL
5jkRBB8w++fG121B1OYnktzrANpLy/shFsbqHfHAi+OJ1oCRViMnGA/XUftU8SAI
1PECwwvMn1pgz8llrR5h
=Tcat
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2014_19_22_34_+1100_deuh57OeUCGCG1zr--
