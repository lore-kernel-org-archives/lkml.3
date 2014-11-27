Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaK0Ufs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:35:48 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51694 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751172AbaK0Ufp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:35:45 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Missing MODALIAS in /sys/devices/system/cpu/uevent
Date: Thu, 27 Nov 2014 21:56:56 +0100
Message-ID: <1892529.CzZLJuFW6x@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <201411272124.30618@pali>
References: <201411272101.11811@pali> <1716071.jpYXuFBQgb@vostro.rjw.lan> <201411272124.30618@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart18669315.WKceiaOVtA"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart18669315.WKceiaOVtA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Thursday, November 27, 2014 09:24:30 PM Pali Roh=C3=A1r wrote:
> On Thursday 27 November 2014 21:39:42 Rafael J. Wysocki wrote:
> > On Thursday, November 27, 2014 09:01:11 PM Pali Roh=C3=A1r wrote:
> > > --nextPart2712852.Yg3XtZvm05
> > > Content-Type: Text/Plain;
> > >=20
> > >   charset=3D"utf-8"
> > >=20
> > > Content-Transfer-Encoding: quoted-printable
> > >=20
> > > Hello,
> > >=20
> > > on 3.18-rc5 I have empty cpu uevent file, but modalias file
> > > is=3D20 populated. See:
> > >=20
> > > $ cat /sys/devices/system/cpu/uevent=3D20
> > > $ cat /sys/devices/system/cpu/modalias=3D20
> > > cpu:type:x86,ven0000fam0006mod003C:feature:,0000,0001,0002,0
> > > 003,0004,0005,0=3D
> > > 006,0007,0008,0009,000B,000C,000D,000E,000F,0010,0011,0013,
> > > 0015,0016,0017,0=3D
> > > 018,0019,001A,001B,001C,001D,001F,002B,0034,003A,003B,003D,
> > > 0068,006B,006C,0=3D
> > > 06D,006F,0070,0072,0074,0075,0076,0078,007C,007D,0080,0081,
> > > 0082,0083,0084,0=3D
> > > 085,0086,0087,0088,0089,008B,008C,008D,008E,008F,0091,0093,
> > > 0094,0095,0096,0=3D
> > > 097,0098,0099,009A,009B,009C,009D,009E,00C0,00C5,00E0,00E1,
> > > 00E3,00E5,00E6,0=3D
> > > 0E7,0100,0101,0102,0103,0104,0120,0121,0123,0124,0125,0127,
> > > 0128,0129,012A,0=3D 12B,012D,0140
> > >=20
> > > =3D46or all other devices in /sys/devices/ which have
> > > modalias=3D20 content there is also MODALIAS=3D3D line in
> > > uevent file.
> >=20
> > /sys/devices/system/cpu/ is not a device.  It is a "collection
> > of all CPUs".
> >=20
>=20
> Ok. But why that inconsistency (missing MODALIAS line)?
>=20
> > > Is cpu device special? Or why it is only one device which
> > > has=3D20 modalias file but is missing MODALIAS=3D3D line in
> > > uevent file?
> >=20
> > Look into the uevent files under /sys/devices/system/cpu/cpu0/
> > etc.
> >=20
>=20
> $ cat /sys/devices/system/cpu/cpu0/modalias
> cat: /sys/devices/system/cpu/cpu0/modalias: No such file or=20
> directory
> $ cat /sys/devices/system/cpu/cpu0/uevent=20
> DRIVER=3Dprocessor
> MODALIAS=3Dcpu:type:x86,ven0000fam0006mod003C:feature:,0000,0001,0002=
,0003,0004,0005,0006,0007,0008,0009,000B,000C,000D,000E,000F,0010,0011,=
0013,0015,0016,0017,0018,0019,001A,001B,001C,001D,001F,002B,0034,003A,0=
03B,003D,0068,006B,006C,006D,006F,0070,0072,0074,0075,0076,0078,007C,00=
7D,0080,0081,0082,0083,0084,0085,0086,0087,0088,0089,008B,008C,008D,008=
E,008F,0091,0093,0094,0095,0096,0097,0098,0099,009A,009B,009C,009D,009E=
,00C0,00C5,00E0,00E1,00E3,00E5,00E6,00E7,0100,0101,0102,0103,0104,0120,=
0121,0123,0124,0125,0127,0128,0129,012A,012B,012D,0140
>=20
> So there is no modalias file, but uevent contains MODALIAS line.
>=20
> > > What userspace application should use for reading
> > > modalias=3D20 string? File modalias or file uevent?
> >=20
> > The cpu modalias is used to trigger loading of some
> > CPU-specific modules upfront IIRC.  So yes, it is special.
> >=20
> > My advice would be to follow udev here.
>=20
> Yes, I know. For some reasons coretemp.ko is not automatically=20
> loaded. I do not know why and I started investigating it. And I=20
> found above inconsistency in modalias and uevent...
>=20
> $ modinfo coretemp
> ...
> alias:          cpu:type:x86,ven0000fam*mod*:feature:*00E7*

That may be a udev issue.  See

http://lists.freedesktop.org/archives/systemd-devel/2013-July/012165.ht=
ml

=2D-=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart18669315.WKceiaOVtA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJUd5AdAAoJEILEb/54YlRxufMP/0JyaKQ85sCUUYMa72OS56ay
+gXgOxWuKQxxykie9Bumf3oJC7dynBbWo9VnstIZxXFWb3/uvdLj5cGAG53rnPPA
legCqqPsf6GahA00qkV+eeXbtHJZR3Tn4wNlyPS+yZSlVWQnuUaP0TGalkIA9Zx6
SdoDNAhghjHRu15kCTIZQYv/xJbm4PH5mEF0novTNxrBG7rWmDLm4k6ddn9xj7u4
aw0VfSnmu5JYGJ8JpqfdExTyyxK6AsO61sRusC0oR56hPkwNkOqlTjzpt5fykQEs
0jGfx5rGfk8ZOjdvGYxcZdelj8i+os+L0kc6ZGaNOBuvIzTRS5T2Pc7GhttQgh/N
gF101ipNnbWwU1Kp8bFOyiB68qWjqOdEYSw/H1X+cMkrMs2f3EXBc296KBGsyiM6
mmIBvukFozmt2gvPLqZcGbJIlZTB5Sf7gvWQutNo7BT6w049RfR5RhB9l6tyz4lT
8VH2VyNgWpxbdMYPsplMv6f7JDcVzOlA+DHWUyUTZ2CiHTYsER5E5p5/cmCJstCi
4CBoxXLrX+XbbKK3e/MNIW/tROtkZDPaNYDrNrOxEEIjVNifXoTa3VpyDof5h/yg
H9gWvT6TiRRPbeXA0HJdkxu5JNGkYBHkvcxH3622oNH0C+dP+qELuaieKXerW1t7
wO6HmbbYqZeGw8OI5V9d
=3MLy
-----END PGP SIGNATURE-----

--nextPart18669315.WKceiaOVtA--

