Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaCAEDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 23:03:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53889 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaCAEDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 23:03:30 -0500
Date: Sat, 1 Mar 2014 13:03:27 +0900
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140301040327.GL29849@sirena.org.uk>
References: <201402271146.s1RBkCGg004925@swsrvapps-02.lan>
 <20140228033715.GE9383@sirena.org.uk>
 <24DF37198A1E704D9811D8F72B87EB51BCFDE02F@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KIbT1ud6duwZIwNL"
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51BCFDE02F@NB-EX-MBX02.diasemi.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.238
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC V1] drivers/base/regmap: Implementation for
 regmap_multi_reg_write
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KIbT1ud6duwZIwNL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2014 at 03:58:34PM +0000, Opensource [Anthony Olech] wrote:

> The algorithm for splitting up into smaller _multi_reg_writes is easy enough,
> so if the calling device driver created a set of (reg,val) pairs for a multi reg
> write operation then surely the intention is for the individual pieces to be
> handled as multi reg writes.

Right, that's what should eventually happen - what I'm saying is it's OK
to defer the hard parts for later if they're not needed right now (in
much the same way that the API was added without an actual multi write
implementation).

> > > +	for (i = 0, n = 0, switched = false, base = regs; i < num_regs;
> > > +								i++, n++) {
> > Don't put all this stuff in the for (), just put the iteration in the for ().

> all those variables are a fundamental part of the loop, but I will change it.

It's still ugly and hard to read, look at the line wrapping...  the
normal thing is to have preconditions that aren't part of the actual
iteration process immediately before the loop statement.

--KIbT1ud6duwZIwNL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTEVwMAAoJELSic+t+oim9Oy8P/0wEzkBCV/COXbXS10uGoHnP
3R9zIHK4wgQUF0uuqlFT220Pjn6OJaUOV8x7eesd4ed3FJ8nU8u4Zg7c35IAmTnT
WwZ74FJc1OonVfgpe3s6pNFtjSjJGFdEY2e2dri/jbehE5MxDdWmZLFzepp58P73
4N8WdQwEmrmrDNgeb/fGJpZLPadJm8Sy0wfF0CIZ039xVbAbbA/6PiFaOaf7bNFk
Wx+awwNNHQ5qpKAjKOaJx7T7oPxELDUqx+nNumM/pBlfuXGwTBe1vea2umswTvIi
/+cN49CK5w9XjwX6cXm0GSln3EZtuFSZai+DruUQxUZ8sERXN9W2kSGWOI7VxLWY
pU0XAnodMB9kR0wsIdRrs6DkQKobyRG2w3Xozy6auuyQ/hDSh/H3X6n3/N/YCghc
SCYEYCpalFldqqFBweTNXtz7oXDioAR3bgzJw6ZZE92XicGXxYCGk8jFog9HmAP+
/WaVkspdJUU90dabUsju6pYvtJMGq9eg91ugFREcvGwq4vItmUXKUQeIcBghc4vj
fR9r+SWkXAugEVE2ywRYNNlo0UQ4IiygBwF1Wn7MI1UjllZwgR4JTaqsFVIbnBHk
CokLHMWZInJ8DhJ79f+PEzbnQ4LfCtfnut11eSosWkO9WbjrVZJF18kTEfQat8ZK
Ddift+1w7VcHsw4mrSMv
=GmEh
-----END PGP SIGNATURE-----

--KIbT1ud6duwZIwNL--
