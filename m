Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbaLAWea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:34:30 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49539 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932518AbaLAWe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:34:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Brown <broonie@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
Date: Mon, 01 Dec 2014 23:55:46 +0100
Message-ID: <8649298.kjiCI4IipL@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141201221907.GR7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <1437951.HUEy7xa933@vostro.rjw.lan> <20141201221907.GR7712@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2310997.WuvYB3skSH"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2310997.WuvYB3skSH
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Monday, December 01, 2014 10:19:07 PM Mark Brown wrote:
> On Mon, Dec 01, 2014 at 11:16:31PM +0100, Rafael J. Wysocki wrote:
> > On Monday, December 01, 2014 05:51:00 PM Mark Brown wrote:
>=20
> > > The dream here is that people working on building systems, people=

> > > working on Windows drivers and people working on Linux drivers wi=
ll at
> > > some point be able to collaborate. If we're going to go off and d=
o our
> > > own thing for Linux without talking to anyone that's not really a=
ddressing
> > > the issue.
>=20
> > Well, that's already going on in the DT land, isn't it?  It has bee=
n going on
> > for quite a while AFAICS.
>=20
> In theory (and where it's actually relevant in practice to at least s=
ome
> extent) this stuff is all OS neutral, there's a definite willingness =
for
> it to be so.
>=20
> > > There's also the option that Windows drivers start using _DSD the=
mselves
> > > which is, I understand, the goal towards which the people working=
 on at
> > > least audio are heading.
>=20
> > Technically, Windows driver writers can evaluate _DSD and handle th=
e
> > information the way we do, but I'm not sure if this is really conve=
nient for
> > them.
>=20
> I'm not sure how convenient it is, though I'm reasonably sure a helpe=
r
> library could make it so.

Well, for that we'd need to find a Windows developer willing to write o=
ne I suppose ...

> > We use _DSD, because we want drivers to work with DT as well with A=
CPI without
> > adding special DT-specific or ACPI-specific code to them.  The peop=
le who work
> > on Windows drivers don't have this problem, so as I said, if they c=
are about
> > Linux at all, that may be a good enough motivation for them to look=
 at _DSD,
> > but if they don't, I honestly don't see why they would do that.
>=20
> They care about getting properties out, or at least they should, and =
in
> this market many of the device vendors care about Linux at least as m=
uch
> as they do Windows (sometimes even more than they care about Windows,=

> there's overlap with the Android market).

OK

> > > Note that all this discussion is pretty much about drivers for si=
ngle
> > > devices which can be wired into the system in a flexible manner, =
even in
> > > a Windows world you won't vary the device ID.  At present we're q=
uirking
> > > on DMI.
>=20
> > So the answer to that in my view is: Use _DSD and allocate your own=
 device IDs
> > for Windows drivers to bind to.
>=20
> Right, so we circle back to the original question about documenting
> those IDs and _DSD properties.  :)

IDs are allocated by whoever owns the device description (the starting =
3 or 4
code letters need to be registered via the UEFI Forum/ASWG).

Properties can be registered with the UEFI Forum via the ASWG too.

> > > > > We also need a way of getting the word out to people that the=
y should be
> > > > > doing this (also a problem no matter if we use PRP0001 or som=
ething UEFI
> > > > > specific).
>=20
> > > > What do you mean by "something UEFI specific"?
>=20
> > > Sorry, I mean ACPI specific (UEFI forum).
>=20
> > Do you mean a special device ID of some sort, then?
>=20
> No, just a regular one.
>=20
> > > It's not just the device IDs you need, it's the properties too.
>=20
> > I suppose you have some specific examples in mind that I may not be=
 familiar
> > with and we may spend an arbitrary amount of time speaking past eac=
h other. :-)
>=20
> Things like Documentation/devicetree/bindings/sound/wm8962.txt (at le=
ast
> the optional properties), basically "how is this device wired into th=
e
> board" properties.
>=20
> > That's where we are today.  Do you have any suggestions on what els=
e we can do?
>=20
> I'd like to see a space where people working with a device can publis=
h
> what they've done in terms of firmware binding for it in a manner tha=
t
> might work for them; at present it seems like the UEFI forum is the b=
est
> place to start doing that, there's the start of a register and proces=
s
> for updating it there at least.

That's correct.

=2D-=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart2310997.WuvYB3skSH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJUfPH3AAoJEILEb/54YlRx0+QQAKI0FQdOWrFD92TWgyRq9ocI
slSyRM9gkR/nnS59rp4mg79emAUwKnIpD5OFdwrJx8WhSxmIVrymt+lwHwZsN8pk
SVPywS2FDVQoSbFXLjDuxemCVal++Rp6GO2qGjn4QFZfHbkfOgyWPVqlILLWC+jA
t37R7/X2JLPCD9IapRIUNIfmwecebLPvYX7JpXUMjxbE01eVIn5fCSo/f9zmBAr0
RNqyuUC01k5oFUg9ZbviUhtPEc0lItPkoyBfLTmHhGyFu1vE70Wn1hAGHOVgwgWD
oocFAKuJoRBywpfAPgvBNfWXxbfAQn6jmGrnPIBeK4ahKhQcKOEa2ONhvdlINIBo
DD9eo6+blSA50zX7l/xYgawdl0PyGBKNuOqBz6nULUlrOOnEZ/EzTCjmZpimCeuz
IsazJHuiAYXmAWIwh4l5RRtuCPr7aBKTSdbJDUU07OYyHO+8/6tumfuTTqyBI/yq
Itztyo4FVzvcT3Qki5P5KXeEEBoG919w65nRT9Iw/m18fG2CQxh1V9Sy3u47hDnr
D7lfIRFyGZB+I4wGvPI/QOgZhlTCgldVn0TVY7d314bUIAVxH7VzXKIwu+zk+iTp
syTYna9wP9+qaQ5QF9uvPZdMMIEmy2F41M3ivaJrpPTIt+AnisngGkg1sOCSD0km
iPuO5pE1R/YhWlGhhEDr
=D0EQ
-----END PGP SIGNATURE-----

--nextPart2310997.WuvYB3skSH--

