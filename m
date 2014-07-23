Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbaGWIpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:45:18 -0400
Received: from ozlabs.org ([103.22.144.67]:52494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaGWIpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:45:16 -0400
Date: Wed, 23 Jul 2014 18:45:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        abdoulaye berthe <berthe.ab@gmail.com>
Subject: linux-next: build warnings after merge of the gpio tree
Message-ID: <20140723184507.30c4b211@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/yn5VGM_H4eVjqUn7HO2Ruhb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yn5VGM_H4eVjqUn7HO2Ruhb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the gpio tree, today's linux-next build (powerpc
allyesconfig) produced these warnings:

drivers/gpio/gpio-ucb1400.c: In function 'ucb1400_gpio_remove':
drivers/gpio/gpio-ucb1400.c:92:2: warning: ignoring return value of 'gpioch=
ip_remove', declared with attribute warn_unused_result [-Wunused-result]
  gpiochip_remove(&ucb->gc);
  ^

And lots of similar ones.

Introduced by commit 9f5132ae82fd ("gpio: remove all usage of
gpio_remove retval in driver/gpio").

Maybe the __must_check attribute should be removed from the declaration
of the function before removing the retval checking ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/yn5VGM_H4eVjqUn7HO2Ruhb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTz3YYAAoJEMDTa8Ir7ZwVzLAP/AkkRRt9mdgWu63BrFWxjEJ8
INy0cE41C/envalGoPeootPvd6bYZY48GD9ZOSOijhK16TVYaGOuMxY3pN7v4qF5
yHxSnZpioGAsLBQ6t3vt7NB90Whi5Vm+t1sU0OAtx8lZ+gBr2nFRV1q9Epr9exmu
gbJrftCh5Hr+TRrW2hErcmGeDtNn5RaQqABAuopBf/TtKLaEtzgF72p3svaWbDp0
yoL6QIr5Q2pfEBxUlvg0vF/ko/DuXANXDBFdsWl2er6aZlpXMXqHzZMnFEUrNmNV
Q4qWbwtS0twvPXy9X9ndtkV+5lHqxaUMMigSRyNY+FtqF+vSer4SwIaunnb+5jqe
inAUkvyiptlk+iOR6O+Q9jgLGRDQqVyctnmlsLO6VA1uewyxMW9fSzr7ccqVMjZd
EbgmzXBO7CopwwFBkIYPXjjEQaYw0eWybd5/Wen2wuuNQ8fmhA38tPTeWhR7V87I
BOD7Gku7ofX67abpRkbvFO/ardy/66eD6xylHTZ/r2wVEy0ain42+CtTGKe67hse
+mGDzUWE+M/0qqPiyqzPOf+3psxgOlcnF35JawwrmRTJ0DSzSw64y3UHVgVRajmr
+kV1fdDDNjzlmW7F9uc+Wu8HOwRChVcyk7mvySKDK6RsvNj3wOuHWGBJgUVd7A3k
vHeeif2jPIiCQU2KkU6g
=uKeq
-----END PGP SIGNATURE-----

--Sig_/yn5VGM_H4eVjqUn7HO2Ruhb--
