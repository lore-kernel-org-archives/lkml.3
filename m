Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaI3IEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:04:41 -0400
Received: from ozlabs.org ([103.22.144.67]:51305 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaI3IEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:04:32 -0400
Date: Tue, 30 Sep 2014 18:04:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tapasweni Pathak <tapaswenipathak@gmail.com>
Subject: linux-next: build failure after merge of the staging tree
Message-ID: <20140930180416.5ae64587@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/J5+WwcI5a13hTmNLCGK7RP6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/J5+WwcI5a13hTmNLCGK7RP6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64 allmodconf=
ig)
failed like this:

drivers/staging/media/cxd2099/cxd2099.c: In function 'slot_reset':
drivers/staging/media/cxd2099/cxd2099.c:537:4: error: expected ';' before '=
if'
    if (ci->ready)
    ^

Caused by commit 7b86477c0e5b ("staging: media: cxd2099: use
usleep_range()").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/J5+WwcI5a13hTmNLCGK7RP6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKmQGAAoJEMDTa8Ir7ZwV08EP/jcgCUJOJ8h2EGHdbtd4qwua
fp+tDzgHgQcy9qe8+ER/9ImL5NWy6ORwyepVrv+yAmGDn6eOcZrY96pfrk3Ry40X
8SmzzUFZrH+WgIkfvw5XXOiNVf1dQPZ79sVPT7v4y9a6oacDD0QYEhy3kRqZcOS9
0i7ExMJteJmEycif5R2rJFEm/hBlHT4chzY9eWNCZOW+xOgKYUqRyZzs5NHJsIxF
52PZaFSc7L86vinhsjZm8bF7m2QgGVjJIJ1JN0qolMyakcWrA+POXkiO4FtGAxFa
wZSNfQtah8NHwhZi6Dtz8n7Xa89bdASvUUs1vLaJqWMqMhpABb25DYcIUhEN+Rnb
kVR1uTpndn4n1SVib0qYrCtYbR4JyPDAs8rg03HuzKpe0zF6+XmxbrVCqFlbG9WE
DZlMJeR2Th0kfUt4fgHetzGjDTmztmdMeD1FWkzNiS+0OrUdUQnG5n0MbqMPJdg2
HZD0hrPeutPGnncfg/VOB4TIDjz4/QiMk6IxVARPujZsnZhCWlYLi0jbI3XXQCTu
vGritbomRd7s98wM8+rRWeqz//M/sj9wUicV85i/WGok4oua2HCxJfuA1sA2wAST
9BJP0eqXfCJxC9zJqQmNMuNjp3RcfC74/2l2rKc++a5ULIrQix7BWSZyQz13tHLp
5c4ovbvqiivoBm6+9yZ3
=oK+y
-----END PGP SIGNATURE-----

--Sig_/J5+WwcI5a13hTmNLCGK7RP6--
