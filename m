Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3FGGUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:20:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50314 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971Ab3FGGUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:20:31 -0400
Message-ID: <1370586022.4021.95.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 183/184] irda: Fix missing msg_namelen update in
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Samuel Ortiz <samuel@sortiz.org>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 07 Jun 2013 07:20:22 +0100
In-Reply-To: <20130604172137.889614525@1wt.eu>
References: <20130604172137.889614525@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PHYEV+jl0rStg7tPH3Su"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PHYEV+jl0rStg7tPH3Su
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:24 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>  irda_recvmsg_dgram()
>=20
> From: Mathias Krause <minipli@googlemail.com>

commit 5ae94c0d2f0bed41d6718be743985d61b7f5c47d upstream.

> The current code does not fill the msg_name member in case it is set.
> It also does not set the msg_namelen member to 0 and therefore makes
> net/socket.c leak the local, uninitialized sockaddr_storage variable
> to userland -- 128 bytes of kernel stack memory.
>=20
> Fix that by simply setting msg_namelen to 0 as obviously nobody cared
> about irda_recvmsg_dgram() not filling the msg_name in case it was
> set.
>=20
> Cc: Samuel Ortiz <samuel@sortiz.org>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [dannf: adjusted to apply to Debian's 2.6.32]
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  net/irda/af_irda.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
> index 476b24e..bfb325d 100644
> --- a/net/irda/af_irda.c
> +++ b/net/irda/af_irda.c
> @@ -1338,6 +1338,8 @@ static int irda_recvmsg_dgram(struct kiocb *iocb, s=
truct socket *sock,
>  	if ((err =3D sock_error(sk)) < 0)
>  		return err;
> =20
> +	msg->msg_namelen =3D 0;
> +
>  	skb =3D skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
>  				flags & MSG_DONTWAIT, &err);
>  	if (!skb)

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-PHYEV+jl0rStg7tPH3Su
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbF7pue/yOyVhhEJAQoTxA/9GOLSxvkOGfyGO6u56xxZ8LNXSChXAcHn
y+5XLaTDFZfE3ihzq2/L1Lq85qh5M48zPWNcBXRQax0LZMF2CtgrBiRvmn7NJ+xq
dVp7VQw9VcMXA0zBq0qi5sfjmk96mc4Gk8qDDOCUgfqK7k+C85djLl/XidMG+Pp/
t92GIHydJuFv+BeUGstTko9o+AZJ2b2HMkbXRa3Tpa5yctdSHhMSgoyFtTOF8hgc
Xno0OF4HS7Ljm2R0kLPlwps74ySwmOOCJohxCVaYqpKM1wLHIUfWVALSyd8rIP2N
YEVNdMn0ReeE4bZlr4ttGcv0xTcsC5toEiZJovcRbRRVD3CJn9Ps8AfPiVryxH2N
EQfQ3TyuP885IenKNoao4s7IpVYsN/TcungwR2kZrnAsh3kbE27Ju1aYihgnFC6l
72qo+I7NW6TtqhJW4Vh+A5HOq68tE7mQHCkLP1eMH8sCfvijyyyUCgLl8q6dSmoV
kNxhCDyLzHvYj4ad67XmkQ2Ih+Xgu9FgYXplL7f2yL+6pVec8MsJDfgQbwfaBGTe
C1aUIGk4TAVG5mSmDj1/kgaf3gVrGqtqaTWhsEi8L5gyzZ2I27Ewed2KHLlcJwvz
rNN3RCDcetHnMvQ+LolXdxWZcU1tIbg7Svmml+ahEQTFPHLpd+qLqCo7omoLgjXO
ZPnjYnOWKVI=
=HZMG
-----END PGP SIGNATURE-----

--=-PHYEV+jl0rStg7tPH3Su--
