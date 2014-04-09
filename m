Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbaDISUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:20:41 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54059 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaDISUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:20:39 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: pstore wierdness on Dell Latitude E6530.
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1397067600_1588P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Apr 2014 14:20:00 -0400
Message-ID: <9443.1397067600@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1397067600_1588P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

For some reason, /sys/fs/pstore has 537 files in it, all called 'console-=
efi',
all having inode number 8021, and all consisting of the same one line:

=5B/sys/fs/pstore=5D cat console-efi=20
=5B    1.567734=5D pci 0000:00:1c.1: PCI bridge to =5Bbus 03=5D
=5B/sys/fs/pstore=5D ls =7C uniq -c
    537 console-efi
=5B/sys/fs/pstore=5D cat console-efi=20
=5B    1.567734=5D pci 0000:00:1c.1: PCI bridge to =5Bbus 03=5D
=5B/sys/fs/pstore=5D grep . * =7C uniq -c
    537 console-efi:=5B    1.567734=5D pci 0000:00:1c.1: PCI bridge to =
=5Bbus 03=5D
=5B/sys/fs/pstore=5D ls -li =7C head
total 0
8021 -r--r--r--. 1 root root 56 Aug 13  2013 console-efi
8021 -r--r--r--. 1 root root 56 Aug 13  2013 console-efi
8021 -r--r--r--. 1 root root 56 Aug 13  2013 console-efi
8021 -r--r--r--. 1 root root 56 Aug 13  2013 console-efi
8021 -r--r--r--. 1 root root 56 Aug 13  2013 console-efi
8021 -r--r--r--. 1 root root 56 Aug 13  2013 console-efi
8021 -r--r--r--. 1 root root 56 Aug 13  2013 console-efi
8021 -r--r--r--. 1 root root 56 Aug 13  2013 console-efi
8021 -r--r--r--. 1 root root 56 Aug 13  2013 console-efi

I can remove one, and then it gets even more weird:

=5B/sys/fs/pstore=5D1 rm console-efi=20
=5B/sys/fs/pstore=5D1 ls =7C wc
    536     536    6432

Goodie - one less. Let's try again. 'rm c<tab>' completes to console-efi

=5B/sys/fs/pstore=5D1 rm console-efi=20
rm: cannot remove 'console-efi': No such file or directory
=5B/sys/fs/pstore=5D ls =7C wc
    536     536    6432

=5B/sys/fs/pstore=5D1 ls -li console-efi=20
ls: cannot access console-efi: No such file or directory

=5B/sys/fs/pstore=5D ls -li 2>&1 =7C uniq -c
    536 ls: cannot access console-efi: No such file or directory
      1 total 0
    536 ? -????????? ? ? ? ?            ? console-efi

Any ideas?




--==_Exmh_1397067600_1588P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU0WPUAdmEQWDXROgAQK8Hw/+Ne6DQDQVQmOsXkQN9lm2Inin/OnIOo11
EcKqIOTZ5AIOBzgoxGE3wDN9kx7ZeAf97guWbMeFZ9/uyLvWJXpuQw8M8GudjP7i
yplo5D1Iyx27HN78IInaz0Zi292lN1sC+xZcHHM6/sZEeFzp7JEe729etNdLZNms
MgXMM9lce3Cl1p8x2W3b3v+BUARw7pPxuAUyYRInO7Ul/vWbhleVXgS4Apqf3JgC
IIDsj/snxUsBdewalYUkk/5lIMSQh0b7N6A/JF05cCMSjYloMa3mu/X5Y8oqGlNu
FmcxyoYFQK+pkUN/o5DXlGRKT4ljFWyytH0vEgJrtWtzR184MGPBITH6AXM3HBkj
DKBynCnNkII0Tf4GdHh+Wrr7KK+jDNQr6oXLGlIxJOuSS1zNMawGyWmRsh17h4mI
fF1bgVcn4PN6XfymAgyVjIrtSn9+wNsUL0KpFCQeghtIciaxYsRUm/QUzEiyqz+t
XZj4Y7VTps25hv+ECNfFqszDYHkXc5J9rosuhTObSsXSUaqU0GZhtev/aW8Hieju
S8Bjg5tLRQteu5aG5oUd2Pv9d2zCa3sTOf9O3fg0ft/ypXAGkZwZgVIA5UVc5XpR
L7O73Zk5HbBtXDHYrwq42SQMalJUV3kVXKlRnP1rWwgvNYGSPjNr07a+GJ3VCuRp
uua3X2q3bAQ=
=zc6c
-----END PGP SIGNATURE-----

--==_Exmh_1397067600_1588P--
