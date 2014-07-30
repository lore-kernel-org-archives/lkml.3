Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaG3Agv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:36:51 -0400
Received: from ozlabs.org ([103.22.144.67]:44857 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbaG3AgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:36:24 -0400
Date: Wed, 30 Jul 2014 10:36:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>
Subject: linux-next: build failure after merge of the net tree
Message-ID: <20140730103617.1a9690de@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/0ZsdLLQM0BZlXm=WAQbv8Ki"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0ZsdLLQM0BZlXm=WAQbv8Ki
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/net/usb/cdc_subset.c:360:15: error: 'dummy_prereset' undeclared her=
e (not in a function)
  .pre_reset =3D dummy_prereset,
               ^
drivers/net/usb/cdc_subset.c:361:16: error: 'dummy_postreset' undeclared he=
re (not in a function)
  .post_reset =3D dummy_postreset,
                ^

Caused by commit 20fbe3ae990f ("cdc_subset: deal with a device that
needs reset for timeout").

I have used the net tree from next-20140729 for today (i.e. up to
commit fe26566d8a0515 ("bnx2x: fix crash during TSO tunneling")).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/0ZsdLLQM0BZlXm=WAQbv8Ki
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2D4FAAoJEMDTa8Ir7ZwVqeIP/2vav/H/HJSk9zlUTdFRBWbP
ID8yGwJYOZaEuq4XUH5h0leTkHvsbHo7gH3U76vEb8Xhusg/wGqgmL3cMP6ZPOeL
ZfQlUX+3RdXg7PK6LtaACzIR2Blw5Zd5FBFX2bN4BIue8ftMJSJXqCSbL5Pufczi
b7gRsRYH2jA1+OpPOtx3g4v1eSd3KR0DFWbjr3OBjJSh9nc5SMsfMxLMPHDPrvDm
Jg02S1ICv9CrmFT8qr+xlA8a8Gjey4/hssrz5bFevR/EDEmkmMJrWByWWwbwNBqh
HS0N3V9uvaeRoP4cba7QkMYpaHofGWs69O7lSiyDEmmp/FLP1aTl3P1oMs8SYjcG
9Ze1yX0pR82l9+pD9g5RWz5F0JU+kh/n1MjPViGomdLDZEpv4hRec7OdDv6IgTYl
e/OMmHKW3eGtn4yWuNsTIyhCAoIOyORW5YC1qFQcOK5as0Ng/q4KJJIO75MDIpz5
T8b9n9UomkKV7oGJ3mISkKgv7pwYFNuxbFYwmhYqkj8EaFMsfwz0KwyFzOMMwMaZ
CkFrxrzWPXmhdReATiRaNkzdjAfgbSlQJ4iW80eJtI63BFyS50N7iq44TxgotnQI
jljNlTtj6sxlhp0fpjLN2u9b81t0kvxK2jxmDZobxQwkD0/XPtDs02R0XfkcMVto
BE5hiA332bj8HF2/qtrm
=x0Ja
-----END PGP SIGNATURE-----

--Sig_/0ZsdLLQM0BZlXm=WAQbv8Ki--
