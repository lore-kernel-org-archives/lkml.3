Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3FRHUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:20:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60645 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3FRHUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:20:10 -0400
Date: Tue, 18 Jun 2013 17:19:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Xie <chao.xie@marvell.com>, Yi Zhang <yizhang@marvell.com>
Subject: linux-next: build failure after merge of the final tree (mfd tree
 related)
Message-Id: <20130618171957.9d8fbcf376243d1d5f1d92b0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Jun_2013_17_19_57_+1000_LAo0.u9TLvKdulc/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Jun_2013_17_19_57_+1000_LAo0.u9TLvKdulc/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/88pm800.c: In function 'pm800_pages_init':
drivers/mfd/88pm800.c:434:2: error: implicit declaration of function 'IS_ER=
R' [-Werror=3Dimplicit-function-declaration]
  if (IS_ERR(subchip->regmap_power)) {
  ^
drivers/mfd/88pm800.c:435:3: error: implicit declaration of function 'PTR_E=
RR' [-Werror=3Dimplicit-function-declaration]
   ret =3D PTR_ERR(subchip->regmap_power);
   ^

Caused by commit f8ca616f67f7 ("mfd: 88pm800: Enhance error handling for
sub pages probe/remove") from the mfd tree.  Forgot to include
linux/err.h (see Rule 1 in Documentation/SubmitChecklist).

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__18_Jun_2013_17_19_57_+1000_LAo0.u9TLvKdulc/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwAojAAoJEECxmPOUX5FEFckP/RA0KFSzRI6uvB8OICH6utiW
YKunCkSciSj56tzzvAk/wol7zQDjG1TubsLvaaJQKNU+Aicao/2tHdUoqBte7emV
Irk263U+xlaa07x8fvIbq8QOiEECNM1CWZZmfq5NQpRX7vqmKbXqELXERRKx0xUO
KEvXoEA+oi/BTNFBlpSMuWeL1OIoB5WjDoHtWGqTqyK3bl371bWsPOlbREsIMhx4
kcUzvPPYj4LtCOA1dS2Hc6DiMP1OGd3sHhGRU2XG7KXA/BcfdY4I45kxZaSIjxgE
wAhshGhsuIudooiSk6qV5oP2PEiRHJCinE7RbcSDnwflqVdt76z+jTwxv9ZwSabf
HenQduU2UDFaAtt1IxLIr2TfrbPg5CDe/eS9SI1tWPoYMHCq3e6JB8v89iYln0Kf
AlN7McgW6EBZsxr8Vk5d7k6VXd3ENG5qGvzDiVYe7BA/BfpOVu//smh3qNZf4D7O
puArAbRYgkWYHVorMgOq0TtLLEb3L00jYsOuN2ulQvgLZ/+Vmd+ljFf3dPu9JTOI
/c6q+rkpl/uEU66RjzDu3iv3/yqzP10pIglzI4rVdz2fU/Mav2c1UPUKSw1H7Fb5
0EUI41mMDahxldgWCZXmeg59XFzQoq7cZ/EekKuOqK9wPrnmrcXlbEY8mNLljGy8
vkYHbQVjMD7NSxz3eUMt
=BdfY
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Jun_2013_17_19_57_+1000_LAo0.u9TLvKdulc/--
