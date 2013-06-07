Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab3FGKYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:24:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54235 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3FGKYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:24:36 -0400
Date: Fri, 7 Jun 2013 11:24:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>, Chris Ball <cjb@laptop.org>,
        Olof Johansson <olof@lixom.net>,
        Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Will Newton <will.newton@imgtec.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        lgirdwood@gmail.com
Message-ID: <20130607102404.GO31367@sirena.org.uk>
References: <1370580406-10254-1-git-send-email-dianders@chromium.org>
 <1664692.GUOAAQ3FLn@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DT/miTrKQuDYoJpq"
Content-Disposition: inline
In-Reply-To: <1664692.GUOAAQ3FLn@flatron>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] mmc: dw_mmc: Handle late vmmc regulator with
 EPROBE_DEFER
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DT/miTrKQuDYoJpq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2013 at 12:19:58PM +0200, Tomasz Figa wrote:
> On Thursday 06 of June 2013 21:46:45 Doug Anderson wrote:

> > dw_mmc is probed.  This regulator is optional, though a warning will
> > be printed if it's missing.  The fact that the regulator is optional
> > means that (at the moment) it's not possible to use a regulator that
> > probes _after_ dw_mmc.

> > Fix this limitation by adding the ability to make vmmc required.  If a
> > vmmc-supply is specified in the device tree we'll assume that vmmc is
> > required.

> This interesting case makes me think that regulator core should=20
> differentiate between regulator lookup failure due to no lookup specified=
=20
> and due to the regulator specified in lookup being unavailable, returning=
=20
> appropriate (different) error codes.

It does exactly that in so far as it can - you get -ENODEV if there's
definitely no supply and -EPROBE_DEFER otherwise.

--DT/miTrKQuDYoJpq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsbTAAAoJELSic+t+oim98CMQAI+zyImtt0r0OTvU74sprUb9
FZzN60D2+GUgf8v72Nzz7YTiDbTDUsehEI/FapNdxNA8HHgF8aDq63uIHgdtyuSA
ThmNYWRRh1oacjzOXDFpl8JfWKm0EwTuTScOV8trBBbbfgTUlcf4+AYwyTF79fV3
u6l5ijYFQFdmATuOgPDKqSTMzX6eFVynf1kn2nviMn23ksbwFnGqyKXoloRfEW+n
IRQLWasm0eH0dH5XiVeNpyQfHqnTxgybQVrEAD/kjKy8VE6L9vOgWYYE7Yljpa2d
8vO2wnoabGDCUvPyxW866p29VkQ20/xVBpoSu61U6dwaSh81OiGp7rjfZorUcgxy
puANtbD9AtOElrM/lv0kVinf5vsNhQaUI5ND0/57WHQDq/DbJ+ceoGimjE371K0x
jhIVYd9rv7nALSdxI8sQeIpEgkOBeX83pKsJO+VPijOw9r56PgUeW03Dkz4WcpCh
eO7tMUYgYAEF6hx/xGKSiUcD4EIiRoKMd5nn5yV5nmV2j4ja5kosSUHMiDBSwolS
DTIj8bu0m4ztrr9R43TJuNbvXBPzptZP8qg3ZuwAwv/s9xEHCJaDEUJa+bFj4G55
khTa9eOko95+PeaNi8dFYxn0Cr9aws62i2vg+tGypEtYgHb5rj0RwTSPEpXfuvQf
GFsAuQ+/wyjgD9G6gcMN
=36I0
-----END PGP SIGNATURE-----

--DT/miTrKQuDYoJpq--
