Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3G2F5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:57:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab3G2F5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:57:08 -0400
Date: Mon, 29 Jul 2013 15:56:55 +1000
From: NeilBrown <neilb@suse.de>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
Subject: Re: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x
 SSD)
Message-ID: <20130729155655.38572fed@notabene.brown>
In-Reply-To: <001e01ce89e6$73f93b80$5bebb280$@lucidpixels.com>
References: <000501ce85fc$d3a60a10$7af21e30$@lucidpixels.com>
	<20130722090257.2faa0874@notabene.brown>
	<009801ce898c$34b83fc0$9e28bf40$@lucidpixels.com>
	<20130726103549.1e6b0b92@notabene.brown>
	<001e01ce89e6$73f93b80$5bebb280$@lucidpixels.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+vNN0dWy8kXzo7pzO5Vn8zX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+vNN0dWy8kXzo7pzO5Vn8zX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Jul 2013 05:56:51 -0400 "Justin Piszcz" <jpiszcz@lucidpixels.com>
wrote:

>=20
>=20
> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]=20
> Sent: Thursday, July 25, 2013 8:36 PM
> To: Justin Piszcz
> Cc: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org
> Subject: Re: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x
> SSD)
>=20
> On Thu, 25 Jul 2013 19:10:50 -0400 "Justin Piszcz" <jpiszcz@lucidpixels.c=
om>
> wrote:
>=20
> > Did the fix by chance make it into 3.10.3?
>=20
> No, it looks like it missed again.  I gather there was a large inflow of
> patches for -stable in the 3.11-rc1 merge window and Greg has been
> processing
> them in batches.  Hopefully in 3.10.4.
>=20
> The relevant patch is commit 30bc9b53878a9921b02e3 in mainline.
>=20
> NeilBrown
>=20
> --
>=20
> Method to get patch via git and patch kernel:
>=20
> $ git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> $ git log |grep 30bc9b53878a9921b02e3
> commit 30bc9b53878a9921b02e3b5bc4283ac1c6de102a
> $ git show 30bc9b53878a9921b02e3b5bc4283ac1c6de102a > /tmp/a
> # patch -p1 < /tmp/a
> patching file drivers/md/raid1.c
> Hunk #1 succeeded at 1848 (offset -1 lines).
> Hunk #2 succeeded at 1886 (offset -1 lines).
> Hunk #3 succeeded at 1915 (offset -1 lines).
>=20
> Reboot- tested, success, thanks..!
>=20
> One follow-up question:
> $ cat /sys/block/md1/md/mismatch_cnt
> 314112
> -> On a live RAID-1 (root filesystem) without swap, is it normal to have
> such a high mismatch_cnt even after a repair?
>=20
> First repair:
> Fri Jul 26 05:30:47 EDT 2013: The meta-device /dev/md1 has mismatch_cnt
> 314112 sectors.
> Second repair:
> Fri Jul 26 05:30:47 EDT 2013: The meta-device /dev/md1 has mismatch_cnt
> 313600 sectors.

Those two lines have exactly the same timestamp and  array name but differe=
nt
mismatch counts.  That is very strange.

Did you run two consecutive 'repair's on the one array, both with the patch=
ed
kernel?  If so and the second mismatch_cnt wasn't zero (or close to
it..maybe) then something is definitely wrong.

NeilBrown


>=20
> Should I be concerned?
>=20
>=20
> Testing the patch:
>=20
> Personalities : [raid1]
> md1 : active raid1 sdc2[0] sdb2[1]
>       233381376 blocks [2/2] [UU]
>       [>....................]  check =3D  0.3% (838976/233381376)
> finish=3D9.2min speed=3D419488K/sec
>=20
> md0 : active raid1 sdc1[0] sdb1[1]
>       1048512 blocks [2/2] [UU]
>=20
> Personalities : [raid1]
> md1 : active raid1 sdc2[0] sdb2[1]
>       233381376 blocks [2/2] [UU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.....]  check =3D 77=
.5% (180889856/233381376)
> finish=3D2.5min speed=3D342654K/sec
>=20
> md0 : active raid1 sdc1[0] sdb1[1]
>       1048512 blocks [2/2] [UU]
>=20
> Personalities : [raid1]
> md1 : active raid1 sdc2[0] sdb2[1]
>       233381376 blocks [2/2] [UU]
>=20
> md0 : active raid1 sdc1[0] sdb1[1]
>       1048512 blocks [2/2] [UU]
>=20
>=20
> Justin.
>=20


--Sig_/+vNN0dWy8kXzo7pzO5Vn8zX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfYEKDnsnt1WYoG5AQLN2xAApE2JFdBRjs4r+Udi4Cf+4LDVwbN+7y/q
9ijonMktuAgkcf9ybruHP6yG2aRueVajZWwZ3YzzDQZP3XLI3pfntc7rwe0k9am0
EGairvnHyxkCsOnOcmdaQl4nnjidoH4OSMIYkYsHjoVsGiC/+jT4E9xRAaZPWUnH
L7uU3jfZP32LtAodHaL+0OyQRxlIX1yl2lGy+j1wIwGaoyJabdX0lStHaiEK8eO0
Kx/biLXPKq8S4ztm3XKtf0OCviKwhLWHjIjmYLiVZ5GnYWkAF13L+LJRpWoI2p9Z
7xHdb6QzyELBCDKPm02Ed9MEqGblh6l4FM70P/FsMkUzWaSS1nBASNRy9B8X9bt2
XWAevy/lcT4pPz16g9L9twYn5QUIJdl1JDllpTXo/XNEvtdGs3rpX58r/Ba9/5JA
DLmIctSMfjNJo38FlJKDSpCq23/IFn4/zKtVopO3nNhAxMUGibgoGSot9ruChzIv
sSANmD7KAZH2xIIex0t0ZJs9GkozhEBq899ICrsT1/MZ2ifFzhmMQg3oKhJJq3QS
gWh7+efkzCULW+fMvlrNBQik/3vlsS6KNjOL9s66ZsC/P8kNaCTrQy97tv560Z1m
+g5Jw3NLUSffOUDyylB0hJDWkeTk5X16WH6bgGxO1NBE2CnjVxr3vn+ZYnEB7ZdP
Pzf+6psqQnE=
=cIcR
-----END PGP SIGNATURE-----

--Sig_/+vNN0dWy8kXzo7pzO5Vn8zX--
