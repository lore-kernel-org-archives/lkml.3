Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3AWCRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 21:17:35 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45150 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3AWCRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 21:17:32 -0500
Date: Wed, 23 Jan 2013 13:17:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20130123131723.412ded13d2c6abcf4f0f66b0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_13_17_23_+1100_if3XPdx/gsZ7ew3w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_13_17_23_+1100_if3XPdx/gsZ7ew3w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/jz4740.c: In function 'jz4740_codec_probe':
sound/soc/codecs/jz4740.c:364:2: error: implicit declaration of function 'd=
evm_ioremap_resource' [-Werror=3Dimplicit-function-declaration]
sound/soc/codecs/jz4740.c:364:7: warning: assignment makes pointer from int=
eger without a cast [enabled by default]

Caused by commit bc96ea9b07ad ("ASoC: Convert to devm_ioremap_resource()").\
I think that devm_ioremap_resource() must be being introduced via a=20
different tree, since there is no mention of it in linux-next (besides
what is done in this commit).  Please build test.

I have used the sound-asoc tree from next-20130122 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_Jan_2013_13_17_23_+1100_if3XPdx/gsZ7ew3w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/0gzAAoJEECxmPOUX5FEXJcP/jmMbK7nvf/R11higsIz4rE9
p+ETalBR4TXuSMStB44b1l3+IySPTnueZPKibsC2uoVx6MCQbKOYtlfd9NMpU+Bg
sOsODmFxELwJGfFFMErC0JwDlet83OzAZIhTOlvefz/l97OIAkekgVj/eHqTwJMa
l+hHxsO1Y1kNu3UzJDNULjlDUr9BEQoREGc4+/yzDqEZIsNYhDuxS3GGHEFXaOQJ
qwVz3TWIIQEFLQNRXnVBcSQa12jEeKI/GZfsZZ7+6wTjffr1NE3ebUvnhxYCL2tm
etvC3h+HkynU8se4ocKbvh1X9LEqNCHRhoOMvS9twC3po73Susl34JHG1ofoNlrO
M/gDEaEDnKac9whqPNffxS5HuXIJSiYF9vFZdgwrP0Mw5T3wgVHAnX1d7bA+3E6e
ZYOpBevv1O+OpDhl6BVC8tTtF0s14R1HNzlsGP0ZWj8KOITsnzOtRmmgZ7fGMK1g
IIyc+1vftRw8lbvyryE9jRzNbLam9ouyhVgFMetvnNKphQI+V2sJltj9WQpxiIfc
47dsvQC9HjGnCUBmscLxmCr2l764DKcAcZP6VarBGUVNGaEj1cXhlL4pWDanGUAK
KHmbMhiW2ftdzRqysNtWv8v9TSMfil6W122KVr4zAjlIuai9pUGAwRdUSSNZsOuA
hemzE23JkCOMhEq7nJda
=/Pg9
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_13_17_23_+1100_if3XPdx/gsZ7ew3w--
