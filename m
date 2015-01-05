Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbbAEPwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:52:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33586 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbbAEPwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:52:05 -0500
Date: Mon, 5 Jan 2015 09:50:49 -0600
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <balbi@ti.com>, Sneeker Yeh <sneeker.yeh@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH 2/3] usb: dwc3: add Fujitsu Specific Glue layer
Message-ID: <20150105155049.GF19336@saruman>
Reply-To: <balbi@ti.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1456155.YPH2fYoGgF@wuerfel>
 <20150103012128.GA11373@saruman>
 <3428284.QtTr113xXr@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Il7n/DHsA0sMLmDu"
Content-Disposition: inline
In-Reply-To: <3428284.QtTr113xXr@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Il7n/DHsA0sMLmDu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 05, 2015 at 04:28:34PM +0100, Arnd Bergmann wrote:
> On Friday 02 January 2015 19:21:28 Felipe Balbi wrote:
> >=20
> > On Tue, Dec 30, 2014 at 11:12:51AM +0100, Arnd Bergmann wrote:
> > > On Monday 29 December 2014 01:52:04 Sneeker Yeh wrote:
> > > > > > +static int dwc3_mb86s70_remove_child(struct device *dev, void =
*unused)
> > > > > > +{
> > > > > > +     struct platform_device *pdev =3D to_platform_device(dev);
> > > > > > +
> > > > > > +     of_device_unregister(pdev);
> > > > > > +
> > > > > > +     return 0;
> > > > > > +}
> > > > > > +
> > > > > > +static u64 dwc3_mb86s70_dma_mask =3D DMA_BIT_MASK(32);
> > > > >
> > > > > why ? Use dma_coerce_mask_and_coherent().
> > > > >
> > > >=20
> > > > okay.
> > >=20
> > > Actually that is still wrong: we use dma_coerce_mask_and_coherent() to
> > > annotate drivers that have traditionally been forcing their own dma m=
ask
> > > by some other means and that need to be changed to something proper (=
after
> > > finding out why they did it in the first place).
> > >=20
> > > Since this is about a child device, the correct interface is to use
> > > platform_device_register_full().
> >=20
> > no, that's wrong. He's essentially fixing the default set by OF core,
> > which is always 32-bits anyway, so this can actually be removed. Your
> > suggestion would just make it worse.
>=20
> Ah, so this was for a device that gets probed from DT? Yes, then no
> change is needed here at all.

right.

> Note that I'm working on a patch set to change the DT initialization to
> be a little smarter about the mask. Specifically any device whose parent
> has a smaller dma-ranges window than 4GB needs to start out with the
> smaller mask, and the dma_set_mask function that is called to allow 64-bit
> DMA on a device will check if the bus can actually support it.

please make sure have that patch soaking in linux-next for weeks before
attempting to merge it upstream. I would target v3.21 with such a patch.
At least keystone might be a little weird about what you describe
considering the thing boots from HIGHMEM. Also needs to consider LPAE,
etc.

--=20
balbi

--Il7n/DHsA0sMLmDu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUqrLZAAoJEIaOsuA1yqREOPMP/1ykV6BAiPtaj1Y1NndABWps
tXtISvRUhzRD0JLG0++Q/xnFUAi4jvUWScU/wDTSNzBNuaP5j580XMz38JKrvbOb
7wlV2Yk9uhSorpdIBtCH+HSyEoLU8naZECgR1weXhaYdwhzqXiUModdkmifXqW31
F5HvaRoV4tumBcrm0mJZhu6Fmwb0ttmQ6AkW4JA6Chv2VPnwQZmj5l+mOfAfpBx0
qbpsibNq75Gh3JbsYd90wl2yxPYjyK15QiETQqRu+LeOgUOBPexrMs5jEgVynivO
dfpah7w9IWi5GD4IsVaKRZP6DUEhogVJPuqBWkfs3UGrbrdT79sv0KVTfKvI2JGi
BfthGP1BSfDl0ymi4Ms99Ndh9Yw+O19jd7ZBvJgESW1ObvWvEYNtNE4t+S6iUab/
lS6Q01AGgAS+VceANr8H4DDZ4IWkCXh2tgXwm69VoezpCrxSIX0WQ7Qnu/4EpnG1
R1z2PAU9cahxl+lUhcaJmvWSNsKjH5/YeRoIzsP8TD3L30t8qvd5DbCI7fv9NJKY
MLUHSogInw5Cdbb17SFId9bPpUnsZq14DWD83C7/9MR3EpWzgn5t5uFi0/mfhVJF
5Ryp4RgCcOPowgTWdalupiKb0jW5UkBdW3FB3wDasGumoNidnzDurjEImnwQe2wQ
mpENGBvIUzLFMdl8VuL6
=+FtZ
-----END PGP SIGNATURE-----

--Il7n/DHsA0sMLmDu--
