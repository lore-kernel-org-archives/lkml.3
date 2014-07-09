Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaGIMEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:04:10 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38423 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaGIMEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:04:08 -0400
Date: Wed, 9 Jul 2014 14:04:02 +0200
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
Message-ID: <20140709120400.GA3819@ulmo>
References: <53A1B252.1030204@wwwdotorg.org>
 <20140619080234.GK3407@tbergstrom-lnx.Nvidia.com>
 <53A3096B.1040409@wwwdotorg.org>
 <20140623101441.GU3407@tbergstrom-lnx.Nvidia.com>
 <20140708130501.GC9516@ulmo>
 <20140708141135.GC23218@tbergstrom-lnx.Nvidia.com>
 <20140709063130.GA3170@ulmo>
 <20140709083311.GE23218@tbergstrom-lnx.Nvidia.com>
 <20140709102551.GA19357@ulmo>
 <20140709110816.GF23218@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20140709110816.GF23218@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 02:08:16PM +0300, Peter De Schrijver wrote:
> On Wed, Jul 09, 2014 at 12:25:52PM +0200, Thierry Reding wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Wed, Jul 09, 2014 at 11:33:11AM +0300, Peter De Schrijver wrote:
> > > On Wed, Jul 09, 2014 at 08:31:32AM +0200, Thierry Reding wrote:
> > > > > Old Signed by an unknown key
> > > >=20
> > > > On Tue, Jul 08, 2014 at 05:11:35PM +0300, Peter De Schrijver wrote:
> > > > > > >=20
> > > > > > > Yes, but the problem is that you also need clocks and reset o=
f other modules
> > > > > > > in the same domain to safely control the domain's status. Eg:=
 the ISPs, VI and
> > > > > > > CSI share a domain. VI and CSI are useable without ISP and th=
e ISP lacks
> > > > > > > public documentation. So it's not unlikely a VI and CSI drive=
r will upstreamed
> > > > > > > someday which means we would need to control the domain and t=
herefore would
> > > > > > > need to tell that driver about the ISPs clocks and resets eve=
n though the
> > > > > > > driver doesn't know anything about the ISP hw otherwise.
> > > > > >=20
> > > > > > Can't we make powergates reference counted so that they don't g=
et
> > > > > > disabled as long as there are any users? Looking for example at=
 the
> > > > >=20
> > > > > We could, but then why not switch to the powerdomain code and mak=
e powering
> > > > > off a domain a NOP until we sorted out the context save/restore o=
r fixed
> > > > > the framework to allow for suspend without turning off the domain=
s?
> > > >=20
> > > > Well, one of the reasons why I'm not sure it's worth the effort at =
this
> > > > point is that we can't get rid of the tegra_powergate_*() API anyway
> > > > because of backwards compatibility. So we're going to add code (wit=
hout
> > > > getting rid of old code) merely to support some generic framework. =
That
> > > > doesn't sound very useful to me.
> > > >=20
> > >=20
> > > We can also convert the existing users to genpd. Today there are only=
 2 users
> > > (gpu/drm/tegra/gr3d.c and pci/host/pci-tegra.c), so that doesn't seem=
 to be
> > > an impossible task.
> >=20
> > We can certainly do that. What I'm trying to say is that since people
> > may be running newer versions of the kernel with a DTB that doesn't have
> > the necessary properties to hook up power domains, we have to keep calls
> > to tegra_powergate_*() functions as-is, lest we break those setups.
> >=20
>=20
> For those 2 domains we can find the necessary clocks and resets by parsing
> the relevant existing DT nodes for PCIe and gr3d. For clocks, this isn't
> even needed as we can always register some extra clkdev's to get them. Th=
ere
> is no equivalent for resets so we have to parse the gr3d and pcie DT node=
s,
> but that's not too bad I think.

Even if we could really do this, at this point I don't see an advantage.
All that it would be doing is move to some subsystem that doesn't quite
match what we need just for the sake of moving to that subsystem. Having
a Tegra-specific API doesn't sound so bad anymore.

Thierry

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvS+wAAoJEN0jrNd/PrOhgzsQALgCYuk/HbxfLGMK4FehH188
eofdS07pw7xg2f2kcek9DHXz0UiKxeF0JHd/ZkvYnwU7c2Xy0SmEUCfNb3vSeyTw
mfLIWPhE3EV6qjaWeOZvn+fDMavLPFOWyL0CRtcBjTXKrL565xhiLjS5fiabknrp
DJsV6edETjRrAh1ejEW3frjNbZwPez3mDXzdKp+50rxyQXWcDjRc6ZtFLLUWoyTH
7G/82wXh+nFGH9V+eMDYQPtjURXagfRcvAme3g/ZdXMCLZu9w7ztoNmwM6Badogq
60qncZ2ECq4diB2403X8wqK3bTUtW+LsCjwteCsXWqVzstp9sPPMA6RXi/x37fAD
f3pnGZCqHKjyhQS70H29bIJEzCNxlRcEgosIJHz0SX+vARNGBf6BuWWVWldOFBSD
dUcHvsP7qG+jxCzS02gw88bEgHliuOUxMIy9hOJ186MVKNQB5aYa8AuSJMVSs+q9
/bUJo68MLPQCRn6H39yefcuiUz8DK2wp8MJViPW5rKZXb+F34qhHqAyKYyVIIiB+
viYmeN7/8TqhRBsojrGP5jamqRxinqs02kjmmh/m5goAgGs0e5IC2+nTjRkRmb0i
uIGrkrXOANNQZCR0nQ3dnk95iU8Pqly7SxMTvq+HRokPSsQhW1Cb5fN4qNzt9hzo
DQVkKXTvUbuxDecBJmIJ
=eUbV
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
