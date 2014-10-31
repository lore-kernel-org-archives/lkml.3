Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbaJaLWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:22:15 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43734 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536AbaJaLWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:22:08 -0400
Date: Fri, 31 Oct 2014 12:22:00 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
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
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH RESEND V4 4/9] pinctrl: tegra-xusb: Add USB PHY support
Message-ID: <20141031112158.GC10778@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
 <1414535277-15645-5-git-send-email-abrestic@chromium.org>
 <20141029122738.GE28356@ulmo.nvidia.com>
 <CAL1qeaF53VUEcn6OruxjufEXnPxyoqp4=sLUuhvJcrpGH=707A@mail.gmail.com>
 <20141030134517.GB19802@ulmo.nvidia.com>
 <CAL1qeaEgyROk2dHbAOCUBJwCFegXH3_Yhr3reWdOrUXHvJ2cdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Content-Disposition: inline
In-Reply-To: <CAL1qeaEgyROk2dHbAOCUBJwCFegXH3_Yhr3reWdOrUXHvJ2cdg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 10:10:06AM -0700, Andrew Bresticker wrote:
> On Thu, Oct 30, 2014 at 6:45 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Wed, Oct 29, 2014 at 12:43:36PM -0700, Andrew Bresticker wrote:
> >> >> diff --git a/drivers/pinctrl/pinctrl-tegra-xusb.c b/drivers/pinctrl=
/pinctrl-tegra-xusb.c
[...]
> >> >> diff --git a/include/soc/tegra/xusb.h b/include/soc/tegra/xusb.h
> >> >> index cfe211d..149434f 100644
> >> >> --- a/include/soc/tegra/xusb.h
> >> >> +++ b/include/soc/tegra/xusb.h
> >> >> @@ -10,6 +10,13 @@
> >> >>  #ifndef __SOC_TEGRA_XUSB_H__
> >> >>  #define __SOC_TEGRA_XUSB_H__
> >> >>
> >> >> +#define TEGRA_XUSB_USB3_PHYS 2
> >> >> +#define TEGRA_XUSB_UTMI_PHYS 3
> >> >> +#define TEGRA_XUSB_HSIC_PHYS 2
> >> >> +#define TEGRA_XUSB_NUM_USB_PHYS (TEGRA_XUSB_USB3_PHYS + TEGRA_XUSB=
_UTMI_PHYS + \
> >> >> +                              TEGRA_XUSB_HSIC_PHYS)
> >> >> +#define TEGRA_XUSB_NUM_PHYS (TEGRA_XUSB_NUM_USB_PHYS + 2) /* + SAT=
A & PCIe */
> >> >
> >> > These are really XUSB pad controller specific defines, why does anyo=
ne
> >> > else need to know this?
> >>
> >> They're not pad controller specific.  They're also used in the xHCI ho=
st driver.
> >
> > I keep thinking that there should be a way around this. Of course if
> > both the XHCI and mailbox drivers were merged, then there'd be no need
> > to expose this publicly at all.
>=20
> I'm not sure what you mean.  They're SoC-specific constants that need
> to be shared amongst multiple drivers.  It would make sense to place
> them in a shared header, does it not?

The problem with this is that if those numbers ever change on a future
generation of Tegra then we're going to have to suffix them in some way
to support more than one generation. And the code to handle that is
going to be ugly because we'd need to differentiate on the compatible
string to match which suffixed version to use.

So I'd rather see this parameterized some way. Of course that's a lot
more difficult to do because these things are shared across XHCI and pad
controller drivers.

That said, I think it'd be fine to merge this as-is for now and rewrite
this in a better way if it ever becomes a problem.

Thierry

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUU3DWAAoJEN0jrNd/PrOhwroQAKQa94IoLsFsIfuL6hQaejZj
6cRsQSlKGwV1cL91WVmVbUW445Q2uJRv+44swS3yd0kyO7H5/XP7lHkvSlj/mtwk
Nodu0csmT+cTnD5ZSybYyfS9Oc9HxNWmebTUnF5rrndutb3PAbVP2Lfka+sD5Mpe
FK6KuqBQ5W1gA5MRKDJYqXFoVghm0/W1OvAeG/4YPwFd7SKXH0dWIbEMVJGJd3j9
Ej17XHgWcldtqsgwYrhNZGA0yKZVHHeyX39VA1/0K8v+jjqgUOIJVFgfSaz2KTWx
gEbEgyFBU3nzssIQksdPVw3boeLhrZ20j3fxOj8vnjYyM3DRHttZ3sJikDWNHivp
IifkR8gKcTeAbPGvkfX8kHyb2FQ/7OcFpi3NC9TjVRVM/rrI29ZMqnTxqv9aUvWm
rRyktNPseprFTg7ajSiO/l2PaPLSI1NU1f2qJ5O8a/1cn4Y2lCOalYfXGdeDjLWp
/lAlDN2DPG19pr06mNByfhpVcpa0NlDhyWdzjQJHeUNqE6YF+gUpeqwTqlWTABOS
OCO4bCa2lpjNS+e/171TfjsbtNVIIYcnl7J7iYJZmY4SwqeU7Hy4Rfkp1UgZKuoU
srpHFdqLIC91sktVfNSjFmvf40jXJ4D3eey+haKpQTuTc2Ecut7I0KcjzU25Sdn0
RGjGEolvonbDJzTSswWi
=8NE0
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
