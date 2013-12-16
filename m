Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3LPVlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:41:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47828 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3LPVlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:41:23 -0500
Date: Mon, 16 Dec 2013 21:40:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>
Message-ID: <20131216214057.GG3185@sirena.org.uk>
References: <1386965234-26461-1-git-send-email-tony@atomide.com>
 <20131216183615.GK3185@sirena.org.uk>
 <20131216194023.GE26293@atomide.com>
 <20131216201102.GP3185@sirena.org.uk>
 <20131216210512.GF26293@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+GiWpZ/vZzfY9+ZQ"
Content-Disposition: inline
In-Reply-To: <20131216210512.GF26293@atomide.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Start using standard gpios property and
 deprecate some custom properties
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+GiWpZ/vZzfY9+ZQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 16, 2013 at 01:05:13PM -0800, Tony Lindgren wrote:
> * Mark Brown <broonie@kernel.org> [131216 12:12]:

> > This is the first time anyone's mentioned this so it probably isn't that
> > serious an issue and bear in mind that the patch was also handling all
> > the named GPIO specifiers too.

> I've certainly debugged this same exact issue twice already and that
> probably means that same issue has been debugged tens or hundreds
> of times by other people.

That surprises me to be honest, but then the fact that the convention
was even defined surprises me.  Like I say you're the first person to
mention it; I suspect you might write more DTs than most.

> Personally I don't see any value for a regulator describing the names of
> the GPIOs in the binding, it's really up to the driver to make sense of
> them. Especially if there are one or more similar GPIOs. We're not

Devices like PMICs frequently have a *lot* of possible pin functions
some of which can get mapped onto GPIOs (in either direction), many of
which are going to be fixed by system design and generally all muxed
onto a much smaller set of physical pins.  If you try to specify those
through an unnamed gpios property you end up with a very large array
(say 30 elements, more wouldn't be too surprising) most of which will be
empty.  That is not at all usable, it's error prone to write and very
hard to read even with the preprocessor support that only got added
quite recently.

> naming interrupts either.

There's typically a much more limited set of interrupts a device can
have (and many of the more optional ones end up getting expressed via
the GPIO binding since you also need to read the state to use them) so
they don't run into the issue so much.

> > In any case, the thing is that there's a difference between parsing both
> > and deprecation - deprecation implies an intention to remove the old one
> > which would just reintroduce the problem the other way around since
> > people are likely to drop or forget the plural, use old DTs and so on.
> > Adding a gpios property in parallel with plain gpio is fine and what I
> > was mostly suggesting.

> Deprecation _may_ imply that it will get removed, but not always.
> Naturally we're going to have to keep the old bindings in place since
> they were merged. I can changed that to obsoleted if that's any better.

Yes, that's better.

> > Exactly, I think it's way more trouble than it's worth to try to change
> > for named single element lists.  The standard property makes more sense.

> I don't think there should be any named GPIOs. If we want names, then
> the GPIO usage should be possible to group quite easily rather than create
> a new property for everything. Something like "enable-gpio" comes to mind.

I don't understand the difference between your suggestion and named
GPIOs.

--+GiWpZ/vZzfY9+ZQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSr3NlAAoJELSic+t+oim9iDYP/i+jDxlPFZvahRT3hl1G5ZRR
zneNmRGVvQ+GVHW2ZclI5s0eLPSNv0lKKl97n4QHRsIzvAGcSspBCg/WYda1gdp6
Eaje6FL9McpglsU0lkOY/3SpGzPJPsdMWilqPn7E+dywv7HwClus8ugPSS9i7Hpz
itpodSiHNUSrWYWSneTvZZOBWBXRoLrX2EkIS137plmz4EmZ7vKXI3uwigzPi3QO
OohJW4573SE1RvKHQ1oSyKGR7fpVOJFnFLwAYxvD8yxkMbHyQx4zlH1gWA4nShkl
L7I35AtJiVErlmvCBzpXFqWBLoduKh0xna8e473tg+3E9jqBuaqCsR/xVTnhblnC
m/xbzlHQdDIDHyqtY5+go5dvlMyHKk2bQsKJLnLolo6NJ795Lc7j7uU0vCzW+Fa6
bv44Z5NHPc4371fyoCodLRJAkaYrIMYhH29YLfjmgsyBo9v0kIeC9YseRgR56Ach
/X/8IT5lM1Yz6FlPCGTldXJLQZh3wSXAU9/PwMs41Lq9L1yWnP/qkLVATXMLVmfA
ibmLpMijrd2AmW9PLpwR0NMpmNnM3NStljUAd5s7/dpPbx5yLzkiS9+nP3i23PI9
dnF9K06KV2kGTZFE+Dk+4mNveE191u1iyPMpCfy6KBFUcpV/1S56VejPayBXyJQZ
aB9SjJuUPjVCX/tdHl98
=Xy8L
-----END PGP SIGNATURE-----

--+GiWpZ/vZzfY9+ZQ--
