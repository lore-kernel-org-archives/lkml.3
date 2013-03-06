Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3CFAo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:44:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58163 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3CFAo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:44:56 -0500
Date: Wed, 6 Mar 2013 11:44:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Lartey <ian@slimlogic.co.uk>, Graeme Gregory <gg@slimlogic.co.uk>
Subject: linux-next: build failure after merge of the final tree (gpio tree
 relatred)
Message-Id: <20130306114452.a041ab0737783f9730c1486e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Mar_2013_11_44_52_+1100_w_hlPTKdwSs_IYIs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Mar_2013_11_44_52_+1100_w_hlPTKdwSs_IYIs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_probe':
drivers/gpio/gpio-palmas.c:173:2: error: implicit declaration of function '=
is_palmas_charger' [-Werror=3Dimplicit-function-declaration]
drivers/gpio/gpio-palmas.c:173:30: error: 'struct palmas' has no member nam=
ed 'product_id'

Caused by commit 82d4d6637fdf ("gpio/palmas: add in GPIO support for
palmas charger").  I wonder if this was ever build tested. :-(

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__6_Mar_2013_11_44_52_+1100_w_hlPTKdwSs_IYIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRNpGEAAoJEECxmPOUX5FEdkYP/iDTA3B4y8LevPHuew07hZhP
7H6re4eVfMtcrW+mHTFzclE+nQFlDXIGGHUdSqYXcmvE0nWNSkE8Ej0NnKvc5zsB
ahumgRkYf92ZBkfZAVPmhk5B5pybDlIaRWrG0kHSV3a75M2oYKEJfFGKEDkdEe0m
VpSNKC3/z2JpOGD4fpIodwNJwXz5/UM4TEcXILEdCSAdKlx0pgJsZqDj26feEcD2
20qua6kwRJCGy3CdtgBn68km7TOPuwOWy3WpfQCvkw1q/Ka6XgKua8EwSWVi0c9t
6+JcznrJLfBK66pGKtb0lf1d3p/MuzpOIeVHksq56FbbqwLLHI6e8ALGR+n7ROo6
uh/m1boSQ+FQcjHEkarg4Q80oCHdRwu+Go8g4LpDdEC+l8ShaqNHdKo9T4jQWZa1
Itz6iKnUcLeL1nn4QbnbeH9nEnhtHWLyv9mLHsIO2F+KYw/gOSDUshOlpJYrVSQ+
Fuftqx+7ujBb0WlsULaklaWkd9UGbAQvL4Fmv8PJP0HTrI9xrNsYuedm5kAxddQ6
K4nghQ3N/sqx+9I2kDaCzajfX8OySnEITq3nJyKBe+mtOHqZDPW9pHSlwZpvJ4Q4
rXXBPo0PE40wVLH+7XCWCFZ3UnQZGu4jcJtuaqyifj9HGUQN+QGf/UeOnMPpR7y1
3eTs4Fyad8V7oS410xXs
=IDZ4
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Mar_2013_11_44_52_+1100_w_hlPTKdwSs_IYIs--
