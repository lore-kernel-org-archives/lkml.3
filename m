Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199Ab3HNTj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:39:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39757 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076Ab3HNTjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:39:55 -0400
Date: Wed, 14 Aug 2013 20:39:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, tobetter@gmail.com, patches@linaro.org
Message-ID: <20130814193950.GQ2401@sirena.org.uk>
References: <1376476171-19072-1-git-send-email-tushar.behera@linaro.org>
 <20130814182239.GC23847@kroah.com>
 <20130814190410.GO2401@sirena.org.uk>
 <20130814191513.GA24873@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQAi4ZBraoACHIeu"
Content-Disposition: inline
In-Reply-To: <20130814191513.GA24873@kroah.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] usb: misc: usb3503: Force late initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rQAi4ZBraoACHIeu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 14, 2013 at 12:15:13PM -0700, Greg KH wrote:
> On Wed, Aug 14, 2013 at 08:04:10PM +0100, Mark Brown wrote:

> > In order for deferred probing to help the device would need to acquire
> > some resource from the parent USB controller once active, allowing it to
> > defer when it fails to get that resource.  Currently there's nothing
> > there for that and it's not clear that's sane and sensible (it'd be more
> > obvious for it to be a child of the USB controller since that's what it
> > really is).

> Then why not do that?

That's why I started the thread about registering devices prior to
learning that they exist; it's a non-trivial bit of work at least from
the everyone agreeing point of view.

> > We can't just treat it as a PHY (which is the obvious workaroud) since
> > we do also need to use the built
> > in PHY in the SoC.

> There has to be some type of resource that it can grab, as obviously
> it's failing to work properly unless that resource is present.  Just

That resource is the USB bus I think (I suspect the issue is that the
fact that power is always present confuses the USB enumeration protocol
if the device gets brought out of reset prior to the bus being live).
The normal way to grab that resource would be to make the device a
device on the bus but currently the only way USB gets children is via
USB enumeration.

> messing with the init order isn't going to solve any problem if the
> driver is built as a module, as nothing guarantees module load order.

Right, and I did discuss that with Tushar elsehwere prior to this being
posted here.  We figured given how cheap and non-invasive the workaround
is it was worth just doing it.

> So this patch wouldn't really solve the problem, only paper over it for
> one type of configuration (i.e. driver built into the system), right?

Yes, though realistically nobody actually does that for the relevant
systems and if they do it's always possible to control the module load
order if you really want to.

--rQAi4ZBraoACHIeu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC90CAAoJELSic+t+oim9TEUQAJl5pcQZQP2qiU5OXqMWK67k
KfJnsDXlmCOPi3BHW6Teu+EE3J6i/aBRc0cW/1Jirf8RJrpI6nKYH+3lxvdmrATS
50LSlSpYsV2r81S+WY/P77+l3PYekaOAmjP9jTy2iezQgFBmo9416iyiJKFnQS+o
1uohpa4TH+8c/LnU4hCFb7eXegjgRPh8xHvjI3xeS/PvEZlhxplsvlW7voWdIzO5
h6IdHW1KPvH7CsLD1LzUx0OlhwFzVPoYHegkbTLpMrUjl+3IJ+gjYdgcrKXlPCa/
DBDCw9df2yCkIoOJec+HpFfaniMMmAOei5Otyt6EYpnRKOjFWsxDkXAbY1peviy1
nhQEq2ZaW5/S7zlQGobwQfl98Jpt6rX1fvUV1dwUSeBCauQqVrUF+wl1svLtoOFV
R7zVuXWf0rGHD/brZiClx0RYSSvpj3OJjKx1sY5lKjfj1ySJsQB6oeTu7vM3kiwF
KS8CyrfJXxY6RNwY9rFuO0fH+bAkIi38sNwVnAzBvgbORzpaV9e6+R0iAjvpAdoN
zwDGejwenPegdsr1E4BtpyeYFcina+tTeXWDMXZ5ORKpa02wXIy/Z5nlZbPpRLcC
Z6j9ow0+XwIyefvFc+Hqgs4Jw2seUrNaFJDm0z+vQaijCHQ4ablVulubz11dY3lg
P1o5g+tXq8RG/s0EMeX0
=3TcC
-----END PGP SIGNATURE-----

--rQAi4ZBraoACHIeu--
