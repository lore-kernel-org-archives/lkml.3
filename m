Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaCITsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 15:48:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51329 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbaCITsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 15:48:02 -0400
Message-ID: <1394394475.15968.25.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH net-next v2 10/13] r8152: support IPv6
From: Ben Hutchings <ben@decadent.org.uk>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Sun, 09 Mar 2014 19:47:55 +0000
In-Reply-To: <1394002168-3193-11-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	 <1394002168-3193-1-git-send-email-hayeswang@realtek.com>
	 <1394002168-3193-11-git-send-email-hayeswang@realtek.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-u6mNg2t3ZiHbmTT/OYJH"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.245
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-u6mNg2t3ZiHbmTT/OYJH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-03-05 at 14:49 +0800, Hayes Wang wrote:
> Support hw IPv6 checksum for TCP and UDP packets.
>=20
> Note that the hw has the limitation of the range of the transport
> offset. Besides, the TCP Pseudo Header of the IPv6 TSO of the hw
> bases on the Microsoft document which excludes the packet length.
>=20
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 107 ++++++++++++++++++++++++++++++++++++++++++=
++++--
>  1 file changed, 104 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 8f6d0f8..8e208f30 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
[...]
> +static int msdn_giant_send_check(struct sk_buff *skb)
> +{
> +	const struct ipv6hdr *ipv6h;
> +	struct tcphdr *th;
> +
> +	ipv6h =3D ipv6_hdr(skb);
> +	th =3D tcp_hdr(skb);
> +
> +	th->check =3D 0;
> +	th->check =3D ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
[...]

I think you need to call skb_cow_head() before editing the header here.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-u6mNg2t3ZiHbmTT/OYJH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUxzFa+e/yOyVhhEJAQo6sBAA0lYYFOvhPfsJhWdjXkuP3am7mqbyqOGO
s9sVsBPYg6fDBQzGmMYB2zn+gIi7wPNQGX0/UQPQePHbcxmCxkTw7Q+CarCzeYrP
arodhyaUOOdlwJMsz7VGN03j7NIx3Gu4QH9z/gqCw6JUAraREYJlenfgdVa5uGz9
sNsQpxjhjtYPI6YfWlh/QLHfFvG8AJL8F4pOWINz0LXaoEr2QvuLGHwd4pvN+fn/
Ts2sYuCnC2DMtU0nTzKmkIUKXEPj5WigwE1dKynvS585eMfu+T+2908oeoDY71WU
7iO8G0ZEINOQspqEhYzzVc/AmhD5qwVLBFHYX5D54FYOKsJ6mcoYFugpV3c5ZOXq
5u0eRE1HVA9icTj/Eqp5nz9VEmPnRpd6OhqQB6XPn9S20jGH53b4fxj0DoYiWL/4
6KeLg1z1uL4Dd5Aa461Ud/72QFCpkNEw8JCqOUdiXZ48QH0FIDvcjOiDHuC+GLKv
/Q5vBskmzRW75enH4TGjrKhUWT3IV+FGErhckobRpz/4lsNPG/bXazhZWJ9/WLrE
sF1+gdFDaf2cYUQ9llK2qLYlAOc5D5BLDMvBqVFxAAMkkUpXjqrYr1q/jfd2ac+J
ichjvfg52a2TzTXMi3P1LW01QL8xfUu3QDyBUc13+Y1TABLRcVmPllD53t0I2L5N
C91FwTDQcUA=
=WjG0
-----END PGP SIGNATURE-----

--=-u6mNg2t3ZiHbmTT/OYJH--
