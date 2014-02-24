Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaBXDpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:45:39 -0500
Received: from ozlabs.org ([203.10.76.45]:40785 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaBXDph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:45:37 -0500
Date: Mon, 24 Feb 2014 14:45:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: linux-next: build failure after merge of the spi tree
Message-Id: <20140224144529.1d3b9f3e974b6364298182cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Feb_2014_14_45_29_+1100_t18sJy9vJFaB0gVn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Feb_2014_14_45_29_+1100_t18sJy9vJFaB0gVn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/spi/spi-qup.c: In function 'spi_qup_set_state':
drivers/spi/spi-qup.c:185:3: error: implicit declaration of function 'write=
l_relaxed' [-Werror=3Dimplicit-function-declaration]
   writel_relaxed(QUP_STATE_CLEAR, controller->base + QUP_STATE);
   ^

Caused by commit 64ff247a978f ("spi: Add Qualcomm QUP SPI controller
support") and exposed by commit 702d3cf9d05d ("spi: qup: Enable driver
compilation with COMPILE_TEST").  Please at least test building on x86
before allowing a build with COMPILE_TEST.

I have used the spi tree from next-20140221 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Feb_2014_14_45_29_+1100_t18sJy9vJFaB0gVn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTCsBgAAoJEMDTa8Ir7ZwVdLYP/iZYJs3g3Bws/rFULj+Yb4hg
wyqUbE8vAiFgGhfARTDJ5n8VCc5uSxIdxLcDu2Qo8gxHbbRsXgAIXkdn7k1ZCabj
dtHMSlzFgszQ5hR3S5pQLtq0Q+18qE4GRP2lJZGXO2V2OtS6QPVuH940/EE/cSmz
3feDM4Il/G0EEv5X76hGNaTDnS7zNpWCMe1630B8fGh9SFAg8PEaRWUsbv9ekBAy
jCLhDValxVC5ezi8jjx7BZvQk7TvD+nIDtHqaNLD0CgisvWgmjktz1fS44HuTFw0
urUzjvg/BQHKhIiPr+bxD5u2oh9Zorue0T+aY6mUB56KKnAdzqKF3++urpnBxDHQ
ussEl+4Vj8DuG/F1wy6PRni4XVuzhIiROM6eh1W9zpYU60UnIhTZGtab7Ujfixnz
2+PzMxXWXBVSkMeL9/OiboqwsoLBYF1JRuh0A5++PsH1EDpVu1HvJFSQYGbwEwkk
GyZMroqM/ECqaYub6pqjY0gnTwYJ7thf5j1pCgxtqe+/MiehvJyzpHlwgx8Le1os
MqrGERPSpDlN/ZUlWVT5P/XZqxfLNjNWuppy68RQJrL9MefiziWVYlaAdkdEYOiV
j5MxOkZEiP+GNWp3ITHl4xSxZWVxdJp3nVg8AABinD++Vwg/XTPToFqE8ynC7C2D
pqIG/4Ke8HMa3xB+7ZvH
=el70
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Feb_2014_14_45_29_+1100_t18sJy9vJFaB0gVn--
