Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbbACBWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 20:22:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57236 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbbACBWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 20:22:48 -0500
Date: Fri, 2 Jan 2015 19:21:28 -0600
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Sneeker Yeh <sneeker.yeh@gmail.com>, Felipe Balbi <balbi@ti.com>,
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
Message-ID: <20150103012128.GA11373@saruman>
Reply-To: <balbi@ti.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <20141222155936.GB12815@saruman>
 <CAJ1gpc0uniw3F3O9nxTLHp9M2boxrOACYDB=fgruhLOLdqg9yA@mail.gmail.com>
 <1456155.YPH2fYoGgF@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <1456155.YPH2fYoGgF@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 30, 2014 at 11:12:51AM +0100, Arnd Bergmann wrote:
> On Monday 29 December 2014 01:52:04 Sneeker Yeh wrote:
> > > > +static int dwc3_mb86s70_remove_child(struct device *dev, void *unu=
sed)
> > > > +{
> > > > +     struct platform_device *pdev =3D to_platform_device(dev);
> > > > +
> > > > +     of_device_unregister(pdev);
> > > > +
> > > > +     return 0;
> > > > +}
> > > > +
> > > > +static u64 dwc3_mb86s70_dma_mask =3D DMA_BIT_MASK(32);
> > >
> > > why ? Use dma_coerce_mask_and_coherent().
> > >
> >=20
> > okay.
>=20
> Actually that is still wrong: we use dma_coerce_mask_and_coherent() to
> annotate drivers that have traditionally been forcing their own dma mask
> by some other means and that need to be changed to something proper (after
> finding out why they did it in the first place).
>=20
> Since this is about a child device, the correct interface is to use
> platform_device_register_full().

no, that's wrong. He's essentially fixing the default set by OF core,
which is always 32-bits anyway, so this can actually be removed. Your
suggestion would just make it worse.

--=20
balbi

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUp0QYAAoJEIaOsuA1yqREcjIP/363ej7TuB2etVjKFfJQ3U+l
aK2jFXPVcHoabf1QZ/ikFRByl0VJa7sHfugLjeQjRWf2gl+YgWKCfDkz96fo2M6N
pP5mgtiZR1iVoZ031ZU3yo6DRq1dg7ZL3Wh76q/UysryeDAYO/bcSoDF3WAKWp+A
3VtmAkKgJqZeayUB7bfNo57GQhZEbHKeUGjA4oZ/XSkB+nWUXgshqiN8bJ0XD4Ux
nv5qK2h1FuqTJKzv1qTQnpgORSQWt+3326Snlxle9jhq4/KlSPjvogSROP9Yi+O9
i8teFmTN3YbYMs6Lvzdsi4FUnH3LPHbCNnJVsxYN+TFhS+MoQ5Y2fmecIqziY07m
8+hnh0i9V6MuTQ9ZTKhlHlN5qfEm88ajoq7JltuRA9SEL5Zzd6ISQl4SeaKCb05q
HCKeI+QfTP6dNOhaGbhm7PjBbtIByJNnaQIb9OR1qWh0dbCx86YLtvtVIgsm4u8b
shnwt5yZQPzXTeHh2Shrb1qoW3bZppX9Hta0+UXEqztQW3cne7nlQsjOgvQ41kmP
5XsSPnnetCNk+5xLmxe1/TnQW+ksWe7rtXDIcHnoJo4Jt4yFC+/WqaxxQvyHx852
wcoWW5G00kaGe98QWD4fKhA7oHZAGHLzhcrenQT5rEd+xx8NmPIh0IVgQEu405Kd
jLVtWfc4sckaPBYNCxN7
=lLKe
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
