Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaHTHje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:39:34 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65081 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHTHjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:39:33 -0400
Date: Wed, 20 Aug 2014 09:39:29 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: =?utf-8?B?R2HDq2w=?= PORTAY <gael.portay@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 2/3] ARM: at91/tclib: move initialization from alloc to
 probe
Message-ID: <20140820073929.GJ13793@ulmo>
References: <1408486072-19268-1-git-send-email-gael.portay@gmail.com>
 <1408486072-19268-3-git-send-email-gael.portay@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Do4IU1xF/9sod/r6"
Content-Disposition: inline
In-Reply-To: <1408486072-19268-3-git-send-email-gael.portay@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Do4IU1xF/9sod/r6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 12:07:51AM +0200, Ga=C3=ABl PORTAY wrote:
> Move resource retrieval from atmel_tc_alloc to tc_probe to avoid lately
> reporting resource related issues when a TC block user request a TC block.
>=20
> Moreover, resources retrieval are usually done in the probe function,
> thus moving them add some consistency with other drivers.
>=20
> Initialization is done once, ie not every time a tc block is requested.
> If it fails, the device is not appended to the list of tc blocks.
>=20
> Furhermore, the device id is retrieved at probe as well, avoiding parsing
> DT every time the user requests of tc block.
>=20
> Signed-off-by: Ga=C3=ABl PORTAY <gael.portay@gmail.com>
> ---
>  drivers/clocksource/tcb_clksrc.c |  2 +-
>  drivers/misc/atmel_tclib.c       | 71 +++++++++++++---------------------=
------
>  drivers/pwm/pwm-atmel-tcb.c      |  2 +-
>  include/linux/atmel_tc.h         |  8 +++--
>  4 files changed, 29 insertions(+), 54 deletions(-)

For the PWM driver part:

Acked-by: Thierry Reding <thierry.reding@gmail.com>

--Do4IU1xF/9sod/r6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9FCxAAoJEN0jrNd/PrOhjIkQAKTNA5QJJFXB674DxzLZRiWH
61eiFkN2vUjw4KPcC4iDJzCCfE+N14GuvVKol/jW7xk8bcrDfu9TGLiqKVoxJqjf
4wzqp/xsMaH8gPvhBIq6QQJ8CgyYUXI1xjwNoZAcUB0cOaZqxb6IKrzXmhVongXR
PFr6wTawXQhRkbfJwYFkpYFwHZThbr55cxoAtJekf4K4iVmpORhQQMb5H9Xg8OJ1
dPhBZ30FnmaL9AZdSPiNKaOiRLdYDJgV4xNDVtBezNGAlxlk9CRuYEBdJ+833Xwv
o7dv6HsnBs6ZptdZOe7CFU3sxM/soEeW+rkWe2QDO4qLPQ/qAKtFfvDJC02iwJFd
4HRdy7AlmqFocLGRn5ynpiJKrkP3GHAgO1eE71XaozIyDKzyyjZOqGpPGnwD1zhQ
dL9sMLv535SYZs9A5JwVFUr/+tOi9LCXKYl2EBNuwt9pCAV/7/glGZidcqwFrjBi
gDhZ70sWOC7JIbZbbl9fB0qQ6frrMOHQ+Dsjcc97iGJC4fnchLmHgI7nBDaVSWTw
YamVWhCxr6g47RawRKkvYdT31+D66Uz9U9YcDpfeG27ELPwPHpkcBTLNi3DGs4HS
c0qvBvD6Jc1heeKwlnPcrbHORfAI+RrTkVn6r2d8opEz3U9sOpCweZCAj5RwWACR
H+ufU7vUwbrMaM8Mt1x4
=QZF3
-----END PGP SIGNATURE-----

--Do4IU1xF/9sod/r6--
