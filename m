Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbbALD0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 22:26:41 -0500
Received: from ozlabs.org ([103.22.144.67]:58781 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbbALD0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 22:26:39 -0500
Date: Mon, 12 Jan 2015 14:26:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [LKP] [mm] Find a way to test remap_file_pages
Message-ID: <20150112142629.46c45532@canb.auug.org.au>
In-Reply-To: <1421032741.6201.162.camel@intel.com>
References: <1421032741.6201.162.camel@intel.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_BL/ybTxqIVxyaTnR872ygL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_BL/ybTxqIVxyaTnR872ygL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

[Just cc'ing Andrew as this patch is in his tree]

On Mon, 12 Jan 2015 11:19:01 +0800 Huang Ying <ying.huang@intel.com> wrote:
>
> FYI, we noticed the below changes on
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 974bb1d5d44f008d7f207437d63d46658ff41dff ("mm: replace remap_file_=
pages() syscall with emulation")
>=20
> That is, trinity can be used to test some aspect of remap_file_pages.
>=20
> +---------------------------------------------------+------------+-------=
-----+
> |                                                   | d96eeaf2cb | 974bb1=
d5d4 |
> +---------------------------------------------------+------------+-------=
-----+
> | boot_successes                                    | 0          | 0     =
     |
> | boot_failures                                     | 10         | 10    =
     |
> | WARNING:at_net/netlink/genetlink.c:#genl_unbind() | 10         | 5     =
     |
> | backtrace:netlink_setsockopt                      | 3          | 2     =
     |
> | backtrace:SyS_setsockopt                          | 3          | 2     =
     |
> | backtrace:SyS_socketcall                          | 3          | 2     =
     |
> | backtrace:do_group_exit                           | 10         | 5     =
     |
> | backtrace:SyS_exit_group                          | 10         | 5     =
     |
> | page_allocation_failure:order:#,mode              | 0          | 5     =
     |
> | backtrace:btrfs_test_extent_io                    | 0          | 5     =
     |
> | backtrace:init_btrfs_fs                           | 0          | 5     =
     |
> | backtrace:kernel_init_freeable                    | 0          | 5     =
     |
> +---------------------------------------------------+------------+-------=
-----+
>=20
>=20
> [   29.665081] Bits 55-60 of /proc/PID/pagemap entries are about to stop =
being page-shift some time soon. See the linux/Documentation/vm/pagemap.txt=
 for details.
> [   29.675960] mmap: trinity-c0 (873) uses deprecated remap_file_pages() =
syscall. See Documentation/vm/remap_file_pages.txt.
> [   29.681044] ------------[ cut here ]------------
> [   29.681841] WARNING: CPU: 0 PID: 870 at net/netlink/genetlink.c:1037 g=
enl_unbind+0x96/0xaa()
> [   29.683610] warning: process `trinity-c0' used the obsolete bdflush sy=
stem call
> [   29.684911] Fix your initscripts?
> [   29.685683] VFS: Warning: trinity-c0 using old stat() call. Recompile =
your binary.
> [   29.686963] CPU: 0 PID: 870 Comm: trinity-main Not tainted 3.19.0-rc3-=
next-20150109-g06f367d #290
> [   29.688399] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   29.689349]  00000000 00000000 d34f3ea4
> [   29.694083] ------------[ cut here ]------------
> [   29.695096] WARNING: CPU: 0 PID: 872 at net/netlink/genetlink.c:1037 g=
enl_unbind+0x96/0xaa()
> [   29.696724]  c15933f7 d34f3ec0 c103c7ff 0000040d c1581310
> [   29.698051]  00000001 00000001 00000000 d34f3ed0 c103c89c 00000009 000=
00000 d34f3ee8
> [   29.699904] CPU: 0 PID: 872 Comm: trinity-main Not tainted 3.19.0-rc3-=
next-20150109-g06f367d #290
> [   29.701406] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   29.702291]  00000000 00000000 d34d9ea4 c15933f7 d34d9ec0
> [   29.703253]  c1581310 c18836fc 00000001 d341f840 00000000 d34f3f0c c15=
7f810 d15b0b40
> [   29.705361] Call Trace:
> [   29.705868]  [<c15933f7>] dump_stack+0x16/0x18
> [   29.706652]  [<c103c7ff>] warn_slowpath_common+0x79/0x90
> [   29.707496]  [<c1581310>] ? genl_unbind+0x96/0xaa
> [   29.708295]  [<c103c89c>] warn_slowpath_null+0xf/0x13
> [   29.709142]  [<c1581310>] genl_unbind+0x96/0xaa
> [   29.709943]  [<c157f810>] netlink_release+0x2d7/0x2ed
> [   29.710776]  [<c1553efd>] sock_release+0x10/0x5a
> [   29.711531]  [<c1553f52>] sock_close+0xb/0xf
> [   29.712286]  [<c1109a69>] __fput+0xf7/0x1f0
> [   29.713044]  [<c1109b88>] ____fput+0x8/0xa
> [   29.713794]  [<c1052412>] task_work_run+0x4e/0x70
> [   29.714566]  [<c103e771>] do_exit+0x43a/0x9c7
> [   29.715300]  [<c103ed6f>] do_group_exit+0x4a/0xd6
> [   29.716111]  [<c103ee0c>] SyS_exit_group+0x11/0x11
> [   29.716975]  [<c1598cfd>] syscall_call+0x7/0x7
> [   29.717722]  [<c1590000>] ? io_submit_one+0x5b3/0x72a
> [   29.719207]  c103c7ff 0000040d c1581310
> [   29.720122]  00000001 00000001 00000000 d34d9ed0 c103c89c 00000009 000=
00000 d34d9ee8
> [   29.721973]  c1581310 c18836fc 00000004 d0ebb840 00000000 d34d9f0c c15=
7f810
> [   29.723252] ---[ end trace 28426633f87b780a ]---
> [   29.724282] ------------[ cut here ]------------
>=20
>=20
> Thanks,
> Huang, Ying

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/_BL/ybTxqIVxyaTnR872ygL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUsz7pAAoJEMDTa8Ir7ZwVQRgQAJBUYczejZe0oexrYsrmc8zp
RVwwRi7ijii4YL1a+BBVazdxu8cJX0bDBWnJK4vNWqzyC5kiTyjfwPPvWa/8jRYp
OE9zWvGfpaVJJk9dSIzB+48jC1PaTno02ivD6m/guQ7ThM7uQhwGPY+vNDaiQY8z
sboqXpi0/stjnF3fpkSDkGURTSfsGqEQs+D/MAWmLcPLPp68TbxDn9+N8xYbduDd
t6xiWCHxT0hzCzAE+dImuw9Gu8ZqDPqx0HOmkuyd3wiReXibYjBaaTCaGRw2u9Jj
tzEjl38eSEryKnRi0yc3Kg+CbGvarKwF0Ls8Ci8jjmWYkb0mSFtKcoVVP8MNE6NO
7QoX4wVVssCBPJi9FfRPu4T2fdnh9LnMAn9kvKIvWDpAtEefqHJSm+BzDMxgBxpx
SBGWGBkDQWMNbVLdsEyIq5PBbGzX152RjFqxTpUhM5AerCcRgHXtNKOpbw5AX6hA
zdp3jaZs3+F6WSrG1Uv6kM1JKCQG2TpPyPaGDenze0p+YCsyyxUmXorB9XRVn74j
iePNicssV91ubgH/zMkWuWBIJ/D09Ys6wfCNaDt4Y+cCThjbk4CocBv/Ux82TMB3
iC1Fko6HJcri6cZz/V0IsZp2PvGuwt9/+ew0Ju3WdEaLaaMmbNXNfDRGgYi2mJbv
8jjJWo/ajk7SkejSD4xR
=sDcx
-----END PGP SIGNATURE-----

--Sig_/_BL/ybTxqIVxyaTnR872ygL--
