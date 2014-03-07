Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaCGD7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:59:32 -0500
Received: from ozlabs.org ([203.10.76.45]:53211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaCGD7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:59:31 -0500
Date: Fri, 7 Mar 2014 14:59:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Iles <jamie@jamieiles.com>, Alan Tull <atull@altera.com>
Subject: linux-next: build warning after merge of the gpio tree
Message-Id: <20140307145925.8f09601ffcefcc65e7837e72@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Mar_2014_14_59_25_+1100_pO.DTO9dSu0t/gAT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Mar_2014_14_59_25_+1100_pO.DTO9dSu0t/gAT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the gpio tree, today's (and yesterday's) linux-next build
(x86_64 allmodconfig among others) produced this warning:

kernel/irq/Kconfig:41:error: recursive dependency detected!
kernel/irq/Kconfig:41:	symbol GENERIC_IRQ_CHIP is selected by GPIO_DWAPB
drivers/gpio/Kconfig:131:	symbol GPIO_DWAPB depends on IRQ_DOMAIN
kernel/irq/Kconfig:46:	symbol IRQ_DOMAIN is selected by GENERIC_IRQ_CHIP

Caused by commit 7779b3455697 ("gpio: add a driver for the Synopsys
DesignWare APB GPIO block").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Mar_2014_14_59_25_+1100_pO.DTO9dSu0t/gAT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTGUQhAAoJEMDTa8Ir7ZwVknUP/0jMkIVdcA58DBRYW0Gt7yMb
hzLXiQi7PNdJf6dyA3dZSCCAp46FcshLCXmJuIGdj27Yf3rEaOL6xJ1U7qz/Jp6I
nY6ZM5dnxekmCZO4QjATu5dIg3zLFEgJ79kjNJ1Za3j8P74f7dCsJUD4wL4atBk+
uCbKE+hlsYL/8ksjSZC6htytAqPUySzixYawdLO4vQ8OhEUP3BthvmxZVqI/V2r+
2rBdYJOL+M1c+ijpzw5pGQ0YQiWMj6tmYeemomjkd6hAt6FpfS6EBNt/xLh5dHmB
5oz8oDjAq/IPzwzwGQijEtKvUPQ8lwH9jfgOetMDeVw6WHwtqM3DgLVJ8/g+v5CR
bsPF+wUVjoy2bdnTCkbJlnnOD8rsT46R9Mb7qozkSTKk3TR2cnKn/ADo2WRWwwX3
WToieBtmmnYwIdsOT0Q+sPkHOLozeLaFzq63IkSXAQcl/hGbihUL0E38kT7uEQOm
mVVvkoR4J9nv/cZEuXna796viyWb+y7JC0m/t1J8uyAeU69BrGWQbgXWHUqzM/Tr
1o6+P2AMuxc02BvDtBBp421qxcbW6ymkka+WUgJYLq/LesB9LPSOaKIBX06uEe+1
M2vcT59uYK14Mgs/CAHSzHZR0d7Gs41nUqwm+X4kovNwCTHZd1DxPax1VFRnxNE2
g/qudGUS+Glxop7JeG3k
=sJk/
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Mar_2014_14_59_25_+1100_pO.DTO9dSu0t/gAT--
