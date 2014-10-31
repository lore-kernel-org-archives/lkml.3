Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbaJaLdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:33:02 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42794 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaJaLc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:32:59 -0400
Date: Fri, 31 Oct 2014 12:32:51 +0100
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
Message-ID: <20141031113249.GD10778@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
 <1414535277-15645-6-git-send-email-abrestic@chromium.org>
 <20141029094338.GA28356@ulmo.nvidia.com>
 <CAL1qeaEf0mTQfMgnY8jHGDBvbQ7ivtzAQRWaE9K24TJ86hWYMg@mail.gmail.com>
 <20141030135500.GC19802@ulmo.nvidia.com>
 <CAL1qeaG701hKtcUL5a67b=X38hbcYunUOUBziZMpxemvhhAayA@mail.gmail.com>
 <20141030172432.GA8944@ulmo.nvidia.com>
 <CAL1qeaEbRkOQApyjkpwxBd3mGkQ3JuXNiar1MbBd844NWe5h9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
Content-Disposition: inline
In-Reply-To: <CAL1qeaEbRkOQApyjkpwxBd3mGkQ3JuXNiar1MbBd844NWe5h9g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3Pql8miugIZX0722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 10:26:47AM -0700, Andrew Bresticker wrote:
> On Thu, Oct 30, 2014 at 10:24 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Thu, Oct 30, 2014 at 10:19:21AM -0700, Andrew Bresticker wrote:
> >> On Thu, Oct 30, 2014 at 6:55 AM, Thierry Reding
> >> <thierry.reding@gmail.com> wrote:
> >> > On Wed, Oct 29, 2014 at 09:37:14AM -0700, Andrew Bresticker wrote:
> >> >> On Wed, Oct 29, 2014 at 2:43 AM, Thierry Reding
> >> >> <thierry.reding@gmail.com> wrote:
> >> >> > On Tue, Oct 28, 2014 at 03:27:50PM -0700, Andrew Bresticker wrote:
> >> >> > [...]
> >> >> >> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,te=
gra124-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,t=
egra124-xusb-padctl.txt
> >> >> > [...]
> >> >> >> +Optional properties:
> >> >> >> +-------------------
> >> >> >> +- vbus-{0,1,2}-supply: VBUS regulator for the corresponding UTM=
I pad.
> >> >> >> +- vddio-hsic-supply: VDDIO regulator for the HSIC pads.
> >> >> >> +- nvidia,usb3-port-{0,1}-lane: PCIe/SATA lane to which the corr=
esponding USB3
> >> >> >> +  port is mapped.  See <dt-bindings/pinctrl/pinctrl-tegra-xusb.=
h> for the list
> >> >> >> +  of valid values.
> >> >> >
> >> >> > I dislike how we now need to provide a list of all pins in the he=
ader
> >> >> > file, where previously we used strings for this. This could becom=
e very
> >> >> > ugly if the set of pins changes in future generations of this IP =
block.
> >> >> >
> >> >> > Could we instead derive this from the pinmux nodes? For example y=
ou have
> >> >> > this in the example below:
> >> >> >
> >> >> >         usb3p0 {
> >> >> >                 nvidia,lanes =3D "pcie-0";
> >> >> >                 ...
> >> >> >         };
> >> >> >
> >> >> > Perhaps what we need is to either key off the node name or add an=
other
> >> >> > property, such as:
> >> >> >
> >> >> >         nvidia,usb3-port =3D <0>;
> >> >> >
> >> >> > This would match the nvidia,usb2-port property that you've added =
below.
> >> >>
> >> >> That is actually how I described the USB3 port to SS lane mapping
> >> >> originally, but in review of an earlier version of this series,
> >> >> Stephen suggested that I make it a separate, not pinconfig property
> >> >> since it wasn't a value written directly to the hardware.  I'm fine
> >> >> with changing it back as the pinconfig property makes more sense to=
 me
> >> >> as well.
> >> >
> >> > Hmm... I had considered it a mux option of the specific lane. If the
> >> > function is usb3, it'd still need to be muxed to one of the ports. So
> >> > it's additional information associated with the usb3 function.
> >> >
> >> > I did look through the driver changes and can't really make out which
> >> > part of the code actually performs this assignment. Can you point me=
 to
> >> > it?
> >>
> >> There's not really an assignment.  The property is used to map between
> >> a lane (e.g. PCIe-0 or SATA) and the USB3.0 port it's mapped to.  For
> >> an example of where it's used, take a look at usb3_phy_power_on().
> >> There are certain per-lane registers which need to be programmed in
> >> addition to the per-USB3.0 port pad registers.  This mapping is used
> >> to determine which lane needs to be programmed.
> >
> > Are you saying the mapping of lane to USB port is fixed? That is, PCIe-0
> > lane is always used for USB port X and SATA always for USB port Y?
>=20
> No, sorry if that was unclear, it's not fixed - it's a board specific
> property.

Okay, but there's no register that contains the mapping of the port to a
lane, similar to what's done for the functions, right? I mean the driver
only uses the lane to find out which register to write. Doesn't that
imply that two lanes (or more) could be mapped to the same USB 3.0 port?

I'm not sure I'm being clear here, so let me try another way. In order
to establish a mapping between USB port and lane, I would've expected
one of the following to happen:

	- A value derived from the lane number is written to a register
	  belonging to a given port.

	- A value derived from the port number is written to a register
	  belonging to a given lane.

I can't see the code do either of the above, which to me implies that
there's a fixed mapping between lanes and ports. What am I missing?

Thierry

--3Pql8miugIZX0722
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUU3NhAAoJEN0jrNd/PrOhYYUP/2C4O5NRTzcggqMZjxWL3vkm
RHMeWitg90neENFZgotVs7SnB/eRXcbJXWX/1DyUsaF5f3DjJ5QNokh8B+Vruo0H
XWaJTdhnymMG2BpzI6sBnBVPnMFil/9vnTrqVPhpiVZNBi+j8F4+1CF2B/5jr/va
4bkvrhCXRS8Tou6f3Livra55d6WQEvRhPUlaj0JPSy0DLpzvU5h3Z0K1UTIx3TrP
fDf4fRgN2j22xnMHh8y+D3eegAVpmGbcjw2NWqNHCvcl+Ke5XqS22e7yXcPymPkK
CV+ybUVUS3dgjw9xzTEslBo5da+G+XbG2I+5X8sPZohUNPMgd6XwLf4X8AZPnLxw
BwNn0FDxzalRcWCVZt49Y8vcn4PAoHpFo/p6/VvvpPRsbMsmzcB2OM+AK5o6n9ea
NQlgrVQ82N5e/VhVZYwq6D87U6P40FsUdLi0M/KdI3WLwuegIJbktEEUSVxDxTu5
vXJDjd5qtsBhRnWm1q4ifhQhxpAG5/oD5dLCJsKMO9gHyx42X1PpU5iCOc1U4G34
LjJuQNs3S7i+DRj9hxudgqo2xpCwvk9GFDLf+t/OiHREpEPGj269j2KL1wk7T58k
V3Yq7GN40TO2bYQMsx7nMKV85X6zo62skEdYC2G6NtnaSG1mg3TuVe8j4bOiIpPk
eYUxoKBvCqcvVPmxg1XG
=gyqK
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--
