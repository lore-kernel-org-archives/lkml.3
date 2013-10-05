Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3JETOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 15:14:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51428 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3JETOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 15:14:21 -0400
Date: Sat, 5 Oct 2013 20:14:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Message-ID: <20131005191413.GY27287@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CgKfkX9/bwndGexZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Conflict in merge of the the random tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CgKfkX9/bwndGexZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

While merging the random tree into -next there was a trivial conflict
in drivers/char/random.c between 0244ad004a54e3 (Remove GENERIC_HARDIRQ
config option) and 557360455b (random: push extra entropy to the output
pools).

I've fixed this up as below:

diff --cc drivers/char/random.c
index 7737b5b,f126bd2..0000000
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@@ -255,8 -255,12 +255,9 @@@
  #include <linux/fips.h>
  #include <linux/ptrace.h>
  #include <linux/kmemcheck.h>
 +#include <linux/irq.h>
+ #include <linux/workqueue.h>
 =20
 -#ifdef CONFIG_GENERIC_HARDIRQS
 -# include <linux/irq.h>
 -#endif
 -
  #include <asm/processor.h>
  #include <asm/uaccess.h>
  #include <asm/irq.h>

--CgKfkX9/bwndGexZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSUGUBAAoJELSic+t+oim9KhoP/2MIOkvzCSwZZR0nW77MN+mM
l+p+5JLYdPod65BSbg2BVG11Zc/tdCFN2nPJ02tIUyhyWZPqwm9e4nN+FhzcRSzO
FNzSaZbKfbph3gkBFObK7UPKYtMeZOXZ21fqhZ3e4/WAUh+KekTXxMPT2msQue23
eG24hp2uCmrPEP8znM/Fif5CgdXVtRvreWevHKds18AfhP4tRK0kLn2IaYx+m0JG
UIKibch8cAQ5YLKxXOXYJ3OUrwRiA9BDqO77lfS7spJADrHug4Fj7s150/7yYzE+
rO6wvYNt5jPTMfL9HBvGruM46BT+WV6rfudKW0uOpXoDt5huVtM0uKen/MSTNcro
bymqmXO8DTRK3XHav34r+enNPLVAUvYrXxciP2I/WnJH8ZKqczPWVX21cHYhUjhl
xpwHqlBFWyhXJjmytQXJGI8RX5DBm3B8F9pe5TicWByyLbF/AGlU6pxnNhVwbY2J
Nz0fOklspDUXq2spm3bUS/NfFrVZa/5VHLBHJAkfIXLgO71p2PFdtfs5N79NLjGK
B8gRRs0KEH1TcBYaLVlFfn+CgoRJI4MWQ4res19UvehKeeyQNFPCIYUz7lGtBA3M
AHw6jwGE7o39jXdbJspUeqE+8p5fXkNd0jAQFicNAuZJve4AGJjhGDWFr2GaebuG
3N45Hyw83n0o2v318cop
=m1iq
-----END PGP SIGNATURE-----

--CgKfkX9/bwndGexZ--
