Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbaGIGbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:31:37 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44443 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaGIGbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:31:35 -0400
Date: Wed, 9 Jul 2014 08:31:32 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
Message-ID: <20140709063130.GA3170@ulmo>
References: <20140617121313.GE18816@ulmo>
 <20140617140146.GH3407@tbergstrom-lnx.Nvidia.com>
 <20140617215119.GC24743@mithrandir>
 <20140618121806.GJ3407@tbergstrom-lnx.Nvidia.com>
 <53A1B252.1030204@wwwdotorg.org>
 <20140619080234.GK3407@tbergstrom-lnx.Nvidia.com>
 <53A3096B.1040409@wwwdotorg.org>
 <20140623101441.GU3407@tbergstrom-lnx.Nvidia.com>
 <20140708130501.GC9516@ulmo>
 <20140708141135.GC23218@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20140708141135.GC23218@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 05:11:35PM +0300, Peter De Schrijver wrote:
> > >=20
> > > Yes, but the problem is that you also need clocks and reset of other =
modules
> > > in the same domain to safely control the domain's status. Eg: the ISP=
s, VI and
> > > CSI share a domain. VI and CSI are useable without ISP and the ISP la=
cks
> > > public documentation. So it's not unlikely a VI and CSI driver will u=
pstreamed
> > > someday which means we would need to control the domain and therefore=
 would
> > > need to tell that driver about the ISPs clocks and resets even though=
 the
> > > driver doesn't know anything about the ISP hw otherwise.
> >=20
> > Can't we make powergates reference counted so that they don't get
> > disabled as long as there are any users? Looking for example at the
>=20
> We could, but then why not switch to the powerdomain code and make poweri=
ng
> off a domain a NOP until we sorted out the context save/restore or fixed
> the framework to allow for suspend without turning off the domains?

Well, one of the reasons why I'm not sure it's worth the effort at this
point is that we can't get rid of the tegra_powergate_*() API anyway
because of backwards compatibility. So we're going to add code (without
getting rid of old code) merely to support some generic framework. That
doesn't sound very useful to me.

> > display controller driver, modules don't seem to care overly much about
> > the powergate's state except that it needs to be turned on before they
> > touch some of the registers.
> >=20
> > From a bit of experimentation it also seems like the sequence encoded
> > within tegra_powergate_sequence_power_up() isn't at all necessary. I
> > couldn't find an authoritative reference for that either, so I'm tempted
> > to conclude that it was simply cargo-culted from the dark-ages.
> >=20
> > So I'm thinking that if we ever move to use power domains for this, we
> > may be able to just drop any extra handling (well, we'd need to keep it
> > for backwards-compatibility... *sigh*) and let drivers handle the clock
> > and reset resources.
> >=20
> > On the other hand, given that we already need to keep the existing code
> > for backwards-compatibility, I'm not sure there's a real advantage in
> > turning them into power domains, since we'd be adding extra code without
> > an clear gains (especially since it seems like we'd need even more code
> > to properly handle suspend/resume in drivers that need powergates).
> >=20
>=20
> Unless we fix the framework to require context save/restore for suspend.
> There is a good reason to do that. context save/restore requires energy
> as well, so it's not a given that turning off domains in system suspend
> will save power.

I'm not sure I follow. "require context save/restore for suspend" is
what many drivers currently don't support, hence we can't use the
generic PM domains. Perhaps what you're saying is that the PM domain
core code should be enhanced so that domains can be marked so that they
stay on during a suspend/resume cycle.

Such functionality could be part of a specifier in a DT binding. It's
technically not a description of the hardware, but it encodes a device's
requirements regarding suspend/resume latency.

Thierry

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvOHCAAoJEN0jrNd/PrOhSWYP/ii2wlR15uMXlLs5i6Rfp492
iakh2grZLuClz0nqqVq6inDhak2+PQ3ehq7Y1x/+9Am7n//vvYwB8Fd/9Oo2zer1
4uT/xxyrXKXaO9KMuczycTpFLA6hSZS/WbUJMcOdb7axF95FlAeOe/AlaGMrD+aL
E6FDvvT3nmxVFmJfHJCSorsJWguGW8bYFGkVQt+lGvdRMUtUaRnEYxFfk7jzJWLd
/E/y38g+RyoaTTw6e05RXEOM9iA+ituSVpkjL/RVlxu2cDuH4TqXhYzK/wAYmVky
RWeh+CyerRyJ22q8S+kQ5T7aLWlz6zxk7sT6EOyRyRdikqePRgnVv6ThLqJ1KPML
KrM2K7fXCJkN4yifY8TQAcX11W3OEMpU3EBk6P1BknuQ184mrr7eaMhQVwBZnEnx
OVPBjaafoPXjkydf9gyZGffEcy6kGEo5b8L673ryaT66rhdwhE2CCUWKifz7R/2c
hEtkuVOVQo2TSptKecEKFkHfl7a96nuZ7jkFIHfa407pE1pMzTA5a0TQcsMry1Ki
9WB8hTqJZrVXLlf6pplDQqyn53yM9f7N7aG3YTYdFzvcOYF4pGhSEIuo8hEaWrD/
9uVqGITBoZIwwbnFbaWoEz9QA3JtrabQFYiioTpTDa6kT6y22IXF66fguTeQwPE/
6H5h2C0t3amJ1oVii1Fx
=A34F
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
