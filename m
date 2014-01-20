Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaATDiC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 22:38:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaATDiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 22:38:00 -0500
Date: Mon, 20 Jan 2014 14:37:48 +1100
From: NeilBrown <neilb@suse.de>
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [BUG] at drivers/md/raid5.c:291! kernel 3.13-rc8
Message-ID: <20140120143748.33bb52d2@notabene.brown>
In-Reply-To: <1390178957.587.9.camel@localhost>
References: <1390168823.587.1.camel@localhost>
	<20140120113851.3b476ed8@notabene.brown>
	<1390178957.587.9.camel@localhost>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZhClVz428QU56nMghgi5waT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZhClVz428QU56nMghgi5waT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jan 2014 01:49:17 +0100 Ian Kumlien <ian.kumlien@gmail.com> wrot=
e:

> On m=C3=A5n, 2014-01-20 at 11:38 +1100, NeilBrown wrote:
> > On Sun, 19 Jan 2014 23:00:23 +0100 Ian Kumlien <ian.kumlien@gmail.com> =
wrote:
> >=20
> > > Ok, so third try to actually email this...=20
> > > ---
> > >=20
> > > Hi,
> > >=20
> > > I started testing 3.13-rc8 on another machine since the first one see=
med
> > > to be working fine...
> > >=20
> > > One spontaneous reboot later i'm not so sure ;)
> > >=20
> > > Right now i captured a kernel oops in the raid code it seems...
> > >=20
> > > (Also attached to avoid mangling)
> > >=20
> > > [33411.934672] ------------[ cut here ]------------
> > > [33411.934685] kernel BUG at drivers/md/raid5.c:291!
> > > [33411.934690] invalid opcode: 0000 [#1] PREEMPT SMP=20
> > > [33411.934696] Modules linked in: bonding btrfs microcode
> > > [33411.934705] CPU: 4 PID: 2319 Comm: md2_raid6 Not tainted 3.13.0-rc=
8 #83
> > > [33411.934709] Hardware name: System manufacturer System Product Name=
/Crosshair IV Formula, BIOS 3029    10/09/2012
> > > [33411.934716] task: ffff880326265880 ti: ffff880320472000 task.ti: f=
fff880320472000
> > > [33411.934720] RIP: 0010:[<ffffffff81a3a5be>]  [<ffffffff81a3a5be>] d=
o_release_stripe+0x18e/0x1a0
> > > [33411.934731] RSP: 0018:ffff880320473d28  EFLAGS: 00010087
> > > [33411.934735] RAX: ffff8802f0875a60 RBX: 0000000000000001 RCX: ffff8=
800b0d816b0
> > > [33411.934739] RDX: ffff880324eeee98 RSI: ffff8802f0875a40 RDI: ffff8=
80324eeec00
> > > [33411.934743] RBP: ffff8802f0875a50 R08: 0000000000000000 R09: 00000=
00000000001
> > > [33411.934747] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8=
80324eeec00
> > > [33411.934752] R13: ffff880324eeee58 R14: ffff880320473e88 R15: 00000=
00000000000
> > > [33411.934756] FS:  00007fc38654d700(0000) GS:ffff880337d00000(0000) =
knlGS:0000000000000000
> > > [33411.934761] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > [33411.934765] CR2: 00007f0cb28bd000 CR3: 00000002ebcf6000 CR4: 00000=
000000407e0
> > > [33411.934769] Stack:
> > > [33411.934771]  ffff8800bba09690 ffff8800b4f16588 ffff880303005a40 00=
00000000000001
> > > [33411.934779]  ffff8800b33e43d0 ffffffff81a3a62d ffff880324eeee58 00=
00000000000000
> > > [33411.934786]  ffff880324eeee58 ffff880326660670 ffff880326265880 ff=
ffffff81a41692
> > > [33411.934794] Call Trace:
> > > [33411.934798]  [<ffffffff81a3a62d>] ? release_stripe_list+0x4d/0x70
> > > [33411.934803]  [<ffffffff81a41692>] ? raid5d+0xa2/0x4d0
> > > [33411.934808]  [<ffffffff81a65ed6>] ? md_thread+0xe6/0x120
> > > [33411.934814]  [<ffffffff81122060>] ? finish_wait+0x90/0x90
> > > [33411.934818]  [<ffffffff81a65df0>] ? md_rdev_init+0x100/0x100
> > > [33411.934823]  [<ffffffff8110958c>] ? kthread+0xbc/0xe0
> > > [33411.934828]  [<ffffffff81110000>] ? smpboot_park_threads+0x70/0x70=
Hi,
> >=20
> > Thanks for the report.
> > Can you provide any more context about the details of the array in ques=
tion?
> > I see it was RAID6.  Was it degraded?  Was it resyncing?  Was it being
> > reshaped?
> > Was there any way that it was different from the array one the machine =
where
> > it seemed to work?
>=20
> Yes, it's a raid6 and no, there is no reshaping or syncing going on...=20
>=20
> Basically everything worked fine before:
> reboot   system boot  3.13.0-rc8       Sun Jan 19 21:47 - 01:42  (03:55) =
  =20
> reboot   system boot  3.13.0-rc8       Sun Jan 19 21:38 - 01:42  (04:04) =
  =20
> reboot   system boot  3.13.0-rc8       Sun Jan 19 12:13 - 01:42  (13:29) =
  =20
> reboot   system boot  3.13.0-rc8       Sat Jan 18 21:23 - 01:42 (1+04:19)=
  =20
> reboot   system boot  3.12.6           Mon Dec 30 16:27 - 22:21 (19+05:53=
) =20
>=20
> As in, no problems before the 3.13.0-rc8 upgrade...
>=20
> cat /proc/mdstat:
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]=
 [multipath]=20
