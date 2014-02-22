Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaBVCr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 21:47:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48752 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaBVCr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 21:47:28 -0500
Date: Sat, 22 Feb 2014 11:47:09 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140222024709.GK25940@sirena.org.uk>
References: <1392913608-23479-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140220233058.GC12197@sirena.org.uk>
 <20140221093855.GC5438@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lildS9pRFgpM/xzO"
Content-Disposition: inline
In-Reply-To: <20140221093855.GC5438@opensource.wolfsonmicro.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.103.222
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: wm5102: Remove cache_bypass from manual register
 patching
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lildS9pRFgpM/xzO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 21, 2014 at 09:38:55AM +0000, Charles Keepax wrote:

> I guess there are two parts here applying the hardware patch and
> the manual application of the register patch. Applying the
> hardware patch restores registers once it is finished anyway, and
> the actual patch is applied by the write sequencer so will go
> straight to the hardware. So that really doesn't need the
> cache_bypass.

Yeah, it's only the manually applied bit that cares.

> > Being able to use the regular patch infrastructure would of course be
> > nicer but you're going to need to add a callback to allow you to run the
> > hardware patch in that case.

> I had considered adding bypassed versions of regmap_write and
> read. That way you could ensure that the bypass was only active
> whilst the regmap lock was held and avoid the problem that way.
> What do you think to that idea?

I think that's a reasonable idea, though I see you actually did
something slightly different (which is sensible and in fact there
already).

Thinking about this stuff there's also some ideas I discussed with
Dimitris for the DSP memories where if it were possible to mark only a
section of the register map as cache only the DSP download could be sped
up a little by making the DSP memories cache only during download and
then syncing at the end to do the actual writes.  That way coefficient
writes that change defaults in the firmware would get coalesced and
possibly some writes to adjacent blocks could be combined too.  Probably
not a massive win but it'd be nice.

--lildS9pRFgpM/xzO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCA+qAAoJELSic+t+oim9fKgQAI2gfPeovqUgH2ShYuh4eCpj
p0H4j9aNY+VSQK2WtCmRSLoo/K7wYlRteG3+pl0pyYVWvNLIaDtyXgwYQf4eZP1p
U4R7gSTe7Zjpu89qvYjbUGUYdHfjiVZp23qEnf5heIxj/XokjX9/4TJSC3egyhZ5
et7hMB4vSv3gMtgu3O8vqWGcZ06T7CBMTRP+PhvyYuoF6ze7JPxWnlsqVRm9uQNF
3ks55ZRdONqVeD2bZqRN2NRDlZ6jcmTunTye5T5AC2mrtGO8+yikjkiPRZZkgLON
k8RqW/dCd/rw+cOoNE/6/dFVD9GXHQMfivYp5t8kMGpi3D1NKxf3SSE07+YkpYhV
/su5J1EtNx0mmj+s3/SlB+BeLxi9tDsPAyWxViUDqqMwP3aJHaJoB9WN8yH1tkf+
adXZVZTAeCFfi1kpC3hmOneQeq3X5nUhgTBkTk7OvZa8BJrNSZ+PfTWNrBTCh73K
SHIk86az4hrhY9L60U5lod6irzxa/mkyjKGGVYE6fuuWIkdIdUy24Myya5mJeGP+
zav2fOv8in8WSxeIB/PRJxPfJrZpmadOcDWnWaVhJ7HnqKh/ZRy2cvaPuKhNe9DS
d5UGIvGeGG+1F7jBGC1ic25++ttthq4HU4zPl2UwTQuToTguOJCCh54XoQOmeWDY
mCCDz0bbBCoaCckqOzp6
=Sw4w
-----END PGP SIGNATURE-----

--lildS9pRFgpM/xzO--
