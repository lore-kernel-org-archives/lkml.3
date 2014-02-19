Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaBSBwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:52:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34342 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaBSBwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:52:05 -0500
Date: Wed, 19 Feb 2014 10:51:48 +0900
From: Mark Brown <broonie@kernel.org>
To: Gerhard Sittig <gsi@denx.de>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140219015148.GL2669@sirena.org.uk>
References: <1392444566-23605-1-git-send-email-iivanov@mm-sol.com>
 <20140216142512.GR4524@book.gsilab.sittig.org>
 <20140218000938.GE2669@sirena.org.uk>
 <20140218193747.GE4524@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQv0vi9oZBoYbpa7"
Content-Disposition: inline
In-Reply-To: <20140218193747.GE4524@book.gsilab.sittig.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.103.38
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi: core: Validate lenght of the transfers in message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQv0vi9oZBoYbpa7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 08:37:47PM +0100, Gerhard Sittig wrote:
> On Tue, Feb 18, 2014 at 09:09 +0900, Mark Brown wrote:

> > It seems fairly clear to me - if we're transferring 16 bit words we need
> > the transfer to me a multiple of 16 bits and so on?  The requirement for
> > padding is unclear I have to say.

> I meant "padding" in the sense that e.g. 12bit bits-per-word
> require data to be provided or consumed in 16bit quantities (2
> full bytes), 20bit bits-per-word require 4 bytes per SPI word.
> Why not 3 bytes?  I'd guess this is due to FIFO port width.

I do tend to agree that things need to be rounded up just to the nearest
byte, I'm not sure what the standard thing for hardware to require in
terms of port sizing is here - it's going to need an audit of the users
to see if we need to worry and what they do if it is an issue I think.

> At least this is how I read the check which this patch
> implements.

I don't recall the actual code now, sorry - I was mostly just following
up on the review comment here.

--LQv0vi9oZBoYbpa7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBA4xAAoJELSic+t+oim92/IP/i/7MaWvwKDxbzWtCBV4ne/Z
rK6ckJsia2ALi+AYr8iOyHXZSMZs4PbfA5JJW8j+35lyIneiPOmPJWtNzpWSya/0
p6eUzwDzo1AmBDTuE8Ee+qQuEWQmCZMXHCEkqtlr9wXKxt7ibMuXVk5Kb8+mOsk2
aAi55m3NpwSAyPc73zF+letZo7350le/2ZTp1crRRukCy0KX0DkS+kcEioKplfSA
I6gBkJOkh2+QQCLLvnd4O557R49cJEnOZ63u7qcwYImtRR04zohprMnD61XyhGeD
QNd5EkWN0b+oIj+llOXaTVlXfdYhwk9PMsLkkSfppSrIhYqDGCRgF+AGOS19DCpr
eQqxNlHN65VawwvL+/NfzhQcVyNO4DBTq9NterCZDueM+7sB1h70SF2wXdmBAb+U
FjhnrAVKTMABm0V7Su/mTgjkMM7oxNxUjyBt4qgPyo4sQLM4Hr6vvYzBtYHd86mv
vOMLTLrpxqsbwEs4q5NkJYSAVNTk5Xpq92U68ZfcFENkxxYbjh+liM1RdaunLD2V
pxI/UhsHpuNQAtrPRoBgqVKP4f0GRGpXenESVTI0Slj8bwrMttVlXy2kHTY8EmG6
8pmxdxACbXnX0d5WPZAd8Xx6mJrTwkCyJrs3ni6h29u8uNEftM8xK07FYnY+D6yh
y+YdaSxwJX8AdWN/HBYY
=Vfdg
-----END PGP SIGNATURE-----

--LQv0vi9oZBoYbpa7--
