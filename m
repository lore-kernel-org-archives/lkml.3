Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3FGGfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:35:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50358 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab3FGGfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:35:13 -0400
Message-ID: <1370586900.4149.0.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 102/184] Bluetooth: fix possible info leak in
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 07 Jun 2013 07:35:00 +0100
In-Reply-To: <20130604172134.542955449@1wt.eu>
References: <20130604172134.542955449@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-6fVLccOILRQSVZbWGyZ1"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6fVLccOILRQSVZbWGyZ1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>  bt_sock_recvmsg()
>=20
> From: Mathias Krause <minipli@googlemail.com>

commit 4683f42fde3977bdb4e8a09622788cc8b5313778 upstream.

> In case the socket is already shutting down, bt_sock_recvmsg() returns
> with 0 without updating msg_namelen leading to net/socket.c leaking the
> local, uninitialized sockaddr_storage variable to userland -- 128 bytes
> of kernel stack memory.
>=20
> Fix this by moving the msg_namelen assignment in front of the shutdown
> test.
>=20
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [dannf: adjusted to apply to Debian's 2.6.32]
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  net/bluetooth/af_bluetooth.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
> index 8cfb5a8..d7239dd 100644
> --- a/net/bluetooth/af_bluetooth.c
> +++ b/net/bluetooth/af_bluetooth.c
> @@ -240,14 +240,14 @@ int bt_sock_recvmsg(struct kiocb *iocb, struct sock=
et *sock,
>  	if (flags & (MSG_OOB))
>  		return -EOPNOTSUPP;
> =20
> +	msg->msg_namelen =3D 0;
> +
>  	if (!(skb =3D skb_recv_datagram(sk, flags, noblock, &err))) {
>  		if (sk->sk_shutdown & RCV_SHUTDOWN)
>  			return 0;
>  		return err;
>  	}
> =20
> -	msg->msg_namelen =3D 0;
> -
>  	copied =3D skb->len;
>  	if (len < copied) {
>  		msg->msg_flags |=3D MSG_TRUNC;

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-6fVLccOILRQSVZbWGyZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbF/FOe/yOyVhhEJAQqDJRAAy0bJ0jg8g8aJAPtGPgYELPLnYgoJgvO+
0tX5qPAFC4eROOyelodanEqYe7hcfbG6LrU6bEeevGP/ZhwMgRvNFKxVxsax5+rh
knBIzpB+EmZkxFinSBsB0olj75V1/2TYJ8auaYEkLlmJVvRJDb4VPBK9GY7Qb9GU
ActMe+imdJfNOdt/HSt8j2fOIm25j/c1Ubcm7gV/6fXAOdpWNlf9BNx1qcDfwEB/
Vm53xMX6x5RdMdkeqlUyb/2qKOh8IdGzsg/qiKrgJSTWaDzsYU9m+3h6NcaQxZVD
GU+zyuslc3YvVuKiM2X7EoFzEmC1f5F5D4REmeZ/qdh6PORlgv9MbzU6Tip/l+ge
pXcanzv4+KvREu+0+lqL8LnUVNfgB4KFWS7ZFJ86DLHqpgbtMA/vPacVOEOF1tEy
a6uJbAcI5EZWOcWMZ1USBKVs5dzwJ7I24oVP3EZVZOXG+0c9GRZTFRq34ZKz8YNV
t7158tnPjot2auEc7bMz5Xj6GdoNCYd4X1BpzPxuesrLg82GBtViu0f/p41QiO6X
28DglqfYzpQbQSP/4N+sRM9433NiEpAo9fV6X9ZSGm3XXc1wU3/0RsEUVAQl62R9
r/hSdVjO+hGG56CoHT9Y3+dgx+go9Ck0gU+quBlA1hbzMwrcqvIBvWVCxeH/eIcv
xyj7HUtZi/M=
=h+Nl
-----END PGP SIGNATURE-----

--=-6fVLccOILRQSVZbWGyZ1--
