Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3H2AtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:49:07 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54128 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab3H2AtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:49:03 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: linux-kernel@vger.kernel.org
Subject: Weirdness with EFI boot and partition tables...
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1377737341_1815P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Aug 2013 20:49:01 -0400
Message-ID: <75805.1377737341@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1377737341_1815P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <75773.1377737331.1@turing-police.cc.vt.edu>

So I'm trying to debug a problem with my Dell Latitude booting in EFI
mode, that looks like a "can't find the initrd", when I stumbled across this:

<4>[    2.831325] VFS: Cannot open root device "mapper/turing--police-froot" or unknown-block(0,0): error -6
<4>[    2.831329] Please append a correct "root=" boot option; here are the available partitions:

<4>[    2.831338] 0800       488386584 sda  driver: sd
<4>[    2.831344]   0801          305368 sda1 5288e82d-f5e3-4f57-a7f9-e29f87149240
<4>[    2.831348]   0802         3150112 sda2 42eb87e8-1e6a-477e-8b66-2255ac98b27d
<4>[    2.831351]   0803          512000 sda3 6c7a5919-61bc-498e-b26a-9c2aa27e65d1
<4>[    2.831355]   0805       293795840 sda5 52e421a3-78df-48ac-877f-9362b50af20f
<4>[    2.831358]   0806         4100096 sda6 ebaf21a2-a1aa-4685-8788-e962b6aad18c
<4>[    2.831364] 0b00         1048575 sr0  driver: sr

Note the entry for sda6.  Boot a Fedora kernel, and:

# fdisk -l /dev/sda
WARNING: fdisk GPT support is currently new, and therefore in an experimental phase. Use at your own discretion.

Disk /dev/sda: 500.1 GB, 500107862016 bytes, 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: gpt


#         Start          End    Size  Type            Name
 1        16072       626807  298.2M  Linux filesyste Linux filesystem
 2       626808      6927031      3G  Microsoft basic Microsoft basic data
 3      6928384      7952383    500M  Linux filesyste Linux filesystem
 5      7954432    595546111  280.2G  Linux LVM       Linux LVM
 6    595546112    976773134  181.8G  Linux LVM       Linux LVM


Any ideas why the size discrepancy?

(No, this probably not relevant to my original issue - my root is on the
LVM on sda5, which is OK, and the problem is the initrd doesn't fire up at all)


--==_Exmh_1377737341_1815P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUh6afQdmEQWDXROgAQJfKhAAqV5HvRo0aPWs/VBAqy/0chkzrNUidQKE
vR9Pastv0tkQsMFt/IxxZgx2QVP8bq4e/oGXBkzq2xbli4WPaHMNtO+ECh6YaH2X
zNEuJBpdw+dKTr0ljVzwcu9msTflXl1aZzY0LjmDFQ+E+I1vS6Kdivp1BIlk789q
nkFbSsmDNsjgsqzE776DjVY2jwCmSWgsU5/CYhe6ecnMoSx3v56NJWUilN5ul1aL
YGWsd8IyMlHymwZ4Nx2GbohkzkSSN/Q7cr3KaVOGDDC4yJ+/rNyCYr29xaDt6B0t
7TRI2EyZjSXC+IOSIemx3PhT/Xt/n2HgguFVRwXjIpjGwdM4ee5SYZ/dQsYyyPa7
qCMxiKfgtkptueHQ6AinF8oP08kOw3hYhbxGl/GAVck1Aj5UFrD7CFiMLuhns7/y
TIYm9vSY+ipKUkRjH55EHF79epIfAo7gXkjOwtfvzEN9PkG9rmu1qiMltukWy3OY
Mom9vYT+7szxzHnRKafJjBKHSODV1Rk1gIm4XIRJcgcVc4pbaxRrVA/kNqGoqFD6
M6Dg0/W1GDsTiEfXaKKlanLAvqPNlMUAXaIOGvtyD2gzXmgwa/g4jOtGtcY+nkT0
FJr5aGFd8cyqFdNhviozg5TneBYzuzOWz479q74Ao4OGX1vHcC7wGr9sJKQom8cV
j/1xXHJ+hV4=
=VAht
-----END PGP SIGNATURE-----

--==_Exmh_1377737341_1815P--
