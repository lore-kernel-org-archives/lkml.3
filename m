Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761880AbbA1WTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:19:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40973 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056AbbA1UNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:13:49 -0500
Message-ID: <1422462646.2709.24.camel@decadent.org.uk>
Subject: Re: [PATCH 3.4 000/177] 3.4.106-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: lizf@kernel.org
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, Zefan Li <lizefan@huawei.com>,
        Jeffrey Knockel <jeffk@cs.unm.edu>
Date: Wed, 28 Jan 2015 16:30:46 +0000
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-k0rXJ49HBy7jprGZZSlZ"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f0a4:bd81:1dc2:fc64
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-k0rXJ49HBy7jprGZZSlZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-01-28 at 12:07 +0800, lizf@kernel.org wrote:
> From: Zefan Li <lizefan@huawei.com>
>=20
> This is the start of the stable review cycle for the 3.4.106 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri Jan 30 03:58:34 UTC 2015.
> Anything received after that time might be too late.
>=20
> A combined patch relative to 3.4.105 will be posted as an additional
> response to this.  A shortlog and diffstat can be found below.

You're missing Jeffrey Knockel's fix for the regression in IPv4
identifier selection.  I can't find the original message now, but you
should be able to apply this:

From: Jeffrey Knockel <jeffk@cs.unm.edu>
Date: Wed, 12 Nov 2014 07:47:20 -0700
Subject: [PATCH] Patch for 3.2.x, 3.4.x IP identifier regression

With commits 73f156a6e8c1 ("inetpeer: get rid of ip_id_count") and
04ca6973f7c1 ("ip: make IP identifiers less predictable"), IP
identifiers are generated from a counter chosen from an array of
counters indexed by the hash of the outgoing packet header's source
address, destination address, and protocol number.  Thus, in
__ip_make_skb(), we must now call ip_select_ident() only after setting
these fields in the IP header to prevent IP identifiers from being
generated from bogus counters.

IP id sequence before fix: 18174, 5789, 5953, 59420, 59637, ...
After fix: 5967, 6185, 6374, 6600, 6795, 6892, 7051, 7288, ...

Signed-off-by: Jeffrey Knockel <jeffk@cs.unm.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ip_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1346,10 +1346,10 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	iph->ihl =3D 5;
 	iph->tos =3D inet->tos;
 	iph->frag_off =3D df;
-	ip_select_ident(skb, sk);
 	iph->ttl =3D ttl;
 	iph->protocol =3D sk->sk_protocol;
 	ip_copy_addrs(iph, fl4);
+	ip_select_ident(skb, sk);
=20
 	if (opt) {
 		iph->ihl +=3D opt->optlen>>2;
--- END ---

I think you should also pick commit 5188cd44c55d ("drivers/net, ipv6:
Select IPv6 fragment idents for virtio UFO packets"); my backport for
3.2 (commit 540aa5b743b3) will probably work for 3.4 as well.

Ben.

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-k0rXJ49HBy7jprGZZSlZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVMkOtue/yOyVhhEJAQrD0w/6AjdEYARq2M8myDuOQRsw+ATyvaoKtQsQ
R3TH9lW4bXwAbnLUhWbSa9tb9yLeOW8qtZTme9T3hmDq4Mr9peO1lGgqS24IvwRh
mamHoZTV+wSxtlBsxq6dscHpcrmYdghhCv8+cjodz5jv9P8m/JpccelPaV1KyDT+
rqZQ6nQRWV/Fwan9KJz5DP40vuyPMsl1EElZvKQeJA8U3/8MnQzNN4QkO9VTccmQ
Wc+xCDQlTYYqno8Z6e9Ubd1wBjA0U0ZUapxsWfUGsMuruqHRD1qFdXZufWPBeJkZ
qxV4r7YqDvf7plNWWuB8FxerCk9WPEUC5dwd+TZbDrBRmaVjUOGa67/feqM/ZlP8
zQjN+mOu481kolGXBMqUPkNWw11SNQc46OOaOZWoGi+Ci+n41fo7x6wHiMbvLoEF
t2XKwIoAY2vtjskRNHBZKrB/OA+Alq/RcxnI5AcaPDzPA+pV8gB/QvrSf2GkNLP4
ybIOpz6vK+hlh+uib8z7j6Tcl7QyQV1bTf7I+df4rMwDpHxIq3IFHlb9f61gnico
rNpU3aWF7cUSkK2pPvZo6xzO/ZvLmKPTAnriTJYhn/wqmoHTeKGkoUBWqbJ38ryU
cspPBw1G387VU61OUJUEA9mXMmyDqNUH8rubVLnJAHzgAifY92OwMzbNBs4ge7HA
Bt5+Z4iKs0c=
=gdrF
-----END PGP SIGNATURE-----

--=-k0rXJ49HBy7jprGZZSlZ--
