Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaATAjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 19:39:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaATAjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 19:39:03 -0500
Date: Mon, 20 Jan 2014 11:38:51 +1100
From: NeilBrown <neilb@suse.de>
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [BUG] at drivers/md/raid5.c:291! kernel 3.13-rc8
Message-ID: <20140120113851.3b476ed8@notabene.brown>
In-Reply-To: <1390168823.587.1.camel@localhost>
References: <1390168823.587.1.camel@localhost>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.MqQGSndzZP7BPcIjzqeU8T"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.MqQGSndzZP7BPcIjzqeU8T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Jan 2014 23:00:23 +0100 Ian Kumlien <ian.kumlien@gmail.com> wrot=
e:

> Ok, so third try to actually email this...=20
> ---
>=20
> Hi,
>=20
> I started testing 3.13-rc8 on another machine since the first one seemed
> to be working fine...
>=20
> One spontaneous reboot later i'm not so sure ;)
>=20
> Right now i captured a kernel oops in the raid code it seems...
>=20
> (Also attached to avoid mangling)
>=20
> [33411.934672] ------------[ cut here ]------------
> [33411.934685] kernel BUG at drivers/md/raid5.c:291!
> [33411.934690] invalid opcode: 0000 [#1] PREEMPT SMP=20
> [33411.934696] Modules linked in: bonding btrfs microcode
> [33411.934705] CPU: 4 PID: 2319 Comm: md2_raid6 Not tainted 3.13.0-rc8 #83
> [33411.934709] Hardware name: System manufacturer System Product Name/Cro=
sshair IV Formula, BIOS 3029    10/09/2012
> [33411.934716] task: ffff880326265880 ti: ffff880320472000 task.ti: ffff8=
80320472000
> [33411.934720] RIP: 0010:[<ffffffff81a3a5be>]  [<ffffffff81a3a5be>] do_re=
lease_stripe+0x18e/0x1a0
> [33411.934731] RSP: 0018:ffff880320473d28  EFLAGS: 00010087
> [33411.934735] RAX: ffff8802f0875a60 RBX: 0000000000000001 RCX: ffff8800b=
0d816b0
> [33411.934739] RDX: ffff880324eeee98 RSI: ffff8802f0875a40 RDI: ffff88032=
4eeec00
> [33411.934743] RBP: ffff8802f0875a50 R08: 0000000000000000 R09: 000000000=
0000001
> [33411.934747] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88032=
4eeec00
> [33411.934752] R13: ffff880324eeee58 R14: ffff880320473e88 R15: 000000000=
0000000
> [33411.934756] FS:  00007fc38654d700(0000) GS:ffff880337d00000(0000) knlG=
S:0000000000000000
> [33411.934761] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [33411.934765] CR2: 00007f0cb28bd000 CR3: 00000002ebcf6000 CR4: 000000000=
00407e0
> [33411.934769] Stack:
> [33411.934771]  ffff8800bba09690 ffff8800b4f16588 ffff880303005a40 000000=
0000000001
> [33411.934779]  ffff8800b33e43d0 ffffffff81a3a62d ffff880324eeee58 000000=
0000000000
> [33411.934786]  ffff880324eeee58 ffff880326660670 ffff880326265880 ffffff=
ff81a41692
> [33411.934794] Call Trace:
> [33411.934798]  [<ffffffff81a3a62d>] ? release_stripe_list+0x4d/0x70
> [33411.934803]  [<ffffffff81a41692>] ? raid5d+0xa2/0x4d0
> [33411.934808]  [<ffffffff81a65ed6>] ? md_thread+0xe6/0x120
> [33411.934814]  [<ffffffff81122060>] ? finish_wait+0x90/0x90
> [33411.934818]  [<ffffffff81a65df0>] ? md_rdev_init+0x100/0x100
> [33411.934823]  [<ffffffff8110958c>] ? kthread+0xbc/0xe0
> [33411.934828]  [<ffffffff81110000>] ? smpboot_park_threads+0x70/0x70Hi,

Thanks for the report.
Can you provide any more context about the details of the array in question?
I see it was RAID6.  Was it degraded?  Was it resyncing?  Was it being
reshaped?
Was there any way that it was different from the array one the machine where
it seemed to work?

Thanks,
NeilBrown

--Sig_/.MqQGSndzZP7BPcIjzqeU8T
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtxwGznsnt1WYoG5AQIOihAAwTSVGpQFBR83TjbIDqpmU7SYwixQTV1a
izsMKMfK2UrvAXvRIqFZrMonRSMFUlAnJ/6KaE7iFdW3P5gZ2t45TXhD/T3YPKSV
MxqKXLl9gqcXHB/zBUs9E5VzZ4Q8wSvD6To1rkYhWsr3XkiaF1sIZjnUnIXpXe+Z
EfV07u7z7uJcrtKXH1zB7pVrv5FqIhN7tPOvPAhIpNlGf41/2bc08wF71+8qlGEK
Tg8xavpaN3DIuPiq2U0dDLksFtFVE8R+6CENE5C4kC1g9+BzHQZ96tR0w95oiywS
7X02RVpbZz53GK0WhUoZGEWKn9w7o0a/aE2iSl130VNHZ5OrDJOVO1jQAZzFZzz0
G9Z5vHZc23pGL2pyM6SKdij3ELCg4Yr4lgmhGjixiDcOCK2Kt1sVEa1wQ0UdaFgV
iY3AJ72E4GoHIDwb53mgj3Gufyg4Ox1M1U+6CZvFuZCMSsSMfG5S+dMBvuNtLiOp
/cdeQaw0v0dT6Hxa0FEBS9xFaT3XP86ZyInkEDJvOkVopTiLDYX+TjKscN6oh99f
70a5r7bK6GH9OQNzjobuYzvSQJizBiZai91RBaKyl/rhZwr19dPIlf1mNEs1/6/+
op+KxHnc9woa9ec2Eh9G+72wWrdiQ/Nc+/Cp+7Q13moYm5Ddrnwd+Z7VaM+LBy+O
U8aZ58FE0mI=
=MOHH
-----END PGP SIGNATURE-----

--Sig_/.MqQGSndzZP7BPcIjzqeU8T--
