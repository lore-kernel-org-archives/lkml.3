Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967718AbaFQWfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:35:38 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:34996 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965502AbaFQWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:35:31 -0400
Date: Wed, 18 Jun 2014 00:35:27 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
Message-ID: <20140617223518.GA25309@mithrandir>
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
 <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com>
 <539F4D44.3070309@wwwdotorg.org>
 <53A03186.3040703@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <53A03186.3040703@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 02:16:06PM +0200, Tomeu Vizoso wrote:
> On 06/16/2014 10:02 PM, Stephen Warren wrote:
> >On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
> >>+
> >>+Child device nodes describe the memory settings for different configur=
ations and
> >>+clock rates.
> >
> >How do the child nodes do that? The binding needs to specify the format
> >of the child node.
>=20
> Sorry, that file was sent before I had finished removing the bits from
> downstream that aren't needed yet. There's no current need for any child
> nodes.
>=20
> >This binding looks quite anaemic vs.
> >Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-emc.txt; I
> >would expect that this binding needs all the EMC register data from the
> >tegra20-emc binding too. Can the two bindings be identical?
>=20
> There's even less stuff needed right now, as all what ultimately the EMC
> driver does is call clk_set_rate on the EMC clock. As the T124 EMC driver
> gains more features, they should get more similar.
>=20
> >Can you explain what the nvidia,mc and nvidia,pmc references are needed
> >for? Hopefully, this driver isn't going to reach into those devices and
> >touch their registers directly.
>=20
> Not really needed, see above.

I've been working on a prototype driver for the memory controller. Part
of what I've added is programming of the latency allowance registers (it
doesn't yet expose an API to do so yet, though). I think that needs to
eventually take into account the EMC frequency (and needs to be notified
of changes to the same).

Without having thought this through very thoroughly, I suspect that
rather than referencing the MC from the EMC it might be better to have
the MC register with the EMC for notifications.

But perhaps there are other services from MC that EMC needs to work?

Thierry

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToMKmAAoJEN0jrNd/PrOh7tsP/1iiyCvf+gToYFTC5Oa277pT
PsNiluavHj05CCD6ospTQ7adIPHx9jHBDVl7Wxcevo3VmWPVAX27dbhqHFNyHFtz
wNi4JFOsbS1FzNoGFcgE/G8BnrsbBnjFTIp+ftzKoMWvS+yO09VEhbW5VOkfuDFY
JX8usGCJznyj0kYFJEXLfh2dU+oy6y6TUcva3k2KGaPhzJw3071VIUqbpqq5ueCr
+XwNefsZniVILBrIT1FX3IxHHOgrDBnI1W5Giv8Ui/0gJcFt/qbpkZiIKq94F9sN
ZKqXTePJdPcYMr9lavezD3K77XnIbQe4//HgiQ6PQXmSO7L4utu2Da/UFA5ZDPFi
eTUkQVooBGbbGa6igJYsl1/A79ZBHiOs+46B0/USCnFNH56JjGlABinCA1Jd5Gdc
ghZ3iA4zFczm5RudD6JkZyLsG6xOxaaPGGnXyAnIG8MINWnEWUZkkNbsQLFnarpf
4rfJT2JK47LAfUo/H9PfN9ld/MnV1A65dJLHNcEAYmaFE/rD2Rfnv3HRYtDNo/gE
SEkRuHdNFT1MQnadRYz0p3c4G54qrPo+Kjb9simhOF1EFMu23BJL4krukv7DJsrb
6bX8sya1NbmwaKYgunVht4NV3I5KqUHHmJ9vFLDqW2iMJtmL+squ4LuCqwzixs/d
1x26cvcn6f2LCl1QxfPZ
=evRg
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
