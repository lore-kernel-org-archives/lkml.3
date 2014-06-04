Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaFDGFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 02:05:31 -0400
Received: from ozlabs.org ([103.22.144.67]:56310 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaFDGF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 02:05:29 -0400
Date: Wed, 4 Jun 2014 16:05:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: linux-next: build failure after merge of the tip tree
Message-ID: <20140604160522.1d788c1e@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/yfOy6ZqkjtCJnNIbSQ6Hf0N"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yfOy6ZqkjtCJnNIbSQ6Hf0N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:


drivers/clocksource/versatile.c: In function 'versatile_sched_clock_init':
drivers/clocksource/versatile.c:37:2: error: implicit declaration of functi=
on 'setup_sched_clock' [-Werror=3Dimplicit-function-declaration]

Caused by commit c04ae71c9c26 ("sched_clock: Remove deprecated
setup_sched_clock() API") from the tip tree.  The usage was only added
to Linus' tree today by commit 220e2a8d22cd ("clocksource: Sched clock
source for Versatile Express") (but this commit has been in linux-next
since May 22 at least).

I have reverted the tip tree commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/yfOy6ZqkjtCJnNIbSQ6Hf0N
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjrcnAAoJEMDTa8Ir7ZwVrQAQAIx8q+QsNv098bsE5W4fBoSn
1enzxh0LzNk+v35+vUuIeDq9qBNyovXKtxUBL/WA97fxz6A4vNrnqe9vFdclYzmt
NMH6pQy5s6HTdyHFuC8dJokX7Oz1ndj94P5P259VNiKaYeAXiIeCWX3Mxua840Lt
wwt/cvEr0U0hEkmGz9YbFxvJTbHxGGATmV4uHkaWBke92abO/nI4nu9NoPMBDemK
Wcue5U9gVdgwgyQitnMuJYUEcgOP8bkqRdlBFDt8vDmWsp2TS4KeZySeQFPZ/Uht
XX0FCj03Ig65lukeODTzqoawORNMutM05kKbvh1zIfV6g/cMgcM1+7mEUwekbcs7
9Zi+fuP5fsjQo58f5DYqOC8r4GOoP3RkJE/Xuar5ozYC0xEfkEKdcEblV2JiYIct
kqPW2spKoRZeqz/YO0D5WSkGHvVGbSfliTGZdPoxIrH1Q0SpkpR8uZfQSLaQBr3j
i7EooJWBiebqW48JJ/CGt6A9NIs5fLwm5wzqAK3hdsOtSH5w1Z9XevViVVYUtpTT
SzBDY+FABl3veHiluYr5+utv1GIeQHwRPB1y9T5BzlSaPDDfN3Go6G2+KeaiQ1/k
G6XV+zg9Uw/W6KoCRAQyAIYAXnVTNPZkeqihFf1yck8U2cAzSluT92g+8ULq2nR2
KGMCkKvAnhMDT42eECVV
=/alA
-----END PGP SIGNATURE-----

--Sig_/yfOy6ZqkjtCJnNIbSQ6Hf0N--
