Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3C0E2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 00:28:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52198 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860Ab3C0E2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 00:28:51 -0400
Message-ID: <1364358520.3520.38.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 64/86] IP_GRE: Fix kernel panic in IP_GRE with GRE csum.
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 27 Mar 2013 04:28:40 +0000
In-Reply-To: <20130326173610.108770791@goodmis.org>
References: <20130326172059.136127374@goodmis.org>
	 <20130326173610.108770791@goodmis.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-krOoFXibGgArlqnZWIYc"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:e40a:77e1:ece1:499b
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-krOoFXibGgArlqnZWIYc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-26 at 13:22 -0400, Steven Rostedt wrote:

> 3.6.11.1 stable review patch.
> If anyone has any objections, please let me know.
>=20
> ------------------
>=20
> From: Pravin B Shelar <pshelar@nicira.com>
>=20
> [ Upstream commit d0a7cc630a337b0f56dc145e7eb6232852b14dd4 ]
>=20
> Due to IP_GRE GSO support, GRE can recieve non linear skb which
> results in panic in case of GRE_CSUM.  Following patch fixes it by
> using correct csum API.
>=20
> Bug introduced in commit 6b78f16e4bdde3936b (gre: add GSO support)

That commit went into 3.7, so I don't think this fix is needed for 3.6.

Ben.

> Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/ipv4/ip_gre.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index b062a98..3ee08ce 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -946,8 +946,12 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff =
*skb, struct net_device *dev
>  			ptr--;
>  		}
>  		if (tunnel->parms.o_flags&GRE_CSUM) {
> +			int offset =3D skb_transport_offset(skb);
> +
>  			*ptr =3D 0;
> -			*(__sum16 *)ptr =3D ip_compute_csum((void *)(iph+1), skb->len - sizeo=
f(struct iphdr));
> +			*(__sum16 *)ptr =3D csum_fold(skb_checksum(skb, offset,
> +								 skb->len - offset,
> +								 0));
>  		}
>  	}
> =20

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-krOoFXibGgArlqnZWIYc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVJ1eOe/yOyVhhEJAQpw1g//Wmplgra4VdENklcVFjPDaOfcSrG7CXxA
J8GVfGy6YXG8FnGhoUvWEa6bmqoUNHxJfBgz1hFP2ubRiSKvzAoKXOXCtCTq3ZBD
8yxMGuU71+bI3+XzhHZgFWlsGyF2I6kyjdWn/1q+X4KQYWLLG0Vix/CBKOuLGAQq
kHIBtKuTS2SMbNGxYYXxWzBgZBy18SLi77g50zqV5eNk5yENasTsznm0qF3ibN5s
5J625AlcSZPWkhk3tLRCnN2aeYd2HrsydhY0T0/3J8tjP4gQJSzFzvxRHgBXmMkF
cy7uOjLpyAiqjNHou0ZBiw9hDcQyYe6LpBuk4nvAkAosyCGvi3Ni1E5Ya1hj7ZzM
DHJMY9SV9OW9o2IPyFYqZOkmxRp/swdH1ldukrEyoPK5oRw2mFurWicYWy+GZ/5Y
EKLG3/jgkZDCVzziGHYJCWpsGxq++0/RO8ajgxa0AwY9Gva2oR0Z9qJ4WW35Um6/
AjHfDR4jY7Dcw2PEwGEwE7W32fiqMw3d0naMSmyNYpUzLgxmmtRaqfS4DdNQI2Wv
mfN7ijdWMA4AFN5xUB0NbuOEqLPblIYmiysfXIypXjMMl16VadS8TCUEH8sis4C3
NrXq9FORPF+rScoH1GeHOfDQa5et6mqCZFOMQxAFhSDHCChxmTBpoFBlbjer6HXe
QsC+82qDL3k=
=+WdO
-----END PGP SIGNATURE-----

--=-krOoFXibGgArlqnZWIYc--
