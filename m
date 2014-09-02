Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaIBK5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:57:08 -0400
Received: from sauhun.de ([89.238.76.85]:53783 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbaIBK5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:57:06 -0400
Date: Tue, 2 Sep 2014 12:56:23 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Simon Lindgren <simon@aqwary.com>
Cc: ludovic.desroches@atmel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c:at91: Fix a race condition during signal handling in
 at91_do_twi_xfer.
Message-ID: <20140902105623.GE1266@katana>
References: <1409080404-19069-1-git-send-email-simon@aqwary.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWTRyWv/ijrBap1m"
Content-Disposition: inline
In-Reply-To: <1409080404-19069-1-git-send-email-simon@aqwary.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SWTRyWv/ijrBap1m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 09:13:24PM +0200, Simon Lindgren wrote:
> There is a race condition in at91_do_twi_xfer when signals arrive.
> If a signal is recieved while waiting for a transfer to complete
> wait_for_completion_interruptible_timeout() will return -ERESTARTSYS.
> This is not handled correctly resulting in interrupts still being
> enabled and a transfer being in flight when we return.
>=20
> Symptoms include a range of oopses and bus lockups. Oopses can happen
> when the transfer completes because the interrupt handler will corrupt
> the stack. If a new transfer is started before the interrupt fires
> the controller will start a new transfer in the middle of the old one,
> resulting in confused slaves and a locked bus.
>=20
> To avoid this, use wait_for_completion_io_timeout instead so that we
> don't have to deal with gracefully shutting down the transfer and
> disabling the interrupts.
>=20
> Signed-off-by: Simon Lindgren <simon@aqwary.com>

Applied to for-current, thanks!


--SWTRyWv/ijrBap1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBaJXAAoJEBQN5MwUoCm2lMAQAKtY21GNyxAPYTmQFYw2xJp/
e67Pit9TL1d2VqvNkR3YDpTsgmDC6ws0qSB4BnubmigY92Bq8378VYSKZ5Pkpe+4
UiHy0K0e1VnyDusZm+LnqcnTct3WsR5WLUkphkrlRZnAFnUQtp8M+tw5y9QRXz/u
H97mianmVfm9JCzyVcxMSBfglcsKZRt4RkB4/7A3L0/Hl2Xb5PQttupZU2kUpRex
dOuJT/flLI0F2M6FYhX1SLzW5bZCRtBIZBHtPC4Pfn3fH+J34D3kCKToKfMwnala
PF4axHt3o7cnoTyrRUO5zU24t68Bi/2bZErlOECmTenUkacw7jzYZQz56by8oPIl
XlPsSNMG0Hq3/4zWXYtveVRSikYZ00tKBtlm10tVjUJ9BBPzU+bskprX+dsHylQM
TGnEXd6KOp5ebOABGFqeGKLjT6AMAbANn+MqMLaffAlqe47jrhNeOpLO7T8AOcxl
Y2rLChAJlFFRvyC/1hvq7P5JSIrBgHNZmh9OfQRqrw6pe0hN+S7GsKYlHYM8aUVB
jJnBxHtC2L0So8S9PAYBVHXx+0WA9DfP+P9ZllLDNURqfv/5WbJoFX8irp9ZXfrq
HJ+vUXVCzbabpJnin/t8JKF7I9fJ17pK9vOjUy5FESFu1DKTYcVEudezGBeqGgw2
E58vbjTLqlwvrq2RsSM6
=Sm5H
-----END PGP SIGNATURE-----

--SWTRyWv/ijrBap1m--
