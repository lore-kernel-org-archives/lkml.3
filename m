Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3JYSch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 14:32:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:43083 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab3JYScg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 14:32:36 -0400
Message-ID: <526AB903.5000701@gentoo.org>
Date: Fri, 25 Oct 2013 14:31:31 -0400
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130925 Thunderbird/17.0.9
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: Brian Behlendorf <behlendorf1@llnl.gov>
Subject: How do I get good backtraces from dump_stack()?
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="AMVFJpXDiho1I2ou6edirJfgwgJdTaXuv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AMVFJpXDiho1I2ou6edirJfgwgJdTaXuv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

ZFSOnLinux does memory allocations using a wrapper that invokes
dump_stack() whenever GFP_KERNEL is used in a performance-critical path
(e.g. one that affects swap).

Unfortunately, dump_stack() seems to always produce nonsensical
backtraces. Here is an example that a Debian user sent me yesterday:

[ 4100.817875] Pid: 1209, comm: txg_sync Tainted: P      D    O
3.2.0-4-amd64 #1 Debian 3.2.51-1
[ 4100.822370] Call Trace:
[ 4100.826762]  [<ffffffffa033355e>] ? spl_debug_dumpstack+0x24/0x2a [spl=
]
[ 4100.831273]  [<ffffffffa0338a09>] ? sanitize_flags+0x6e/0x7c [spl]
[ 4100.835729]  [<ffffffffa0338c9d>] ? kmalloc_nofail+0x1f/0x3d [spl]
[ 4100.840192]  [<ffffffffa0338e55>] ? kmem_alloc_debug+0x164/0x2d0 [spl]=

[ 4100.844599]  [<ffffffff810ec6ff>] ? __kmalloc+0x100/0x112
[ 4100.849038]  [<ffffffffa02e45b1>] ? nv_mem_zalloc.isra.12+0xa/0x21
[znvpair]
[ 4100.853468]  [<ffffffffa02e5f90>] ? nvlist_add_common+0x113/0x2f9
[znvpair]
[ 4100.857954]  [<ffffffffa02e61af>] ?
nvlist_copy_pairs.isra.29+0x39/0x4b [znvpair]
[ 4100.862388]  [<ffffffffa02e5e5e>] ?
nvlist_copy_embedded.isra.31+0x47/0x66 [znvpair]
[ 4100.866878]  [<ffffffffa02e60c9>] ? nvlist_add_common+0x24c/0x2f9
[znvpair]
[ 4100.871314]  [<ffffffffa02e74ba>] ?
fnvlist_add_nvlist_array+0x19/0x6b [znvpair]
[ 4100.875839]  [<ffffffffa049cb1e>] ? vdev_config_generate+0x330/0x49a
[zfs]
[ 4100.880298]  [<ffffffffa0338e55>] ? kmem_alloc_debug+0x164/0x2d0 [spl]=

[ 4100.884802]  [<ffffffffa0338ca9>] ? kmalloc_nofail+0x2b/0x3d [spl]
[ 4100.889241]  [<ffffffff810ec6ff>] ? __kmalloc+0x100/0x112
[ 4100.893718]  [<ffffffffa02e5dd1>] ? nvlist_remove_all+0x3d/0x83 [znvpa=
ir]
[ 4100.898334]  [<ffffffffa02e615c>] ? nvlist_add_common+0x2df/0x2f9
[znvpair]
[ 4100.902788]  [<ffffffffa0336d4b>] ? kmem_free_debug+0xc5/0x10d [spl]
[ 4100.907308]  [<ffffffff810eb882>] ? kfree+0x5b/0x6c
[ 4100.911747]  [<ffffffffa0336d4b>] ? kmem_free_debug+0xc5/0x10d [spl]
[ 4100.916249]  [<ffffffffa02e62e4>] ? nvlist_add_uint64+0x1d/0x22 [znvpa=
ir]
[ 4100.920747]  [<ffffffffa048ff5c>] ? spa_config_generate+0x4b0/0x701 [z=
fs]
[ 4100.925297]  [<ffffffffa0488a1e>] ? spa_sync+0x430/0x942 [zfs]
[ 4100.929831]  [<ffffffff81066733>] ? ktime_get_ts+0x5c/0x82
[ 4100.934362]  [<ffffffffa0496113>] ? txg_sync_thread+0x2cd/0x4be [zfs]
[ 4100.938864]  [<ffffffffa0495e46>] ? txg_thread_wait.isra.2+0x23/0x23
[zfs]
[ 4100.943381]  [<ffffffffa033a1bc>] ? thread_generic_wrapper+0x6a/0x75
[spl]
[ 4100.947785]  [<ffffffffa033a152>] ? __thread_create+0x2be/0x2be [spl]
[ 4100.952202]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
[ 4100.956552]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
[ 4100.960977]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
[ 4100.965362]  [<ffffffff81356370>] ? gs_change+0x13/0x13

Here, the stack between kmem_alloc_debug and spa_sync makes no sense. I
guess part of this has to do with the use of static functions, but it is
not clear to me when a static function causes problems.

Does anyone have any suggestions on how to make this better?

I have added the ZFSOnLinux project lead to the CC list. Neither of us
are on the mailing list, so please include both of us on CC.

P.S. It might seem odd for a Gentoo developer to tackle a report made by
a Debian user. I cannot speak for all of us, but I do what I can to
tackle bug reports involving distribution-independent issues in Gentoo
packages that I maintain. Many others do the same. I realize ZFS is not
mainline, but I sincerely hope that people will be as accommodating to
my question as I try to be with bug reports by users of other
distributions. :)


--AMVFJpXDiho1I2ou6edirJfgwgJdTaXuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIaBAEBAgAGBQJSarkGAAoJECDuEZm+6ExkECUP8IsO91B4HqWrup4NF5BTYNcK
YcXurL83YaRQSb465a8o4PU8/v9vVQhKfskv8B57DoL5/wfulSsCviayinwn0PHa
nLpqodbqUHtzXILSR5+Tl86DfIWy0lygY3XQqGegDsakN5VQJouhlX69fWx4svrV
obAX1NdCavbAeh1FgnWsmahefxc4A3D5IOUIJdYDnD9ARTBETm6mH8Esq7fck1+9
z0W6zcZRadgBc6g/KaBPSnUTeKw4UCpzzvLF39TZgjrKDHvZceehUzWFe6Vv3Wbx
ps+wo/p7GQ7r18BYqPXEfTrtczevGVu/XDtFFdqtqHL74D7pOZ4lsB3pqkXFRDGQ
n1flrXx0nl/hKYB7DryUJKy4Hv4D7X2UD98W8aF+UfSA2YYmZdhwVmqpB5ql21NI
NGncBteS+4oez15ioSXMH+oK3p7sztsgTZ9uic4V1cuM/l+VpABneEBjT5qwohMA
+xjIMBRWDxY/3uHOMbnLT+c8hjxhF2kD6jZaFTtORGbAwGGI+SZriH/zq8cUdOB/
axETGgta+DWHM78ZxEwgVrJlhzrkAC9tIxNSW3S2VHKKzrCRlXnkWpv4VOxiG2JC
lXeqS9mbejUkFOoO9xvGBY97Vj8eAvX54SW1vp8GUu2P1bzCheOMNflSdKVWEuw6
0DAAYw/GCfe5mxLePA==
=wNny
-----END PGP SIGNATURE-----

--AMVFJpXDiho1I2ou6edirJfgwgJdTaXuv--
