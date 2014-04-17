Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaDQEOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 00:14:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaDQEOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 00:14:04 -0400
Date: Thu, 17 Apr 2014 14:13:55 +1000
From: NeilBrown <neilb@suse.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [raid5] kernel BUG at drivers/md/raid5.c:4374!
Message-ID: <20140417141355.355e2f3e@notabene.brown>
In-Reply-To: <20140417035958.GE8702@localhost>
References: <20140417035958.GE8702@localhost>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3_tRFgz0Hh2R2m.b2q4bMD7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3_tRFgz0Hh2R2m.b2q4bMD7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Apr 2014 11:59:59 +0800 Fengguang Wu <fengguang.wu@intel.com>
wrote:

> Shaohua,
>=20
> We noticed the below BUG on
>=20
> commit e240c1839d11152b0355442f8ac6d2d2d921be36 ("raid5: get_active_strip=
e avoids device_lock")
>=20
> test case: lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-10dd

Thanks.  We know about this.  I really should push that patch out....
Sorry

NeilBrown



>=20
> 27c0f68f0745218  e240c1839d11152b0355442f8 =20
> ---------------  ------------------------- =20
>          0           +Inf%          1 ~ 0%  TOTAL dmesg.kernel_BUG_at_dri=
vers/md/raid5.c
>          0           +Inf%          1 ~ 0%  TOTAL dmesg.invalid_opcode
>          0           +Inf%          1 ~ 0%  TOTAL dmesg.RIP:handle_active=
_stripes
>          0           +Inf%          1 ~ 0%  TOTAL dmesg.Kernel_panic-not_=
syncing:Fatal_exception
>=20
> Legend:
> 	~XX%    - stddev percent
> 	[+-]XX% - change percent
>=20
> [  264.260444] kernel BUG at drivers/md/raid5.c:4374!
> [  264.267590] invalid opcode: 0000 [#1] SMP
> [  264.272076] Modules linked in: btrfs microcode ipmi_si ipmi_msghandler=
 acpi_cpufreq processor
> [  264.281514] CPU: 0 PID: 4005 Comm: md0_raid5 Not tainted 3.15.0-rc1-00=
611-g2e76799 #1
> [  264.289823] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/20=
10
> [  264.296789] task: ffff8804151e41a0 ti: ffff88041672c000 task.ti: ffff8=
8041672c000
> [  264.304750] RIP: 0010:[<ffffffff81804ef1>]  [<ffffffff81804ef1>] handl=
e_active_stripes.isra.24+0x254/0x360
> [  264.314951] RSP: 0018:ffff88041672dd10  EFLAGS: 00010002
> [  264.320527] RAX: ffff88021dc46000 RBX: ffff880220a4e000 RCX: ffff88022=
0a4e080
> [  264.327926] RDX: 0000000000000001 RSI: ffff88021e0d7010 RDI: ffff88022=
0a4e000
> [  264.335325] RBP: ffff88041672dda8 R08: 0000000000000000 R09: 000000000=
0000000
> [  264.342724] R10: 0000000000000000 R11: 000000000000ef58 R12: 000000000=
0000000
> [  264.350131] R13: ffff880220a4e080 R14: 0000000000000000 R15: ffff88022=
0a4e268
> [  264.357530] FS:  0000000000000000(0000) GS:ffff880237c00000(0000) knlG=
S:0000000000000000
> [  264.366099] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  264.372111] CR2: 0000000001e21d64 CR3: 000000000200f000 CR4: 000000000=
00007f0
> [  264.379509] Stack:
> [  264.381780]  ffff8804173d7de0 ffff880220a4e000 ffff88041672dd38 ffffff=
ffffffffd8
> [  264.389907]  ffffffff1e1bd000 ffff880220a4e090 ffffffff817fdba2 ffff88=
0220a4e000
> [  264.398043]  0000000000000021 ffff880220a4e268 0000000000000000 ffff88=
041672dd78
> [  264.406172] Call Trace:
> [  264.408893]  [<ffffffff817fdba2>] ? do_release_stripe+0xdf/0x158
> [  264.415168]  [<ffffffff817fdc30>] ? __release_stripe+0x15/0x17
> [  264.421266]  [<ffffffff818054f2>] raid5d+0x3e2/0x4f2
> [  264.426497]  [<ffffffff819bcacf>] ? schedule_timeout+0x2f/0x19f
> [  264.432681]  [<ffffffff81826151>] md_thread+0x123/0x139
> [  264.438171]  [<ffffffff811148b6>] ? __wake_up_sync+0x12/0x12
> [  264.444096]  [<ffffffff8182602e>] ? md_register_thread+0xd5/0xd5
> [  264.450368]  [<ffffffff810fa267>] kthread+0xdb/0xe3
> [  264.455511]  [<ffffffff810fa18c>] ? kthread_create_on_node+0x16f/0x16f
> [  264.462310]  [<ffffffff819c7d7c>] ret_from_fork+0x7c/0xb0
> [  264.467973]  [<ffffffff810fa18c>] ? kthread_create_on_node+0x16f/0x16f
> [  264.474764] Code: 60 00 00 00 00 48 8b 70 10 48 8b 48 18 48 8d 50 10 4=
8 89 4e 08 48 89 31 48 89 50 10 48 89 50 18 f0 ff 40 50 8b 50 50
> ff ca 74 02 <0f> 0b 4a 89 44 d5 98 49 ff c2 49 83 fa 08 0f 85 d7 fd ff ff=
 41
> [  264.498252] RIP  [<ffffffff81804ef1>] handle_active_stripes.isra.24+0x=
254/0x360
> [  264.506112]  RSP <ffff88041672dd10>
> [  264.509869] ---[ end trace 58f3875ff7b4e923 ]---
>=20
> Thanks,
> Fengguang


--Sig_/3_tRFgz0Hh2R2m.b2q4bMD7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU09VAznsnt1WYoG5AQLVdw/9G0uSXmqcp0kzRXLXlWHNIDgILkvQ97Ko
wyNZmmeq2csBwQYdZ1cQRsLNA+TLwQ1iew/+eloq8pOGrRTczPjrt2RPi2fN5cNL
JkEXcyR769JRQoUW1F4yG7H1rw3paagQpIDAwQkbT+u3mEtBSTEvjBrMlsT43i8u
C4MMv6ls6WRakWsNRLyoB2UM/7QkFuBxGzZyjxHGCZ7V19ZQCt9CdBmiEEzhlWhi
3qc/DLJLr4pDJ+budKVjDfBZ5DvRvM1oj5vq5SRUbRmskbglu4ZPWum+t2UfjztY
lKFk2qKMotkZsobriQaMgMHWYcJc5SVs2n72CvAlH4yxk//JzNUragvDZptTqgbn
V9CtFHMxCqkOimxHKuvdczKehimzC+PqfoXCEsoiLoKUfoL3rAcmocbfntxjNQb5
4U1m3tUspeOy/3Lj8lXIgzm8u/pb5G7o+mSOhrYhBFQYzHt9owxJpB4s0NO4gTNE
NKTwZF8kYtBzTfUXMv2PvgcnOb0OljoM0bOAjYpJgHSXOUY7Rk4fom/4BEHMEl4X
5ov+NgPeB0CGsBBi+/TeCk2EhSm27xyoSJRw8oh1zMQyFRgB24BqR40qJFSBO5Y/
U3E7QmFofS5dn4rHLhNlPZIclzKyzw21VXwHlY4bGLSR3oUdrhMT2Ha9TX7Xo+bL
/Eq/x9UTOKM=
=Vywh
-----END PGP SIGNATURE-----

--Sig_/3_tRFgz0Hh2R2m.b2q4bMD7--
