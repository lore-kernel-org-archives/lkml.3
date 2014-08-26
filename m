Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbaHZHub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:50:31 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:61893 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbaHZHu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:50:29 -0400
Date: Tue, 26 Aug 2014 09:50:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Message-ID: <20140826075023.GB17263@ulmo>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
 <53FB8820.4010202@wwwdotorg.org>
 <20140826065729.GC15573@ulmo>
 <3804028.YQzQ4uAVsf@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <3804028.YQzQ4uAVsf@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 09:43:50AM +0200, Arnd Bergmann wrote:
> On Tuesday 26 August 2014 08:57:31 Thierry Reding wrote:
> > On Mon, Aug 25, 2014 at 01:01:52PM -0600, Stephen Warren wrote:
> > > On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
> > [...]
> > > >+static int tegra_xusb_mbox_probe(struct platform_device *pdev)
> > >=20
> > > >+    res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > >+    if (!res)
> > > >+            return -ENODEV;
> > >=20
> > > Should devm_request_mem_region() be called here to claim the region?
> > >=20
> > > >+    mbox->regs =3D devm_ioremap_nocache(&pdev->dev, res->start,
> > > >+                                      resource_size(res));
> > > >+    if (!mbox->regs)
> > > >+            return -ENOMEM;
> > >=20
> > > Is _nocache required? I don't see other drivers using it. I assume th=
ere's
> > > nothing special about the mbox registers.
> >=20
> > Most drivers should be using devm_ioremap_resource() which will use the
> > _nocache variant of devm_ioremap() when appropriate. Usually the region
> > will not be marked cacheable (IORESOURCE_CACHEABLE) and therefore be
> > remapped uncached.
> >=20
>=20
> Note that ioremap() and ioremap_nocache() are the same. We really shouldn=
't
> ever call ioremap_nocache().

Perhaps we should remove ioremap_nocache() in that case. Or ioremap(),
really, and keep only those variants that do what they claim to do.

> devm_ioremap_resource() and pci_iomap() checking for IORESOURCE_CACHEABLE=
 is
> rather silly, since it doesn't call ioremap_cache() in that case.

Then that should be fixed.

Thierry

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/Dw/AAoJEN0jrNd/PrOhNisP/A24pw1TBz0I4UieI1cV0Fus
XlEkrXWIA2MHd5ZfJtXuu7gm+ecrBKqh0f57w1RZBazUIaidXaPO5wHGG1YyveAf
2sI7dhPrnQPCNnmrn4cRyWPNzmHNiwtEvSad6oZihUCzMFCVoS4j0a2lQyHI6BKj
Q4v9kfQq1A1QODclNAOfCWGVkaw9ldMPsHEclMZw4qbbphe4yzPM5qVguN1g/fvI
SSd+WQwvNGynLZxGw84VN0GI+wwymV74I3ev5WtevnCNBmj9iWz//jOywu/fsOgZ
uRyfFp7bzYNnA5t8Pu7bH3iCtWX5EcT4oxyvmncraO+ym6/pOtvwf8dAnwjDygAa
if1IxC0DAjQAU4dPXlltQwswaLVyXe9Cc7fEqNRg4pUYcqDOW4PSFF36cNCQe2Gf
RO1qDTJRYTaTfRgMjrKATNJfz9hkHMBqwMSwpEE4wIsbnH/hTaY1s2ObRH+zrulW
rFTnj/5oL2tRzOIaSbDQWXtXCQQPG3YVg1EZaj/gaI0e76A/O4F0RkdQCtXXztF4
91HSYYC6zv9D6xG7ZrGYTvukmWAI1+VWpl7Q05FKDTTp2Y9H3x4z+El9xplFEN5Z
Uz54NoJHTJlhooyq6dbGDjQigBrytT/LkK+BcWYoey9wqAbA8aEKIu2UbuaCyopZ
zOlTN9XP+f6/KKskMLqr
=gQLC
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
