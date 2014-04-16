Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaDPUsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:48:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35362 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbaDPUsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:48:06 -0400
Date: Wed, 16 Apr 2014 21:47:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Mike Looijmans <mike.looijmans@topic.nl>, Arnd Bergmann <arnd@arndb.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjb@laptop.org, gdjakov@mm-sol.com
Message-ID: <20140416204733.GX12304@sirena.org.uk>
References: <1395991817-3503-1-git-send-email-mike.looijmans@topic.nl>
 <10471336.Pb8zVvW3Hp@wuerfel>
 <53429AD4.7030508@topic.nl>
 <4902841.krZFXFDZqb@wuerfel>
 <5342A3F5.606@topic.nl>
 <CAL1qeaET+cy19EtB_TbtQ40Lb9r9hrO4H5vjG5YmCTpYoOmcog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MikxO53xlyBvwArL"
Content-Disposition: inline
In-Reply-To: <CAL1qeaET+cy19EtB_TbtQ40Lb9r9hrO4H5vjG5YmCTpYoOmcog@mail.gmail.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] sdhci: Forward EPROBE_DEFER on vmmc and vqmmc regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MikxO53xlyBvwArL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 01:15:53PM -0700, Andrew Bresticker wrote:

> Not true.  If !CONFIG_REGULATOR, regulator_get() and co. will return
> NULL.  Normally it is ok to ignore this case, but the sdhci driver
> will call regulator_is_supported_voltage() on vqmmc to determine
> whether 1.8V signalling is supported.  With !CONFIG_REGULATOR,
> regulator_is_supported_voltage() will always return false, causing the
> sdhci driver to disable all UHS modes.  So we still need to handle the
> NULL (!CONFIG_REGULATOR) case.  One possibility is to guard the
> voltage check with #ifdef CONFIG_REGULATOR, as is done later with
> vmmc.

It seems better to just fix regulator_get_optional() to return an error
if the API is disabled, that case didn't really get considered since
it's a bit surprising that something actively using regulators (rather
than simply ensuring they're enabled) would be using that function.
Though if you already have ifdefs the ifdef is probably fine.

--MikxO53xlyBvwArL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTuxiAAoJELSic+t+oim9laQQAIHSElUlAe5voqkRes1Ay1GX
y62AwRiryRpmY215UUCBemS9fEKTfJYHb/yHgGF+kRbIU3j6cmRuWome4PDtnVCp
H4C8uNVZ1F/OaebL6822DJzSsaPObICUBIm39a6phTIHLKlsgLpEQLAgWWQ6DJNS
TTTI2jx9rLDjn9AV6V+RokTCANF48xRkd4ZK7goPwuSWjZkwRpZBVGlk6qhnwx+f
u7ugIjVrD70e4joZMu6T1OVRsjl40k8eSDMzabIqGSlE2eLWewvuhll92yKISvSl
eDHzf4CtUI9a/mru6Wymklu2+TL2Y2LdSgVj21KqaKIt2mSC77v/yhkga+aCqUIg
WA2Wr5QfgszA8dG96vztDPYBLs2iNx05hhkwCS8P2iZWRP8k/VaM5PWoO20CcTpC
bbu8cXfpnlI511fy3hDHlxauPXafXvFkTjHNbt5rp1W6IaiOPHDcX/6JECo1jwoo
4x4gwZSnTd23xWQGuc0ch16dgV353ob9jOOU5V0rY781RDi0ECN3xHdKDwFwR4Sm
M6M7DD+wI3zxJv9lA1RqMQVbRWSYcql/sHmv/ok5inV44gVbhfY+l/LJ4QjV2pqG
RLkt6cracze+JIyoQlFJX7kBf4rauE+mz14Sy+rF97SyK6THrG/HNnOqFpef2/W7
om3wHy6xhA+4HHziD6Uh
=IucX
-----END PGP SIGNATURE-----

--MikxO53xlyBvwArL--
