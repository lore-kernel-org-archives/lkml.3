Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965101AbaH0U0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:26:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36605 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965063AbaH0U0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:26:13 -0400
Date: Wed, 27 Aug 2014 21:25:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140827202554.GW17528@sirena.org.uk>
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk>
 <53FE2446.3040402@gmail.com>
 <20140827183733.GN17528@sirena.org.uk>
 <53FE25EB.7060702@gmail.com>
 <20140827184705.GO17528@sirena.org.uk>
 <53FE2901.50508@gmail.com>
 <20140827191526.GS17528@sirena.org.uk>
 <53FE2F9E.80501@gmail.com>
 <20140827194411.GU17528@sirena.org.uk>
 <53FE387F.3030302@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wEk44teJy1btJsu9"
Content-Disposition: inline
In-Reply-To: <53FE387F.3030302@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: max77802: set opmode to normal if off is
 read from hw
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wEk44teJy1btJsu9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 09:58:55PM +0200, Tomasz Figa wrote:
> On 27.08.2014 21:44, Mark Brown wrote:

> > The point is that if anything was setting the mode to something other
> > than normal it was almost certainly a previously running copy of Linux
> > and one would expect that if the mode does need to be changed the new
> > copy will be doing that anyway.  It's rare enough to need to actively
> > manage modes in the first place.

> From what I know based on my experience with Samsung boards we used, the
> opmodes of regulators are preconfigured by board bootloader to certain
> values based on power design of the board (i.e. there is no need to keep
> a regulator in full power mode, if on given board only a little fraction
> of it is needed).

Well, presumably the bootloader is going to run again even for a warm
reboot?

> Now Linux should not change this mode (excluding cases when the values
> in the bootloader are wrong - they happen unfortunately), so I'm not
> getting why you say that it is Linux which changes the mode to something
> other than normal. Linux should only toggle between the value resulting
> from power design and off.

It's not in general true that Linux should never change the mode (the
main case for toggling modes is usually going between an idle/suspend
state and active state) and for practical purposes bootloader and
hardware defaults tend to be the same.  You're talking about the case
where the bootloader does set something but avoids doing so on warm
reboots only here.

Besides, even if we did have a way of specifying modes in DT (with all
the problems that brings) we still have to pick a default if that's not
used).

--wEk44teJy1btJsu9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/j7PAAoJELSic+t+oim9c8MP/0z8OtI+T21zCwrp079h3T1f
ElUier850asDDs80ZnxvHd8IBF/5yQfKvrKOgg9GrVK7ZzgISG60ebbRpdeu/V1Q
PiLjCa66BRgfhJrxP2fGUXypbwWzMgR8BMgcoyNOofke6YOMO3fO3Sn7IsWabCGU
sy8ZuP+A7KZtHyMsm3oXPUKxaRC3hyEDvya9w2FT2s+o8cmPwoK/AODeIbimRGDu
k5LBUZlhDSciXyM9UdQSvLjJiA3sAZvinMsZRveHe+VCKhzy8+2Pv8G18FKTIXaI
L6fGiHAJnWO/FamsWDwXwUEsQtAa2zSgCwSIt0JStvv2sGT93SfqSKiNDdkxTTIp
sdr8pTdEcML0Mj6quZYjr55c3cjSCAFrexyWG1SDYWLcfJTEBBchiS4NUoVwOvYJ
k8Vv21RrQBptWhChz532R21dWj7nsQc7n+up0lvs+Ojosy1AEjWovNCItYVc+JoT
4EKUpqlBfJOl2JNyHV4vFYM/WLfPryghZxSVdynulsAUs/VY3HNWhXESvAY0tDj+
IwV2AsF7BbpjcLRC1sQ92Ewn5xJfBNnitlTKa5lDM2/1iVsvBqg1RaoQayx4+Uwd
DQFfpxscXd05YeWkR4e8kV575fM1TWtJg9O3wmAeja0RH+Y9NRTgd5uGLB8MU7oU
bYEcbpylWGYX5dPzscUN
=pR/+
-----END PGP SIGNATURE-----

--wEk44teJy1btJsu9--
