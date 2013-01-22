Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3AVELB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 23:11:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49357 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3AVEK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 23:10:59 -0500
Date: Tue, 22 Jan 2013 15:10:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: linux-next: build failure after merge of the final tree (gpio-lw
 tree related)
Message-Id: <20130122151048.e47ecfe9432b747f79544c25@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Jan_2013_15_10_48_+1100_q0BpyIRh8nYK5.Y4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Jan_2013_15_10_48_+1100_q0BpyIRh8nYK5.Y4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_get':
drivers/gpio/gpio-palmas.c:46:2: error: implicit declaration of function 'p=
almas_read' [-Werror=3Dimplicit-function-declaration]
drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_set':
drivers/gpio/gpio-palmas.c:62:3: error: implicit declaration of function 'p=
almas_write' [-Werror=3Dimplicit-function-declaration]
drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_output':
drivers/gpio/gpio-palmas.c:83:2: error: implicit declaration of function 'p=
almas_update_bits' [-Werror=3Dimplicit-function-declaration]
drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_to_irq':
drivers/gpio/gpio-palmas.c:108:2: error: implicit declaration of function '=
palmas_irq_get_virq' [-Werror=3Dimplicit-function-declaration]

Caused by commit 4bb49f0dc999 ("gpio: palmas: Add support for Palams
GPIO").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Jan_2013_15_10_48_+1100_q0BpyIRh8nYK5.Y4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/hFIAAoJEECxmPOUX5FEZkgQAJbKucZL5oFkMP1nHoWIlpiF
RogFR1+l0ngTGI+h81QzFEErweWU5KAMKz0aF2mFJ68xVLBfr5UcqTc54A2GSdP8
F/MlkuIAqCbMbUAXn/4CkFe6wg5ndumiUAQCVpSB8zggGN0WT0BWtcYssyWqe0Ft
ZvUSUFlX+U9Vg6vqDV2KXyBWoTQ59l8Bo4XDKFI1TO2StfRsYHdvNLdVTurh98P8
7gP+0OHuQupo5q+lxDxC4dPu8P23SU72IE7QBlTvBUv94+hKNamzUt/4t0UEYOVV
63j1ktVRU5aOxnZObwTsyGiYPI4LaEf9Z9vqC8bzEK2bF0q1wABnvfjLDwqeOdjh
dFpqVvMXs7fIAKDIhdnz3Ddc2JI/v6WdF810Jyr3b6PUNntEjbBbPcxE6r7tnmvt
wyb7NN+P49I6RozSP79tN5kWJaj86b/ziNsUO7O/9td+ojZ6vObldKWkInDXJHES
XCcr10mWqHIQtYkuNp9a8bwUGJDmX/6JIPwcR5s1Sju9HDj+R+zsFsFWYAujezRm
hMIuB4Mc04Z74GMjzWLgcFqqKdPJ0iteXXPuQw7sO86ryuB7FOB5ldWZ2zTrzlwu
YoO2eSsInLHXHjWaVuFf6wPLspY8QRwqE8aLf4pG6eU9ZRgmMhiMl5t1jLkNB9UN
8Gaec7FZGoos0iYGNvB8
=DtOz
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Jan_2013_15_10_48_+1100_q0BpyIRh8nYK5.Y4--
