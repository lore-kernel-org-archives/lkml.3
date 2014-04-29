Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094AbaD2UQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 16:16:48 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36946 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910AbaD2UQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 16:16:46 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: bug: acpi ata_bay dock reminds undocked
Date: Tue, 29 Apr 2014 22:16:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc3-generic; KDE/4.12.3; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2836586.KoBJUF4ueo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201404292216.41256@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2836586.KoBJUF4ueo
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I have problem with sysfs entry docked

/sys/bus/platform/devices/dock.0/docked

for my media bay DVD drive on notebook Dell Latitude E6440.

After booting linux kernel docked is set to 1 (which is correct,=20
DVD hw is inserted into sata dock). When I undock it via sysfs=20
entry

/sys/bus/platform/devices/dock.0/undock

then kernel remove DVD device from system (no /dev/sr0 anymore)=20
and docked sysfs entry is set to 0.

When I press eject button on DVD drive, I hear some spin up and=20
kernel detect DVD device again (also udev create /dev/sr0). But=20
docked sysfs entry remains set to 0. It will never be set back to=20
1 - only after reboot.

So this looks like bug somewhere and probably in linux acpi dock=20
driver... Do you know to solve this problem? More applications=20
checking docked sysfs entry for dock presence and returning 0=20
will mislead them.

Here is some info from sysfs about dock:

$ grep "" /sys/bus/platform/devices/dock.0/*
/sys/bus/platform/devices/dock.0/docked:0
/sys/bus/platform/devices/dock.0/flags:32
/sys/bus/platform/devices/dock.0/modalias:acpi:LNXIOBAY:
/sys/bus/platform/devices/dock.0/type:ata_bay
/sys/bus/platform/devices/dock.0/uevent:MODALIAS=3Dacpi:LNXIOBAY:

If you need some more info let me know. I would be happy to have=20
working docked sysfs entry.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2836586.KoBJUF4ueo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlNgCKkACgkQi/DJPQPkQ1ITegCfdBVqg3M+onjtWXinn27oU1SN
/kcAn2lLsPdGgUaBje+kEDIoSKeZobQs
=WHKs
-----END PGP SIGNATURE-----

--nextPart2836586.KoBJUF4ueo--
