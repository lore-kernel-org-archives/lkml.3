Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab3HSUEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:04:42 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:35852 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab3HSUEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:04:40 -0400
Date: Mon, 19 Aug 2013 22:04:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
Message-ID: <20130819200435.GA5191@mithrandir>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
 <20130816215530.GA14464@mithrandir>
 <CACxGe6uhiKY7a0+aViEamwKbE2tJicVc8CMZChBUaf+KYTs5rw@mail.gmail.com>
 <3558931.NyoikKT8ha@flatron>
 <521276BE.4090208@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <521276BE.4090208@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 01:49:18PM -0600, Stephen Warren wrote:
> On 08/17/2013 04:26 AM, Tomasz Figa wrote:
> ...
> > Please correct me if I'm wrong, but to get to initcalls you need a time=
r.=20
> > However a timer driver might need interrupts (to tick) and clocks (to g=
et=20
> > the frequency).
> >=20
> > At least this is what happens on the platforms I work with. They don't=
=20
> > need any special early registration method, though. We just special cas=
e=20
> > those drivers, as Thierry pointed, so they don't use device based APIs.
> >=20
> > However if we consider a more complex setup, let's say that the timer=
=20
> > driver needs to access some special registers, which are shared with ot=
her=20
> > drivers as well (again not a completely exotic case, as I already met t=
his=20
> > when working with timer and PWM drivers for older Samsung platforms and=
=20
> > had to hack things a bit). One would suggest using regmap here, but it =
is=20
> > a device based API.
>=20
> To take this even further, I'm not sure there's a particular reason why
> the timer has to have an internal clock source driven from the same chip
> clock input as the CPU itself. What if there's a separate clock input,
> whose source chip has an enable input, which is connected to a GPIO,
> which is driven by an I2C-based GPIO expander? Admittedly that's a
> pretty crazy HW design, but I doubt it's much other than an accident
> that it doesn't exist in practice, given the probable lack of feedback
> cycle from Linux SW internals to all board designers.
>=20
> It seems like the best solution here is to make the generic case fully
> capable. Perhaps initcalls shouldn't depend on a timer at all, or should
> be split into sets that require certain services, and those services can
> appear dynamically, and when they do, the relevant initcalls that were
> held off by lack of a certain feature all get triggered.

But that's pretty much a special case of deferred probing, isn't it?

If we make it any more specific than deferred probing we'll end up with
a set of statically defined features that drivers need to check instead
of directly requesting the resources they need. Maintaining that list
will probably be manageable, but how will that handle cases where for
instance two drivers announce the same services and one driver depends
on that service? It'll be difficult to find out if the provider of the
service is the right one.

Thierry

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEnpTAAoJEN0jrNd/PrOhJKQP/1/fbv+1crpGtEpkD/SsnwWP
zyD+Nkah2KgOsf3pk/ksNsllJCqI0SN4gS9ky0gIj7i8AwyQrtM82h5Oqk3VXxh4
JpWBIk49bGrAIwCRRTRJq9J6YLxmZjQBJIlo1J4fuqubmw9kVPDID9S0dtKUovoF
3wWiYjmtaRTs0FFYzw7jjqthZJ3a+AJjKV78+vGjbFztVwP0FCli0RijIBM0VTn+
x4RX3j0+mdYcKyDNBk0anCsq2YIhQK4R15zxNk8c8tjrsPeM5fbjQSNvVqPBA6kd
QYnlrG6pvf8IdkZ4NIf4JSLCJQJG/+VCMBElIED21QlZtSWBPOGEfAI2Mh4ZlDEE
AZ0kqqB835qmVHQNLq12pEWJsArgpulEG4zf78bqPjSoxehQ4RdH3In+lgqUL0Yv
elqdGJBCuLjsNDHWpEOaT01JdTLrs2jIT3LXF+uXkfs2DXU72WGw6I9pGGOzi8kb
OMa+W92urlGqUomHNViXWZ+35gX32ZbmsTBGID0+Z5WETyyx3BZBorEUIigFJDQH
S4Tn060KvibxqcFgG+o5O/pRNQ4bJDSyE9UfSE5TZbdcgFi0hfCKTTMNsJUol+PM
hbBBCnfSyHBQP4adQvqLYTgGMEhpv7e6zBz/+2ppqkqIGqPa75fGp3hZL4pu4bai
oruXTNWu1xhWPJqjMd6E
=o0Sg
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
