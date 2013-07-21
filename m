Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3GUXDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 19:03:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab3GUXDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 19:03:11 -0400
Date: Mon, 22 Jul 2013 09:02:57 +1000
From: NeilBrown <neilb@suse.de>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
Subject: Re: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x
 SSD)
Message-ID: <20130722090257.2faa0874@notabene.brown>
In-Reply-To: <000501ce85fc$d3a60a10$7af21e30$@lucidpixels.com>
References: <000501ce85fc$d3a60a10$7af21e30$@lucidpixels.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DM87ExlRuyVsnCG9y2_4yty"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DM87ExlRuyVsnCG9y2_4yty
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 21 Jul 2013 06:26:55 -0400 "Justin Piszcz" <jpiszcz@lucidpixels.com>
wrote:

> Hi,
>=20
> When I run repair on an MD-RAID1 sync_action, the speed slows down and it
> stays like this (below) for hours. =20
>=20
> The system is then completely unresponsive to user input.  I have replace=
d a
> failing SSD; however, after a check, mismatch_cnt seems to increase over
> time.  When I run repair, the system freezes to user-input.  Has anyone e=
lse
> run into this issue with a RAID-1 volume (2 x SSD) using 0.90 metadata?
> Long ago I used to use this same configuration with two physical disks and
> there was never a problem.
>=20
> Even though I left a root shell open, this has no effect to break the
> resync:
> # echo idle > /sys/devices/virtual/block/md1/md/sync_action
>=20
> Every 1.0s: cat /proc/mdstat                            Sun Jul 21 06:15:=
38
> 2013
>=20
> Personalities : [raid1]
> md1 : active raid1 sdc2[0] sdb2[1]
>       233381376 blocks [2/2] [UU]
>       [>....................]  resync =3D  0.0% (151616/233381376)
> finish=3D36171.5min speed=3D107K/sec
>=20
> md0 : active raid1 sdc1[0] sdb1[1]
>       1048512 blocks [2/2] [UU]
>=20
> unused devices: <none>
>=20
> 10 minutes later:
>=20
>       233381376 blocks [2/2] [UU]
>       [>....................]  resync =3D  0.0% (151616/233381376)
> finish=3D52219.3min speed=3D74K/sec
>=20
> Where it hangs (151616) or elsewhere, has been different each time I watc=
hed
> it, it does not appear to be hanging at the same block each time.
>=20

Hi Justin,
 this is a known bug.  Fix has been accepted into mainline for 3.11-rc2.
 Hopefully it will get into 3.10.3 (too late for 3.10.2).

NeilBrown

--Sig_/DM87ExlRuyVsnCG9y2_4yty
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUexooTnsnt1WYoG5AQJFEBAAkWIzG9qZJcywg24DkFpBdoJKNnGZzPlH
IjJg0SB3fCLyPkFVppcd+lThKPekBmHm+yyOIvFHsgPp3scLPzbsX7Od7AkJgh9F
ztL4Zp4WTPsCDStIE2tThy5qKj4fMB1Lp4zTN/T66CLOReECQ5YdsDehiqh3QY+S
ottZ6mtuRll8p7QRTvZkJ3GCSVOJjBPeuE07u2ySEPYiljU2ZJN4UvskzdQ2qGXA
i8STSEoLdxHcsGFt3UkZ5QRbbn6qKMXmq9sYVlVxWJ9N+FubHP/CN22w2QxrXcI+
piV0TSp9Qxb2SNIvRjaCZ6NcL/pGS1NT8RbHzf52lNQ6nPSzBBNy6UlvuZ1AkuD/
abGmUAtlefVBUyLn2zuhnfGm/T0P6iHxU+1QzztyPjdmKv7is+gSI+D0hcawG3EE
JB0GnT91PYf0C+tCpnApjmcjzazr9Pi2SaG+GZJdYpDB3PcY3tNXaMpCWDr8o4fL
LsagFdCPwFo8cqmybm92Ouu/cPwYKOKFhHB4i3Zskrzri27c9hOlCvaT+rXQgL5x
M9QE+LiAyP7FodCvnZn3ICQtlVwOMGbSH9vbXKdsu/zLDxF7DhOVmZAtITSechDA
Ljd+/hcFWKdix/JTfTXnQ8HFcf2+q+rBr5thqn14RzJOe0/AAAt+cwGHKb8nrbzf
uEQ3Uc85rac=
=OxEw
-----END PGP SIGNATURE-----

--Sig_/DM87ExlRuyVsnCG9y2_4yty--
