Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab3DCLLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:11:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759519Ab3DCLLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:11:00 -0400
Date: Wed, 3 Apr 2013 07:10:54 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (nfsd
 tree related)
Message-ID: <20130403071054.45a02a88@tlielax.poochiereds.net>
In-Reply-To: <20130403174219.0786d27109633a30d89b38bf@canb.auug.org.au>
References: <20130403174219.0786d27109633a30d89b38bf@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m51IO3YnGshhLAqu8U8rpYD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/m51IO3YnGshhLAqu8U8rpYD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Apr 2013 17:42:19 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
>=20
> After merging the final tree, today's linux-next build (arm defconfig)
> failed like this:
>=20
> fs/built-in.o: In function `nfsd_reply_cache_stats_show':
> super.c:(.text+0x87308): undefined reference to `__udivdi3'
>=20
> Probably caused by commit 187da2f90879 ("nfsd: keep track of the max and
> average time to search the cache") which adds a divide by u64
> (num_searches).
>=20
> I have reverted that commit and the following one for today.

Thanks, known problem...

Looks like Bruce's tree has an older version of that patch series. I
think we just need to get him to drop that one and merge the new one.

--=20
Jeff Layton <jlayton@redhat.com>

--Sig_/m51IO3YnGshhLAqu8U8rpYD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRXA4+AAoJEAAOaEEZVoIVQVYQAL9rpTSNOj3kSmSktRfh1aQW
jTyjlpN0QlXTqzu1PpsEBvO3ugEuGFEutT70J6rfVql1ZznwodjbvJaJnVku7gUE
b2Wn/ZsjtZU7i2x7aUhUcLjFjZABNS7zoG72ofx4/3MLtjSHCGCUf8qMlP+5u0sS
+CG6Oq4ayI4Edlcl9xfaii/a6pJns3JdnQP4iy/4SkriL6Vf0XMXjgo0ZwwW4leT
BO4DHXdrJDQHiUYomu9oxMb6F/M5IhN3zGsrplbGViVLusk5znJT7iPI96/rsUEO
3iMnefdIFCGuIYnltAkCcztobyhL3kAjJUg70d//gu8uE4AVw4kOwRPL08LUjySc
LbNfRvvxmx7kcoywK8Y7chZtENIOAER/m/KoT9O2qf1qWJRzYE1zDwz+HxhBLMg/
4Nk3J2JpaUOAh9WAUFvw2ApETJE+CcWY7fvLqH5t1861qogagiKrDc3vhnJa1FkP
TmhosWlJ9HUYil0+VCI3XQMxsDwnTN0eBJVX0q/FIZ6R72ZbU1fJmkR37hmNx1Qq
smeUmxR0mv9VHHDsh4HMSLnYFVcOF7m/ASchMYYrm1ezZp1DXcX6qJtXqqeiotyl
T+75OGe9lXZ/OSmuHBNE5LnbCuaDz3HQq+9EQ1WkLwGc/1v6C1KZUkTc7H0P8eo5
yJ2SfZ1nXmHHzul2h4jW
=5ZdX
-----END PGP SIGNATURE-----

--Sig_/m51IO3YnGshhLAqu8U8rpYD--
