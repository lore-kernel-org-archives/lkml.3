Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbaJ1V64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:58:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaJ1V6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:58:53 -0400
Date: Wed, 29 Oct 2014 08:58:44 +1100
From: NeilBrown <neilb@suse.de>
To: Ronny Egner <ronnyegner@ronnyegner-consulting.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Andrea Mazzoleni" <amadvance@gmail.com>
Subject: Re: What happened with the Patch "New RAID library supporting up to
 six parities"
Message-ID: <20141029085844.31789cb8@notabene.brown>
In-Reply-To: <D06C14D9.4018A%ronnyegner@ronnyegner-consulting.de>
References: <D06BCADE.40140%ronnyegner@ronnyegner-consulting.de>
	<20141021182725.016ec0e1@notabene.brown>
	<D06C14D9.4018A%ronnyegner@ronnyegner-consulting.de>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/T6Zqf60KuV59HLtMTvvLeqY"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/T6Zqf60KuV59HLtMTvvLeqY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Oct 2014 13:16:52 +0000 Ronny Egner
<ronnyegner@ronnyegner-consulting.de> wrote:

> Hi Neil,
>=20
>=20
> i did a short test and it works so far. Here are my results. Let me know
> if you need something more:
>=20
> (TL;DR: Wonderful patch. Tested with PAR6 (=3D six parities) and was able=
 to
> recover from losing five disks at once.)

Thanks for doing this - it does sound like they are useful.

As you note, the patches only include support for btrfs, not for md/raid.

I can carry the lib/raid stuff as I am nominally responsible for that, but I
cannot send it upstream until there is a user ready to use it.  If the btrfs
team can be convinced to include the functionality: good.  If not, there is
nothing I can do to help.

There would be a non-trivial amount of effort to integrate this support into
md/raid.  I am not free to do that at present but if someone else wants to =
put
in the time and effort, I can certainly provide guidance and review.

(and please don't send emails about md/raid to me personally.  Always inclu=
de
the list at least in 'cc').

Thanks,
NeilBrown


