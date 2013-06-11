Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3FKLrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:47:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48007 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3FKLrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:47:49 -0400
Date: Tue, 11 Jun 2013 12:47:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130611114727.GY1403@sirena.org.uk>
References: <20130606105530.GT31367@sirena.org.uk>
 <51B06FE4.7040805@itdev.co.uk>
 <20130606131638.GX31367@sirena.org.uk>
 <51B0B52C.1090807@itdev.co.uk>
 <20130606164629.GG31367@sirena.org.uk>
 <51B1F859.1010504@itdev.co.uk>
 <20130607154134.GU31367@sirena.org.uk>
 <51B20630.7000304@itdev.co.uk>
 <20130607164700.GW31367@sirena.org.uk>
 <51B6FE69.6060505@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HSHpc5A+GJc9BHcd"
Content-Disposition: inline
In-Reply-To: <51B6FE69.6060505@itdev.co.uk>
X-Cookie: Tomorrow, you can be anywhere.
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


--HSHpc5A+GJc9BHcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 11, 2013 at 11:39:37AM +0100, Nick Dyer wrote:
> Mark Brown wrote:

> > I don't think you're using the usual definition of "register map" here.
> > You seem to be switching between talking about this object model the
> > device has and device registers - perhaps the objects are also registers
> > sometimes?

> Yes, in Atmel Object Protocol "instances" of "objects" do each have an
> assigned register range (they do also correspond to modules of code in the
> firmware).

OK, so you're talking about the objects which happen to be implemented
in terms of the register map here.  I think this is confusing to me
because you are moving between the abstraction levels.

> Essentially, the device is designed (and tested) on the assumption that
> touch processing can be going on whilst various parameters are changed in a
> live fashion. If poking around in the register map caused it to lock up or
> behave oddly then that would be considered a firmware bug. In general it
> will fail gracefully - for example if you write a configuration that is
> invalid it will just stop and emit a CFGERR message.

That's not really it, it's the fact that this is being done with no
abstraction - exposing the entire device register map directly to
application layer so the application can totally ignore what's going on
in the kernel doesn't seem like awesome design.

> The absolute worst thing that I can think of is that you can try to beat
> the interrupt handler to reading the "message processor" registers, which
> would possibly leave touches stuck on screen. But even that operation is
> useful in debugging interrupt line issues.

Well, there's also the potential issues with standard application layer
code either not being able to do things that the hardware supports or
getting into a fight with the magic custom stuff.

> > Won't the driver end up getting into a fight with the magic userspace
> > stuff if the driver has no idea what the magic userspace is doing?  How
> > would suspend and resume work?

> On suspend the driver puts chip into "deep sleep" where touch acquisition
> is halted and minimal power consumed. But it will still come out of its
> sleep state temporarily to service I2C comms if necessary (although one
> particular family requires that I2C retry for this case).

So these errors are just part of waking the chip up - in that case
shouldn't the driver be waking the chip up automatically?

--HSHpc5A+GJc9BHcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtw5MAAoJELSic+t+oim9ZvYP/338M1huMc5H2KXPwyCOdIq6
Kb/UOQBkoZiurffkg43KRrHnIo1jgm8YdiGh/sAosdl9J9kTWUS/QK3F7lwVbCAw
FaLQEBtFWFzJJvXfM/Ov3s39vl4yqch1+965NtpH0C/eCxamuAT/Kbmct6EAVYWG
5gqMf814YBKSONu0WFVktbI6CFh1xAPgOkMG4wh4g9aKmntnvl+XvMnYdDtNWdq3
VZyzE1c4lgE1gxHw6PJAJa4zbdurQHltpppkkMJVR7LKaomLuxOTeMlpZLAFi/3d
wA837tl+vB3V5j1x2mTcHFwffFMqM3/34asfBvpEtnNyi+4oYYthMLGO9vu8XU8M
QnVVyYcQRH9fz8Xnl/xsaeUbilT3m16SJ7PgK389sBOYxSrJXPj0JdJQ6YRcuFCu
RLTpYpRKDYOwhY0OtSMu70bNVRK8/8jQWyDyTCZlGgJola/Xm4flN3BZ9QMVySdZ
R22Ax1uifWGTpw8CBInB5p7RzjpjRwJLK76PzMxhq0RSAsqGrmiBUX15luRQCTtH
APIz68lncVy9D1delvlRRHMJGe3kB6FMwl7sPV8RDFOTMgV+fbn1sI93c3QmPOK0
umzcPTiLo3wm9pBOpBIaY+Bj2fbEYBzN3oTwm8O2tCX4VYLi6fT51i7nOUgN+k9L
Ky+itrBwtx2CRXWkJgw+
=BZLt
-----END PGP SIGNATURE-----

--HSHpc5A+GJc9BHcd--
