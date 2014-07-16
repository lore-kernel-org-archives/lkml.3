Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbaGPLm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:42:29 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45144 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGPLm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:42:27 -0400
Date: Wed, 16 Jul 2014 13:42:18 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, swarren@wwwdotorg.org,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 7/8] ata: Add support for the Tegra124 SATA controller
Message-ID: <20140716114217.GA18977@ulmo>
References: <1405500863-19696-1-git-send-email-mperttunen@nvidia.com>
 <1405500863-19696-8-git-send-email-mperttunen@nvidia.com>
 <53C65E96.9070508@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <53C65E96.9070508@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 01:14:30PM +0200, Hans de Goede wrote:
> On 07/16/2014 10:54 AM, Mikko Perttunen wrote:
[...]
> > +enum sata_clks {
> > +	AHCI_CLK_SATA		=3D 0,
> > +	AHCI_CLK_SATA_OOB	=3D 1,
> > +	AHCI_CLK_CML1		=3D 2,
> > +	AHCI_CLK_PLL_E		=3D 3
> > +};
>=20
> You should mention that having the clocks in this order is mandatory
> in Documentation/devicetree/bindings/ata/tegra-sata.txt / in
> "[PATCH v3 1/8] of: Add NVIDIA Tegra SATA controller binding"

This is precisely why I said that using a library for resources is a bad
idea. Why on earth would we want to mandate a specific order? The clock
bindings specifically have the clock-names so that the order in which
the clocks are listed in the clocks property doesn't matter. Now because
of these library helpers we can no longer do that, but instead need to
fix the order.

So we're now in a position where a Linux-specific driver, worse
actually, a Linux helper library dictates what the device tree binding
must look like. This obviously conflicts with what device tree people
have been recommending for years.

What this also means is that since the DT bindings are ABI, the libahci
platform library code effectively becomes an ABI too.

Thierry

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxmUZAAoJEN0jrNd/PrOh5rcP/Ag4x08eeUslFD57YhoFYqXQ
wuo7P3DkX6UnKMUo9AXQlBJg7/g3VdtRq2ayO0AFawodRLU1sKw9vmpheWfAWrbb
ZdV23ARSBZmgE2W+X6ZinJPBCAHX9cGJKiOFJg7jtjB+5CZvkoSh0gBpFd3vTH6G
hZnxnJEF8ZKG5k0vwFVa1Yp8vPq+2suTnfHgmtEickCogI+qN05gWTvz93z5Z9v4
FinjmFm4I8l0HquS2/QSPPdv+aATxXO/PeA+CfAl8Zwbd5oMPi11kSEXzUc3dbRn
ws+l/Y3uJjt/6HdUH5cyeFp1f+vsXyUmSR8zCWJBDTToyoVLUb35CJQTQjkyz1N9
WpRHlhB8F7uU7LoHv8rBkfXljJOQeEidTEL39Ki0cNvS4IYEOam9TwvV+sSINu+w
HnckNaQWjoK75M/g4O+/PydkTNVBTdPKM+AMFrumNOQoH/0zrWrCqZnuYnleJ1q4
4/nObKc11XzIxswEvOXfiHmfJBMwpMXqulcVDz0XafIKrg5tilAhwV37VZDweLJu
sXU7KbGfCIkmyDLqpfMjO5rnwAeFqL+4FPlcQqg8ZT/N/MzksNAw5yiBqJ9ls5jW
KD3Miv6Mj8gRUbeEg5BPeRpl7jrt6ybePSV57S5UwdB6TSobH+uBd+0Sdsh2lgdC
UAxx/frKjTw+mTsnD6FL
=lzFM
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
