Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbbALDF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 22:05:26 -0500
Received: from ozlabs.org ([103.22.144.67]:48190 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbbALDFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 22:05:23 -0500
Date: Mon, 12 Jan 2015 14:05:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Vinson Lee <vlee@twopensource.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20150112140515.369eb687@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/EMx7uJ4jvKRCg9WLLnCaso_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/EMx7uJ4jvKRCg9WLLnCaso_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64 allmodcon=
fig)
failed like this:

Documentation/networking/timestamping/txtimestamp.c: In function '__recv_er=
rmsg_cmsg':
Documentation/networking/timestamping/txtimestamp.c:205:33: error: derefere=
ncing pointer to incomplete type
Documentation/networking/timestamping/txtimestamp.c:206:23: error: derefere=
ncing pointer to incomplete type

Caused by commit cd91cc5bdddf ("doc: fix the compile error of
txtimestamp.c").  On (at least) Debian stable, the system's definition
of struct in6_pktinfo depends on __USE_GNU being defined (at least, I
think that is the problem).

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/EMx7uJ4jvKRCg9WLLnCaso_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUsznwAAoJEMDTa8Ir7ZwVJXIQAJAHECLB0+JLhZedsbRdxD1N
SAWmEZlux5txAWJ4r2xM8x68hJTGXS3ef3Eriim1xhMCsyCU5QQU2LOFHbS75Bt+
9EcWoR80BSo7cmUoetBxpSwLYrbzPQ9EFzJIkaDXK2cIDVFH+tq1UlVjwhBNjBxl
ZBFNkedNRgOtVQXL26J+P/xtw8t9mcHPbAaA2rFXpjU0rwTx3pnG4aovyqYOaQzd
9RZ4YHfARDrnlgrobr3spJ2PWrfw008VtbdAsKGvUgjHP//mziWzvNXXoeapX3BN
FLTpwvM/TrO9ffcEAom9crukPhkIcuChmtRKwOLp4nzw9tf6mpnKpdJuKY2m+wDe
+VVQ5Qw7+mvJxk/dHJCXV/WO4o2t11HXk1aJdn1NYCsY65fpGYDy/BPrR5fl2OVJ
fRLS4woYjYhKt8tcWhV+e4+BezB09RcpdcoselhWPeoMul56BaV5R63d8EqTg5dQ
2Tu6IpqAoQxHrDi5MPEBj09ieJj8NIRwWz3YVM4BBeMSyLNA3YkAYSeBic23uBd0
CGOOddG7t1c32G7yLb/Qo7znRwgP/9UviF+HWF0tz2TaPSrFTcNUK32QhBulu+KD
l7Jv+2Jdggz5XehzfFh5HQmW68oQRP2OrDnkxwmw+TXrAEyiDg+pX9dmSaKGaz2v
k3s3mLhu9dbO99+EvwLA
=aPMB
-----END PGP SIGNATURE-----

--Sig_/EMx7uJ4jvKRCg9WLLnCaso_--
