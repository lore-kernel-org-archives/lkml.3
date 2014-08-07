Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaHGGvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:51:45 -0400
Received: from ozlabs.org ([103.22.144.67]:45494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbaHGGvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:51:43 -0400
Date: Thu, 7 Aug 2014 16:51:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <antonio@meshcoding.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Ken Helias <kenhelias@firemail.de>
Subject: linux-next: manual merge of the akpm-current tree with Linus' tree
Message-ID: <20140807165136.60cbaf44@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//ud=Rf09rjtE0Jd_JMe3Y3z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//ud=Rf09rjtE0Jd_JMe3Y3z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
net/batman-adv/fragmentation.c between commit d9124268d84a
("batman-adv: Fix out-of-order fragmentation support") from Linus' tree
and commit ffe04af00b27 ("list: fix order of arguments for
hlist_add_after(_rcu)") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/batman-adv/fragmentation.c
index 022d18ab27a6,16dd40910c65..000000000000
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@@ -181,14 -180,11 +181,14 @@@ static bool batadv_frag_insert_packet(s
  			ret =3D true;
  			goto out;
  		}
 +
 +		/* store current entry because it could be the last in list */
 +		frag_entry_last =3D frag_entry_curr;
  	}
 =20
 -	/* Reached the end of the list, so insert after 'frag_entry_curr'. */
 -	if (likely(frag_entry_curr)) {
 -		hlist_add_behind(&frag_entry_new->list, &frag_entry_curr->list);
 +	/* Reached the end of the list, so insert after 'frag_entry_last'. */
 +	if (likely(frag_entry_last)) {
- 		hlist_add_after(&frag_entry_last->list, &frag_entry_new->list);
++		hlist_add_behind(&frag_entry_new->list, &frag_entry_last->list);
  		chain->size +=3D skb->len - hdr_size;
  		chain->timestamp =3D jiffies;
  		ret =3D true;

--Sig_//ud=Rf09rjtE0Jd_JMe3Y3z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4yH8AAoJEMDTa8Ir7ZwV4Q4QAJFEFUgY5o2Et8ufaG2tzhwQ
g0MsDvjlnemYIK47N3Xk0TKYYZqpyW5dcCaKZfjkRM4WZXUWBesZEXnJsAih0eOb
P4fLCghjeL8/ChIb80b40HnJqLf9aieJ5sEl92mwpl+Z6ZeAgpn1deXb+SZISYkb
ipklnIEaz2f0sqMMJ156jfphNEn4hPX2wCWvMDLXRSu3SKeJZ0CNSOMn6o0H/06S
FFTFZf1uDkSj6TwNO1/G+M82YdRsen6bpU6f3rbKesMrmFWru9QAbt6Mupq9iBQT
n9LwK+gsqFtBZNd26XcttcBd+UcY+sby0HDdKVUpUMDi4sPl5Clx0wBvF4M0MSLT
9qp7vCHTTUdFXHG1v8qS6TG5wCy8BfQ0+xf8livaxmTN3Z/fRKaNCQW5lOaIJsqg
lWHd0dQ3UsIDK7bYftOBeH5yO2hLilsuujPE+TfCDaF/SiryDr1hgViTHe2RmM07
/ew32MV+3b5O20u1BN7YR58lSfjnNXqnn784+eqP5LM24BAfWvHY8rRIUWfuUHjC
b2OEBCqyaiFsvoHt+u8VCDvSfViZFycboXNKV8z8mCi2zcESz/Sul9uiR+1pe0Wd
3Gg3O5PkiWGFyUbvYhyfcfNXgp5+Y/sTETqA05edhe0WStYTOcCrMAVs6CMZOavO
RnWootYA/2k+0K413T4v
=iL3b
-----END PGP SIGNATURE-----

--Sig_//ud=Rf09rjtE0Jd_JMe3Y3z--
