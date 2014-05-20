Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaETICM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:02:12 -0400
Received: from ozlabs.org ([103.22.144.67]:40872 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaETICJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:02:09 -0400
Date: Tue, 20 May 2014 18:01:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: build failure after merge of the mfd-lj tree
Message-ID: <20140520180159.3a70193c@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/QmC0ADOs9cbiX_WkMI1Op=f"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QmC0ADOs9cbiX_WkMI1Op=f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Lee,

After merging the mfd-lj tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/stmpe.c: In function 'stmpe_irq_init':
drivers/mfd/stmpe.c:1000:15: error: 'struct stmpe' has no member named 'irq=
_base'
   base =3D stmpe->irq_base;
               ^

Caused by commit 3ba1d516d5fe ("mfd: stmpe: root out static GPIO and
IRQ assignments").

This is exactly the same error and commit I reported against the gpio
tree on Friday.  Why has it come back?

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/QmC0ADOs9cbiX_WkMI1Op=f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTewv8AAoJEMDTa8Ir7ZwVU3AP/31qWp2yRS8I91hIXlX1iZK7
HTaztR0Z9dyLMUP5rArDWi3Z+ce3um3PcfrquzwZuQcw5A6GZ6wrvnkrBCwoGjjl
kUUbrgIb+mFpGcdp4nFPwyR4vFLUi20p4TJsCrEn6P2Lnadc7BBft1F0DQeHy/4v
mFsburQx2tB3UcHfRP2VpPxAP0/u/JfYFx21rgWG4jsSCPU4+Y/5xW5nmcImze56
SEYqT0fYDPmGv9XlqNZM4D8SKbFJ+dqMKydw39aHqt5qhJ1AIb1GbjGMgHjRrivW
y2UpDNKJNcQYy2QscPQPxsO8pnoYYk0U9vqDyK7CRDNqFmuJxH7WQxVBOWZKmRwd
UO+Gy5h/QMNPhXqCjv+R//feNhbDgfeoGUTaPjzSX5lZiehXPR+bS+aCXsEPFbEc
wVWeM2+JXqFX7F54RN7oeAcOqD+gM80tlrryDWfRYc7i3pHvj1kLJfoPfYuctjme
xaodpJ0IxpibvcaCaJ8c2A5YDhi4YSUIMcVxFNXI/Dk8Xp5gNbtyQv+fb6a49sI7
HLafx8Do1NKgDRj0Yce1G+4GTZF6sV0TBqsVfhrV4l/UQ/BGfmJT723q/CKUYPZU
i42YHgbCmnyClEEMuZj4B6qtGJqD46xZhwfEGO2yTio4sl/Ug43b8G36/saHvwCP
i6+XjHqMwpX1dBLw6vGi
=jLW3
-----END PGP SIGNATURE-----

--Sig_/QmC0ADOs9cbiX_WkMI1Op=f--
