Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaDPKNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:13:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34812 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaDPKNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:13:45 -0400
Date: Wed, 16 Apr 2014 11:13:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>, Anton Vorontsov <anton@enomsg.org>,
        Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Message-ID: <20140416101323.GP12304@sirena.org.uk>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
 <1397592876-5741-3-git-send-email-dianders@chromium.org>
 <20140416095922.GG4754@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/F2XdnRjS8y2HUtp"
Content-Disposition: inline
In-Reply-To: <20140416095922.GG4754@lee--X1>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] mfd: tps65090: Stop caching registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/F2XdnRjS8y2HUtp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 10:59:22AM +0100, Lee Jones wrote:

> > NOTE: the IRQnMASK and CG_CTRLn registers are the exception and could
> > be cached.  If we find that we spend a lot of time reading those we
> > can turn on cache for just those registers.

> > -static bool is_volatile_reg(struct device *dev, unsigned int reg)
> > -{
> > -	if ((reg == TPS65090_INT_STS) || (reg == TPS65090_INT_STS2))
> > -		return true;
> > -	else
> > -		return false;
> > -}
> > -

> I don't know enough about Regmap internals to know what this actually
> affects in real terms.

> Mark,
>   Does this change seem sane to you?

It does what it says, it stops us caching stuff.  It would seem better
to do what the changelog suggests above and keep caching the registers
that can be cached - especially the interrupt masks, they should get
read in the interrupt path and that tends to be a bit latency sensitive.

--/F2XdnRjS8y2HUtp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTlfAAAoJELSic+t+oim9XG0P/0GYEXL3COJuPxqh4msPQdvE
kGpJmlst0l7U6EU3MVJT3VTqCv6ZuXhxiklxyZYI4CckicqcR2/ob6YiMrcUN9km
FoFclt5EDxWzLAz7GvvxjCNHfllFnju80CSMr9RQD91sWp7Wo5+XyKwRu3t312lk
N50sFcSmk/arIdp6NvQiMXATFjilq13rlfKtKVisIEj92E4DZTgQ3qePl+9USv8K
vMIijoBMIMZyN7ieKDynXUuPNKfykhkkxSR3qBGqeG9x+Uq7rl3sq/4SmVNxo8jx
gLANJ/QXbc7R4lvZcF+xhJiHikl+TQY2A757Kvdmeg/N9YmpvNU2KgLr/ODvqoOk
lzj6J3Rvxmf60ocipoQtzln6A6R3EQDyFKlWsdxyAalBotXSmwK2YLxf5Ypgl8Ye
CCSWGk+WSGwUwiYA5e50O8KICbv55C9YLIe35XdSUT91thEFendF7eevRbyP/jmR
PkS/kcVii4NkLmmk46COre7TO5bxXJYwp1grrfTmuluZXWOPSCSjs2t+33sbM2Bt
xbX08biXZJaZjLfPUOvDK2lV6ivLhWYqoepzl6G48qsd6UUUNcemsPjHvNov2eEH
1v9A0bQ3GDkso7NbEPvhhdjxawbx/VN0cPQc127rnY6l6S/ceNPAfCUFxKK9sai+
aJydW/fwYzo5qXPnTDqG
=kwAY
-----END PGP SIGNATURE-----

--/F2XdnRjS8y2HUtp--
