Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724Ab3GWRca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:32:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57967 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab3GWRc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:32:29 -0400
Date: Tue, 23 Jul 2013 20:32:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Illia Smyrnov <illia.smyrnov@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] Input: omap-keypad: Convert to threaded IRQ
Message-ID: <20130723173227.GA9636@radagast>
Reply-To: <balbi@ti.com>
References: <1374595798-15492-1-git-send-email-illia.smyrnov@ti.com>
 <1374595798-15492-3-git-send-email-illia.smyrnov@ti.com>
 <20130723172501.GC9166@radagast>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20130723172501.GC9166@radagast>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 23, 2013 at 08:25:01PM +0300, Felipe Balbi wrote:
> > Convert to use threaded IRQ.
> >=20
> > Cc: Felipe Balbi <balbi@ti.com>
> > Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
> > ---
> >  drivers/input/keyboard/omap4-keypad.c |   29 ++++++++++++++++++++-----=
----
> >  1 files changed, 20 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyb=
oard/omap4-keypad.c
> > index c727548..b876a0d 100644
> > --- a/drivers/input/keyboard/omap4-keypad.c
> > +++ b/drivers/input/keyboard/omap4-keypad.c
> > @@ -112,8 +112,22 @@ static void kbd_write_irqreg(struct omap4_keypad *=
keypad_data,
> >  }
> > =20
> > =20
> > -/* Interrupt handler */
> > -static irqreturn_t omap4_keypad_interrupt(int irq, void *dev_id)
> > +/* Interrupt handlers */
> > +static irqreturn_t omap4_keypad_irq_handler(int irq, void *dev_id)
> > +{
> > +	struct omap4_keypad *keypad_data =3D dev_id;
> > +
> > +	if (kbd_read_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS)) {
> > +		/* Disable interrupts */
> > +		kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
> > +				 OMAP4_VAL_IRQDISABLE);
> > +		return IRQ_WAKE_THREAD;
> > +	}
> > +
> > +	return IRQ_NONE;
> > +}
> > +
> > +static irqreturn_t omap4_keypad_irq_thread_fn(int irq, void *dev_id)
> >  {
> >  	struct omap4_keypad *keypad_data =3D dev_id;
> >  	struct input_dev *input_dev =3D keypad_data->input;
> > @@ -121,10 +135,6 @@ static irqreturn_t omap4_keypad_interrupt(int irq,=
 void *dev_id)
> >  	unsigned int col, row, code, changed;
> >  	u32 *new_state =3D (u32 *) key_state;
> > =20
> > -	/* Disable interrupts */
> > -	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
> > -			 OMAP4_VAL_IRQDISABLE);
>=20
> looking a lot better, but I wonder if you should add a mutex to this
> threaded handler, but I guess there's no way this will never race since

s/never/ever

--=20
balbi

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR7r4rAAoJEIaOsuA1yqREUPsQAJ/XGjI6hr1xErQnDOaYS5cB
DtMggrmZvpZ+gEsS602olbYfyYg1mZQwS7gIVAgVrw0vAI/C1rDoTs0lZLiLDA1I
5tXER4UTeMusLuQBg92GOEHn8bCiak4lHLlvRSYrW7XbuOPaFRr4T31wd2czs8RN
zja7T/qqSq4ibVENP/nPmRJ3bnbQAZHDs7DmvO+0zJXl2+TP426CxDF9ZvloBiHW
2sgxny9X+IiDHYQhPkF/2vvN/TOlvRmgr3LFWdOhD8dJ5kCU1Uyxvt4uuKlgdpZM
oWbMrMcF39YmPi58Q3Axr6Aa5meOg3DHQPbjj3+1xSr52thfJN3FA/fZhc4AxYvi
g2kDLK5zGbg1qSg7qxtrc52rEnhIT6fkTYsH0z4Nu3ay+5PcEMdQl9Eikva4J4/k
uQ2ifyGVU9t+I8t8J+A4NGjzSe2FC+CrgmiR7igSOb3Z1dfg2vrKAZUKC0ixM6yt
8ck48DCdoRJjAXoANEw29E+vYHaYjDu+9vEe7+8Y6NtrpVRogB3oqdO5VpieBIvg
537qI0H2OweqWFbP4Lrgr2P+Ca/JdH6MLHYz97Ey/l5sWmfOzvBH9FDTxVUapv0Z
vBhf3sEZYo+tIybKkYeO3Lc6LEh//vcR+o79MLyV93i/KbC0yRJNwz65l/M0Dlgl
GMolJCn3Mv+eI8X88sP9
=QG6h
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
