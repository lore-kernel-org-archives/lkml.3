Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaIQLRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:17:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbaIQLRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:17:10 -0400
Message-ID: <1410952609.3040.100.camel@decadent.org.uk>
Subject: Re: [PATCH 3.14 108/114] blkcg: dont call into policy draining if
 root_blkg is already gone
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Shirish Pargaonkar <spargaonkar@suse.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jet Chen <jet.chen@intel.com>,
        Jens Axboe <axboe@fb.com>
Date: Wed, 17 Sep 2014 12:16:49 +0100
In-Reply-To: <20140915192644.795711233@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
	 <20140915192644.795711233@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Hwkm2FyF4vurqZzDDBzy"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:cde6:1b3a:bf85:5ca0
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Hwkm2FyF4vurqZzDDBzy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-15 at 12:26 -0700, Greg Kroah-Hartman wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Tejun Heo <tj@kernel.org>
>=20
> commit 2a1b4cf2331d92bc009bf94fa02a24604cdaf24c upstream.

This is a duplicate of commit 0b462c89e31f which was already
cherry-picked into 3.10.51 and 3.14.15 and included in 3.16-rc7.  You
can drop it from all the updates.

Ben.

> While a queue is being destroyed, all the blkgs are destroyed and its
> ->root_blkg pointer is set to NULL.  If someone else starts to drain
> while the queue is in this state, the following oops happens.
>=20
>   NULL pointer dereference at 0000000000000028
>   IP: [<ffffffff8144e944>] blk_throtl_drain+0x84/0x230
>   PGD e4a1067 PUD b773067 PMD 0
>   Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>   Modules linked in: cfq_iosched(-) [last unloaded: cfq_iosched]
>   CPU: 1 PID: 537 Comm: bash Not tainted 3.16.0-rc3-work+ #2
>   Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>   task: ffff88000e222250 ti: ffff88000efd4000 task.ti: ffff88000efd4000
>   RIP: 0010:[<ffffffff8144e944>]  [<ffffffff8144e944>] blk_throtl_drain+0=
x84/0x230
>   RSP: 0018:ffff88000efd7bf0  EFLAGS: 00010046
>   RAX: 0000000000000000 RBX: ffff880015091450 RCX: 0000000000000001
>   RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>   RBP: ffff88000efd7c10 R08: 0000000000000000 R09: 0000000000000001
>   R10: ffff88000e222250 R11: 0000000000000000 R12: ffff880015091450
>   R13: ffff880015092e00 R14: ffff880015091d70 R15: ffff88001508fc28
>   FS:  00007f1332650740(0000) GS:ffff88001fa80000(0000) knlGS:00000000000=
00000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>   CR2: 0000000000000028 CR3: 0000000009446000 CR4: 00000000000006e0
>   Stack:
>    ffffffff8144e8f6 ffff880015091450 0000000000000000 ffff880015091d80
>    ffff88000efd7c28 ffffffff8144ae2f ffff880015091450 ffff88000efd7c58
>    ffffffff81427641 ffff880015091450 ffffffff82401f00 ffff880015091450
>   Call Trace:
>    [<ffffffff8144ae2f>] blkcg_drain_queue+0x1f/0x60
>    [<ffffffff81427641>] __blk_drain_queue+0x71/0x180
>    [<ffffffff81429b3e>] blk_queue_bypass_start+0x6e/0xb0
>    [<ffffffff814498b8>] blkcg_deactivate_policy+0x38/0x120
>    [<ffffffff8144ec44>] blk_throtl_exit+0x34/0x50
>    [<ffffffff8144aea5>] blkcg_exit_queue+0x35/0x40
>    [<ffffffff8142d476>] blk_release_queue+0x26/0xd0
>    [<ffffffff81454968>] kobject_cleanup+0x38/0x70
>    [<ffffffff81454848>] kobject_put+0x28/0x60
>    [<ffffffff81427505>] blk_put_queue+0x15/0x20
>    [<ffffffff817d07bb>] scsi_device_dev_release_usercontext+0x16b/0x1c0
>    [<ffffffff810bc339>] execute_in_process_context+0x89/0xa0
>    [<ffffffff817d064c>] scsi_device_dev_release+0x1c/0x20
>    [<ffffffff817930e2>] device_release+0x32/0xa0
>    [<ffffffff81454968>] kobject_cleanup+0x38/0x70
>    [<ffffffff81454848>] kobject_put+0x28/0x60
>    [<ffffffff817934d7>] put_device+0x17/0x20
>    [<ffffffff817d11b9>] __scsi_remove_device+0xa9/0xe0
>    [<ffffffff817d121b>] scsi_remove_device+0x2b/0x40
>    [<ffffffff817d1257>] sdev_store_delete+0x27/0x30
>    [<ffffffff81792ca8>] dev_attr_store+0x18/0x30
>    [<ffffffff8126f75e>] sysfs_kf_write+0x3e/0x50
>    [<ffffffff8126ea87>] kernfs_fop_write+0xe7/0x170
>    [<ffffffff811f5e9f>] vfs_write+0xaf/0x1d0
>    [<ffffffff811f69bd>] SyS_write+0x4d/0xc0
>    [<ffffffff81d24692>] system_call_fastpath+0x16/0x1b
>=20
> 776687bce42b ("block, blk-mq: draining can't be skipped even if
> bypass_depth was non-zero") made it easier to trigger this bug by
> making blk_queue_bypass_start() drain even when it loses the first
> bypass test to blk_cleanup_queue(); however, the bug has always been
> there even before the commit as blk_queue_bypass_start() could race
> against queue destruction, win the initial bypass test but perform the
> actual draining after blk_cleanup_queue() already destroyed all blkgs.
>=20
> Fix it by skippping calling into policy draining if all the blkgs are
> already gone.
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Shirish Pargaonkar <spargaonkar@suse.com>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Reported-by: Jet Chen <jet.chen@intel.com>
> Tested-by: Shirish Pargaonkar <spargaonkar@suse.com>
> Signed-off-by: Jens Axboe <axboe@fb.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  block/blk-cgroup.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -866,6 +866,13 @@ void blkcg_drain_queue(struct request_qu
>  	if (!q->root_blkg)
>  		return;
> =20
> +	/*
> +	 * @q could be exiting and already have destroyed all blkgs as
> +	 * indicated by NULL root_blkg.  If so, don't confuse policies.
> +	 */
> +	if (!q->root_blkg)
> +		return;
> +
>  	blk_throtl_drain(q);
>  }

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-Hwkm2FyF4vurqZzDDBzy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVBltrOe/yOyVhhEJAQrnUhAAorcNCHS/a6HrQ6nRILumAw3IXHwBZJXs
x6qlntfMuWn03WD78U1s7TYRTXI6g7oWXcIIPg7gs3/Z+YctrOme0qFzFwXoKSWe
MtE33S7b2pnKzkDTDsvlt34eqgY5GIf6d4MX8YthX48pzE7zjc4mEOl4eFFqcs43
atkcn3Jt4zsP3kY6rhSnLUo6JTFtugXg9W1GVLJz9r4XkSupNORuGFjQApGt0vjX
Cew2Ei2KO+ON+5AfQZADkbECWfVSF960W796erlBdHNLKJMzh7Fv1KSOrkCqL96o
kQAY1ua+JE9MI2ALecKvKDVL5abvrrypSi33WRNtadHc63+vq4Nmj/CNV9eY0jPf
uwVPDzW0KI0Qpi6S8khPaQG5QqD4T5sXyr0TGV56YVIVIA3Bghz4mcIenlX3YtEb
Uv1WMkgeCwQykxRrSHbJ9m1OhM+Dq/UauEJRl4yqBL65m/oKlxmDKabSDc8FBsTG
/NUbxq1E4sykFfqbPAz79iWeBG2dvclNYS2+3eGhwFL/wofpFtyu4pXZfy/UUFP2
H2d9M+zboIOoXWaM5vMnQMjEGF2vvPVx1ZwjZ775PeH9wcijiYpKsavJPvLw0IEe
JWDyoYGTY5B6xFFg4JavShVI8J/XFnCK1Hgk1iIcIjDoyIv2Ogcol2D9iVJFCXO2
RDVLlGT5jXE=
=EFpZ
-----END PGP SIGNATURE-----

--=-Hwkm2FyF4vurqZzDDBzy--
