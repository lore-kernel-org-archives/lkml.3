Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaGaOkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:40:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:48515 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaGaOj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:39:59 -0400
Date: Thu, 31 Jul 2014 16:39:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>, davidlohr@hp.com,
        jason.low2@hp.com, axboe@kernel.dk
Subject: Re: [PATCH] locking/mutexes: Revert "locking/mutexes: Add extra
 reschedule point"
Message-ID: <20140731143946.GV19379@twins.programming.kicks-ass.net>
References: <1406801797-20139-1-git-send-email-ilya.dryomov@inktank.com>
 <20140731115759.GS19379@twins.programming.kicks-ass.net>
 <CALFYKtBGQpxaZ0EFXbdvuEHeDeASeU-7XxQ_1a6ZDM=aJS651w@mail.gmail.com>
 <20140731131331.GT19379@twins.programming.kicks-ass.net>
 <1406817052.17194.12.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tptko/SaOMWhbcZu"
Content-Disposition: inline
In-Reply-To: <1406817052.17194.12.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tptko/SaOMWhbcZu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 04:30:52PM +0200, Mike Galbraith wrote:
> On Thu, 2014-07-31 at 15:13 +0200, Peter Zijlstra wrote:
>=20
> > Smells like maybe current->state !=3D TASK_RUNNING
>=20
> Bingo
>=20
> [ 1200.851004] kjournald       D 0000000000000002     0  4398      2 0x00=
000000
> [ 1200.858283]  ffff8803537bb788 0000000000000046 ffff8803537bb7a8 000000=
0000000000
> [ 1200.865914]  ffff880423324b60 0000000000012f80 ffff8803537bbfd8 000000=
0000012f80
> [ 1200.873590]  ffff88042937cb60 ffff880423324b60 ffff880428ceb240 ffff88=
04231e59b8
> [ 1200.881256] Call Trace:
> [ 1200.883724]  [<ffffffff816981c9>] schedule+0x29/0x70
> [ 1200.888798]  [<ffffffff8169849e>] schedule_preempt_disabled+0xe/0x10
> [ 1200.895239]  [<ffffffff81699fe5>] __mutex_lock_slowpath+0x1b5/0x1c0
> [ 1200.901673]  [<ffffffffa0479826>] ? ceph_str_hash+0x26/0x80 [libceph]
> [ 1200.908198]  [<ffffffff8169a013>] mutex_lock+0x23/0x37
> [ 1200.913430]  [<ffffffffa046751d>] ceph_con_send+0x4d/0x130 [libceph]
> [ 1200.919912]  [<ffffffffa046c540>] __send_queued+0x120/0x150 [libceph]
> [ 1200.926444]  [<ffffffffa046ec5b>] __ceph_osdc_start_request+0x5b/0xd0 =
[libceph]
> [ 1200.933855]  [<ffffffffa046ed21>] ceph_osdc_start_request+0x51/0x80 [l=
ibceph]
> [ 1200.941126]  [<ffffffffa042bf60>] rbd_obj_request_submit.isra.25+0x10/=
0x20 [rbd]
> [ 1200.948622]  [<ffffffffa042e8ee>] rbd_img_obj_request_submit+0x1ce/0x4=
60 [rbd]
> [ 1200.956040]  [<ffffffffa042ebcc>] rbd_img_request_submit+0x4c/0x60 [rb=
d]
> [ 1200.962845]  [<ffffffffa042f2a8>] rbd_request_fn+0x238/0x290 [rbd]
> [ 1200.969108]  [<ffffffff8133a397>] __blk_run_queue+0x37/0x50
> [ 1200.974764]  [<ffffffff8133affd>] queue_unplugged+0x3d/0xc0
> [ 1200.980424]  [<ffffffff8133fddb>] blk_flush_plug_list+0x1db/0x210
> [ 1200.986635]  [<ffffffff81698288>] io_schedule+0x78/0xd0
> [ 1200.991954]  [<ffffffff8133b864>] get_request+0x414/0x800
> [ 1200.997440]  [<ffffffff8133f477>] ? bio_attempt_back_merge+0x37/0x100
> [ 1201.004013]  [<ffffffff8109b9e0>] ? __wake_up_sync+0x20/0x20
> [ 1201.009782]  [<ffffffff8133ff2c>] blk_queue_bio+0xcc/0x360
> [ 1201.015353]  [<ffffffff8133c2d0>] generic_make_request+0xc0/0x100
> [ 1201.021605]  [<ffffffff8133c385>] submit_bio+0x75/0x140
> [ 1201.026921]  [<ffffffff811de4e6>] _submit_bh+0x136/0x1f0
> [ 1201.032390]  [<ffffffff81290081>] journal_do_submit_data+0x41/0x50
> [ 1201.038662]  [<ffffffff81291380>] journal_commit_transaction+0x1150/0x=
1350
> [ 1201.045683]  [<ffffffff81063aff>] ? try_to_del_timer_sync+0x4f/0x70
> [ 1201.052043]  [<ffffffff81293e01>] kjournald+0xe1/0x260
> [ 1201.057324]  [<ffffffff8109b9e0>] ? __wake_up_sync+0x20/0x20
> [ 1201.063072]  [<ffffffff81293d20>] ? commit_timeout+0x10/0x10
> [ 1201.068855]  [<ffffffff81078829>] kthread+0xc9/0xe0
> [ 1201.073819]  [<ffffffff81078760>] ? flush_kthread_worker+0xb0/0xb0
> [ 1201.080084]  [<ffffffff8169bb6c>] ret_from_fork+0x7c/0xb0
> [ 1201.085573]  [<ffffffff81078760>] ? flush_kthread_worker+0xb0/0xb0

