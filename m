Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965344AbaCTTjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:39:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57763 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933625AbaCTTjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:39:33 -0400
Date: Thu, 20 Mar 2014 14:37:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <peter@hurleysoftware.com>,
        <m-karicheri2@ti.com>, <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/11] In the uart_handle_cts_change(),
 uart_write_wakeup() is called after we call @uart_port->ops->start_tx().
Message-ID: <20140320193743.GM3959@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
 <1395343807-21618-8-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v541l457l4DThMFo"
Content-Disposition: inline
In-Reply-To: <1395343807-21618-8-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--v541l457l4DThMFo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


On Thu, Mar 20, 2014 at 02:30:04PM -0500, Felipe Balbi wrote:
> From: Huang Shijie <b32955@freescale.com>
>=20
> The Documentation/serial/driver tells us:
> -----------------------------------------------
>   start_tx(port)
> 	Start transmitting characters.
>=20
> 	Locking: port->lock taken.
> 	Interrupts: locally disabled.
> -----------------------------------------------
>=20
> So when the uart_write_wakeup() is called, the port->lock is taken by
> the upper. See the following callstack:
>=20
> 	|_ uart_write_wakeup
> 	   |_ tty_wakeup
> 	      |_ ld->ops->write_wakeup
>=20
> With the port->lock held, we call the @write_wakeup. Some implemetation of
> the @write_wakeup does not notice that the port->lock is held, and it sti=
ll
> tries to send data with uart_write() which will try to grab the prot->loc=
k.
> A dead lock occurs, see the following log caught in the Bluetooth by uart:
>=20
> --------------------------------------------------------------------
> BUG: spinlock lockup suspected on CPU#0, swapper/0/0
>  lock: 0xdc3f4410, .magic: dead4ead, .owner: swapper/0/0, .owner_cpu: 0
> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.10.17-16839-ge4a1b=
ef #1320
> [<80014cbc>] (unwind_backtrace+0x0/0x138) from [<8001251c>] (show_stack+0=
x10/0x14)
> [<8001251c>] (show_stack+0x10/0x14) from [<802816ac>] (do_raw_spin_lock+0=
x108/0x184)
> [<802816ac>] (do_raw_spin_lock+0x108/0x184) from [<806a22b0>] (_raw_spin_=
lock_irqsave+0x54/0x60)
> [<806a22b0>] (_raw_spin_lock_irqsave+0x54/0x60) from [<802f5754>] (uart_w=
rite+0x38/0xe0)
> [<802f5754>] (uart_write+0x38/0xe0) from [<80455270>] (hci_uart_tx_wakeup=
+0xa4/0x168)
> [<80455270>] (hci_uart_tx_wakeup+0xa4/0x168) from [<802dab18>] (tty_wakeu=
p+0x50/0x5c)
> [<802dab18>] (tty_wakeup+0x50/0x5c) from [<802f81a4>] (imx_rtsint+0x50/0x=
80)
> [<802f81a4>] (imx_rtsint+0x50/0x80) from [<802f88f4>] (imx_int+0x158/0x17=
c)
> [<802f88f4>] (imx_int+0x158/0x17c) from [<8007abe0>] (handle_irq_event_pe=
rcpu+0x50/0x194)
> [<8007abe0>] (handle_irq_event_percpu+0x50/0x194) from [<8007ad60>] (hand=
le_irq_event+0x3c/0x5c)
> --------------------------------------------------------------------
>=20
> This patch adds more limits to the @write_wakeup, the one who wants to
> implemet the @write_wakeup should follow the limits which avoid the deadl=
ock.
>=20
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

patch came without a subject, Peter already sent it anyway, so Greg can
ignore this one.

--=20
balbi

--v541l457l4DThMFo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTK0OHAAoJEIaOsuA1yqREEYkQAI8dRqNI8CE3O0Lh+2s29U0I
0/DJKnjCbojkgKh5BjfxyvP3J5BRj3Al8wt3bG1ZjYqkvcEabVLqzMAJ5G1lSM5p
YOk82u+qIaf8jlTYvwYwtdzML977Y2GXHDvLiJfbY4gWtUfqj0UBaXXIEUssM6uh
jDN0j3G6EeM9yHy+MqxiwS+AHRVrLHRtENaZPJ9+CbmH/bBfjs3iy/TwwhqWvY2q
jacwRlx7FDhZ8ExkpsSch6s5a0vSQH99l8vV84wO422PUzdZpV4J7+P7eOUHaxrW
zqjUgfMX3YkzJwj4ZDo6epfsp/RqEyhCHp4d5l9rHqsOjLaZfU5FypO9P8yj9uBW
PJfeXGWC8kWoDSKDz0lsPq6Qav/cYHd7uwKmTa4HKCmILSw/VwjVG8M/X0YocPoI
kiFYTVZGGRWZKnBohWNCUZjd13gtlqDpbKSrd5xEk1awKpsEzqBiPwMhOqES6WS5
Anrt1Ut4/7jLdx2AVNPEn2b3tP2ENpuDLZ5V7KBKhZDkq6/XMobMu/bMGczK0i7T
UGUeMOvQejb1jB5E6JCjsuEreaIqzrOnLzLU+LKFjKCZQuE2gUEsCSA7Gsnetcur
+jcAaN8mJqB/FVI7vGStx3bqmLF3mfIsxHb63HcKp0T6TyOA+Yr0xU7t8Faja4AK
kqKw0D2JJhODDT6NgPfa
=kIi/
-----END PGP SIGNATURE-----

--v541l457l4DThMFo--
