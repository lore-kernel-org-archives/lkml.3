Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaGUVQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:16:39 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48340 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaGUVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:16:37 -0400
Date: Mon, 21 Jul 2014 23:16:32 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ARM: tegra: roth: add display DT node
Message-ID: <20140721211630.GA12076@mithrandir>
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
 <1404303560-32209-5-git-send-email-acourbot@nvidia.com>
 <53B42B60.1000600@wwwdotorg.org>
 <53B4C9C0.4000605@nvidia.com>
 <53CD333F.2070805@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <53CD333F.2070805@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 09:35:27AM -0600, Stephen Warren wrote:
> On 07/02/2014 09:10 PM, Alexandre Courbot wrote:
> > On 07/03/2014 12:55 AM, Stephen Warren wrote:
> >> On 07/02/2014 06:19 AM, Alexandre Courbot wrote:
> >>> DSI support has been fixed to support continuous clock behavior that =
the
> >>> panel used on SHIELD requires, so finally add its device tree node si=
nce
> >>> it is functional.
> >>
> >>> diff --git a/arch/arm/boot/dts/tegra114-roth.dts
> >>> b/arch/arm/boot/dts/tegra114-roth.dts
> >>
> >>> +    host1x@50000000 {
> >>> +        dsi@54300000 {
> >>
> >> That node looks fine, but I wonder why we need to mark a bunch of
> >> regulators as always-on? shouldn't the references to vdd-supply and
> >> power-supply from this node be enough? If not, perhaps the tree
> >> structure of the regulators isn't correct, or the DSI or panel bindings
> >> don't allow enough regulators to be referenced?
> >=20
> > regulator-always-on is indeed not needed for vdd_lcd. I actually had a
> > patch in my tree removing this line that I forgot to squash. Will post a
> > v2 for this patch that fixes this, thanks.
> >=20
> > vdd-2v8-display needs to remain always-on however. Here we may hit a
> > limitation of the simple-panel driver, where only one power supply can
> > be provided.
>=20
> Can't we fix the simple-panel driver to allow a list of regulators in
> the property?

I have no objection to allowing that. But I don't think there's a way to
do that with the current regulator API. You can use the bulk API, but
that requires separate properties, not multiple regulators in one
property.

Perhaps one idea to solve this would be to make the regulator API return
a regulator handle that in fact controls an array of regulators? Adding
Mark.

Thierry

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTzYMuAAoJEN0jrNd/PrOhRlYP/267hH2TOWbVMHr5gzd6V5Dp
CfK7zto/h37uT0Z+VwTo1SFHMm2YhWKg1O5Xk9q6QMrUyWJJVDrbf6S1cgvKZn63
l/Z8pz42AqWqDXP86sGdvwjdu/zrZDGPLF6P7+5EP5y6QKGmASFzJkxF4XN1RT09
CrLlJea9/o2tdJ9qfQV/s08Mde5B4+tZ6ZYmVJ05LB7418tp8ZDgsRWKfT7B/U2a
WvbSZUVsEObC5PIEWNJgOsZGiCGGqOKqXEo5ubua5/d0s1FgPark7jGaRXKN5Xj6
1/T/etv9oGgV6wvz9rPG8arM/k3/mP3e9Wsax4mHM6YvUsN55HibGAJe69G9e5cp
UeHvHXqk449lyLMX0r/K+3Mtuxd2m3pPe8PuR95nbAyyuPX0QJDE+aoV/ncbiq6i
IA8W7b3GwHcryM+2KEB7b209s5DdWnFwUpzXYPc6TH0a92R5qIe6YX2hNBrTF/wf
1oNjB/A3UsTxYt0GwYTad4Q7a9kC4GWtfGly3CwmMRGtT9cNEu0PAL4POvIj6mrb
rHRB6GGHmM6AOpd8TimCCrEp21RkSmM1JYPYLK9zbg7rNarIvrJ5C/X2BGA5xa/e
RL3fnIVPtUppkV+la4Ynn69eTpG9ZiF3NuEQJvZkqzO0QVwkwYkAS3+o7YRSW9on
HddJoCuv7OVLx/Lq1PET
=SaFc
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
