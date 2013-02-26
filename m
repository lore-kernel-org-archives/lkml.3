Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab3BZXRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:17:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55730 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3BZXRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:17:13 -0500
Date: Wed, 27 Feb 2013 10:17:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: linux-next@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: JFFS2 deadlock
Message-Id: <20130227101704.90466ae6df78ab9b3aa4ba22@canb.auug.org.au>
In-Reply-To: <512CA290.6050509@mimc.co.uk>
References: <512CA290.6050509@mimc.co.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Feb_2013_10_17_04_+1100_d0RNwD8Hns4nTwWW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Feb_2013_10_17_04_+1100_d0RNwD8Hns4nTwWW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue, 26 Feb 2013 11:54:56 +0000 Mark Jackson <mpfj-list@mimc.co.uk> wrot=
e:
>
> Just tested the current next-20130226 on a custom AM335X board, and I rec=
eived the JFFS2 deadlock shown below.

Is this new today?  is it reproducible? Does if ail for Linus' tree?

Al, could this be something to do with the new stuff in the vfs tree?

> Regards
> Mark JACKSON
> ---
> [    3.250349] jffs2: notice: (1) jffs2_build_xattr_subsystem: complete b=
uilding xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan) and 0 of xref =
(0 dead, 0 orphan) found.
> [    3.268364] VFS: Mounted root (jffs2 filesystem) readonly on device 31=
:6.
> [    3.277233] devtmpfs: mounted
> [    3.280982] Freeing init memory: 332K
> [    3.706697]
> [    3.708306] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [    3.714804] [ INFO: possible circular locking dependency detected ]
> [    3.721398] 3.8.0-next-20130226-dirty #10 Not tainted
> [    3.726708] -------------------------------------------------------
> [    3.733297] rcS/686 is trying to acquire lock:
> [    3.737969]  (&mm->mmap_sem){++++++}, at: [<c00f0af4>] might_fault+0x3=
c/0x90
> [    3.745437]
> [    3.745437] but task is already holding lock:
> [    3.751569]  (&f->sem){+.+.+.}, at: [<c023d128>] jffs2_readdir+0x44/0x=
1a8
> [    3.758748]
> [    3.758748] which lock already depends on the new lock.
> [    3.758748]
> [    3.767348]
> [    3.767348] the existing dependency chain (in reverse order) is:
> [    3.775215]
> -> #1 (&f->sem){+.+.+.}:
> [    3.779184]        [<c0092df0>] lock_acquire+0x9c/0x104
> [    3.784701]        [<c04b76e4>] mutex_lock_nested+0x3c/0x334
> [    3.790666]        [<c023d950>] jffs2_readpage+0x20/0x44
> [    3.796261]        [<c00d9d38>] __do_page_cache_readahead+0x2a0/0x2cc
> [    3.803050]        [<c00da004>] ra_submit+0x28/0x30
> [    3.808187]        [<c00d179c>] filemap_fault+0x304/0x458
> [    3.813884]        [<c00f0c58>] __do_fault+0x6c/0x490
> [    3.819203]        [<c00f3c5c>] handle_pte_fault+0xb0/0x6f0
> [    3.825071]        [<c00f433c>] handle_mm_fault+0xa0/0xd4
> [    3.830755]        [<c04bbdcc>] do_page_fault+0x2a0/0x3d4
> [    3.836449]        [<c000845c>] do_DataAbort+0x30/0x9c
> [    3.841861]        [<c04ba2a4>] __dabt_svc+0x44/0x80
> [    3.847089]        [<c0289c34>] __clear_user_std+0x1c/0x64
> [    3.852877]
> -> #0 (&mm->mmap_sem){++++++}:
> [    3.857393]        [<c00927ec>] __lock_acquire+0x1d70/0x1de0
> [    3.863353]        [<c0092df0>] lock_acquire+0x9c/0x104
> [    3.868855]        [<c00f0b18>] might_fault+0x60/0x90
> [    3.874174]        [<c011bc3c>] filldir+0x5c/0x158
> [    3.879230]        [<c023d1c0>] jffs2_readdir+0xdc/0x1a8
> [    3.884823]        [<c011becc>] vfs_readdir+0x98/0xb4
> [    3.890144]        [<c011bfcc>] sys_getdents+0x74/0xd0
> [    3.895554]        [<c0013820>] ret_fast_syscall+0x0/0x3c
> [    3.901251]
> [    3.901251] other info that might help us debug this:
> [    3.901251]
> [    3.909668]  Possible unsafe locking scenario:
> [    3.909668]
> [    3.915892]        CPU0                    CPU1
> [    3.920652]        ----                    ----
> [    3.925411]   lock(&f->sem);
> [    3.928451]                                lock(&mm->mmap_sem);
> [    3.934688]                                lock(&f->sem);
> [    3.940376]   lock(&mm->mmap_sem);
> [    3.943965]
> [    3.943965]  *** DEADLOCK ***
> [    3.943965]
> [    3.950196] 2 locks held by rcS/686:
> [    3.953952]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c011be90>] v=
fs_readdir+0x5c/0xb4
> [    3.962686]  #1:  (&f->sem){+.+.+.}, at: [<c023d128>] jffs2_readdir+0x=
44/0x1a8
> [    3.970320]
> [    3.970320] stack backtrace:
> [    3.974930] [<c001b158>] (unwind_backtrace+0x0/0xf0) from [<c008f29c>]=
 (print_circular_bug+0x1d0/0x2dc)
