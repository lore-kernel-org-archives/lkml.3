Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaJXU6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:58:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46906 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaJXU6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:58:51 -0400
Date: Fri, 24 Oct 2014 21:58:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        airlied@linux.ie, robdclark@gmail.com, davidb@codeaurora.org,
        dri-devel@lists.freedesktop.org
Message-ID: <20141024205840.GM3729@sirena.org.uk>
References: <1414178111-19525-1-git-send-email-balbi@ti.com>
 <20141024201138.GL3729@sirena.org.uk>
 <20141024201827.GJ11455@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ICrdrp3pM9DyZLTK"
Content-Disposition: inline
In-Reply-To: <20141024201827.GJ11455@saruman>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: stub out devm_regulator_get_exclusive
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ICrdrp3pM9DyZLTK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 24, 2014 at 03:18:27PM -0500, Felipe Balbi wrote:
> On Fri, Oct 24, 2014 at 09:11:38PM +0100, Mark Brown wrote:

> > Right now not having the stub seems to only be affecting buggy users
> > (which given the use cases for _exclusive() isn't *that* surprising) so
> > I'm more inclined to leave this there in the hope that the users get
> > fixed or we can at least get some sort of dialogue with the relevant
> > maintainers.

> quite frankly, flawed or not, I still think it's wrong of regulator
> framework to cause a build break during randconfig. Pretty much every
> other call is stubbed out, why wouldn't this be ? Moreover, if nobody

Well, it wasn't precisely a thought through choice before it happened
but when it was reported it wasn't obvious how someone could use a stub
(or what that stub should be) so I looked at the code and it just didn't
look at all sensible which made me think having the stub was a bad idea.

There are some bits of the regulator API which can quite happily be
stubbed out since the stub behaviour is within what could happen in
normal usage but there are other bits where the user really has to care
about what's happening and should probably depend on the regulator API,
this is one of the latter bits.

> cared to this day, why would this randconfig build break change their
> minds ?

For me it's more that I'm not terribly motivated to add code which only
serves to enable broken usage; it may be that there's a perfectly good
explanation for what the driver is doing but nobody seems to care about
it so...

--ICrdrp3pM9DyZLTK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUSr18AAoJECTWi3JdVIfQXDsH/AtoobO+17GlrKwfwPN+ZZIk
enP6UC+AxtL19HQPx94fg2wojX9lBcPFD30nsdCEnVxBpF0wKrjddge76S1mdj12
8x4PxfhFQqfoOd66c7wq3MWRLiLDh0g7+RIsJ1bKA4inPLvy+XTcmGHOSrZ5HZ5s
B8762js2Jku3mdqN2McIkBDQXkRezyFJb/cEKmDd5IhNfEXJGxEXVLkMSn59j6F5
ww+Tm/c4K7sVtsmYbLUCZSjMaco17U8CWF1EHdYO5UmJS1NEiTNQ4rohcO1RJO6/
0M05te2zv19Jc0wBxBGgbqvNFYRKfcQ89ncHWQDHErqMZjzOi1KkNTpi0LrPf+E=
=uME0
-----END PGP SIGNATURE-----

--ICrdrp3pM9DyZLTK--
