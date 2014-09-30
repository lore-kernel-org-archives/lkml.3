Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaI3ST2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:19:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55186 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaI3ST1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:19:27 -0400
Date: Tue, 30 Sep 2014 19:19:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140930181910.GJ4273@sirena.org.uk>
References: <20140928150342.CC21B786A1D@smtpfb1-g21.free.fr>
 <20140928151207.GI5182@n2100.arm.linux.org.uk>
 <20140928180550.5f0b8f03@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kr14OxHsRwZHHqxS"
Content-Disposition: inline
In-Reply-To: <20140928180550.5f0b8f03@armhf>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC:kirkwood: Don't raise an error when no DAI format
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kr14OxHsRwZHHqxS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 28, 2014 at 06:05:50PM +0200, Jean-Francois Moine wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > On Sun, Sep 28, 2014 at 04:19:27PM +0200, Jean-Francois Moine wrote:

> > > This patch prevents the controller to raise an error when
> > > the DT audio card definition by the simple card contains the PCM
> > > format of one CPU DAI only.

> > I think this is a silly idea - why should every driver have additional code
> > to detect when it's called to do thing.  Why doesn't the simple card code
> > always pass the required format?

> > Looking at other drivers, no one else does this; they all appear to require
> > the proper format to be specified.

> > What some drivers do (eg, omap-mcbsp.c) is to block set_fmt when the
> > DAI is already in use - setting a flag "configured" in hw_params, and
> > clearing it in shutdown.  Maybe following this will solve your problem.

> > In any case, random drivers doing stuff differently without reason is
> > really not a good idea.

> As the simple card is done, the audio hardware definitions of the
> platform and all the CPU DAIS are always set in the audio controller.

> When the PCM format is globally defined (platform), the function
> set_fmt() is called for all CPU DAIs (then, twice for the kirkwood
> controller) with the same value. The DT is:

...

> The PCM format may also be defined per DAI link. The following DT works
> the same as setting globally the format, i.e. there are two calls to
> set_fmt() with 'i2s':

> The problem appears when the format is defined in only one DAI link:

> Then, audio does not work.

So this is still a generic rather than driver issue and should be solved
outside of the driver - exactly the same issue is going to apply to any
other device with a similar shared configuration.  We could either say
that the DT is buggy here or we could say that the generic card ought to
assume that if only one link specifies a format then it should use that
format for other links if possible (since clearly the user doesn't care
what it chooses).

Please also try to use subject lines matching the style for the
subsystem.  You've been working with upstream for a while, you really
ought to be familiar with this sort of basic process stuff.

--kr14OxHsRwZHHqxS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKvQdAAoJECTWi3JdVIfQkYIH/1q4A6HJAl/PRxCIle+ANwnA
KQFFtEc2/7UK4rscr458j/019Za7yo9iZhnapSpcYwc4AgUd65ivOy/reyZ3W7KG
dmlhRfDzFi4GTZrnng83uUjdyg37QNMDLLF+xS9msJHhrml4Bh7EzPraLKHEWELH
Tg552HSKjyCCQJRif1yb/xDP5PGIw+Bchpm0BQF4q4LpaSyNepE70+hbUWZ6H8aD
gfPWv7Fp180rRayTs8hKV+WY4NupoOX6bJK9M8WFF5Gm1bvzY8EDnWL20pN8ngib
BgwxUGflLwsJfAHpSDkJ5xQitpE3I+2Q8TEjLQLlMlmlWBZgcsXZ9GG657I0/Zw=
=l4XE
-----END PGP SIGNATURE-----

--kr14OxHsRwZHHqxS--
