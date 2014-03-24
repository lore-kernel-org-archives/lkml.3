Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaCXGXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:23:36 -0400
Received: from ozlabs.org ([203.10.76.45]:34742 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaCXGXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:23:34 -0400
Date: Mon, 24 Mar 2014 17:23:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140324172327.b852272309976f61238d3d22@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Mar_2014_17_23_27_+1100_vbK3T_b7sWeiz1Cz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Mar_2014_17_23_27_+1100_vbK3T_b7sWeiz1Cz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/mm.h:897:0,
                 from include/linux/mman.h:4,
                 from arch/powerpc/kernel/asm-offsets.c:22:
include/linux/vmstat.h: In function '__count_vm_event':
include/linux/vmstat.h:36:2: error: implicit declaration of function 'raw_c=
pu_inc' [-Werror=3Dimplicit-function-declaration]
  raw_cpu_inc(vm_event_states.event[item]);
  ^
include/linux/vmstat.h: In function '__count_vm_events':
include/linux/vmstat.h:46:2: error: implicit declaration of function 'raw_c=
pu_add' [-Werror=3Dimplicit-function-declaration]
  raw_cpu_add(vm_event_states.event[item], delta);
  ^

Caused by commit "vmstat: use raw_cpu_ops to avoid false positives on
preemption checks".

My kernel (even going back to v3.13) has no reference to
raw_cpu_inc/add ... missed patch?  Ah, ha percpu-add-raw_cpu_ops.patch
etc are in the later part of the series :-(

I just reverted "vmstat: use raw_cpu_ops to avoid false positives on
preemption checks" and
"vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix"
for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Mar_2014_17_23_27_+1100_vbK3T_b7sWeiz1Cz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTL89kAAoJEMDTa8Ir7ZwVZ7IQAIMbItezGMaMH1S1M4eOaap6
rbV6xHug1RBtnjK2m/Z9QjFM9Ey7RjbpqUuJldMcAuaN+vXLcRg06lIgBmHi6pZH
i2ogicZnGpCOgtB6a93jOal0rvvX0SGh14dWym6BQ9R40VLRCLji7Zje9U+IpMpe
oR140/DBIbamL+IosCZcCuLyqbaNvBN7+viZhfUF3xgpy7GLPe0g6Ce3zXQEFi+U
3mqdO8/sNwyh9DVZBFaePUVAQ0qogPLN0ZyFUcbGKxPFG373u5twdadslkybDnO+
JVMARob6O/fNxWZtSLMFjtvvrYMScTxeQ3eRHBtvzA+LJLgreY85LVhgZwCkLS5u
W1XS08xidwTcWx+U3aZ59TWF+2pkf/uGmqa7LUOBYEJpOgPAjnDPIcFPg490lWMf
cTp3qLul3QaIEr4DrVkhdyWxHpCOfgNAzAWbSzOtHe8H1IdCGKKIDm438C0+87jR
N+CqXC39d5h2RieD0SClqaprcCSTFQ6/D1Ge9hro5EwRQXT8XeoeqTOYcwtAInA1
1e2urT6CSKPYMtAUNOafHRq/ofOyTCowhFiOJDmYnEocoHMAH/EWGfRHI7GH2bKy
MHo/jQ7IU+1Q5E+41nWXTrjfs2qSBXI2ba1cz6GxMC5dfwMd4GlticAHBiDUTfNf
UoO9A46KIn7jZMlG61Ka
=OIDU
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Mar_2014_17_23_27_+1100_vbK3T_b7sWeiz1Cz--
