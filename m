Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3FTFGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:06:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32854 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3FTFGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:06:07 -0400
Date: Thu, 20 Jun 2013 15:05:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the tip tree with the arm tree
Message-Id: <20130620150550.9eda4f00469d4ba4a08dcb00@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Jun_2013_15_05_50_+1000_JlwwO_pKiKayUHO1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Jun_2013_15_05_50_+1000_JlwwO_pKiKayUHO1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm/kernel/Makefile between commit 4477ca45fb36 ("ARM: ARMv7-M:
Allow the building of new kernel port") from the arm tree and commit
38ff87f77af0 ("sched_clock: Make ARM's sched_clock generic for all
architectures") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kernel/Makefile
index fccfbdb,97cb057..0000000
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@@ -15,8 -15,8 +15,8 @@@ CFLAGS_REMOVE_return_address.o =3D -p
 =20
  # Object file lists.
 =20
 -obj-y		:=3D elf.o entry-armv.o entry-common.o irq.o opcodes.o \
 +obj-y		:=3D elf.o entry-common.o irq.o opcodes.o \
- 		   process.o ptrace.o return_address.o sched_clock.o \
+ 		   process.o ptrace.o return_address.o \
  		   setup.o signal.o stacktrace.o sys_arm.o time.o traps.o
 =20
  obj-$(CONFIG_ATAGS)		+=3D atags_parse.o

--Signature=_Thu__20_Jun_2013_15_05_50_+1000_JlwwO_pKiKayUHO1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwo2yAAoJEECxmPOUX5FEMnIP/1OHe/iYlKZj5/sB7lSrtmBL
bCI5kTdxgSDfF4yxSXWmGb91jrDM6mvrQvMD209pCdsJn4PGwArByB8KzSfItCHO
um4N5JKzLf3++nkCKYCAJGDbLkg3X+AN10mYC4/tuC8r/wRivtfvBH+S3fjAAGLp
uKzAQfiCD8GUr9w3mWtv/o3czPyShU9koH7xKscyWWoc/fGim+/HaNDStG5DoFQy
OOLDHjkUhle2jH2IUduuC+gvz28KOeQeZMheBXzwi50cJg59UnthkwXndT2JxxSA
VYhV305+TM+TvWOWncWq+cpWsSmcxrB9iynMbw7PB1paw6LpFgBps8g+W8fQSMra
pIITIL8k6IWlZ9XLASevO0VWXK8PIlZ2W3Cvy+d3HqLUrCLlV7fULgIqU79b1KQh
azCkCG5uaQK2dpQYO2RvKy/1xx8tAEwNJKmEVu0oLdHUKrDQXXaUrtDpkNBtmhP+
J2ru9KeJyWJ6KmOOsttQYP8iVPj9+6HYungZOBU+axq6GGa/0aPv9NjNhTZjDPTr
oZ6JanSO2z+h4lHaR2GP3Twqfw+Y+srRnGKtUUhKjRgf1J+2riQ13l2jbEAt4fw6
mH/Vg1EwEuexjIUMeU1cebN0c9Ht4dpVabKUjnV+q2diJ4jQHmtGFXoj8wFXiyVP
PDyi/Hu1OJ+0Rv/ACjn1
=Q9w9
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Jun_2013_15_05_50_+1000_JlwwO_pKiKayUHO1--
