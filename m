Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaGNGYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:24:44 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34588 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaGNGYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:24:36 -0400
Date: Mon, 14 Jul 2014 08:24:29 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joerg Roedel <joro@8bytes.org>,
        Olav Haugan <ohaugan@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140714062428.GC2081@ulmo>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140712093917.GD18601@arm.com>
 <CAF6AEGutHp+3f3iPA+jjaRkqq=5T_vytZ_ESoSqsQ4RHZ8F8yQ@mail.gmail.com>
 <201407121422.02078.arnd@arndb.de>
 <CAF6AEGs7=3UByP2DLm-uwU03wr7M14x2t-0hLX-VPJ6_eZbU3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <CAF6AEGs7=3UByP2DLm-uwU03wr7M14x2t-0hLX-VPJ6_eZbU3g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 12, 2014 at 08:57:31AM -0400, Rob Clark wrote:
> On Sat, Jul 12, 2014 at 8:22 AM, Arnd Bergmann <arnd@arndb.de> wrote:
[...]
> > The way that Thierry's binding does that is the obvious solution to thi=
s,
> > and it mirrors what we do in practically every other subsystem. I defin=
itely
> > want the SMMU to change before anybody starts using it in a real system,
> > which we fortunately do not have yet.
>=20
> hmm, well if some of the things I need for (like this or batching
> mappings) are too weird and gpu specific, I'm willing to duplicate the
> IOMMU driver in drm/msm.  It really isn't so much code, and that gives
> me a lot more more flexibility to do crazy things... at some point I'm
> probably going to want to do context switches by banging the IOMMU
> registers directly from the gpu.

If the IOMMU API doesn't provide for what you need, then perhaps it's
time to enhance it? We do that all the time in other parts of the
kernel, why should IOMMU be special?

It seems to me like context switching for per-process address space
isolation is one of the important features of an IOMMU. If the current
API doesn't let you do that then we should think of ways how it can be
improved. And if it doesn't do it fast enough, then we should equally
find ways to speed it up.

This is part of why I think it would be good to have explicit objects
associated with IOMMU contexts. That would give us a good place to add
caching for this kind of situation. Currently we're required to handle
most of this in drivers (map from struct device to context, ...).

Thierry

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw3ecAAoJEN0jrNd/PrOhllsP/0whPnL6702VkDlPpAixjHP5
+OlYxfOT2jq0i53kyyqU2zhyn7L9wDnSLrqozvLD3TEdX+qxKKqiIMl8t1wSeT/P
hBoi8mtjxAAcOR/Ip5Hxl6T4OduLADaDVfsA3ox/wpz3fd9XveHBYqogM0md8vbw
8G5OafkQKOm60H/U9W++zeZRXxBEhenSkrazP4+5z7VNJSd5wQ/eQ01f7utMvJAe
c886gQLlNh6bccRsDWqQ91qL/sYbFN0vjgyauBwFxaPzJeQh5QpFN6WoUj5aUe3b
e3J/zNvnb7Pr9CqzA/3prmXc12ZGARIzAEUnwTWXz0zUM0Khs1Y7lTC5mRAEpyiy
3pTH4oDoWye6VuXtNeWqJUWfl7g9wfOP9/tWS4KmWpZg5ZGOVWN0XThHHk6/9iWd
44ta//jqbewjNHTIu3nlqTsqfMKKANuddmzpGipn4ap/CAz98Dl3IlU2fESM+5c3
UkckwetgVTj7pmwUpywUmyC7nbLD/MBOOSj9VWPv0Yw/GfyQRTLRP//iLMx1lefL
4zRqj1F6qL1lJsiHNlJ/9IQwRUmIZMfU0h7tTrnZI+TNpAvlBPQDVgso5/uVNNjf
IGEbgLjDUqKVXtfmIQ8573k7vvrNv/QdtIX+NLjCXKwmmhLDI236J2eE4ntyfedA
9PqClBrpwDTMzs7CRMTK
=EgGu
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
