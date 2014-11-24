Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaKXJQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:16:14 -0500
Received: from ozlabs.org ([103.22.144.67]:41387 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaKXJQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:16:13 -0500
Date: Mon, 24 Nov 2014 20:16:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Schwarz <max.schwarz@online.de>,
        Doug Anderson <dianders@chromium.org>
Subject: linux-next: build failure after merge of the i2c tree
Message-ID: <20141124201604.51aa3a82@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/th++vzCiZZ_OTMfNARewbS1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/th++vzCiZZ_OTMfNARewbS1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Wolfram,

After merging the i2c tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/i2c/busses/i2c-rk3x.c: In function 'rk3x_i2c_clk_notifier_cb':
drivers/i2c/busses/i2c-rk3x.c:634:7: error: 'PRE_RATE_CHANGE' undeclared (f=
irst use in this function)
  case PRE_RATE_CHANGE:
       ^
drivers/i2c/busses/i2c-rk3x.c:634:7: note: each undeclared identifier is re=
ported only once for each function it appears in
drivers/i2c/busses/i2c-rk3x.c:635:31: error: dereferencing pointer to incom=
plete type
   if (rk3x_i2c_calc_divs(ndata->new_rate, i2c->scl_frequency,
                               ^
drivers/i2c/busses/i2c-rk3x.c:641:12: error: dereferencing pointer to incom=
plete type
   if (ndata->new_rate > ndata->old_rate)
            ^
drivers/i2c/busses/i2c-rk3x.c:641:30: error: dereferencing pointer to incom=
plete type
   if (ndata->new_rate > ndata->old_rate)
                              ^
drivers/i2c/busses/i2c-rk3x.c:642:33: error: dereferencing pointer to incom=
plete type
    rk3x_i2c_adapt_div(i2c, ndata->new_rate);
                                 ^
drivers/i2c/busses/i2c-rk3x.c:645:7: error: 'POST_RATE_CHANGE' undeclared (=
first use in this function)
  case POST_RATE_CHANGE:
       ^
drivers/i2c/busses/i2c-rk3x.c:647:12: error: dereferencing pointer to incom=
plete type
   if (ndata->new_rate < ndata->old_rate)
            ^
drivers/i2c/busses/i2c-rk3x.c:647:30: error: dereferencing pointer to incom=
plete type
   if (ndata->new_rate < ndata->old_rate)
                              ^
drivers/i2c/busses/i2c-rk3x.c:648:33: error: dereferencing pointer to incom=
plete type
    rk3x_i2c_adapt_div(i2c, ndata->new_rate);
                                 ^
drivers/i2c/busses/i2c-rk3x.c:650:7: error: 'ABORT_RATE_CHANGE' undeclared =
(first use in this function)
  case ABORT_RATE_CHANGE:
       ^
drivers/i2c/busses/i2c-rk3x.c:652:12: error: dereferencing pointer to incom=
plete type
   if (ndata->new_rate > ndata->old_rate)
            ^
drivers/i2c/busses/i2c-rk3x.c:652:30: error: dereferencing pointer to incom=
plete type
   if (ndata->new_rate > ndata->old_rate)
                              ^
drivers/i2c/busses/i2c-rk3x.c:653:33: error: dereferencing pointer to incom=
plete type
    rk3x_i2c_adapt_div(i2c, ndata->old_rate);
                                 ^
drivers/i2c/busses/i2c-rk3x.c: In function 'rk3x_i2c_probe':
drivers/i2c/busses/i2c-rk3x.c:941:2: error: implicit declaration of functio=
n 'clk_notifier_register' [-Werror=3Dimplicit-function-declaration]
  ret =3D clk_notifier_register(i2c->clk, &i2c->clk_rate_nb);
  ^
drivers/i2c/busses/i2c-rk3x.c:961:2: error: implicit declaration of functio=
n 'clk_notifier_unregister' [-Werror=3Dimplicit-function-declaration]
  clk_notifier_unregister(i2c->clk, &i2c->clk_rate_nb);
  ^

Caused by commit 5a6f1566f6a0 ("i2c: rk3x: handle dynamic clock rate
changes correctly").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/th++vzCiZZ_OTMfNARewbS1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUcvdaAAoJEMDTa8Ir7ZwVHEkP/3qrooqbHvfBvkSjFmE28tvW
RFNnn73FGJamTdXV3G1MM36F3OE0RsWxxiIPQ+0xZk/hg8ySUJabzy+FoKAmqFR8
8ZFBkUP22Hh3yOo4L7+E825ndlzvMa6SJYWkxrtP6tULDfK+rRv6Y2yCJ58vNAYT
UciaskoZF7rw78y+vMUqAjhwSa9Mbe27LA2MCaHkULyscnar4k1vMnsNodzkCToy
373IgHFqjPS+Ud/PwCereWcTU10rHgiucsvCZQLBIrdbgdDydzWIFcbzm/6sbphJ
oT7D0riPsktCkF2m3WW+/ps/Ao1K01Wc+nX5AZJhohxr1V/DThx0b2zuntMXdMB+
0rqN8C5Van+oOlLjZflux8LjwnJUd9kjB4U26Vtbwc8YVEyGY+HMioXfz5CXv4IE
WVT7fomv2e38N/lWJsyNUTqGClz3u+5/jPCpd6VehF7mlZgd6MJrWGZhhls2ZTk6
KdZr1L1/XrhjyZDumWneSv3br6ki8Ph7APzhx/a2THa0T4ibLCFd5qwHJEU8lvRN
QFa+md7k25XhJtWnsAVoEJhR28m2YWdgdBEaPEtuUYdTJ3scwUk7k5RWk/+n32jk
4VErvR2Rzf5YpI00tWfGPyA8wK1/yL3as9pgB1yNfAcHZiFfrhxvK1RN6lb1EM2N
/WO4pXRfc6CBNGSysLqC
=0Gqo
-----END PGP SIGNATURE-----

--Sig_/th++vzCiZZ_OTMfNARewbS1--
