Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbbAPCXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:23:03 -0500
Received: from ozlabs.org ([103.22.144.67]:54299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbbAPCXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:23:00 -0500
Date: Fri, 16 Jan 2015 13:22:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: linux-next: build failure after merge of the i2c tree
Message-ID: <20150116132253.1c5f7a8d@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/jGvSC2bZ6OcEPUT28vnmVe3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jGvSC2bZ6OcEPUT28vnmVe3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Wolfram,

After merging the i2c tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/i2c/i2c-core.c: In function 'i2c_unregister_device':
drivers/i2c/i2c-core.c:1016:3: error: implicit declaration of function 'of_=
node_clear_flag' [-Werror=3Dimplicit-function-declaration]
   of_node_clear_flag(client->dev.of_node, OF_POPULATED);
   ^
drivers/i2c/i2c-core.c:1016:43: error: 'OF_POPULATED' undeclared (first use=
 in this function)
   of_node_clear_flag(client->dev.of_node, OF_POPULATED);
                                           ^

Caused by commit d5285c36e6d2 ("i2c: Mark instantiated device nodes
with OF_POPULATE").

I have used the version of the i2c tree from next-20150115 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Sig_/jGvSC2bZ6OcEPUT28vnmVe3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUuHYCAAoJEMDTa8Ir7ZwVYEQP/3ZUsJJYPQxxZjGxaAWxjHSV
SX8+gDIb66cr5C4lC9tKSMpgWmi6OCZJtuS3TmSeQQZS2WKsgklPvAfJhF71qJoH
MtKwQBnPZgruDJZOK6b38tgwujf/XOfZW9Y7qFbAKYEq49A0FyzNRbaFZRvcCa+6
KccEZ8ii/shexfvFUXyZKhVjVyIMQYjcnvJYyPJkH3ydCsZXhasOL+2iVAZPJAF/
s47OJanquDPUJZlMQpJkGQhiQaXAXCdSdPQRYG4tlO07NpGbYDRauCfooyPXW/iK
ay1kND4yseLya7/Ni0yMoif++L7T+L3u+wUSBwWONNVcsJaCrLmN3Kjj10QMbGh9
LieDNwJVUvSzXdgmb8PfG11IBj3954hKvq838i4k4wIMooW+pV8mRnfrmQdiuhKY
edugd1U8NWcQMfmaqstWKdDSdWEipiRAnMwfzh16wnS+XHZrnnJ3lOp4rKFab1rB
ewbh94Ijd9R2jTic++sT+c5vFPWw746UR2QWTK511MwY2y9o/XJ4qEFkb3/5qvFI
TcK0DV8yvdhGIAeElVv6isa3Zgpzhv043ripedrvbJVhpqv2dqGnZxMOzFUWqlJ0
eUUTFt8YFqFS3lTchEqLPZX4g4eHLk2mYtrlOLrKzQ0ctcYNG2ctQPAsrOOB+5Vu
INFFaKHsig7loez4aR+h
=mPyV
-----END PGP SIGNATURE-----

--Sig_/jGvSC2bZ6OcEPUT28vnmVe3--
