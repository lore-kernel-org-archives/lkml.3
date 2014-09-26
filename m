Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaIZGZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:25:22 -0400
Received: from ozlabs.org ([103.22.144.67]:59105 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbaIZGZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:25:19 -0400
Date: Fri, 26 Sep 2014 16:25:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jason Cooper <jason@lakedaemon.net>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the tip tree with the arm-soc tree
Message-ID: <20140926162512.07ef4957@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4JAOwzqUquCHY52QtU4T675"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4JAOwzqUquCHY52QtU4T675
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm/mach-omap2/irq.c between commit 8598066cddd1 ("arm: omap: irq:
move irq.c to drivers/irqchip/") from the arm-soc tree and commit
f978999f6096 ("Use the new handle_domain_irq method to handle
interrupts") from the tip tree.

I fixed it up (I applied the latter patch to the moved file - see
below) and can carry the fix as necessary (no action is required).

diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-int=
c.c
index f3814e79192d..28718d3e8281 100644
--- a/drivers/irqchip/irq-omap-intc.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -334,8 +334,7 @@ out:
 		irqnr &=3D ACTIVEIRQ_MASK;
=20
 		if (irqnr) {
-			irqnr =3D irq_find_mapping(domain, irqnr);
-			handle_IRQ(irqnr, regs);
+			handle_domain_irq(domain, irqnr, regs);
 			handled_irq =3D 1;
 		}
 	} while (irqnr);

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/4JAOwzqUquCHY52QtU4T675
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJQbNAAoJEMDTa8Ir7ZwVqhQP/1JAY7Uo1vZg2PEc4Al1rfXL
D/vFAeGwbVcjlDdj4NU6/QgFdgnQ7zrq3jeYVl518SyoYG41kPwUI2tBwUmWGu0H
+tG/c4EX7t5mORY9CFWzYBEQrATnAs7cM3EBsvc3zKvehnhDM2th9CCR0DdT+BhC
Cncha4nG4UmqdO8vMuCs0A3oWdrTa+HaClaF041teb/qpO8oWchmsDF/BQzFDY4z
B2sMEkO48IdwU1HXkuGqGarFgp6f8iv8xoWeyWzZdV8Vpo9kxkRikQfgL/VNKzF2
AqLq+JhcP4ICa2vnNsVFHBRtuDh56wVZEPB2Pqybm3U26pS3DtAcszVJ00mIZYPm
i/G56DxiS3YzUhJu2NIyIV+h0MetFIsw78zQc77jpL2Yd7CDNFd0LHlJPrmnFVfH
ax/5seb71Jcc6xTdD8tFQMYgPL363r6ViYZR6Z7dMFoAWcyP6/D1gyfluQh5mXmG
CeHph/n8OgkasuucbsTrtFcC2HOZQhOS3R7eQXJx4FDCajEfmQDZiAf0k5+0+rQY
GTaVaabapk5KZGRjTQJ85ZHe1icrZIaSfUlK/5ZblrO24mCYgJOrU+FHXXMlTZbY
2nlTM7QXFcJM+PMJOnVjN8AwJpIsDt8I5TWUh7RPFtDxA/t0yET0siguv+qQKI15
fyyKJNN7NWJQh/rPogER
=p3h8
-----END PGP SIGNATURE-----

--Sig_/4JAOwzqUquCHY52QtU4T675--
