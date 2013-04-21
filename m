Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3DUWgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 18:36:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab3DUWgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 18:36:04 -0400
Date: Mon, 22 Apr 2013 08:35:49 +1000
From: NeilBrown <neilb@suse.de>
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mdadm raid1 regression
Message-ID: <20130422083549.7c1cff84@notabene.brown>
In-Reply-To: <CACaajQv+HhzStC-U1RGz4ZWdn0-w4X3MyMM9GTJPOFeyrxtP3w@mail.gmail.com>
References: <CACaajQv+HhzStC-U1RGz4ZWdn0-w4X3MyMM9GTJPOFeyrxtP3w@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/l8DlaOfN4c4AbSvCcKMrqAe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/l8DlaOfN4c4AbSvCcKMrqAe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Apr 2013 14:38:53 +0400 Vasiliy Tolstov <v.tolstov@selfip.ru>
wrote:

> Hello. I'm using linux 3.8.6 and mdadm 3.2.6 (from git).
> I have many raid1 arrays that have data offset 2048 (metadata 1.2,
> created with various mdadm versions but mostly 3.2.1 on linux 2.6.32).
> If i create raid1 with never mdadm on 3.8.6 i have data offset 8192?? Why?

More room for various useful things.
In particular, if you one day want to convert this raid1 to a raid5, then
having a bit of extra space at the front will mean you can avoid a 'backup
file' and all the problems they cause (code for this isn't quite ready, but
is getting there).

>=20
> My problem:
> Sometimes i'm doing mdadm --zero-superblock on both parts of array and
> re-create it. On older systems i have no errors. On new (linux 3.8.6
> and mdadm 3.2.6) i get corrupted ext3 fs and partition table. Why this
> happening?

Why are you doing that?

> P.S. If i use mdadm 3.2.2 i get data offset 4096 that not breaks data,
> but inconsistent with older versions.

I suggest you use mdadm 3.2.2 then.

> P.P.S. I'm try to specify --data-offset when create array but as i see
> - its ignored and data offset still have 8192).

I'll try to make sure that works correctly for the next release.
Thanks for the report.

NeilBrown

>=20
>=20
> Thanks!
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov@selfip.ru
> jabber: vase@selfip.ru
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/l8DlaOfN4c4AbSvCcKMrqAe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXRpxTnsnt1WYoG5AQLyRhAAgi5fN+tdWNjaTgEnZzpvOkah/4g35Su3
K/pCd5Mwg3tH3fgpIrTHBPjovKZyRuDfyVShiMIvPwM6bdr67ewdgyAQHaCwYI+e
IOCFSbtddBUpBqkb7JeLlRAmkDN9ugVXkUFbbpESN9lP3amfM3fKnnCCsHqH7QAh
ByvkH9yDVvejgfh91BRhn6FSZKlAIfXrbVeV9Ds/uVU+litMqeiswuJLn/JmCYb+
JNiEkb/MCCM0H6DUohgqrvj9Ul3BvoTihOgT1RL+fdN4eNjDcvplBbnIkN6eR5jV
FopUOnHi2QgwOXpnE7Ti9R8p44CDjb83Tlqgkk3Jt3A+UPvp3loNnMpt+vNlQ6Tf
f6AbLBamRc1HftjccjHkJ2nhNkwBfWQBaHwzcBZtyWgLjqjNAbpWvW9p1hb/59JI
DnKfvDHYCn5//wxmJsc9b/1cQNdkooWJnBNVWp8LkKeo4hwKmf8pFoDaXhTyZ+PQ
lmzIAJVnpnNIoVuhMIk1Y3VZJdrijJWxtksk5LWcNKUEOtHiZoCFEhn8NRicNKY0
PvPOX2jJFFVd+IAlZFtU8sP5PG+SXuWYvkxaC0fcF38CvUF7BzO4RX+zA3ep2cU7
X7tgHcZiFM+c8+LFhgoF0uAoOyGgldEhkwJd7SwJ+qKyIywA6qVmZTT13zxqI3BG
hp1gbW1XYSg=
=x0tD
-----END PGP SIGNATURE-----

--Sig_/l8DlaOfN4c4AbSvCcKMrqAe--
