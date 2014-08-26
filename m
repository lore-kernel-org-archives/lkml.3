Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934545AbaHZKUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:20:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58471 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbaHZKUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:20:20 -0400
Date: Tue, 26 Aug 2014 12:20:13 +0200
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
        linux-usb@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Message-ID: <20140826102011.GA31124@ulmo>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
 <6589717.GOLq1GlTCJ@wuerfel>
 <20140826090810.GH17263@ulmo>
 <5184912.mY2hCPH20k@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <5184912.mY2hCPH20k@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 11:54:43AM +0200, Arnd Bergmann wrote:
> On Tuesday 26 August 2014 11:08:11 Thierry Reding wrote:
> > On Tue, Aug 26, 2014 at 10:09:25AM +0200, Arnd Bergmann wrote:
> > > On Tuesday 26 August 2014 09:50:25 Thierry Reding wrote:
> > > > On Tue, Aug 26, 2014 at 09:43:50AM +0200, Arnd Bergmann wrote:
> > > > > On Tuesday 26 August 2014 08:57:31 Thierry Reding wrote:
> > > > > > On Mon, Aug 25, 2014 at 01:01:52PM -0600, Stephen Warren wrote:
> > > > > > > On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
> > > > > > [...]
> > > > > > > >+static int tegra_xusb_mbox_probe(struct platform_device *pd=
ev)
> > > > > > >=20
> > > > > > > >+    res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > > > > >+    if (!res)
> > > > > > > >+            return -ENODEV;
> > > > > > >=20
> > > > > > > Should devm_request_mem_region() be called here to claim the =
region?
> > > > > > >=20
> > > > > > > >+    mbox->regs =3D devm_ioremap_nocache(&pdev->dev, res->st=
art,
> > > > > > > >+                                      resource_size(res));
> > > > > > > >+    if (!mbox->regs)
> > > > > > > >+            return -ENOMEM;
> > > > > > >=20
> > > > > > > Is _nocache required? I don't see other drivers using it. I a=
ssume there's
> > > > > > > nothing special about the mbox registers.
> > > > > >=20
> > > > > > Most drivers should be using devm_ioremap_resource() which will=
 use the
> > > > > > _nocache variant of devm_ioremap() when appropriate. Usually th=
e region
> > > > > > will not be marked cacheable (IORESOURCE_CACHEABLE) and therefo=
re be
> > > > > > remapped uncached.
> > > > > >=20
> > > > >=20
> > > > > Note that ioremap() and ioremap_nocache() are the same. We really=
 shouldn't
> > > > > ever call ioremap_nocache().
> > > >=20
> > > > Perhaps we should remove ioremap_nocache() in that case. Or ioremap=
(),
> > > > really, and keep only those variants that do what they claim to do.
> > >=20
> > > That would be good, but there are many instances of either one:
> > >=20
> > > arnd@wuerfel:/git/arm-soc$ git grep -w ioremap | wc
> > >    2156   13402  183732
> > > arnd@wuerfel:/git/arm-soc$ git grep -w ioremap_nocache | wc
> > >     485    2529   42955
> >=20
> > Ugh... nothing that I currently have time for. Perhaps this is a good
> > one for the Janitors? I'm not sure if the kernelnewbies.org TODO list is
> > still frequented since many pages seem to be very old. Is there some
> > other place where I could add this?
>=20
> I'm not sure if it's really worth it. One thing we might do is just
> remove all definitions of ioremap_nocache and add a wrapper to
> include/linux/io.h, to make it more obvious what is going on.

Yes, I suppose that would work too. I still think there's an advantage
in being explicit and avoid aliases like this. Perhaps a __deprecated
annotation would help with that?

> > > > > devm_ioremap_resource() and pci_iomap() checking for IORESOURCE_C=
ACHEABLE is
> > > > > rather silly, since it doesn't call ioremap_cache() in that case.
> > > >=20
> > > > Then that should be fixed.
> > >=20
> > > Yes. I'd suggest we just ignore that flag and always call ioremap her=
e.
> > >=20
> > > When I checked this before, IORESOURCE_CACHEABLE only ever gets set f=
or
> > > PCI ROM BARs, which we don't map into the kernel.
> >=20
> > There's still a few users of ioremap_cache() around and they are
> > potential candidates for a conversion to devm_ioremap_resource(), so I
> > think it'd still make sense to keep the check.
>=20
> Possibly. Note that these are all in architecture-specific code, as
> evidenced by the fact that we have multiple names for this function:
>=20
> ioremap_cache:    arm, arm64, x86, ia64, sh
> ioremap_cached:   metag, unicore32
> ioremap_cachable: mips
>=20
> All other architectures have none of the above.
>=20
> An alternative approach would be to kill off IORESOURCE_CACHEABLE
> and introduce a devm_ioremap_resource_cache() helper when the first
> driver wants it.

Looking briefly at the involved headers and structure there seems to be
quite a bit of potential for cleanup.

Thierry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/F9bAAoJEN0jrNd/PrOhgSIQAMKJkrzmA1H5ar+Iu79XUooi
9ps9CLjBlUwUsBqSeQwwAwO1kr+DkL9FDF0VDhqRwEBsc69D7AapHKQVeAour6K/
KNApylCSNJIBRfogzF1jGx22eNgksdWQoJnjqvZ6W0xnUFqZMmXdJnIkqZrFLZAz
VrJRhv25XGj48THGHLXSRCPiPYDlN1MBOeynZE3Id9JfotbNSOm5keNYxsop1IHo
rnFObgQO0RwUrCTkcsvlmllY6KNefKBgWiJrAtjtMn3pkhLlqm+/aiHliFLmaeDx
n82cWEJ2lTTFxcSRuqitgkns/3djpupHG7Y/4RMpoY1wQSuD61ZFxUad0PFyxrBX
GdcxEMZxRu2W2kLi7Dw1n7sShNQ4YmgT/77YDbzZZWNRrMGG7r4puu+ZDAt3xtyI
zfFqBCMU3dUbRG6fmaaNbcHtuNwOveglLc+2ygUo4Q5T0ZHBhqSE2yTjQhl1T8Uc
QKvGSony27RpF5qIsu1T77su+rR3FC3oJcm++I06riWPgP3aqvLJx+9ow/MqjDhP
cs+gQv63euUmTXOn/E2AvPMAliwzJVty/XIBCsS+JwgvZJTidBvSxSSXemMVOSKT
GuND45c/1ouiu/IB7ajf+ZQzVgsubvl6N7VicRQ/xETjJR+MoSxQIOTSXGDpYcKu
1vXZsvDJFevi+M4p1LJL
=3EXS
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
