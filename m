Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaAJQxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:53:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52146 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaAJQxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:53:01 -0500
Date: Fri, 10 Jan 2014 16:52:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: timur@tabi.org, alsa-devel@alsa-project.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, shawn.guo@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Message-ID: <20140110165229.GP29039@sirena.org.uk>
References: <1389265078-16256-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140109184453.GP12858@sirena.org.uk>
 <20140110023252.GA16467@MrMyself>
 <20140110023537.GB16467@MrMyself>
 <20140110120439.GG29039@sirena.org.uk>
 <20140110130338.GA17392@MrMyself>
 <20140110132642.GM29039@sirena.org.uk>
 <20140110154824.GA17609@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vzUQzca511KWT6Hk"
Content-Disposition: inline
In-Reply-To: <20140110154824.GA17609@MrMyself>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: fsl_esai: Add ESAI CPU DAI driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vzUQzca511KWT6Hk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 10, 2014 at 11:48:25PM +0800, Nicolin Chen wrote:

> I think I start to understand the point here: If a user only needs to playback
> the default case - 44.1KHz for example, the driver can just configure all the
> dividers once at the beginning, not every time, so that we can save further
> register overriding operation or even complicated clock selection and divisor
> calculation, which obviously makes the procedure clean and reduces the system
> loading even if it might be just in a slight level.

> Is this the reason, or maybe one of the reasons, to the defaults providing?

The main thing is that if the DAI driver does it then it's less code in
the machine drivers using it - what tends to happen otherwise is that
quite a few machine drivers end up replicating the same logic.  Hardware
designers tend to do a lot of cut'n'paste with these things so even if
the CODEC is different the clocking is often very similar.

--vzUQzca511KWT6Hk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS0CVKAAoJELSic+t+oim99IQP/08MHspLPF61FZWnYD7c/ocz
umRR6MfesK+5hChKTM5MjqKhRbORurpimLy3SQgiFHuoJXHUWkDWOFyU7ARsirm4
SE93me6Ug7ARPdKtfdLJpH7xxgBsdV9YvbsZMfilEAjjLCa3UbZt7ZeDDBlOYMVE
AbWOoGFjPrmvAMn5vNIUGZ2whqp9GEEzWCjrcFb2PRWNr8CCiJF+u23bX0CT/17B
kxXqagbocugD3Rqjpo7EVZhaDlh8B/MARkGbnqTp53DpxRJl8xlSuM2GuyV7njhZ
qedOxwUu7prtwID2HvF+xhj2cQstZaA0IXRutEoe2wj0cVBx0btGz/FHPcw85aou
EQburgwdP2e63AcC8m2JcGGZ5y5QLQqMktxwgOr9RNTZj7ksL399KKpsLRiM2ABH
z6gisop7cFr4BHl2H11V8W6telUgNq/TVIYAYfKASZ/3ei8BdPrT8cDm8NCShzBy
aRgmxb6f2rfBwIl1xXlNYV3vP1iWhICO0TzHDKxCQ+hl1cSKB0b6Lez6OmmHzUN3
o86Hz/pfcxzRY6BdwwINgEqdiSyi0YJ91DQ8uvuISSLUVvOqx4ZwB9Mw4mhprAhV
Ezpp0kEIGQuL7OhcPrjSGyJP8SeNjWMsFzZFtO3YbtPdcuw/gFIKzHvTfBL5xNbJ
MBAW15HInlDLOVdc5Yga
=SwMh
-----END PGP SIGNATURE-----

--vzUQzca511KWT6Hk--
