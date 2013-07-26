Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379Ab3GZQYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:24:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34538 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab3GZQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:24:20 -0400
Date: Fri, 26 Jul 2013 17:23:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>, devicetree@vger.kernel.org
Message-ID: <20130726162355.GR9858@sirena.org.uk>
References: <1374781320-10793-1-git-send-email-vpalatin@chromium.org>
 <20130725200343.GV9858@sirena.org.uk>
 <CAP_ceTyH3Yfw5ruSWfaDz_e=vrgkS6FT8PV1XgcCAwxLroHm1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5gLVUf0OArUb3P4b"
Content-Disposition: inline
In-Reply-To: <CAP_ceTyH3Yfw5ruSWfaDz_e=vrgkS6FT8PV1XgcCAwxLroHm1g@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: read low power states configuration from
 device tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5gLVUf0OArUb3P4b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 09:06:56AM -0700, Vincent Palatin wrote:

> > The reason this isn't in device tree at the minute is that suspend to
> > disk and suspend to RAM are somewhat Linux specific concepts and the
> > whole thing gets more and more dynamic as time moves forwards with the
> > suspend state for practical systems depending on the instantaneous
> > device state prior to entering suspend and the bits that are fixed often
> > involving sequencing elements and so on which get fixed in hardware
> > and/or bootloader.  Do you have practical systems where this is needed?

> Yes, on a Chromebook machine, an internal USB device power rail is
> connected to one of the FET of a TPS65090,
> the device is leaking power in suspend-to-RAM, it would be nice to cut
> the FET during suspend.

So this isn't powered off through a combination of the normal suspend
process and strap/bootloader configuration of the PMIC?

> you mean declaring an optional (string) property  such as :
>  regulator-suspend-mem-state
>  which can take the value "enabled" or "disabled"

I'd probably go with an optional boolean property but yes.  Suspend to
disk is relatively clear but I'm rather nervous about suspend to RAM
here.

--5gLVUf0OArUb3P4b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8qKYAAoJELSic+t+oim9eMAQAI+IqoBD9C39ve2OF0Wt9Iw2
1GEHRrYTgZ6f7FcMg/3pPBNm3qnxGgOTxIy3pxT0CtOuo16MhdbaVTEzGrbb0FRG
JObFLl8zQbEqHyQdRq1+KzjUFzZV2j6TUE938ICjZCiuZhINQEXqyJaVhBChubqz
CIbXFeRcgX6zfBo/E6n6n3GGY8JUHBaO5VKw2aLrbgrRTR25w/sEOIf+VhbU/SoH
5SgEtbxmZhi5tzoNJJ4n+mYWLUVAgDtBuLSWY8dz7r+zI9/mPrZwviW69jSXfqcA
2j4JIeas9sxQTLAmI3770M50zzCVPcrJFKG9No5eJUG5fFpWPNUu+YF7Cql72HE7
XRFd7EvWC0cznmm5wvoCCEx/VRMdVKtgeRXOwyvBjcrUmuGYWeCN0TwhLxiVyB3K
42CLGOKu3FAv2J0kr4td50K4FigipH8YanBt+OpeNtQtMh5UbBykoUlIJ0hWT/w3
ysIJxIu7o9wArCmneVx3mvNhZ7e+c0gXN4GdlxjvOC6NHUMdseF3ZDIH7UxKBnLH
Cmjz7/+d5I8k3Hpy1ZpOyPTSr46rqk7iJU/SBUzu2rvUKtAMXkAivMHiEY02kyL+
R0Y+xo/L07UihSHntaufzSOpzV7LxoC3t+PSfq0H5cUUo5bmfyDyJi7gO2v3/t6Z
Ao4LV47TZ3ANMKZj7Rrt
=Kl75
-----END PGP SIGNATURE-----

--5gLVUf0OArUb3P4b--
