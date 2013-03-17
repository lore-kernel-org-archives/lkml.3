Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750955Ab3CQEGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 00:06:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53719 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699Ab3CQEGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 00:06:46 -0400
Message-ID: <1363493197.3937.241.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] tty: Correct tty buffer flush.
From: Ben Hutchings <ben@decadent.org.uk>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-serial@vger.kernel.org
Date: Sun, 17 Mar 2013 04:06:37 +0000
In-Reply-To: <5134F3CD.3020805@ilyx.ru>
References: <50BC76E9.2070703@ilyx.ru> <5134F3CD.3020805@ilyx.ru>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xL337aW7h21SNm6HEK1P"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xL337aW7h21SNm6HEK1P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-04 at 23:19 +0400, Ilya Zykov wrote:
> On 03.12.2012 13:54, Ilya Zykov wrote:
> >   The root of problem is carelessly zeroing pointer(in function __tty_b=
uffer_flush()),
> > when another thread can use it. It can be cause of "NULL pointer derefe=
rence".
> >   Main idea of the patch, this is never release last (struct tty_buffer=
) in the active buffer.
> > Only flush data for ldisc(tty->buf.head->read =3D tty->buf.head->commit=
).
> > At that moment driver can collect(write) data in buffer without conflic=
t.
> > It is repeat behavior of flush_to_ldisc(), only without feeding data to=
 ldisc.
> > Test program and bug report you can see:
> > https://lkml.org/lkml/2012/11/29/368
> >=20
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
> > ---
> > diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
> > index 6c9b7cd..4f02f9c 100644
> > --- a/drivers/tty/tty_buffer.c
> > +++ b/drivers/tty/tty_buffer.c
> > @@ -114,11 +114,14 @@ static void __tty_buffer_flush(struct tty_struct =
*tty)
> >  {
> >  	struct tty_buffer *thead;
> > =20
> > -	while ((thead =3D tty->buf.head) !=3D NULL) {
> > -		tty->buf.head =3D thead->next;
> > -		tty_buffer_free(tty, thead);
> > +	if (tty->buf.head =3D=3D NULL)
> > +		return;
> > +	while ((thead =3D tty->buf.head->next) !=3D NULL) {
> > +		tty_buffer_free(tty, tty->buf.head);
> > +		tty->buf.head =3D thead;
> >  	}
> > -	tty->buf.tail =3D NULL;
> > +	WARN_ON(tty->buf.head !=3D tty->buf.tail);
> > +	tty->buf.head->read =3D tty->buf.head->commit;
> >  }
> > =20
> >  /**
> >=20
>=20
> You can include this patch, in 3.2 series , for improve stability,
> it would be merged in upstream 3.9-rc1.

Added to the queue, thanks.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-xL337aW7h21SNm6HEK1P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUVBTee/yOyVhhEJAQpafRAAqIUtLIB3ekURM1dUy5MecGG8G2NLyiDV
5mJJhk85382xJ7ac9yxlWI2KWfiQP3o2c1dRw8c4ScybFZLxbkowSThZ21JGKGVq
UrMjZQOUiO7PG2ro+L+KL1du59LIlGrBhjR1aDSgasS8EbPpcbVPD200U/iTZ+lF
2c4rqk7KxPGEF7tTp7c+otGJYLj92qVfhicJPJwboYUbT4U+RM4CdGiXegNro4Di
tMxu5QRDGVLV1OiNIN6x784fWmz5qBdv3oy5WcE7Gi09um6x/cfxDZHWN5OHD0LK
QrPqV1RCHWHSduTURR3S0o79ODQ6AIiY92wOybrXcM5y+WnVvmk0VDqfp8zH4UZ0
rNqV0ZFWFelEvDVnLsmV0ch8x38MrYg7MfBsjDlyAAyjpXTjJ5AZsHM3xEyUXlL7
ttR37w1OhEvHZKuTOBDhlPPXS30/mP+qH1rLmWY5JUKQao+jfdwzD8TAmKO9hRlo
V8otd5jaue/kymFIm6RgwiX+tt3J5CE7AYazZYCpqvtYxK7Smzq385aj8+s4WZVx
UsFl3ko4BhzjgvQTk5KJosZFhvfSppR1w3hKcdPkp8cJMcGwS5LCVQkjIT8xREvl
fNJRb2Tl98sZUXniliFwOmX8LThHrXO444L1rOO4v3n91PYg2qqVVIR/Auv/rKn0
+4BmP0S/7dE=
=3jsf
-----END PGP SIGNATURE-----

--=-xL337aW7h21SNm6HEK1P--
