Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaKGQLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:11:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49636 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaKGQLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:11:14 -0500
Date: Fri, 7 Nov 2014 16:10:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141107161029.GV8509@sirena.org.uk>
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415365205-27630-2-git-send-email-javier.martinez@collabora.co.uk>
 <20141107145806.GQ8509@sirena.org.uk>
 <545CE75C.8000408@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="06t+fwoZeTwcpCmx"
Content-Disposition: inline
In-Reply-To: <545CE75C.8000408@collabora.co.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.208
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/5] regulator: Document binding for initial and
 suspend modes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--06t+fwoZeTwcpCmx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 07, 2014 at 04:38:04PM +0100, Javier Martinez Canillas wrote:
> On 11/07/2014 03:58 PM, Mark Brown wrote:
> > On Fri, Nov 07, 2014 at 02:00:01PM +0100, Javier Martinez Canillas wrote:

> >> +	  The "regulator-mode" property only takes effect if the regulator is
> >> +	  enabled for the given suspend state using "regulator-on-in-suspend".

> > Why?

> I saw that the regulator core only call the .set_suspend_mode callback if
> the regulator is either enabled or disabled explicitly...

That's the current implementation.  Why are you adding it to a
specification?

> static int suspend_set_state(struct regulator_dev *rdev,
> 	struct regulator_state *rstate)
> {
> 	....
> 	/* If we have no suspend mode configration don't set anything;
> 	 * only warn if the driver implements set_suspend_voltage or
> 	 * set_suspend_mode callback.
> 	 */
> 	if (!rstate->enabled && !rstate->disabled) {

For example why couldn't these get set by reading the current state?

> >> +	  If the regulator has not been explicitly disabled for the given state
> >> +	  with "regulator-off-in-suspend", then setting the operating mode
> >> +	  will also have no effect.

> > This seems surprising, I'd expect mode setting to be paid attention to
> > even if the regulator is off - we may add other ways to control the
> > enable state in suspend for example.

> ...and I thought that setting a mode if the regulator was disabled in suspend
> was not a possible configuration, that's why I documented that.

Like I say this is at the very least making it impossible for us to in
future add other ways of setting if the regulator is enabled or disabled
in suspend.

> I know that there is both a .set_suspend_disable and .set_suspend_mode but
> at least in the hardware that I'm interested in (max77802), the same hw
> register is used for setting a suspend mode and disable on suspend.

That's your device, other hardware exists which uses seprate bitfields.

> >> +If no mode is defined, then the OS will not manage the modes and the hardware
> >> +default values will be used instead.

> > Again that seems surprising, it precludes any future changes and isn't
> > going to be true for devices where we can't read the current state.

> I saw that you asked Chanwoo on an early version of his suspend states
> series, to point out that in the absence of a initial state, the state is
> the hardware default [0] so I thought that it should be the case for the
> regulator suspend mode too.

You're also saying that the OS won't manage the mode here, that's a step
further.

> So should I just explain what each property is about without trying to make
> assumptions about the limitations that different devices could have and let
> each device DT binding to specify those?

More towards that direction, yes.  Don't overspecify.

--06t+fwoZeTwcpCmx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXO70AAoJECTWi3JdVIfQkWwH+wWbLyMybuTtE00j09Kr+8sA
gekLlYsUTanL6W9sGG1OuZ+aFVJCwH9EgN8GCexhsvKACFxiRRfrNdB2jO+zBsrV
UVi5HXjDfEZQVj3JzWGFV7f0nJS4HL7Dk1ILYynXKLxVRfBGLyCknJMs9Bv4iYR9
s5/HbKQ1naBn1BT7G3rexcC1ADO2tvX1By7QGOf+9UsZ0JJqp0h0iX1yN23Ach+c
Yw82T2MEdx2XuMNVt/k9ttQf+F6OJFtWncXKA6F5L2ID2aJsoaaaFXwiDZebuyv7
07CDoh+AoS5TriHMkEpRXxnibje/bZ+bRbtk96M+nlc/zrJFmcimQZL31fBjmFc=
=6mSe
-----END PGP SIGNATURE-----

--06t+fwoZeTwcpCmx--