> md2 : active raid6 sdf1[2] sdd1[9] sdj1[8] sdg1[4] sde1[5] sdi1[11] sdc1[=
0] sdh1[10]
>       11721074304 blocks super 1.2 level 6, 64k chunk, algorithm 2 [8/8] =
[UUUUUUUU]
>       bitmap: 0/15 pages [0KB], 65536KB chunk
>=20
> What i do do is:
> echo 32768 > /sys/block/*/md/stripe_cache_size
>=20
> Which has caused no problems during intense write operations before...=20
>=20
> I find it quite surprising since it only requires ~3 gigabytes of writes
> to die and almost assume that it's related to the stripe_cache_size.
> (Since all memory is ECC and i doubt it would break, quite literally,
> over night i haven't run extensive memory tests)
>=20
> I don't quite know what other information you might need...

Thanks - that extra info is quite useful.  Knowing that nothing else unusual
is happening can be quite valuable (and I don't like to assume).

I haven't found anything that would clearly cause your crash, but I have
found something that looks wrong and conceivably could.

Could you please try this patch on top of what you are currently using?  By
the look of it you get a crash at least every day, often more often.  So if
this produces a day with no crashes, that would be promising.

The important aspect of the patch is that it moves the "atomic_inc" of
"sh->count" back under the protection of ->device_lock in the case when some
other thread might be using the same 'sh'.

Thanks,
NeilBrown


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3088d3af5a89..03f82ab87d9e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -675,8 +675,10 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 					 || !conf->inactive_blocked),
 					*(conf->hash_locks + hash));
 				conf->inactive_blocked =3D 0;
-			} else
+			} else {
 				init_stripe(sh, sector, previous);
+				atomic_inc(&sh->count);
+			}
 		} else {
 			spin_lock(&conf->device_lock);
 			if (atomic_read(&sh->count)) {
@@ -695,13 +697,11 @@ get_active_stripe(struct r5conf *conf, sector_t secto=
r,
 					sh->group =3D NULL;
 				}
 			}
+			atomic_inc(&sh->count);
 			spin_unlock(&conf->device_lock);
 		}
 	} while (sh =3D=3D NULL);
=20
-	if (sh)
-		atomic_inc(&sh->count);
-
 	spin_unlock_irq(conf->hash_locks + hash);
 	return sh;
 }

--Sig_/ZhClVz428QU56nMghgi5waT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtyaDDnsnt1WYoG5AQL1Yw//b5quLX17XplJjJotOzNOBn3IJSwQdomR
WJCRnnMGoWjv2z8i3oF58SC4gbG23px7vc4131icP8GqMjc76/dp9crcWMirgXjy
3rm54A5Q9HMNcdUqfrcTWqTFbGlrMV0iCyR+drVdZmioJRf2ovD8rk5C4yzyDjPr
I82R7J4Pbit8I2ArIgTdoCnQglgY9Z8NNxHkTqGbuMAgJCZoq3fHF8hCwJhH+XHs
ZXEoVDqJQlsfYXs1N0KJFbXHTjGRaD8C1wfTd1ZJGbBXJ5H4lSA6bJgZf7Gchuk2
2MmF9NNjIG1rdhLLQD1n7eJobVHMH8GIkXte+PJEN48qxiJkFUozXpDNG6ZA/2nS
xFDizQNRdCJ1YlIKo6dvM/2NzZDfg5Jh6Pxwak/2cTupPFjYC5uAA5ZCj9XjOjDO
wxSBWrwb1Wx8B4YOD7wOp4hYdz7OlD6yRtvfpaNNGLS1dSz1B+dgmDheBHWadngQ
k5EJVCxGMzG0k2pfmz35KbedVPS0K01Z5yFgUhjBgzQkZmzb4spu4OHT60qR3FX4
l71Kw+xifwTjpnswNDK6HG5L1XZB8K25SJT2Z2VHcaJ5dLd8z3D+Rd3nx1BV4oFN
soYIZsOuQWD293E8j8PT+hpRz2knAUCO1UTR76k0wl5yunhI86/3nnGMAIS5sNTT
f1m5dgs96WA=
=dkdX
-----END PGP SIGNATURE-----

--Sig_/ZhClVz428QU56nMghgi5waT--