> [    3.984815] [<c008f29c>] (print_circular_bug+0x1d0/0x2dc) from [<c0092=
7ec>] (__lock_acquire+0x1d70/0x1de0)
> [    3.994975] [<c00927ec>] (__lock_acquire+0x1d70/0x1de0) from [<c0092df=
0>] (lock_acquire+0x9c/0x104)
> [    4.004494] [<c0092df0>] (lock_acquire+0x9c/0x104) from [<c00f0b18>] (=
might_fault+0x60/0x90)
> [    4.013376] [<c00f0b18>] (might_fault+0x60/0x90) from [<c011bc3c>] (fi=
lldir+0x5c/0x158)
> [    4.021802] [<c011bc3c>] (filldir+0x5c/0x158) from [<c023d1c0>] (jffs2=
_readdir+0xdc/0x1a8)
> [    4.030502] [<c023d1c0>] (jffs2_readdir+0xdc/0x1a8) from [<c011becc>] =
(vfs_readdir+0x98/0xb4)
> [    4.039477] [<c011becc>] (vfs_readdir+0x98/0xb4) from [<c011bfcc>] (sy=
s_getdents+0x74/0xd0)
> [    4.048270] [<c011bfcc>] (sys_getdents+0x74/0xd0) from [<c0013820>] (r=
et_fast_syscall+0x0/0x3c)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Feb_2013_10_17_04_+1100_d0RNwD8Hns4nTwWW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRLUJwAAoJEECxmPOUX5FEjBwP/1tqyOXBZ+GMjeqnXBKqkBrW
wGkVmPQG5jGSSwrtgPrnxkLoa6UyVuABdwXCh3EO5yW+UFYkJn0SHWhEkcXNVqzH
0ktmG0vjGJ2jq0DOXRiKIzHpDWIATQce7fbUUZiUQ4fCqumQ1OHlEz5q91AKvygU
ltqTf7Ms/XclU4WwSPnN7hAJucHwO7J8EGYXkWLyceTz56IBzrNFXVWqsL8/jG7M
uojBBxsIZdDONWdvvU5t9P3fVOLnRZ1FIiRvnQYwCj55af9aNXiHM3foOzggG0tP
JiHHIMPGT/QNEjmGrmaVgjpQ46RWMTpj+6pBj3tULUkf+ezN2hfxwF1pe+rro6Si
Iy1jSpLjSHZWLRQNWQ8Pc8YJUTb1WmSTrOVMHV/hvZiashB5JEpevi/lORfpudcB
eWhQbjCFcyxUSUjJkk4s83CkZxO6KPsAiRMJn7ElWORY1LkW5s4DX1hiRQqpHVWC
t53OzI/8od/+X3n+qJmXsV1ZZJ1fRqXpUZw1oLEWkVbbM/O1s7BuOucYRRH0IyuM
y+35DTUAO7BVuHXsCx2Sc7qrz9eEBW0WIRhcZOOUks+koai8o8AsExyxjhdufYDG
9oOOW+IzBw1GFJ1sF1lZqz6Tek9PSVrlUqhIZvibXUiTzYNgnpwLqBpy1FNHz1L3
S4HfNY3Y+TJ30G4hvvz0
=xWdF
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Feb_2013_10_17_04_+1100_d0RNwD8Hns4nTwWW--
