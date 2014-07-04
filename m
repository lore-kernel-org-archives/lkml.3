Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbaGDNrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:47:18 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40285 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaGDNrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:47:16 -0400
Date: Fri, 4 Jul 2014 15:47:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 01/10] iommu: Add IOMMU device registry
Message-ID: <20140704134709.GA4203@ulmo>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-2-git-send-email-thierry.reding@gmail.com>
 <20140704110529.GF13434@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20140704110529.GF13434@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 04, 2014 at 01:05:30PM +0200, Joerg Roedel wrote:
> On Thu, Jun 26, 2014 at 10:49:41PM +0200, Thierry Reding wrote:
> > Add an IOMMU device registry for drivers to register with and implement
> > a method for users of the IOMMU API to attach to an IOMMU device. This
> > allows to support deferred probing and gives the IOMMU API a convenient
> > hook to perform early initialization of a device if necessary.
>=20
> Can you elaborate on why exactly you need this? The IOMMU-API is
> designed to hide any details from the user about the available IOMMUs in
> the system and which IOMMU handles which device. This looks like it is
> going in a completly different direction from that.

I need this primarily to properly serialize device probing order.
Without it the IOMMU may be probed later than its clients, in which case
the client drivers will assume that there is no IOMMU (iommu_present()
for the parent bus fails).

There are other ways around this, but I think we'll need to eventually
come up with something like this anyway. Consider for example what
happens when a device has master interfaces on two different IOMMUs. Not
only does the current model of having one and one only IOMMU per struct
bus_type break down, but also IOMMU masters will need a way to specify
which IOMMU they're talking to.

Thierry

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtrBdAAoJEN0jrNd/PrOhzl0P/iwj8bP8nXBSPf/py2sTO2lo
r6ME8Ag48kI8cccEXWQgDCmaw8mKPF8Tf6Wbtjzgd+aFSGuDyG5DdRu90yFGNYJz
y+WZapVkdCIVt2HhgtqrldVEi4+1Ins2PWP6iqzHp4SJ0NAFZwWMeTkHLEQQC3Wm
HrDBZJJ4SpS4SiNGElZ5cfmZOXHO1nPYMPdvDTFmRAtFpLgSvWrqEyoRGl6AKhip
t4VLiUUEd2Mi1hR1UwDVrKsUX4nz6KGFhUSHe49MaITkUHzAwZ6gdxIYBMcZ/G1b
09O2MBhJvtRMsGsCd7q4sa1dj5tDxTDn5kUz3BOyL2pAxeOIIH+f7RqHd3/AWBbv
djJlFR8nFmqo/DuwM00U+i40u3yLtJm8OWZOh15JKoIp64AWdjZ6GuMHRrM553wA
pRJIIYewjngLR8cLvC2s27bl0ZwQUjYP02rHZGlpqTKstAwnOcjhv8AW6gEijV7I
xgZLXqDBvf4aVZNeXSYCycxcndRjzQ4AG0WIdGBv+iloPkP4e7znMuVxvueiLMVq
EcPwYdRcwnSVLSaP+vk5WNYrM7Iml7xA8jZ42m3EK9SpFzVkqVG62h8+C8jzeJT3
EdmRD5GMqBdh60jpt58HZitnb9kHAujF1smMeRjxlcXGZNsQQy/shK6gHFcsfz71
OSkMzl9QvDDINi9jjBvG
=7jBS
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
