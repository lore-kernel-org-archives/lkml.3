Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaKXSUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:20:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38790 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103AbaKXSUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:20:46 -0500
Date: Mon, 24 Nov 2014 12:20:53 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <balbi@ti.com>, George Cherian <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
Message-ID: <20141124182053.GD25712@saruman>
Reply-To: <balbi@ti.com>
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
 <20141118211734.GA19146@saruman>
 <54736FBE.6060505@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
In-Reply-To: <54736FBE.6060505@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 06:49:50PM +0100, Sebastian Andrzej Siewior wrote:
> On 11/18/2014 10:17 PM, Felipe Balbi wrote:
> > I think the driver is mis-detecting Babble. A babble only occurs when
> > the device side tries to move data without the host asking for anything.
>=20
> It also occurs if the device moves more than packet_size bytes. Not
> really helping, I know=E2=80=A6

hmm, why would the device move more than wMaxPacketSize at a time ?
That's certainly babble :-) We *must* move data in the wire in
<=3DwMaxPacketSize chunks.

--=20
balbi

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc3cFAAoJEIaOsuA1yqREUUAP/3R/XAmacfhzpklsapmLsU2C
TZxE+IHX7c/FG6m+b3PA2izUMnIIi1FRcVf0sgXInN0oys3xFeT0O0JERCjO9xR8
JuprCtBDLxzrmlPpqnIi+wwdJMaxyXyTiGQGks9eHSAJhKgorUnknb/btcpn4GdM
GFvv0EFCbwUo+7Elhm6SLeX6ltlLcRd50qBtQS7gi3Ro6yvRLkQ2JQiEoNMZwnhw
SJf5gbMbK1cQELMIqh/c3+UGcHu4dGevqyHv5msTGokWKMReLbfuHVWvZtgo97jT
xFLS0QQGWIYwh2HXQaU+bxI1jBD+DUnu1it30PnHwmaTH8x2UktpwHkW0+PinZzH
kvjj6yBmCCx+ErBKS2WHe57VYx3RcHbsIX6c1KzsYNeRnu3dry7XZUc4iG09uzil
b9ES3JShnLPlVnm1Ok/RUn/NtGwKOo/ORiYi3qitgon7ee7sURyqqPJUnwrg088v
u9Xs8c2kB5Ms7uX7+XLmy5WSQHdxQqaKH1iUjppNCeQgmuvzEtEfImx6fB3RT0yD
rO5FsoE6IS/1vAhEB0c+lJP2HtAEomnossFtA5vBhmt443hLZ2u8Sr1IqhqYQrVx
WmiskjevcHlQj89GvGfQKVFKwj4k54DJwHzvJUI1mCpV1e7kBHPqxZVLBrliXYvp
iR/8GqEFjnWh4oWoPAF3
=7NhG
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