Ohh. that's properly broken indeed.

You can't just call blocking primitives on the way to schedule(), that's
fail.

Also, if I look at blk_flush_plug_list(), it calls queue_unplugged()
with IRQs disabled, so _who_ is enabling them again and calling blocking
stuff?

/me stares more..

rbd_request_fn() does.. *argh*

Someone needs to go fix, this cannot work right.

--Tptko/SaOMWhbcZu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2lUyAAoJEHZH4aRLwOS6+5UQAKd4XEacT8jkhpuFxHKXpQCh
89IuWTvBX7cGcAWPK1AngeBgzvtKEPAgFxLHS08hIi1J/32tR1Dq7c71Zb9wkdss
VkAAWHJjUqN52aGnbQrpGDll1ixYYgeAQxsW207Ps6mmQxVRzBPLIcze/aZFNshe
B/AiV1zCCw2ZSSmP78nUbIojvzej1WcuNkxB3gYobY0CLctdc7B4Zpq8oe/EyLFd
51jgVvucqDNo4Zx64JXPhGGhXnb2HL7O+G9tmFfae4hokpBKyOqn5MAtaIQ7RUtU
EzhDf+rFTIx6uLun4FXKDHqO+Lf7f9YggnPwYy34lpgGi3IxbTGKdE1dtX3Uv0eX
ox1+BMM+Z6acIh6iZAIhNLml/xcnCdJFBx9bJTN9mYKkrqYYWkuyQZAL9cBM68k0
neJF0BzITmPia96Kbz7UHsGiE5A3MchfDMOtgiWxiCR+j4I3iibIzIsfTl3BcMSd
m6Fx33KQFBKi2otQ7aBSWOmOs6FVP0iHDSqTsV/tGzwYot6CVUlZ+vxFXqvh4I2r
ncqCvdu40UBVBrpB7iZSzqxJJr18n3oRbPu3wS+gqi9INjKMfaRs/ixRLgm0dYLF
wmqJ50I91+xMMfxLvcEnKtiUjMMK+NUNqG8L9JUCq4IYrecoX2IFFg1WQCmtgOCV
4kRT9y7erXVQKODfkVJN
=OMW9
-----END PGP SIGNATURE-----

--Tptko/SaOMWhbcZu--
