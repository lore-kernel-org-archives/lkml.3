Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbaJ3NzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:55:11 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61782 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaJ3NzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:55:08 -0400
Date: Thu, 30 Oct 2014 14:55:02 +0100
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
Subject: Re: [PATCH RESEND V4 5/9] of: Add NVIDIA Tegra xHCI controller
 binding
Message-ID: <20141030135500.GC19802@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
 <1414535277-15645-6-git-send-email-abrestic@chromium.org>
 <20141029094338.GA28356@ulmo.nvidia.com>
 <CAL1qeaEf0mTQfMgnY8jHGDBvbQ7ivtzAQRWaE9K24TJ86hWYMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Content-Disposition: inline
In-Reply-To: <CAL1qeaEf0mTQfMgnY8jHGDBvbQ7ivtzAQRWaE9K24TJ86hWYMg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 09:37:14AM -0700, Andrew Bresticker wrote:
> On Wed, Oct 29, 2014 at 2:43 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Tue, Oct 28, 2014 at 03:27:50PM -0700, Andrew Bresticker wrote:
> > [...]
> >> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124=
-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra12=
4-xusb-padctl.txt
> > [...]
> >> +Optional properties:
> >> +-------------------
> >> +- vbus-{0,1,2}-supply: VBUS regulator for the corresponding UTMI pad.
> >> +- vddio-hsic-supply: VDDIO regulator for the HSIC pads.
> >> +- nvidia,usb3-port-{0,1}-lane: PCIe/SATA lane to which the correspond=
ing USB3
> >> +  port is mapped.  See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for=
 the list
> >> +  of valid values.
> >
> > I dislike how we now need to provide a list of all pins in the header
> > file, where previously we used strings for this. This could become very
> > ugly if the set of pins changes in future generations of this IP block.
> >
> > Could we instead derive this from the pinmux nodes? For example you have
> > this in the example below:
> >
> >         usb3p0 {
> >                 nvidia,lanes =3D "pcie-0";
> >                 ...
> >         };
> >
> > Perhaps what we need is to either key off the node name or add another
> > property, such as:
> >
> >         nvidia,usb3-port =3D <0>;
> >
> > This would match the nvidia,usb2-port property that you've added below.
>=20
> That is actually how I described the USB3 port to SS lane mapping
> originally, but in review of an earlier version of this series,
> Stephen suggested that I make it a separate, not pinconfig property
> since it wasn't a value written directly to the hardware.  I'm fine
> with changing it back as the pinconfig property makes more sense to me
> as well.

Hmm... I had considered it a mux option of the specific lane. If the
function is usb3, it'd still need to be muxed to one of the ports. So
it's additional information associated with the usb3 function.

I did look through the driver changes and can't really make out which
part of the code actually performs this assignment. Can you point me to
it?

Thierry

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUkM0AAoJEN0jrNd/PrOhMS8P/i/lGqgEusOrtNYyZhrYikX9
/3mOb4M3tfpY5A9yt5sWZrnTXRa+Yg0mDg3ct5I9uPcO231miVdCI+X3VmLXtMzx
7JKA7xfdO530WaEbjJWZQnocm8Ofy2bVmwgy2beWJoMyKOE22+Ibe1pRs/Ew27B/
QiCAzvJY0AA+GoKbfwUIRblg3vRUc9iqMf8Za6RvHfgM0xzRRz68KgYneDaoW/lV
DKSXu+pPXxVzCU4EAu+jqA5Vusj96S3dPdZp05Jk3jEyLKswlveb5xZgWzZkssVN
Cvjjknlde6pPlvtRsm/3eT1XdF719A2+8l5FL1Dixv2ZatsXx3IW210tHrTg0D6Q
hSpBMGbLBF4TMlbDOaVQplgVDCKIMQSpk8F6rSxFK0kO8qQ4EbMlt+u4Cqi6xQXi
hAyBc4gdq0NWmq+EU0YvaPgn5B+o4Ohsxaqa4maikEXlbL0hf6TlrIRkLQx/VDGD
LliNkRszMrRhaPiSr+6VHdREtWWd/YjFzplbNW22R1Bd6iSbPj8E8LBcKHvUzb/T
MixEf8JmYyaB7xJ9ok+ObSTIytxsedEt1pXXVdKHoA4dZVW7DTSH0cnA4xvHFiuC
zpkK7P1fpGu+UOIz/KrT05xXt37g/vba0PIfYwe2BB0GS16rtlj77GFBBx35alvi
TvZ/tempujyTIThhNrOa
=+NwF
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--
