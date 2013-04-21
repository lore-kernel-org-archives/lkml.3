Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3DUJfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 05:35:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36863 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab3DUJfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:35:45 -0400
Date: Sun, 21 Apr 2013 19:35:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Arch Mailing List <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Using __int128 on 64-bit architectures
Message-Id: <20130421193531.43965f592f00dfd6e3cfcf45@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.03.1304210450490.17443@linux-mips.org>
References: <51464C00.5090107@zytor.com>
	<alpine.LFD.2.03.1304210450490.17443@linux-mips.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__21_Apr_2013_19_35_31_+1000_VkNU.a4xyAt0CptT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__21_Apr_2013_19_35_31_+1000_VkNU.a4xyAt0CptT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 21 Apr 2013 05:29:28 +0100 (BST) "Maciej W. Rozycki" <macro@linux-m=
ips.org> wrote:
>
>  Hmm, nobody has replied, so just FYI such widening multiplication is=20
> available in all 64-bit MIPS hardware and GCC has supported it since 4.4=
=20
> or mid 2008 (older versions used a libgcc __multi3 helper, not quite so=20
> efficient as you can imagine).

$ powerpc64-linux-gcc --version
powerpc64-linux-gcc (GCC) 4.6.3
  ...
$ powerpc64-linux-gcc -O2 -c mulditi3.c
$ powerpc64-linux-objdump -d -r mulditi3.o
mulditi3.o:     file format elf64-powerpc

Disassembly of section .text:

0000000000000000 <.mulditi3>:
   0:	7c 08 02 a6 	mflr    r0
   4:	7c 86 23 78 	mr      r6,r4
   8:	7c c5 fe 76 	sradi   r5,r6,63
   c:	f8 01 00 10 	std     r0,16(r1)
  10:	7c 64 1b 78 	mr      r4,r3
  14:	f8 21 ff 91 	stdu    r1,-112(r1)
  18:	7c 63 fe 76 	sradi   r3,r3,63
  1c:	48 00 00 01 	bl      1c <.mulditi3+0x1c>
			1c: R_PPC64_REL24	__multi3
  20:	60 00 00 00 	nop
  24:	38 21 00 70 	addi    r1,r1,112
  28:	e8 01 00 10 	ld      r0,16(r1)
  2c:	7c 08 03 a6 	mtlr    r0
  30:	4e 80 00 20 	blr
  34:	00 00 00 00 	.long 0x0
  38:	00 00 00 01 	.long 0x1
  3c:	80 00 00 00 	lwz     r0,0(0)
$=20

i.e. for gcc 4.6.3, 64 bit powerpc calls out to __multi3

The same is true for sparc64.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__21_Apr_2013_19_35_31_+1000_VkNU.a4xyAt0CptT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRc7LjAAoJEECxmPOUX5FEeJgP/icYz0Ccicq9jGVZ+XXlVEJz
omDCTXJpDPGUgbyAw354RsBXAV3ZRPJahahx8RQLU/w125atQsCxZQy3bSVKZ4tT
xIwu3N2zMso/JWmK8xE+5FDBWgGiqwmZH8DkHuVgdRolBzxF8uUcyvQp7C0aLV/E
SVyQKH+NaiR8BK26K1eAsSdaAC4qlpdOQbnI0xHDpxF934QQu7LjmqrpQQp0JuOr
rYNGVVzJVMYQ5/bRZd9lqbDHNWY/GccR6zyC76toUyZt5ajFS8Y2Xq52d/lxCdNG
rduIrCGiZnUBJsft3nYLNpf7qs7A5zLzDPuMrJRXD4eCiBqEd0bQcIyacCPiofMB
PV4WYV8z/1duOfyqLedLOevt2ngywnk4MYEYKflaoyFMk2Sjl9geeKVFLqB1x8KE
OD7nBS6QJDXk6zK46LISx/Av/hw5KuSLoYcUAKTO1Hk6rbho9+UPQzfk4SYoaapT
ZxzKjENGR6Efh/i8Q3zVvLXkZC4hJ0YtLluv4MD8HglJJSF9QbXLn5P2UOtxDFKC
E9jbL5DgY1E6p0lZYlOxa42AlUurKwqIXUR5gyVGKG8fX1SXOrBT7IbuGxguIac/
QEkj3hv8j+9cAQs7R2QtEnJ4Lk7Lc3NlCczlq1MgrAB2T2BA1H4S4xDRuNqwco7K
0+mg29IuwMCzl5vEJFBQ
=u79l
-----END PGP SIGNATURE-----

--Signature=_Sun__21_Apr_2013_19_35_31_+1000_VkNU.a4xyAt0CptT--
