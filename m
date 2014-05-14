Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaENO3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:29:47 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:55508 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaENO3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:29:45 -0400
Date: Wed, 14 May 2014 16:27:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
Message-ID: <20140514142739.GA8612@ulmo>
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
 <1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
 <53725FED.7050303@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <53725FED.7050303@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 12:09:49PM -0600, Stephen Warren wrote:
> On 05/13/2014 08:06 AM, Peter De Schrijver wrote:
> > Add shared and cbus clocks to the Tegra124 clock implementation.
>=20
> > diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bind=
ings/clock/tegra124-car.h
>=20
> > +#define TEGRA124_CLK_C2BUS 401
> > +#define TEGRA124_CLK_C3BUS 402
> > +#define TEGRA124_CLK_GR3D_CBUS 403
> > +#define TEGRA124_CLK_GR2D_CBUS 404
> ...
>=20
> I worry about this a bit. IIUC, these clocks don't actually exist in HW,
> but are more a way of SW applying policy to the clock that do exist in
> HW. As such, I'm not convinced it's a good idea to expose these clock
> IDS to DT, since DT is supposed to represent the HW, and not be
> influenced by internal SW implementation details.
>=20
> Do any DTs actually need to used these new clock IDs? I don't think we
> could actually use these value in e.g. tegra124.dtsi's clocks
> properties, since these clocks don't exist in HW. Was it your intent to
> do that? If not, can't we just define these SW-internal clock IDs in the
> header inside the Tegra clock driver, so the values are invisible to DT?

I'm beginning to wonder if abusing clocks in this way is really the best
solution. From what I understand there are two problems here that are
mostly orthogonal though they're implemented using similar techniques.

The reason for introducing cbus clocks are still unclear to me. From the
cover letter of this patch series it seems like these should be
completely hidden from drivers and as such they don't belong in device
tree. Also if they are an implementation detail, why are they even
implemented as clocks? Perhaps an example use-case would help illustrate
the need for this.

As for shared clocks I'm only aware of one use-case, namely EMC scaling.
Using clocks for that doesn't seem like the best option to me. While it
can probably fix the immediate issue of choosing an appropriate
frequency for the EMC clock it isn't a complete solution for the problem
that we're trying to solve. From what I understand EMC scaling is one
part of ensuring quality of service. The current implementations of that
seems to abuse clocks (essentially one X.emc clock per X clock) to
signal the amount of memory bandwidth required by any given device. But
there are other parts to the puzzle. Latency allowance is one. The value
programmed to the latency allowance registers for example depends on the
EMC frequency.

Has anyone ever looked into using a different framework to model all of
these requirements? PM QoS looks like it might fit, but if none of the
existing frameworks have what we need, perhaps something new can be
created.

Thierry

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTc31bAAoJEN0jrNd/PrOha6kP/RJ4vFFsAKj1HstgOGDr+9kR
X7NtK+rBdBxQ1LW52MRA8n/H+UmXrGvfrLhgDERgSQ+AcVisKiQ2FVnLVyVDsM/y
S8q0n7o/ySYGjz8vPZaJ+uqr7yl5Qi6mHtSiRD2lkB/EuqqK7YT519/pQ/2/Ozc5
G3U4HvSLBeQ3FztVZMiZlndQSMMPcKhDyy8AVAn7igX1kvrd4MW978uDEO5qg6mo
lyc2pYuCbG6nKpilNV7wFckflPTK3M8YMftdX8Ycws0NDWLCLbVLn+nou3ENDRoc
+NT2S3wFZbXs7LXHhaP1ZJMdwPpSaEvWS4i7l07lE3uz9DxzUW/Wv/UhLgUMRnw3
Qdwr0TVMRTRbFEGzwnR9fauXKdFsxnYJQVCBZq3oNDNmBNMRuPwSjeOMlXP6pt8C
vfcTmxGf1Djajaq6XpAuuabUSvLuZGruhlqp2iI8ym9J1XLR17kaNbcA5bXmEUup
nR8c6RbZVFaZDc/4Ud3EhihHtLnpb3lnlhuc8jcotAdh0llwzDQMVsnjD3p0V0+K
QpuFllxNEFsFGKguNMBV27iooXZ/M6jYp9J/jceXEZOHKMjuW8qv4LXA3s5x2Lsk
ILtVIidfGdj/VvKByeMUvU6e3hkceFV7xMjqutrsM2aLi/KhwVJmLM97w9k2Qzdx
P8XUo+l1OFQjVAr5iqh9
=KFi/
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
