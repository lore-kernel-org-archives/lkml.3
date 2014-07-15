Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbaGOJb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:31:58 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50401 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758299AbaGOJbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:31:53 -0400
Date: Tue, 15 Jul 2014 11:31:49 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, Tejun Heo <tj@kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v2 6/7] ata: Add support for the Tegra124 SATA controller
Message-ID: <20140715093148.GA13878@ulmo>
References: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com>
 <1403101406-15439-7-git-send-email-mperttunen@nvidia.com>
 <20140708132216.GA4979@htj.dyndns.org>
 <53C3DCF0.3030001@redhat.com>
 <53C4D472.9010507@nvidia.com>
 <53C4EC81.1040304@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <53C4EC81.1040304@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 10:55:29AM +0200, Hans de Goede wrote:
> On 07/15/2014 09:12 AM, Mikko Perttunen wrote:
[...]
> > Other subsystems I've been in don't have this kind of helper
> > library, so diverging here seems weird.
>=20
> Well the usb uhci-platform and ehci-platform drivers are doing the same,
> what we're trying to do here is avoid needless code duplication and
> if possible (for ehci and uhci it currently is) make it so that adding
> support for a new soc only requires adding dt stuff + a phy driver,
> without touching the ?hci code at all. Again I can see that this
> is not possible for the Tegra124.

I don't think helper libraries are good at managing resources. They are
very good for extracting common /functionality/ so that it doesn't have
to be duplicated. That's where the commonalities really are. Resource
allocation and setup are usually where the differences are. Trying to
extract that into common helpers often results in clumsy code.

Also, since resources and setup sequences are often very different, the
chances are that adding support for a new SoC will always require
extending the helpers to cope with that new type of resource that the
new SoC now requires, or bumping the maximum number of resources of an
existing type.

Thierry

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxPUEAAoJEN0jrNd/PrOhd9AQAJD3tIaz2TYjaUTSpFFcOWbx
Da5Cgs2uRCjjcbILm08BmtyypWTJozndxa7kUuHul8Wcv62iujKIczA2UO5KlKES
lPWiTs/s0qdkeeY9qZkTK65XHKBy/egwFAkGt9E7nHx5lJ9tx753cGRo7O9gitsl
LcqOyENRsZvrRM2BMfRT8CCnuaB+ZXptFVsOVAyujN0rpJoDmOSXSS0/O5Gn2ppB
JbUjl4FR8gMzNSYtsx00Ud6URkNWyBgfz/+1tQifkRY9Yzg7PoeX9e+2mnF+VW6o
ieVDLFDT+a9KYbej9x52FiGYlu32NP8EVwkdYY31aY9t+0CdN6mPxt0SYgJqwkLo
hHlqEfP2D7l3IJjWoNmfcglfthzPX9+RdIbQikhDvfV1PjyaWdvdNVFTDCTcYMY3
9/cZ2y+K9r14uxDOYuTRwrTdEYOSl++aW/XBtRoB/STCIUnNohBIfAStPLcK+Zrr
WIU2d260plqTITuJC5Uj4msJT1/kyh9EvX93WJrCj595xdjx/gye2SmD6Ppov+4K
gjENHtVRW9mGBDgdv/pm1dJZqRgripKMwncf/QfBSnIQuGMHoqlNDVD6htm7mb0w
SZP0peg+DC0cjZUJHLbGRvtUmiA7B3YQCAOCHvRMCylwRqz0hHKN+60TVDsX0+RY
Z4ThlQt4FW/bgccDaB32
=9dsk
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
