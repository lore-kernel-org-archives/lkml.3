Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3JRM60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:58:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45687 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3JRM6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:58:24 -0400
Date: Fri, 18 Oct 2013 13:58:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131018125814.GL2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jQPBlZt6jIpLStwc"
Content-Disposition: inline
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: manual merge of the net-next tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jQPBlZt6jIpLStwc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Today's linux-next merge of the next-next tree got a conflict in
include/net/dst.h between e87b3998d (net: dst: provide accessor function
to dst->xfrm) in the net tree and a4023dd01 (dst.h: Remove extern from
function prototypes) in net-next.

I've fixed up as below and can carry as required.

diff --cc include/net/dst.h
index 3c4c944,211dcf1..0000000
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@@ -479,22 -478,10 +478,22 @@@ static inline struct dst_entry *xfrm_lo
  {
  	return dst_orig;
  }=20
 +
 +static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
 +{
 +	return NULL;
 +}
 +
  #else
- extern struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *d=
st_orig,
- 				     const struct flowi *fl, struct sock *sk,
- 				     int flags);
+ struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
+ 			      const struct flowi *fl, struct sock *sk,
+ 			      int flags);
 +
 +/* skb attached with this dst needs transformation if dst->xfrm is valid =
*/
 +static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
 +{
 +	return dst->xfrm;
 +}
  #endif
 =20
  #endif /* _NET_DST_H */

--jQPBlZt6jIpLStwc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYTBiAAoJELSic+t+oim9KTYQAIGjhZKJLoqZE9vJnzmMhTYT
wgisleRj26gRmfA4Sq2IdiWx80SA7oKtEnZej0IV5Y8rFU/uXdTP6nMSl5chUyhI
Ip1AHVqetBZwAgB8LFKZxYk0P29wrJmEq6q+iCrAzm5SYwKoZDtFDKtB1zJHG5Fs
LVni0VwUlXxrrMFByzHkYbW3tLHGc9YlQZWVZw9LFwyMbVlcCxpHz72LCEIswA+g
zXYWg83iUwXngqxAobKTqzcuR03vvxsLaee+qlkRWdrwDs+W53KcZRfzq6yE9M/E
e3kLilDo6zQjD1EpOLgPzG1+I951OeApThOYirg89JX2IB0aj5IVb7WRWbQgSlnW
ru0lqQ54XTuajFQQH658PGBbhW2mpSWqbAB5HhbuIthpQ7KJHmwi8t5u15R1/5tM
p9L5g0DK/7FJV7hBh87cYiYer63Lgc43y4PWLcexS6r8JdMBjrzXnQOwb882qsg6
oK33LuQwBoyxnOFckp4hDdTaa64O/sdqyHWk6Tnp7pejpO7zYBzrIFqKOTxUvwKx
rOuLUb8li47UvBQOemBSV5WCAtIVoNm6/evjIZ0gl5CxMBVz9zWYwjuavPiKvzLU
qSJK7y6drnn7eM3pN46bmbPgu0w/Uglqy7MFSDExpWXnu4wDP0LQu129p3pkG2El
xMGP213lPGXsWvAZJV5k
=Z5sp
-----END PGP SIGNATURE-----

--jQPBlZt6jIpLStwc--
