Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3IIPmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:42:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49460 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3IIPmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:42:02 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Oddness in security/Makefile
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1378741281_1775P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Sep 2013 11:41:21 -0400
Message-ID: <11543.1378741281@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1378741281_1775P
Content-Type: text/plain; charset=us-ascii

Seen in security/Makefile:

% git blame security/Makefile
...
^1da177e (Linus Torvalds  2005-04-16 15:20:36 -0700 15)
^1da177e (Linus Torvalds  2005-04-16 15:20:36 -0700 16) # Object file lists
da31894e (Eric Paris      2008-08-22 11:35:57 -0400 17) obj-$(CONFIG_SECURITY)                  += security.o capability.o
da31894e (Eric Paris      2008-08-22 11:35:57 -0400 18) obj-$(CONFIG_SECURITYFS)                += inode.o
^1da177e (Linus Torvalds  2005-04-16 15:20:36 -0700 19) # Must precede capability.o in order to stack properly.
^1da177e (Linus Torvalds  2005-04-16 15:20:36 -0700 20) obj-$(CONFIG_SECURITY_SELINUX)          += selinux/built-in.o
5915eb53 (Miklos Szeredi  2008-07-03 20:56:05 +0200 21) obj-$(CONFIG_SECURITY_SMACK)            += smack/built-in.o
...

What's wrong with this picture? Line 19 looks more than slightly confused,
and it has been for several years....

--==_Exmh_1378741281_1775P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUi3sIQdmEQWDXROgAQKKog/+L1Hhd2/MAv2qp+TNaWj/z5Jncw7jYV7Q
C1Rgu6vUc0a7ZtCaNrt9IdRPUS6nc+m/6SY1oPf4EBzuVrSSVDu5gxeGbcKp3DFw
EbaE5Gv/JMShf2bqvlBUqmmvqP59pLWiZjZfetlGgyaSU5IBnDX0pWOM2aVXC4mI
R4fPWuxAOeDSHFmzS57QRT0yb4tDL3kK+r/9auRtOeQbGNPrWz2R+qlhOSCNB0Xg
82CTuMBJY9772k1I732CrPrTEDwKk0tfZ6blfiGstrKxVzVpqEDtwZOudUC/cGjP
kTcY+itgazxNK1EGjkptqIQ/5HdQ/FJr3yOYHKHJ9qvced01lU84Hz6aUEpsrcS4
/gpYPyXTTH9tk8PM5c5tUMpm+tx3BSmHs4hxdDQVTMXnccBTDVSOUXaY44xL0RfV
wL32YAv/1jgXFJwuy0mng+ss36VIsyNbWsBls+hlyqFb+A61KoSg1l8bCxqd9Y5R
VomBvc2ZSdECnlzsp8ORScZp5EazqxKZAWFu2t/lkwbiI/Z3N/6WHeKrWiPegSSM
HDCB8/cjq5NzyDIh72ocEKaafU2n5UAPQooTzQB7nqTq2MgJ9T/AGudk9bg+QiYe
1ktr+QzyAemAhBjdd6Reb7xoGuJoEo6VmxO+eWgb/GkyG+rHs0jwTu1ERu/idZ1+
QAJsalSdl+g=
=sb/m
-----END PGP SIGNATURE-----

--==_Exmh_1378741281_1775P--
