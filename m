Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3GYEQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:16:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47971 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637Ab3GYEPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:15:23 -0400
Message-ID: <1374725713.18653.49.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [40/85] net/tg3: Avoid delay during MMIO access
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Date: Thu, 25 Jul 2013 05:15:13 +0100
In-Reply-To: <87zjtbzz8j.fsf@canonical.com>
References: <lsq.1374674565.832521875@decadent.org.uk>
	 <87zjtbzz8j.fsf@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-A74DR2pg4C+FjtrL5I9R"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A74DR2pg4C+FjtrL5I9R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-07-24 at 17:42 +0100, Luis Henriques wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>=20
> > 3.2.49-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: Gavin Shan <shangw@linux.vnet.ibm.com>
> >
> > commit 6d446ec32f169c6a5d9bc90684a8082a6cbe90f6 upstream.
[...]
> > @@ -3067,6 +3085,10 @@ static int tg3_halt_cpu(struct tg3 *tp,
> >  			tw32(offset + CPU_MODE,  CPU_MODE_HALT);
> >  			if (tr32(offset + CPU_MODE) & CPU_MODE_HALT)
> >  				break;
> > +			if (pci_channel_offline(tp->pdev))
> > +				return -EBUSY;
> > +			if (pci_channel_offline(tp->pdev))
> > +				return -EBUSY;
> >  		}
>=20
> I believe you didn't want to have these two invocations to the
> pci_channel_offline() function.  i guess you wanted to have one of
> these moved to the other branch of the 'if' statement.

Indeed, and I've dropped this patch.  This was partly due to a bug in
the patch command.  If there are two consecutive hunks which only insert
lines and have the same context, and it can only find one match for the
context, it will apply both insertions in the same place.

Ben.

> [ btw, I've just replied to an email by David S. Miller about his
>   backport to 3.4 (and 3.2) of this commit. ]
>=20
> Cheers,

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-A74DR2pg4C+FjtrL5I9R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfCmUee/yOyVhhEJAQrALA/+P5/v/G6Tip+FOsTxAVEQeBu9hdRpD+4F
B8u1AxmJUg5WitZEd/nyexmJtz50bGBoCsUwE4kbWeqTHKbMR/B31btq3KOFk+Jd
Azwxy1iWSAhl3kW1HGh9H/mywHfpw75ypRLUDkSgPNQnuOwcWbmiH3H5wr6m8Jw3
pv9mZAKz9cFzeRfwbejsqpPHDPmtg49JQ9FbffD77u3NbQLuJbokfy38rm4day7U
ZzaFv0xefIwDT22RKIH9D1aNuxE147pi/+CppDcBzS2OvoVLZyoPvaHjYMBz5yEk
6RfHpiWBCxo+OP/9ctUD0Nbk5qp/LPlyiyBvSQkrYYKIRssJuNv62hmmMV38nhys
dYeD++vnW5QELpPB9D1NIaXccV5p+icbMlsuScp+OtS46SxYCTlBXXXo1XD7EJmT
+v0AuHuS/EU48PebxAm6yq1rvT27dlGK0vYpJHySLDD+z20Stw6WyL2JnAnf7oXi
Qo9BH6LMQXPTFSd+KUydm1O/2bqRYAYIAePiQNaxzm2gXIyjE3wo3xhlr759TFRs
U6BxC0vEagyNoDcauHc/I7/0Kooex7aNGwmkfV0vA4JzdwA54FGoNOsI62t2IdRx
U0iO4dohSSCkv4jc2uwQjWWt4yk8D+TGVOoOxxEVV11G2rHi/Llv+BcsNf5UIWRd
3NKOZQ52wqI=
=NHbQ
-----END PGP SIGNATURE-----

--=-A74DR2pg4C+FjtrL5I9R--
