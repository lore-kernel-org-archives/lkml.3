Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaKYBJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:09:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48083 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaKYBJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:09:37 -0500
Date: Mon, 24 Nov 2014 19:09:39 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Felipe Balbi <balbi@ti.com>, George Cherian <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
Message-ID: <20141125010939.GA17125@saruman>
Reply-To: <balbi@ti.com>
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
 <20141118211734.GA19146@saruman>
 <54736FBE.6060505@linutronix.de>
 <20141124182053.GD25712@saruman>
 <20141124203908.4425.qmail@stuge.se>
 <54739B7C.7020102@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <54739B7C.7020102@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 09:56:28PM +0100, Sebastian Andrzej Siewior wrote:
> On 11/24/2014 09:39 PM, Peter Stuge wrote:
> > Felipe Balbi wrote:
> >>>> A babble only occurs when
> >>>> the device side tries to move data without the host asking for anyth=
ing.
> >>>
> >>> It also occurs if the device moves more than packet_size bytes. Not
> >>> really helping, I know=E2=80=A6
> >>
> >> hmm, why would the device move more than wMaxPacketSize at a time ?
> >=20
> > Some devices are buggy.
>=20
> for instance if the device comes out of resume and the clock is not yet
> stable but the device sends data. That is not the case here, but an
> example :)

that would be a bug on clk driver, it shouldn't return control to the
user until clk *is* stable :-)

> I *think* for some reason the host did not really receive ep0
> set_config request as planned. And device's answer is probably then
> interpreted as data which is not expected (as Felipe said "device side
> tries to move data without the host asking for anything").

that's definitely a bug, unfortunately I can't think of any Erratum
right now.

> >> That's certainly babble :-)
> >=20
> > Certainly! But musb shouldn't fall over or lock up because of it,
> > should it?
>=20
> No and the patch fixes the issue. The strange thing is that it only
> happens on the same device. Not if you connect host<->device with two
> boards.

probably some crap going on within the interconnect when both instances
are used.

--=20
balbi

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc9bSAAoJEIaOsuA1yqREoukP/3wcapbYm4tqRkbIAc6VLBf7
Ed4dYLAqfTsmjR6+sAkt9Wch2SpYgi973eFSwiOEkvXr6hzXd2cxJt9p4fvT+ic7
BeBRRgbeVP5cXUzUtCba0RDLVJBg0fZ626XFR+3Srsc+4Rddt2rZsegSut6XyWht
ZjIdJFkX/lRTSLVjG/oLk5NAvcS2dmGcRzp99sOJg16efY7Qqwhp+TEbSEKizENN
tiBL77SoxK2ZSDZiZTwUqVCFh9bt220yqUXqSjCAzulzybXOJTswoF9AGsQCJy0O
FEuOXu7VMNqYw2sZv9ZWW8+9mZW+dIQUboj1DD95VbEV32e6t3q5wWiOHjkbr15K
xgMCwYb6OnILg2ekKhgw7xEbfoIrFtSMCau6IT/7W1TQ962f5YKCFCJ636233YS9
lawvvEMU1JajM0D/AvLrPxHMTUe+hHXq1B3yDAaGQgUYcpjr0gvqmylOVtwLT5RD
fxmvlecyRy8Vxj92iOBd1ecg2V0lhweK945j9QQs0/Mpms4mtdSmdYADAP8H9W1y
1E3YeeoLJwIw4RMzenJvU6wsraQvwmUVUCPBjWqDydhF++JXCm+LasIhm7/WZeiM
uqPzkeBHgTM89dhxKGpkEGUBZtzYQKtxOGEOTqPyhQL2Hfd7xKdsei0FDNfFrjBb
wat+flWuY3AGaR8zXeW+
=J/Kf
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
