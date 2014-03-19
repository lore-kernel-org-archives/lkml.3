Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbaCSXCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:02:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbaCSXCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:02:47 -0400
Date: Thu, 20 Mar 2014 10:02:38 +1100
From: NeilBrown <neilb@suse.de>
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UsOpbWkgUsOpcm9sbGU=?= <remi.rerolle@seagate.com>
Subject: Re: [PATCH 2/2] md: fix deadlock while suspending RAID array
Message-ID: <20140320100238.18c9f434@notabene.brown>
In-Reply-To: <1394565130-24233-3-git-send-email-simon.guinot@sequanux.org>
References: <1394565130-24233-1-git-send-email-simon.guinot@sequanux.org>
	<1394565130-24233-3-git-send-email-simon.guinot@sequanux.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zQ76VWqtSc8JkLUDtjy/WAQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zQ76VWqtSc8JkLUDtjy/WAQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Mar 2014 20:12:10 +0100 Simon Guinot <simon.guinot@sequanux.org>
wrote:

> Sometimes a deadlock happens while migrating a RAID array level, using
> the mdadm --grow command. In the following example, an ext4 filesystem
> is installed over a RAID1 array and mdadm is used to transform this
> array into a RAID5 one. Here are the observed backtraces for the locked
> tasks:
>=20
> jbd2/dm-0-8     D c0478384     0  9100      2 0x00000000
> [<c0478384>] (__schedule+0x154/0x320) from [<c0157c68>] (jbd2_journal_com=
mit_transaction+0x1b0/0x132c)
> [<c0157c68>] (jbd2_journal_commit_transaction+0x1b0/0x132c) from [<c015b5=
f4>] (kjournald2+0x9c/0x200)
> [<c015b5f4>] (kjournald2+0x9c/0x200) from [<c003558c>] (kthread+0xa4/0xb0)
> [<c003558c>] (kthread+0xa4/0xb0) from [<c000df18>] (ret_from_fork+0x14/0x=
3c)
> ext4lazyinit    D c0478384     0  9113      2 0x00000000
> [<c0478384>] (__schedule+0x154/0x320) from [<c0364ed0>] (md_write_start+0=
xd8/0x194)
> [<c0364ed0>] (md_write_start+0xd8/0x194) from [<bf004c80>] (make_request+=
0x3c/0xc5c [raid1])
> [<bf004c80>] (make_request+0x3c/0xc5c [raid1]) from [<c0363784>] (md_make=
_request+0xe4/0x1f8)
> [<c0363784>] (md_make_request+0xe4/0x1f8) from [<c025f544>] (generic_make=
_request+0xa8/0xc8)
> [<c025f544>] (generic_make_request+0xa8/0xc8) from [<c025f5e4>] (submit_b=
io+0x80/0x12c)
> [<c025f5e4>] (submit_bio+0x80/0x12c) from [<c0265648>] (__blkdev_issue_ze=
roout+0x134/0x1a0)
> [<c0265648>] (__blkdev_issue_zeroout+0x134/0x1a0) from [<c0265748>] (blkd=
ev_issue_zeroout+0x94/0xa0)
> [<c0265748>] (blkdev_issue_zeroout+0x94/0xa0) from [<c011a3e8>] (ext4_ini=
t_inode_table+0x178/0x2cc)
> [<c011a3e8>] (ext4_init_inode_table+0x178/0x2cc) from [<c0129fac>] (ext4_=
lazyinit_thread+0xe8/0x288)
> [<c0129fac>] (ext4_lazyinit_thread+0xe8/0x288) from [<c003558c>] (kthread=
+0xa4/0xb0)
> [<c003558c>] (kthread+0xa4/0xb0) from [<c000df18>] (ret_from_fork+0x14/0x=
3c)
> mdadm           D c0478384     0 10163   9465 0x00000000
> [<c0478384>] (__schedule+0x154/0x320) from [<c0362edc>] (mddev_suspend+0x=
68/0xc0)
> [<c0362edc>] (mddev_suspend+0x68/0xc0) from [<c0363080>] (level_store+0x1=
4c/0x59c)
> [<c0363080>] (level_store+0x14c/0x59c) from [<c03665ac>] (md_attr_store+0=
xac/0xdc)
> [<c03665ac>] (md_attr_store+0xac/0xdc) from [<c00eee38>] (sysfs_write_fil=
e+0x100/0x168)
> [<c00eee38>] (sysfs_write_file+0x100/0x168) from [<c0098598>] (vfs_write+=
0xb8/0x184)
> [<c0098598>] (vfs_write+0xb8/0x184) from [<c009893c>] (SyS_write+0x40/0x6=
c)
> [<c009893c>] (SyS_write+0x40/0x6c) from [<c000de80>] (ret_fast_syscall+0x=
0/0x30)
>=20
> This deadlock can be reproduced on different architecture (ARM and x86)
> and also with different Linux kernel versions: 3.14-rc and 3.10 stable.
>=20
> The problem comes from the mddev_suspend() function which don't allow
> mddev->thread to complete the pending I/Os (mddev->active_io) if any:
>=20
> 1. mdadm holds mddev->reconfig_mutex before running mddev_suspend().
>    If a write I/O is submitted while mdadm holds the mutex and when the
>    RAID array is still not suspended, then mddev->thread is not able to
>    complete the I/O: The superblock can't be updated because
>    mddev->reconfig_mutex is not available. Note that having a write I/O
>    over a "not suspended yet" RAID array is not a marginal scenario:
>    To load a new RAID personality, level_store() calls request_module()
>    which is allowed to schedule. Moreover on a SMP or a preemptible
>    kernel, the odds are probably even greater.
>=20
> 2. In a same way, mddev_suspend() sets the mddev->suspended flag. Again
>    this may prevent mddev->thread to complete some pending I/Os when
>    a superblock update is needed: md_check_recovery, used by the RAID
>    threads, does nothing but exits when the mddev->suspended flag is
>    set. As a consequence the superblock is never updated.
>=20
> This patch solves this issues by ensuring there is no pending active
> I/Os before suspending effectively a RAID array.
>=20
> Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
> Tested-by: R=C3=A9mi R=C3=A9rolle <remi.rerolle@seagate.com>
> ---
>  drivers/md/md.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index fb4296adae80..ea3e95d1972b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -375,9 +375,22 @@ static void md_make_request(struct request_queue *q,=
 struct bio *bio)
