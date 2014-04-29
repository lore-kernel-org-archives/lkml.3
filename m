Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967AbaD2S7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:59:20 -0400
Received: from mout.gmx.net ([212.227.17.22]:58013 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932759AbaD2S7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:59:19 -0400
Date: Tue, 29 Apr 2014 20:59:04 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Cc: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "chase.southwood@yahoo.com" <chase.southwood@yahoo.com>,
        "unixed@gmail.com" <unixed@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: remove duplicate pointer assignments
 in attach functions
Message-ID: <20140429205904.6eb6ffdd@spike>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825E2096F@P3PWEX4MB008.ex4.secureserver.net>
References: <20140426160429.4883f678@spike>
	<DC148C5AA1CEBA4E87973D432B1C2D8825E2096F@P3PWEX4MB008.ex4.secureserver.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Ugl+tuEA7cypnLb/VnnROUi"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:wLmjK/UgBpA43a8K4CRuy3kS+lcX0ZcEEA9rFQbt1CJu53uAUwZ
 4noi0srAKJKGnQQqH/xICZN+jdB1h0rcPSApFJYfu6bWPSL24cJnoXSL6LvjMqXyBs7rP1C
 NVM5V0ElysVNjySoRa6PDr/K1aelEcIsDdjJhOaqoojL2s6Bqa6ud4g3fOHzxSXPrQECeXr
 cL40oFHQBN90w4qcQIN6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ugl+tuEA7cypnLb/VnnROUi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Apr 2014 22:36:13 +0000, Hartley Sweeten <HartleyS@visionengrave=
rs.com> wrote:
> Technically, these drivers are fine as-is.

They are. The proposed change falls under minor code maintenance only.

> They are all legacy comedi drivers and use the manual attach mechanism. T=
he
> dev->board pointer is setup by the comedi core before calling the drivers
> (*attach) so the foo =3D comedi_board(dev) is getting the board pointer t=
hat
> was found by the core.

> Unlike most comedi legacy drivers, these drivers then do an additional "p=
robe"
> to try and identify the board. This could result in the dev->board_ptr ge=
tting
> changed which requires updating the local variable for the board pointer.

The point is that while updating dev->board_ptr is necessary in case of the
manual attach use case, deriving the local pointer before dev->board_ptr is
decided is not. Furthermore it might be a bit risky to already have a local
pointer to a valid, but potentially wrong comedi struct preselected by the
core, although it cannot be used safely anyway until overwritten after the
manual probe is done.

Having had a short look over the comedi code I was under the impression that
the change would make the 4 affected functions consistent to the other parts
that seemingly follow the skeleton.

	static int skel_attach(struct comedi_device *dev, struct comedi_devconfig =
*it)
	{
		const struct skel_board *thisboard;
		struct skel_private *devpriv;

		/*
		* If you can probe the device to determine what device in a series
		* it is, this is the place to do it.  Otherwise, dev->board_ptr
		* should already be initialized.
		*/
		/* dev->board_ptr =3D skel_probe(dev, it); */

		thisboard =3D comedi_board(dev);

> These probe functions need to be looked at to see if they are actually ne=
eded.
> For now I would prefer that the existing code stay as-is.

That added about the intention of the patch, I'm fine if You want to questi=
on
the necessity of the probes as a whole and keep the legacy code meanwhile
untouched.

Regards,
Christian

--Sig_/Ugl+tuEA7cypnLb/VnnROUi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTX/Z4AAoJEKssnEpaPQKEbhgP/0Dws0R3pqBmLkgp50MTTQ2d
Jj9gVtJDDfbTvSmePhK4FtpbgQpQACclktp730FQ3Y3j41ddzmXW9Hi0cu3TdHdu
fNsEKJ2rmn2YjdXmsNvuXLfU920ACZFTNA93z1fBzzpGn+Hrro7wDYqvOhL1/9dE
RlBZntDBl3wO7AhkJeFq5TfNEoJkXk46uFWg4mESmaMkPyOuWP3Twi0NwhqY38Ql
UFK7HuXac4oLag68CzuTakMPhhooqiUUh70yOW+8y/pfmmNSTikdxLjwfT9eStzZ
XOFty9nUbrvdWKU/nsPTusPq3VCp/wtMq4ix9zv0wXKX1FFuXbC3XGXNqi4ZaIhR
2KiyhXGe85c2mKrKw+wxyrcUAIp4nWDuzbqD5OLTsW53NF8OLJaZsn+Tb8/gUKr5
KO1A7nXE38cGElHmbshY6korx3dUtxhjIKA3XAWTq1dVYMNjspxLrkHIZvWrXWLY
lQZ9WT5Oe0V7HTmUVrNJlK8JkOdubUwWTdbqsIDo1oBhmiBRvwoX1mZAKGaKFZO5
omZvLSmD+588xMK9GAS6TlyepRCqBPprsRwe+iaHNRj6blTwYECISjUkSVPbHXeE
WiVHK6Y708sKDnd4G/QIjJgFEzlSw4WQ6Q7XWADSztWVQyGhXlJuye7lYcX0uoQK
ZubKJxgxFEJleTYVkP4M
=MiAq
-----END PGP SIGNATURE-----

--Sig_/Ugl+tuEA7cypnLb/VnnROUi--
