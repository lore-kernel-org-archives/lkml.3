Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab3GAESj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 00:18:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48277 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3GAESi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 00:18:38 -0400
Date: Mon, 1 Jul 2013 14:18:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: linux-next: build failure after merge of the regulator tree
Message-Id: <20130701141827.8f9122f0b6ca860fa5fd11a5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__1_Jul_2013_14_18_27_+1000_v1AEq6aERCMb=MX7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Jul_2013_14_18_27_+1000_v1AEq6aERCMb=MX7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/regulator/palmas-regulator.c: In function 'palmas_regulators_probe':
drivers/regulator/palmas-regulator.c:850:8: error: 'PALMAS_REG_SMPS10' unde=
clared (first use in this function)
   case PALMAS_REG_SMPS10:
        ^

Caused by commit 07a02e0b1a4f ("regulator: palmas: model SMPS10 as two
regulators").  Clearly not build tested at all :-(  Grep is your
friend ...

I have used the regulator tree from next-20130628 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__1_Jul_2013_14_18_27_+1000_v1AEq6aERCMb=MX7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR0QMYAAoJEECxmPOUX5FEgckP/025sTKkAeAghOMSxMXU0GQi
HkgeKHd+eBEIhKOOzKtrOF/frOjT+iLvVpbyVnHddUlG78Lrvl9wIZhoDqpH/cKe
2ikIA3Xc6Lk3o0tsM3j3YNWnaxDu2bmwRrWFW03mHE9PFTk5bv0mcKKZ+iVGiJ3O
L5quoW3Mrr+r0oFYb6fOdrnCp/5sK5p4ds8vj9V7KceqLDNWvPGlPdA9te14NvEv
VyP4YbwHCxgEkhhp82p86A2oZgX0FAYaqdBEveGAySL0PIBEKcidfY+MzYOfJ2Xr
Acnm/la4x+ogo3Po+A1Q/VYEV9xuVfufpMPb38/RaXxu34xQcDilWS06BuGNN2AR
us2fK/TOFEpeTmwrisD7PZQ8wXsVOWRaRqR8ar4cP+/mB/27UyZKYhdwenBAFxmf
Wj979olEAstdmWOOLhnE4QMkfDoSw2tDwDdbdp9blz4M9It9/iYW09D8T7kghyUG
GiVUsIi26kcYEHJ4Bzl7Gs7i+ikOL4yJcLO3qyrM3ETm+y+ZY83klpoLanPkcwX/
3M/wku9QTK8Fs3y1hV8y9kOQmOfv0+93iU1kHNEdee69vn4JseXiRiWUcl1099pD
W27Uybi+K5YqJVqb3ITRYMQwK1UY+//LrngUp3XHJpeuFpbP6DDXVUH/K/dHcppr
RDbb2rYNfNhBwyh5gOHG
=yfgN
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Jul_2013_14_18_27_+1000_v1AEq6aERCMb=MX7--
