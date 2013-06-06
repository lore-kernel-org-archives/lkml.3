Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab3FFNQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:16:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33370 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3FFNQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:16:49 -0400
Date: Thu, 6 Jun 2013 14:16:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130606131638.GX31367@sirena.org.uk>
References: <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com>
 <51AF8730.4010507@itdev.co.uk>
 <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
 <51AFA02B.3000604@itdev.co.uk>
 <20130605210715.GA16013@core.coreip.homeip.net>
 <51AFAF6D.7050204@itdev.co.uk>
 <20130606100346.GC1883@sirena.org.uk>
 <51B0651D.3090902@itdev.co.uk>
 <20130606105530.GT31367@sirena.org.uk>
 <51B06FE4.7040805@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5Jh2alslEMtI9ynf"
Content-Disposition: inline
In-Reply-To: <51B06FE4.7040805@itdev.co.uk>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5Jh2alslEMtI9ynf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2013 at 12:17:56PM +0100, Nick Dyer wrote:
> Mark Brown wrote:

> > If that's a big problem just put the data table in a section of the
> > firmware (or a separate file that gets requested as a firmware).  Or
> > have the firmware be able to enumerate itself when asked.

> That still would breach the NDA, I'm afraid. And there's hundreds of
> existing versions of maXTouch chips already out there which don't have the
> infrastructure in place to do what you describe.

I'm sorry, this just doesn't seem plausible.  The data is going to be on
the running system and accessed via the kernel - as soon as people start
using this back door they're going to be revealing what they're
accessing and the information is going to be present in the binary blobs.
You're only revealing that the parameters are present, not what they
mean, and if it's a big concern then do something like strip down the
data file that gets shipped in production to just the controls that are
being accessed.

Again, the fact that you have shipped this stuff doesn't make much
difference here - you really should work with upstream on interfaces
like this sooner rather than later otherwise you're going to have to
cope with pushback.

> If we expose every single parameter as a get/set as you suggest, we haven't
> added anything that stops a binary of the wrong version doing something
> stupid. We've just added a complex API to the same underlying thing, which
> gains nothing.

So this goes back to what I was saying before about the interface being
badly designed - if the API you have to present is really this complex
then you've got a big problem in kernel or out of kernel.

> In practice, where there is a risk of the user mucking up their
> configuration, the open-source user-space tools that we have released
> provide an easy way to back up and restore the configuration in use, and
> the kernel driver provides a way to load a known good configuration on
> probe. The same configuration formats and tools are used across maXTouch
> products on many platforms.

So you're saying that this is all nice and consistent.  If that's the
case then there should be no problem putting at least the core bit that
does the actual physical interaction with the device into the kernel.

--5Jh2alslEMtI9ynf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsIuzAAoJELSic+t+oim97oMP/2qJrKnIAAFYVFjWGXPS+qQ3
LlXBfLhrGup1NflZEmW5kZa6KIbEfLzB1NaMrZQYPj2ij4OzlhU3y0HJuID6z312
Pb9PWadRA+NRgtlTezL8WOiTj0p9vgz6ziXhNwAcRjUIpWB5/crUzB2/C8Q89hu9
lSAt0E5rgxK2IS6NTwU5uatU3FscmiiMJ34vbJBLW41uOgzxx+GHsLTtMgGSsn7M
jTyetmzfuFMkV/l4maA91VXwy2ya+FR5Oqm07gS2r7MJwMFnwceFjtNuxqu1jou6
z4Sm+jqWYWHt3atGieUOPos6Ff9TGkd6CdSptNZOzWlWnz+4OonyDXz4nxZvggdm
PIHweXsC8LGTsYFNDs5NWTlbMXFDmFcBnhaEkC7sAtNWGbteMJpp1tEA5K7SLyVx
ohGZ9I0Pepm6Wac5cOL/rxnNhHIDhyGCuJK6Di96BHskRM2WKmZK8cpytn8Y/l5V
dli6f0OYZXSQsyU/fVZOmSFAzQLNk4yjJKX2q8L1YXn+30q7K6FN2XnK4TFKS7h3
DirLuPIYZGPp6K8I43eD3RsL6ItuUkuf6CXmF7JORHWw0vbkAC9tHc8XTIA7AdcT
rRrUSgRgVTga6auS1YMU2JL9/+j7e6e8CmJbceAUlEk+vNLX5D2LmeiXm2t042SN
oAh8+x6bj4BUF7NoGw7y
=OOcj
-----END PGP SIGNATURE-----

--5Jh2alslEMtI9ynf--
