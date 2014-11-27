Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaK0Und (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:43:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37362 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaK0Unc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:43:32 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Missing MODALIAS in /sys/devices/system/cpu/uevent
Date: Thu, 27 Nov 2014 21:43:28 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201411272101.11811@pali> <9796230.2QoPTQHj6x@vostro.rjw.lan> <2091767.N6CqySqsKt@vostro.rjw.lan>
In-Reply-To: <2091767.N6CqySqsKt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8290514.DDUW7fxBWE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411272143.28926@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8290514.DDUW7fxBWE
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 27 November 2014 22:00:32 Rafael J. Wysocki wrote:
> On Thursday, November 27, 2014 09:59:03 PM Rafael J. Wysocki=20
wrote:
> > On Thursday, November 27, 2014 09:56:56 PM Rafael J. Wysocki=20
wrote:
> > > On Thursday, November 27, 2014 09:24:30 PM Pali Roh=C3=A1r=20
wrote:
> > > > On Thursday 27 November 2014 21:39:42 Rafael J. Wysocki=20
wrote:
> > > > > On Thursday, November 27, 2014 09:01:11 PM Pali Roh=C3=A1r=20
wrote:
> > > > > > --nextPart2712852.Yg3XtZvm05
> > > > > > Content-Type: Text/Plain;
> > > > > >=20
> > > > > >   charset=3D"utf-8"
> > > > > >=20
> > > > > > Content-Transfer-Encoding: quoted-printable
> > > > > >=20
> > > > > > Hello,
> > > > > >=20
> > > > > > on 3.18-rc5 I have empty cpu uevent file, but
> > > > > > modalias file is=3D20 populated. See:
> > > > > >=20
> > > > > > $ cat /sys/devices/system/cpu/uevent=3D20
> > > > > > $ cat /sys/devices/system/cpu/modalias=3D20
> > > > > > cpu:type:x86,ven0000fam0006mod003C:feature:,0000,000
> > > > > > 1,0002,0 003,0004,0005,0=3D
> > > > > > 006,0007,0008,0009,000B,000C,000D,000E,000F,0010,001
> > > > > > 1,0013, 0015,0016,0017,0=3D
> > > > > > 018,0019,001A,001B,001C,001D,001F,002B,0034,003A,003
> > > > > > B,003D, 0068,006B,006C,0=3D
> > > > > > 06D,006F,0070,0072,0074,0075,0076,0078,007C,007D,008
> > > > > > 0,0081, 0082,0083,0084,0=3D
> > > > > > 085,0086,0087,0088,0089,008B,008C,008D,008E,008F,009
> > > > > > 1,0093, 0094,0095,0096,0=3D
> > > > > > 097,0098,0099,009A,009B,009C,009D,009E,00C0,00C5,00E
> > > > > > 0,00E1, 00E3,00E5,00E6,0=3D
> > > > > > 0E7,0100,0101,0102,0103,0104,0120,0121,0123,0124,012
> > > > > > 5,0127, 0128,0129,012A,0=3D 12B,012D,0140
> > > > > >=20
> > > > > > =3D46or all other devices in /sys/devices/ which have
> > > > > > modalias=3D20 content there is also MODALIAS=3D3D line
> > > > > > in uevent file.
> > > > >=20
> > > > > /sys/devices/system/cpu/ is not a device.  It is a
> > > > > "collection of all CPUs".
> > > >=20
> > > > Ok. But why that inconsistency (missing MODALIAS line)?
> > > >=20
> > > > > > Is cpu device special? Or why it is only one device
> > > > > > which has=3D20 modalias file but is missing
> > > > > > MODALIAS=3D3D line in uevent file?
> > > > >=20
> > > > > Look into the uevent files under
> > > > > /sys/devices/system/cpu/cpu0/ etc.
> > > >=20
> > > > $ cat /sys/devices/system/cpu/cpu0/modalias
> > > > cat: /sys/devices/system/cpu/cpu0/modalias: No such file
> > > > or directory
> > > > $ cat /sys/devices/system/cpu/cpu0/uevent
> > > > DRIVER=3Dprocessor
> > > > MODALIAS=3Dcpu:type:x86,ven0000fam0006mod003C:feature:,000
> > > > 0,0001,0002,0003,0004,0005,0006,0007,0008,0009,000B,000C
> > > > ,000D,000E,000F,0010,0011,0013,0015,0016,0017,0018,0019,
> > > > 001A,001B,001C,001D,001F,002B,0034,003A,003B,003D,0068,0
> > > > 06B,006C,006D,006F,0070,0072,0074,0075,0076,0078,007C,00
> > > > 7D,0080,0081,0082,0083,0084,0085,0086,0087,0088,0089,008
> > > > B,008C,008D,008E,008F,0091,0093,0094,0095,0096,0097,0098
> > > > ,0099,009A,009B,009C,009D,009E,00C0,00C5,00E0,00E1,00E3,
> > > > 00E5,00E6,00E7,0100,0101,0102,0103,0104,0120,0121,0123,0
> > > > 124,0125,0127,0128,0129,012A,012B,012D,0140
> > > >=20
> > > > So there is no modalias file, but uevent contains
> > > > MODALIAS line.
> > > >=20
> > > > > > What userspace application should use for reading
> > > > > > modalias=3D20 string? File modalias or file uevent?
> > > > >=20
> > > > > The cpu modalias is used to trigger loading of some
> > > > > CPU-specific modules upfront IIRC.  So yes, it is
> > > > > special.
> > > > >=20
> > > > > My advice would be to follow udev here.
> > > >=20
> > > > Yes, I know. For some reasons coretemp.ko is not
> > > > automatically loaded. I do not know why and I started
> > > > investigating it. And I found above inconsistency in
> > > > modalias and uevent...
> > > >=20
> > > > $ modinfo coretemp
> > > > ...
> > > > alias:        =20
> > > > cpu:type:x86,ven0000fam*mod*:feature:*00E7*
> > >=20
> > > That may be a udev issue.  See
> > >=20
> > > http://lists.freedesktop.org/archives/systemd-devel/2013-J
> > > uly/012165.html
> >=20
> > And it was fixed in udev quite some time ago.
>=20
> By this commit:
>=20
> http://cgit.freedesktop.org/systemd/systemd/commit/?id=3Dbf7f800
> f2b3e93ccd1229d4717166f3a4d3af72f

Thanks for info! I checked system udev files (Ubuntu 12.04 LTS)=20
and this patch is not applied.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart8290514.DDUW7fxBWE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR3jPAACgkQi/DJPQPkQ1I8pQCfSInMCPthlllAqTbNkXQKR/Td
6TMAoIJ3fP3+3IigooPMrL/jaGuk4CQp
=yAKV
-----END PGP SIGNATURE-----

--nextPart8290514.DDUW7fxBWE--