>=20
>=20
>=20
> The patches apply against 3.14.22 and btrfs-progs 3.12 but not against the
> recent 3.18-rc1 and btrfs-progs > 3.12.
>=20
>=20
> 	root@ubuntu-1204-build:~# btrfs --version
> 	Btrfs v3.12-dirty
> =09
> 	root@ubuntu-1204-build:~# uname -a
> 	Linux ubuntu-1204-build 3.14.22 #3 SMP Tue Oct 21 13:00:08 CEST 2014
> x86_64 x86_64 x86_64 GNU/Linux
>=20
>=20
> For the tests i used a VM with 4 GB memory, two cores and 15 disks with
> 150 GB each. Every disk looked like this:
>=20
> 	root@ubuntu-1204-build:~# fdisk /dev/sdi
>=20
> 	Command (m for help): p
>=20
> 	Disk /dev/sdi: 157.3 GB, 157286400000 bytes
> 	81 heads, 30 sectors/track, 126419 cylinders, total 307200000 sectors
> 	Units =3D sectors of 1 * 512 =3D 512 bytes
> 	Sector size (logical/physical): 512 bytes / 512 bytes
> 	I/O size (minimum/optimal): 512 bytes / 512 bytes
> 	Disk identifier: 0x5b5d7269
>=20
> 	Device Boot      Start         End      Blocks   Id  System
> 	/dev/sdi1            2048   307199999   153598976   83  Linux
>=20
>=20
> File system created:
>=20
> 	root@ubuntu-1204-build:~# mkfs.btrfs -dpar6 -L testpar6 /dev/sdh1
> /dev/sdi1 /dev/sdj1 /dev/sdk1 \
> 		                  /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1
> /dev/sdq1 /dev/sdr1 \
> 				  /dev/sds1 /dev/sdt1 /dev/sdu1 /dev/sdv1
>=20
>=20
> 	Turning ON incompat feature 'extref': increased hardlink limit per file
> to 65536
> 	Turning ON incompat feature 'par3456': raid support with up to six
> parities
> 	adding device /dev/sdi1 id 2
> 	adding device /dev/sdj1 id 3
> 	adding device /dev/sdk1 id 4
> 	adding device /dev/sdl1 id 5
> 	adding device /dev/sdm1 id 6
> 	adding device /dev/sdn1 id 7
> 	adding device /dev/sdo1 id 8
> 	adding device /dev/sdp1 id 9
> 	adding device /dev/sdq1 id 10
> 	adding device /dev/sdr1 id 11
> 	adding device /dev/sds1 id 12
> 	adding device /dev/sdt1 id 13
> 	adding device /dev/sdu1 id 14
> 	adding device /dev/sdv1 id 15
> 	fs created label testpar6 on /dev/sdh1
> 	nodesize 16384 leafsize 16384 sectorsize 4096 size 2.15TiB
> 	Btrfs v3.12-dirty
>=20
>=20
> Mount:
>=20
>=20
> 	root@ubuntu-1204-build:~# mount /dev/sdh1 /mnt
>=20
> Stats:
> =09
> 	root@ubuntu-1204-build:~# df -h
> 	Filesystem                 Size  Used Avail Use% Mounted on
> 	/dev/mapper/vgroot-lvroot   26G   17G  8.4G  67% /
> 	none                       4.0K     0  4.0K   0% /sys/fs/cgroup
> 	udev                       1.6G  4.0K  1.6G   1% /dev
> 	tmpfs                      331M  1.1M  330M   1% /run
> 	none                       5.0M     0  5.0M   0% /run/lock
> 	none                       1.7G     0  1.7G   0% /run/shm
> 	none                       100M     0  100M   0% /run/user
> 	/dev/sdh1                  2.2T  2.8M  2.2T   1% /mnt
>=20
>=20
> 	Data, single: total=3D8.00MiB, used=3D0.00
> 	Data, PAR6: total=3D9.00GiB, used=3D995.16MiB
> 	System, RAID1: total=3D8.00MiB, used=3D16.00KiB
> 	System, single: total=3D4.00MiB, used=3D0.00
> 	Metadata, RAID1: total=3D1.00GiB, used=3D65.59MiB
> 	Metadata, single: total=3D8.00MiB, used=3D0.00
>=20
> 	root@ubuntu-1204-build:/mnt# btrfs fi show
> 	Label: testpar6  uuid: 79d3c5e4-74ce-4464-a509-ef666dcd9073
> 	Total devices 15 FS bytes used 1.04GiB
> 	devid    1 size 146.48GiB used 1.02GiB path /dev/sdh1
> 	devid    2 size 146.48GiB used 1.00GiB path /dev/sdi1
> 	devid    3 size 146.48GiB used 1.00GiB path /dev/sdj1
> 	devid    4 size 146.48GiB used 1.00GiB path /dev/sdk1
> 	devid    5 size 146.48GiB used 1.00GiB path /dev/sdl1
> 	devid    6 size 146.48GiB used 1.00GiB path /dev/sdm1
> 	devid    7 size 146.48GiB used 1.00GiB path /dev/sdn1
> 	devid    8 size 146.48GiB used 1.00GiB path /dev/sdo1
> 	devid    9 size 146.48GiB used 1.00GiB path /dev/sdp1
> 	devid    10 size 146.48GiB used 1.00GiB path /dev/sdq1
> 	devid    11 size 146.48GiB used 1.00GiB path /dev/sdr1
> 	devid    12 size 146.48GiB used 2.00GiB path /dev/sds1
> 	devid    13 size 146.48GiB used 2.00GiB path /dev/sdt1
> 	devid    14 size 146.48GiB used 1.01GiB path /dev/sdu1
> 	devid    15 size 146.48GiB used 1.01GiB path /dev/sdv1
>=20
>=20
> Metadata and data still =E2=80=9Asingle=E2=80=98? Bug? Nevermind - lets c=
onvert it:
>=20
> 	root@ubuntu-1204-build:/mnt# btrfs balance start -mconvert=3Draid1 /mnt
> 	Done, had to relocate 4 out of 6 chunks
>=20
> 	root@ubuntu-1204-build:/mnt# btrfs fi df /mnt
> 	Data, single: total=3D8.00MiB, used=3D0.00
> 	Data, PAR6: total=3D9.00GiB, used=3D1.02GiB
> 	System, RAID1: total=3D32.00MiB, used=3D16.00KiB
> 	Metadata, RAID1: total=3D1.00GiB, used=3D67.83MiB
> =09
> 	root@ubuntu-1204-build:/mnt# btrfs balance start -dconvert=3Dpar6 /mnt
> 	Done, had to relocate 2 out of 4 chunks
>=20
> 	root@ubuntu-1204-build:/mnt# btrfs fi df /mnt
> 	Data, PAR6: total=3D9.00GiB, used=3D1.02GiB
> 	System, RAID1: total=3D32.00MiB, used=3D16.00KiB
> 	Metadata, RAID1: total=3D1.00GiB, used=3D68.72MiB
>=20
>=20
>=20
> OK now lets see what happens if we remove on device. Save a MD5SUM before:
>=20
>=20
> 	root@ubuntu-1204-build:/mnt# md5sum linux-3.14.22.tar
> 	80af37cdfb2fa2239f79597c914a8c73  linux-3.14.22.tar
>=20
>=20
> (Removed one disk and replace it with a brand new, empty one)
>=20
>=20
>=20
>=20
> 	root@ubuntu-1204-build:~# mount /dev/sdh1 /mnt
> 	mount: wrong fs type, bad option, bad superblock on /dev/sdh1,
> 	missing codepage or helper program, or other error
> 	In some cases useful info is found in syslog - try
> 	dmesg | tail  or so
>=20
> 	root@ubuntu-1204-build:~# mount /dev/sdh1 /mnt -o degraded
> 	root@ubuntu-1204-build:~#
>=20
> 	root@ubuntu-1204-build:~# btrfs fi show
> 	Label: testpar6  uuid: 79d3c5e4-74ce-4464-a509-ef666dcd9073
> 	Total devices 15 FS bytes used 31.42GiB
> 	devid    1 size 146.48GiB used 4.00GiB path /dev/sdh1
> 	devid    2 size 146.48GiB used 5.00GiB path /dev/sdi1
> 	devid    3 size 146.48GiB used 4.00GiB path /dev/sdj1
> 	devid    4 size 146.48GiB used 4.00GiB path /dev/sdk1
> 	devid    5 size 146.48GiB used 4.00GiB path /dev/sdl1
> 	devid    6 size 146.48GiB used 5.00GiB path /dev/sdm1
> 	devid    7 size 146.48GiB used 4.03GiB path /dev/sdn1
> 	devid    8 size 146.48GiB used 4.00GiB path /dev/sdo1
> 	devid    9 size 146.48GiB used 4.00GiB path /dev/sdp1
> 	devid    10 size 146.48GiB used 4.00GiB path /dev/sdq1
> 	devid    11 size 146.48GiB used 4.00GiB path /dev/sdr1
> 	devid    12 size 146.48GiB used 4.03GiB path /dev/sds1
> 	devid    13 size 146.48GiB used 4.00GiB path /dev/sdt1
> 	devid    14 size 146.48GiB used 4.00GiB path /dev/sdu1
> 	devid    15 size 146.48GiB used 4.00GiB path
>=20
>=20
> Lets replace the faulty disk:
>=20
> 	root@ubuntu-1204-build:~# btrfs device add /dev/sdv1 /mnt
> 	root@ubuntu-1204-build:~# btrfs device delete missing /mnt
>=20
> 	In /var/log/syslog:
>=20
> 	[  191.442050] BTRFS warning (device sdk1): devid 15 missing
> 	[  581.367659]  sdv: sdv1
> 	[  598.009968] BTRFS: device label testpar6 devid 16 transid 63 /dev/sdv1
> 	[  614.679654] BTRFS info (device sdk1): relocating block group
> 40865103872 flags 4097
> 	[  657.889822] BTRFS info (device sdk1): found 64 extents
> 	[  659.190497] BTRFS info (device sdk1): found 64 extents
> 	[  659.247765] BTRFS info (device sdk1): relocating block group
> 31201427456 flags 4097
> 	[  861.359599] BTRFS info (device sdk1): found 132 extents
> 	[  862.875521] BTRFS info (device sdk1): found 132 extents
> 	[  862.973499] BTRFS info (device sdk1): relocating block group
> 11874074624 flags 4097
>=20
>=20
>=20
> After the =E2=80=9Adelete missing=E2=80=98
>=20
> 	Label: testpar6  uuid: 79d3c5e4-74ce-4464-a509-ef666dcd9073
> 	Total devices 15 FS bytes used 31.42GiB
> 	devid    1 size 146.48GiB used 4.00GiB path /dev/sdh1
> 	. . .
> 	devid    14 size 146.48GiB used 4.00GiB path /dev/sdu1
> 	devid    16 size 146.48GiB used 4.00GiB path /dev/sdv1
>=20
>=20
> The md5 checksum is still correct:
>=20
> 	root@ubuntu-1204-build:/mnt# md5sum linux-3.14.22.tar
> 	80af37cdfb2fa2239f79597c914a8c73  linux-3.14.22.tar
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> Hardcore test: PAR6 =3D 6 parities. Let=C2=B4s see what happens if i remo=
ve five
> disks and replace with with empty ones.
>=20
> Before i did that the metadata format was converted to PAR6 as well:
>=20
> =09
> 	root@ubuntu-1204-build:~# btrfs fi df /mnt/
> 	Data, PAR6: total=3D36.00GiB, used=3D31.32GiB
> 	System, PAR6: total=3D144.00MiB, used=3D16.00KiB
> 	Metadata, PAR6: total=3D1.12GiB, used=3D101.81MiB
>=20
>=20
>=20
>=20
> 	root@ubuntu-1204-build:~# mount /dev/sdn1 /mnt/ -o degraded
> =09
>=20
> 	root@ubuntu-1204-build:~# btrfs fi show
> 	Label: testpar6  uuid: 79d3c5e4-74ce-4464-a509-ef666dcd9073
> 	Total devices 15 FS bytes used 31.42GiB
> 	devid    1 size 146.48GiB used 4.00GiB path
> 	devid    2 size 146.48GiB used 5.00GiB path
> 	devid    3 size 146.48GiB used 4.00GiB path
> 	devid    4 size 146.48GiB used 4.00GiB path
> 	devid    5 size 146.48GiB used 4.00GiB path
> 	devid    6 size 146.48GiB used 5.00GiB path /dev/sdm1
> 	devid    7 size 146.48GiB used 4.03GiB path /dev/sdn1
> 	devid    8 size 146.48GiB used 4.00GiB path /dev/sdo1
> 	devid    9 size 146.48GiB used 4.00GiB path /dev/sdp1
> 	devid    10 size 146.48GiB used 4.00GiB path /dev/sdq1
> 	devid    11 size 146.48GiB used 4.00GiB path /dev/sdr1
> 	devid    12 size 146.48GiB used 4.03GiB path /dev/sds1
> 	devid    13 size 146.48GiB used 4.00GiB path /dev/sdt1
> 	devid    14 size 146.48GiB used 4.00GiB path /dev/sdu1
> 	devid    16 size 146.48GiB used 4.00GiB path /dev/sdv1
>=20
>=20
> Now let=C2=B4s bring it back in shape and add five new, empty disks:
>=20
> 	btrfs device add /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /mnt
> 	btrfs delete missing
> 	<<wait>>
> 	root@ubuntu-1204-build:~# btrfs fi show
> 	Label: testpar6  uuid: 79d3c5e4-74ce-4464-a509-ef666dcd9073
> 	Total devices 15 FS bytes used 1.09GiB
> 	devid    6 size 146.48GiB used 2.14GiB path /dev/sdm1
> 	devid    7 size 146.48GiB used 2.14GiB path /dev/sdn1
> 	devid    8 size 146.48GiB used 2.14GiB path /dev/sdo1
> 	devid    9 size 146.48GiB used 2.14GiB path /dev/sdp1
> 	devid    10 size 146.48GiB used 2.14GiB path /dev/sdq1
> 	devid    11 size 146.48GiB used 2.14GiB path /dev/sdr1
> 	devid    12 size 146.48GiB used 2.14GiB path /dev/sds1
> 	devid    13 size 146.48GiB used 2.14GiB path /dev/sdt1
> 	devid    14 size 146.48GiB used 2.14GiB path /dev/sdu1
> 	devid    16 size 146.48GiB used 2.14GiB path /dev/sdv1
> 	devid    17 size 146.48GiB used 2.14GiB path /dev/sdh1
> 	devid    18 size 146.48GiB used 2.14GiB path /dev/sdi1
> 	devid    19 size 146.48GiB used 2.14GiB path /dev/sdj1
> 	devid    20 size 146.48GiB used 2.14GiB path /dev/sdk1
> 	devid    21 size 146.48GiB used 2.14GiB path /dev/sdl1
>=20
>=20
>=20
>=20
>=20
> And now the checksum:
>=20
> 	root@ubuntu-1204-build:/mnt# md5sum linux-3.14.22.tar
> 	80af37cdfb2fa2239f79597c914a8c73  linux-3.14.22.tar
>=20
> Checksum matches!=20
>=20
> So.. this looks *very* good to me.
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> Mit freundlichen Gr=C3=BC=C3=9Fen
> Ronny Egner
> --
> Ronny Egner
> Oracle Certified Master 11g (OCM)
> =20
> Mobile:   +49 170 8139903
> EMail:      ronnyegner@ronnyegner-consulting.de
> <mailto:roonnyegner@ronnyegner-consulting.de>
>=20
>=20
>=20
>=20
> Am 21.10.14 09:27 schrieb "NeilBrown" unter <neilb@suse.de>:
>=20
> >On Tue, 21 Oct 2014 06:33:47 +0000 Ronny Egner
> ><ronnyegner@ronnyegner-consulting.de> wrote:
> >
> >> Dear All,
> >>=20
> >> i was wondering what happened with the patch posted by Andrea Mazzoleni
> >> back in Februrary 2014 (this Thread:
> >> http://thread.gmane.org/gmane.linux.kernel/1654735).
> >>=20
> >> Why wash=C2=B4t it added to the code? Something missing/wrong?
> >>=20
> >> In my opinion the posted patch is awesome and would enable a unique
> >> feature that no other UNIX-like operating system currently has.
> >>=20
> >
> >Could you report your test results please.
> >
> >NeilBrown
>=20


--Sig_/T6Zqf60KuV59HLtMTvvLeqY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFARlDnsnt1WYoG5AQIwRRAAmf8WGZeL2oNUYiQAb+REzGwfMAJHLmX4
rxFKeayRU4xLyf87d8J5Cp3h4Xhc9ApUHe4uReKtf4qPE/S2leDjNkZXBjwDmha2
wbS0+2+mOTACbSTJjNUrjI2hlui61Md3jAvw3RwU/XZB/Eqznu/aAL87gbCGHAa0
DeLu5sBeQNRO93tr1gvQLhQMqqMTJ9NhGDjmAVABlGGMzneiGRvIv46O7x8lIZCu
qZtdb0s5818x6Xp/vRJkS+iqoQWc2YCPLGUK/dWaNaFyof6XP68AnUh8Nk5L8P7S
eJQyjXWdjcjOxe2xA5EDr4rYRYU3EYn/WMOyAeOtSU5leTC1/SuPkl/O/1fa7df3
isoSUy3RonnIBKhIpqw7fv7dUU1FfVC1ZvZcStCaTxW63tqvrYNzAv4H2IsrSkvG
0mR/bJpI5lnVvUT4xASveW71mo8k7OznzEw0zwJJfrmffx3soYoOQ/Cmzi7FVNdv
CoopNp7U853Aa19r/sbiG2E8GyXVkIpSB3inm9766eNiPFcvsQyCwMdXNjNQSeAO
3SmfPv7hrIq0xxsKdlC+oeKqrllx5okYCshmvgLcAf8Te2mMzk6M8xO9MMtolvKL
XiK/zJORtSEPbyWFwAlUhELE2H0qJRMUlIGYAVR1L3UsXUHla+0OAWLde5/e5VN+
xvDCXZgmOIQ=
=pOZD
-----END PGP SIGNATURE-----

--Sig_/T6Zqf60KuV59HLtMTvvLeqY--
