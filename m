Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaB1VSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:18:08 -0500
Received: from sauhun.de ([89.238.76.85]:57151 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbaB1VSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:18:04 -0500
Date: Fri, 28 Feb 2014 22:17:58 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: David Howells <dhowells@redhat.com>
Cc: wolfram@the-dreams.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: Add message transfer tracepoints for I2C
Message-ID: <20140228211758.GB2517@katana>
References: <20140218203346.GG18768@katana>
 <20140109214954.25590.73057.stgit@warthog.procyon.org.uk>
 <10892.1393506444@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <10892.1393506444@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > And for the buffer: %*phN is difficult to read IMO. What about %*ph? Or
> > %*phD at least?
>=20
> My problem with that is that it increases the length of the output by 50%=
 and
> there's a hard limit on how much output we may produce.

Is it PAGE_SIZE? How is this handled when the buffer is so big that the
limit will be reached anyhow? Note that it is really uncommon to
transfer kilobytes in one go via i2c. Usually, big transfers are split
up into smaller fragments, say 128-256 byte. So, for readability, I'd
still favour %*ph.


--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTEP0FAAoJEBQN5MwUoCm2N8QQAJwcR8oQtE8665iDc3n9GSvr
dNf2LeaMc9glfRZmHXDW6rVFe7duP/ZdBKLklmFLhNEIUALvtDywUpjEn/yFwI4Q
eGDte13BVq12VgHk9Z56HWxNkLUB+emWl80W3B3eVL5HX4oNopaFlPhcQEIKUln3
7Lg2pyxAaSgzjmD3Cjq0/gSM7jJqwQR84vqp2FtdUfJ2BcmnGYN6imYgMMpshyyx
QWrBI4TJE/ZQOIeFYK5/vuEumjX3vsgcbYoC83W7vceNx8B7EVxtV6Qj8FMfXZzL
bIlJGvGSeHHh96AS3L1itflmthsuFh1inF/Q2qKZB/7oCgP9jrS7s2LMOgHylSz+
lkVCT8irweisW6vSAymXJlBz5lQiZrl24Zs0u6nP9wPY6Qz6LwqFE4HX5IWWtl94
rFlwiRN7X/Z4y+MRX6WbalVaRLa74qELN+rhe88dACIgsmrwmYeSTsxqmEXnL+6w
WDF6HjL2foEdinQaYS9jqUECNY7zOILyRshug8T0rhPxo557qJ9QkVVqA+ai3jmU
nCXmOPtWihktGzUj7SVDs8MtBXlqGCatwFdJ5Yio13Eol+XD3TanswIXD9uYfm6R
iNFzg+RTF0ZaM9F7ychKWFuZGIlQPOo2m+20CASlpRq+oKCd7l3fbJjeSsBhzdb6
rlj+g2jsrt/IL3UsHgXm
=Yiah
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
