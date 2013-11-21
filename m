Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3KUCx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:53:28 -0500
Received: from dspam.tip.net.au ([203.10.76.12]:57465 "EHLO members.tip.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750860Ab3KUCx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:53:26 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 21:53:26 EST
Date: Thu, 21 Nov 2013 13:46:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>
Subject: linux-next: build failure after merge of the final tree (Linus'
 tree related - powerpc)
Message-Id: <20131121134622.a853064a1b5a8355e5077737@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Nov_2013_13_46_22_+1100_vfGZ4JQYADJS.m_v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Nov_2013_13_46_22_+1100_vfGZ4JQYADJS.m_v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

<stdin>:1:0: error: -mcall-aixdesc must be big endian
<stdin>:1:0: error: -mcall-aixdesc must be big endian
scripts/gcc-version.sh: line 31: printf: #: invalid number
scripts/gcc-version.sh: line 31: printf: #: invalid number
<stdin>:1:0: error: -mcall-aixdesc must be big endian
<stdin>:1:0: error: -mcall-aixdesc must be big endian
scripts/gcc-version.sh: line 31: printf: #: invalid number
scripts/gcc-version.sh: line 31: printf: #: invalid number
<stdin>:1:0: error: -mcall-aixdesc must be big endian
<stdin>:1:0: error: -mcall-aixdesc must be big endian
<stdin>:1:0: error: -mcall-aixdesc must be big endian
scripts/gcc-version.sh: line 29: printf: #: invalid number
scripts/gcc-version.sh: line 29: printf: #: invalid number
scripts/gcc-version.sh: line 29: printf: #: invalid number
/bin/sh: line 0: test: 0001 6000 0160: integer expression expected
scripts/mod/empty.c:1:0: error: -mcall-aixdesc must be big endian
 /* empty file to figure out endianness / word size */
 ^
scripts/mod/devicetable-offsets.c:1:0: error: -mcall-aixdesc must be big en=
dian
 #include <linux/kbuild.h>
 ^
kernel/bounds.c:1:0: error: -mcall-aixdesc must be big endian
 /*
 ^

Caused by commit 7c105b63bd98 ("powerpc: Add CONFIG_CPU_LITTLE_ENDIAN
kernel config option").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Nov_2013_13_46_22_+1100_vfGZ4JQYADJS.m_v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSjXQDAAoJEMDTa8Ir7ZwV9ckQAIHy/rvp/8a5qLLvKtDsBLXt
a9PPF3A6+6XtYN70jFOYZV1P5uRvmJEXrNywBCKPj2pcBvlLl7iorZOsYt4It1K3
Gzd7TBvGtknwKqA4DtBojqijf1Zr1NTPItxEKv4Aen+1WXPyJBvPCqsr8ioH0tz8
1SG548BD4QHdrig/KXElrHAjKjNPi6N4MwAN3x0aBPIQc6fjty4PJlFJRADfAOwE
3x4LvgRzVY/j1CpUUIkBlCDf74FORNbhmoGjlOZ3TmirM/u8WED7ErJmZEvDui8c
D2/DnTwjb7dEuDUye3e54o427VPWBUcGzCXBZL4lRzKAi2lBynmZNpzq8/atETAc
X+A181wBGbKdpXWqFf8ESAHHejbJvBOkSYiWody64cuxyiitAS664YC/ujCct7xU
Zc6ioGsFpMbnNOhG765+qyzmkpTUQH0GDj5ReF93JGb9i9ZG6mAP7fpOeKT7iHc+
NHKSYHa3FrwRMNDtCyxgT3I7Z4zbvgYIG/n+xXbtyaD2tx94KrTaM0Wd7w7VW4BB
tmVOwCrOJGONUSKkt91yeyGCl9O0ZJfHDn6zcNDid1m6gW50+vnYOUE+976dJaAB
s+pxWz/5Kq3pYGkd0oBlVTTzNbID99gn7Edq8TuVk6//CsrRfElSuMwYXozCZX7i
BtU5MnFMYzzBQjvKyjcG
=WRj1
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Nov_2013_13_46_22_+1100_vfGZ4JQYADJS.m_v--
