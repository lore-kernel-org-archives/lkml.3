Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaJTT52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:57:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38474 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaJTT50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:57:26 -0400
Date: Mon, 20 Oct 2014 20:56:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Zhong <zyw@rock-chips.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Message-ID: <20141020195641.GT18557@sirena.org.uk>
References: <1413454410-23396-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413454410-23396-3-git-send-email-javier.martinez@collabora.co.uk>
 <CAD=FV=UtwNjyx56QtRrEo=jbX_PeMRAYZJVXzxqeS-vs4JyGRg@mail.gmail.com>
 <54453F2E.1080401@collabora.co.uk>
 <CAD=FV=WJfjhb9pfNhQwpToddR67NpA+m6kkj5oUVE5ewEhzvVQ@mail.gmail.com>
 <544567A1.2060006@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sosn/fv6aiTyEgxl"
Content-Disposition: inline
In-Reply-To: <544567A1.2060006@collabora.co.uk>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sosn/fv6aiTyEgxl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 20, 2014 at 09:50:57PM +0200, Javier Martinez Canillas wrote:
> On 10/20/2014 07:36 PM, Doug Anderson wrote:

> > I guess I was just trying to follow the suggestion that was in the
> > regulator code:
> > http://lxr.free-electrons.com/source/drivers/regulator/core.c#L3699
> > that says "This will usually be called by machine suspend code prior
> > to supending."

> I see, but still I feel as if it may be a lot of duplication since most
> platforms will likely want to call the regulator core suspend prepare

Note that architectures are an example of a platform.  It really depends
what's responsible for final poweroff, we want this called as late as we
possibly can.

> and finish functions. Maybe it can be added as a Kconfig option so each
> platform can choose at the config level if they want those to be called?

No, that's obviously not going to do anything useful for multiplatform.

--Sosn/fv6aiTyEgxl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJURWj4AAoJECTWi3JdVIfQlTsH/RfUqb+3xLWmk7MxF0pVO4kb
yFP8aLnW4rl/6W4zV5UbSs0TTpAJlUMOvVmAXd33A4qM3cpdIlLT4Da4X/kxh9dL
oCrz7lMXq1WjMyiZzDok2fC02vK1zbi1s6JE/SsUXm0nYbZZ78E/QSgvu3Eq7mdU
ptWKfyUJxnlXMGCmf8PXXSlmij8e28xSmS3WyGmykaWLNMto5Bswvu5q1TZUsJkY
G58S8oCPwtKyJlZ161o/qwja8o8L0tvQiTtBHuYWc2hK8SJZjdtaZbEGw0lBQppI
ISFQPC5UgV0JRLdcmq+oTx3dlIlQ5OmWMJky6bws/9eiGUMcW/B1qDD3N5Tjau0=
=ELdq
-----END PGP SIGNATURE-----

--Sosn/fv6aiTyEgxl--
