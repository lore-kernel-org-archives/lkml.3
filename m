Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423033Ab3FUGSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:18:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57686 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422796Ab3FUGSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:18:06 -0400
Date: Fri, 21 Jun 2013 16:18:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the tip tree
Message-Id: <20130621161801.34c4a75c217ca4c1b7d6529c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_16_18_01_+1000_.P16kGKRp9sIJek4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_16_18_01_+1000_.P16kGKRp9sIJek4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-u300/timer.c between commit 38ff87f77af0 ("sched_clock:
Make ARM's sched_clock generic for all architectures") from the tip tree
and commit 3c96d8ea8101 ("ARM: u300: enable delaytimer on the U300") from
the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-u300/timer.c
index af771b7,390ae5f..0000000
--- a/arch/arm/mach-u300/timer.c
+++ b/arch/arm/mach-u300/timer.c
@@@ -18,12 -18,12 +18,12 @@@
  #include <linux/clk.h>
  #include <linux/err.h>
  #include <linux/irq.h>
 +#include <linux/sched_clock.h>
-=20
- #include <mach/hardware.h>
- #include <mach/irqs.h>
+ #include <linux/delay.h>
+ #include <linux/of_address.h>
+ #include <linux/of_irq.h>
 =20
  /* Generic stuff */
 -#include <asm/sched_clock.h>
  #include <asm/mach/map.h>
  #include <asm/mach/time.h>
 =20

--Signature=_Fri__21_Jun_2013_16_18_01_+1000_.P16kGKRp9sIJek4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRw/AZAAoJEECxmPOUX5FEHucP/0YcpUvV90X3/ejnxetN1aYS
IHAVTRvdA+4QgJQGOfQmeDRzZWSBHrZrpovCuKlMlmmY3ttyF4Fd0W3rJyMvibFe
+GCmZyUmHvgZMQ3gU4E0eB25YxFSWNS5quhWXaXoJxOOSDUOOh+vB4mq9yZsblAz
R5ICIPvCnwpckH1lFOfNo8fRZo9APo4PWLQhkmfNTjXjS/FaUrhtLirnbJqUZvaP
Nor4suqNP4MqjSAlZ0OUGDBdRW2DnCvAy0enbj8sPoCbzp0TOIgU8wrCvEsEuLvS
30GvffWXelFxdkiNCV2q36lJx6q6HP6VOfquzCe8pSLbgV25VAtHV1TUday7EyeL
H29g6wISLRp094q7R/eIJxupIdYfRMh4IHYUucfh9rMPykrRWcwI9qVQzk3jDoHd
pwztE9bvXxsyFf3ggRWF8nskAXYN8Ab/xxgM9daG6Kj4CrnoNEHa28/n3SchOCfj
4HpQ2jJIqY0UwqxP/mkjogqyEzMEoE4Z8BhEamsypLPjup+5UEq78qavx3Qcuhki
XbhB9xNguU7gouD/Y3uzxYLSSsmsau5+uYMhLF0zHsGa6u1T7iJD3limI1sKD6FG
6WOgEkP/PBUN/us7km/g73/jK0FWDT2HzTTuuOerlXaol14uoQTkOLKJujONKWUn
5VaOJekbLMi8NKRaOB3C
=qOKD
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_16_18_01_+1000_.P16kGKRp9sIJek4--
