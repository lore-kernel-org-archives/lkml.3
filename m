Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaKYGDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 01:03:24 -0500
Received: from ozlabs.org ([103.22.144.67]:33340 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaKYGDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 01:03:23 -0500
Date: Tue, 25 Nov 2014 17:03:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: linux-next: manual merge of the tiny tree with the tip tree
Message-ID: <20141125170315.13157c60@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tZpN3/Vz9OhZ+Oq9x8xf9nZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tZpN3/Vz9OhZ+Oq9x8xf9nZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

Today's linux-next merge of the tiny tree got a conflict in
kernel/time/Makefile between commit fd866e2b116b ("time: Rename
udelay_test.c to test_udelay.c") from the tip tree and commit
d1f6d68d03ea ("kernel: time: Compile out NTP support") from the tiny
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/time/Makefile
index f622cf28628a,d07d4c9207b9..000000000000
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@@ -13,7 -13,8 +13,8 @@@ obj-$(CONFIG_TICK_ONESHOT)			+=3D tick-on
  obj-$(CONFIG_TICK_ONESHOT)			+=3D tick-sched.o
  obj-$(CONFIG_TIMER_STATS)			+=3D timer_stats.o
  obj-$(CONFIG_DEBUG_FS)				+=3D timekeeping_debug.o
 -obj-$(CONFIG_TEST_UDELAY)			+=3D udelay_test.o
 +obj-$(CONFIG_TEST_UDELAY)			+=3D test_udelay.o
+ obj-$(CONFIG_NTP)				+=3D ntp.o
 =20
  $(obj)/time.o: $(obj)/timeconst.h
 =20

--Sig_/tZpN3/Vz9OhZ+Oq9x8xf9nZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdBuoAAoJEMDTa8Ir7ZwVZMwP/2gCBwIH10tjfZ4s8mYw1HnD
L9Pf8XMTh8HkN9IqqzuldYWgpB1kGAOAqg7N4VyaIyN5Is9IBQHkv43UdqvGNcEe
+I1izgJnJNOV28nil4XC7/BH8P3Z9KZtsaTvWQxIROZsl0Dib9TBQt4fsrDS439G
XH95KCNpBZ56/uNU9JxvhTXFhrf7ngrPlGUSrGVUeN9PFOYSHjd8Z1xgyi7khCZ1
Rud44jU7V8PWu0Begy9j5+pe6pZRikvUiuvKExq/U1IE0gAWUjwY/z3UXkiPpcgF
c4QDfejLYDHqcJFRFGbAStn6f8PcN5PO9QgkzTCTBy1O1Yp3abxhGkx/i73C8gMn
yajiu2Q5/sEhnhKKpgjPtZI9BqUCzUlrWjp0ILcVxKlRBU1L3aEc7HEVPPtnjbSL
hvVHftYKxH8c4fdzpMx4Qpl/VxTaORIEIeqBsPOeRVcDub6toJKsTD62GZKwkvQO
MT1Jzu8vjCSQuWR/llkn5U/Nb8fjKnMkm1/mkxIxbuzb/r5yEYHY/fwr/nqePDl3
ZS831PTKdcqu++b+Ur+oimNusxTwCe6hTsmCKRU7CmeOCCRpIJM9lH/6A1xsEjnn
rAifd+RN/32tUqkb+C+VFGVrdY9AuwCWDkOxiIQnNmXNnch/qi+KplRH2EV98BXJ
Sdmk7XOJNq3OhMRgzz4T
=3OOG
-----END PGP SIGNATURE-----

--Sig_/tZpN3/Vz9OhZ+Oq9x8xf9nZ--
