Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbaCTUT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:19:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57707 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759397AbaCTUTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:19:25 -0400
Date: Thu, 20 Mar 2014 15:17:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11] bluetooth: hci_ldisc: fix deadlock condition
Message-ID: <20140320201732.GA23113@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
 <1395343807-21618-9-git-send-email-balbi@ti.com>
 <95DFF994-1668-4F93-943B-06805FD5B20B@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <95DFF994-1668-4F93-943B-06805FD5B20B@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2014 at 12:40:40PM -0700, Marcel Holtmann wrote:
> Hi Felipe,
>=20
> > LDISCs shouldn't call tty->ops->write() from within
> > ->write_wakeup().
> >=20
> > ->write_wakeup() is called with port lock taken and
> > IRQs disabled, tty->ops->write() will try to acquire
> > the same port lock and we will deadlock.
> >=20
> > Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> > Reported-by: Huang Shijie <b32955@freescale.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> > drivers/bluetooth/hci_ldisc.c | 24 +++++++++++++++++++-----
> > drivers/bluetooth/hci_uart.h  |  1 +
> > 2 files changed, 20 insertions(+), 5 deletions(-)
>=20
> I hope these are not causing any conflicts with bluetooth-next /
> linux-next. If not, then I can let Greg take it through tty-next tree.
>=20
> Acked-by: Marcel Holtmann <marcel@holtmann.org>

tty-next is already closed, i'll rebase (if necessary) once -rc1 is out
;-)

cheers

--=20
balbi

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTK0zcAAoJEIaOsuA1yqREaYoQAKQrd/P/CKeb1ROSx0x7Bbol
wjoUjUVab/tRHp5DYqJLr6xrB3Ns6FTHJ1sJNi+fou6k2FGfgjGUxRGxKqqNTSEj
BUWrdENgphuZyLsXAiT057CX8NMO3q3pKHHcBNJrZpdedXY3iQYnSmEpzM1qy3Km
blUzlEnlcVLPNsmurDccCM3GJQ5evfrEnZQn53hMTzKQnklJx6RC9K87h0U10jDy
EzQZM7nCX5/ktJPdimVZw3ls9KsVZ4ffjBMPcNLhc6QuHSYPIouzFGPWEZk8AzLx
uEq085A5dYU5wLBXODOLIzmw9spx10OzwHK9dpdVSgwkGXKl8g0cNq4RhZ0hBrln
quil7WItwNROgUgZxk0gvo5966Hh8iXl3CZ+RyxjadOABrHo03gjrp30ttdzfLPC
ajWzONIjufHb7+PvEIguNhQX39oNx6NvsneZu7hPcb2KHshGVVFUSDOezuHzn6Eg
yYYGUhrTgmroGqi2QD3sHbv1DFehouBuP4bmNCTk0vmYGbRq23PvDWcBTxCFhRek
gQ3RvVgcV8lwyAx6XZM1S6Y7WmbXmRHTsY3K1zh00BzzOmah9Dhx9dBA+qHLan8F
23GIQjxF0427lVn/IuXU5SmoCdAy2+YasZ2P9xKWX0qt48MSjYxdfNwdjROmq/aj
h0Ih3Sk6WmtpVDfkpdp4
=o3Ee
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