>  void mddev_suspend(struct mddev *mddev)
>  {
>  	BUG_ON(mddev->suspended);
> -	mddev->suspended =3D 1;
> -	synchronize_rcu();
> -	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D 0);
> +
> +	for (;;) {
> +		mddev->suspended =3D 1;
> +		synchronize_rcu();
> +		if (atomic_read(&mddev->active_io) =3D=3D 0)
> +			break;
> +		mddev->suspended =3D 0;
> +		synchronize_rcu();
> +		/*
> +		 * Note that mddev_unlock is also used to wake up mddev->thread.
> +		 * This allows to complete the pending mddev->active_io.
> +		 */
> +		mddev_unlock(mddev);
> +		wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) =3D=3D 0);
> +		mddev_lock_nointr(mddev);
> +	}
>  	mddev->pers->quiesce(mddev, 1);
> =20
>  	del_timer_sync(&mddev->safemode_timer);


Hi Simon,
 thanks for the report and the patch.

Dropping a lock inside a function which was called with the lock held always
makes me feel nervous.  It is quite possible that it is safe, but I find it
very hard to convince myself that it is safe.  So I would rather avoid it if
I could.

Would it be possible to perform that superblock update etc inside
mddev_suspend?
e.g.

   mddev->suspended =3D 1;
   synchronize_rcu();
   while  (atomic_read(&mddev->active_io) > 0) {
      prepare_wait(... mddev->sb_wait..);
      if (mddev->flags & MD_UPDATE_SB_FLAGS)
          md_update_sb(mddev, 0);
      schedule()
   }
   finish_wait()

and then in md_check_recovery()

   if (mddev->suspended) {
       if (mddev->flags & MD_UPDATE_SB_FLAGS)
           wake_up(mddev->sb_wait);
       return;
   }

Probably a lot of details are missing but hopefully the idea is clear.

Does that seem reasonable to you?  Would you like to try coding that and see
how it goes?

Thanks,
NeilBrown

--Sig_/zQ76VWqtSc8JkLUDtjy/WAQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUyoiDjnsnt1WYoG5AQIWSRAAn2UUotzEVCFn+5yqAE2cFP2pkmHs8pVo
oVkuIzudE2dk52NwYLwsJpjFKJ087lcZ2b2ZS9dmqY60gzZ8MlInM1LfjPvjm3QV
52i/DPYpkeyNmx2UOg9/jnHlR2WElc5uId2WK1R8NhaCAqVdO5YowUC9kQOF8Mnq
06xhxWyB3MtGptAAWk5XqnNb7lcOEMhS+b3f4GQIzJbfga9ZbNzqDQo4/yOVcLN4
WGTFNV76TgVLfgNkzqwkXjEhAup+x2Ui+fMJo4WHYJ5NmYe+f/+sdqA+hunGVQjZ
/fLK5d7fJYd4nQFMCs9LuV9xFiEFE3lHxE0AvwLr5hvVA3IJoshhaPfOqQMYMUh1
KXc/i53qYa0xbcWknIfqql5LrR1uyoc0XHO4/nDgjl91ob8X65QdRepSX3bIZMXO
6Y3m98DEtfBXl+Ca+GLZu8axExR8wJlTPN3j0CpjdFxaIFAgFC6q8XmYUBVpvp2y
ApW/70SD5GUVsTKm4opbFZXLKISjO1rOea4R6af0Byxzjl7pjO81JWimijhUbUr5
q1iqTI3cWtwR6sU4LuG3cZCOcoUfVsOYln6CmTQJegfXtQyNlBA+QsKrWOv9bFdG
MR7B0CWu3jASs0cUZtZ2Rk58xVLphDac6YsNbVOUkP6leUxGXzKfn04LOCfk/cAE
eI5C2/D39fo=
=ZzYD
-----END PGP SIGNATURE-----

--Sig_/zQ76VWqtSc8JkLUDtjy/WAQ--
