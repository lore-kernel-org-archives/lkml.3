Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaFSEDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 00:03:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58857 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaFSEDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 00:03:06 -0400
Date: Wed, 18 Jun 2014 23:02:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: <balbi@ti.com>, <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>, <r.sricharan@ti.com>,
        <robh+dt@kernel.org>, Josh Elliot <jelliott@ti.com>,
        <galak@codeaurora.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] arm: dts: add support for AM437x StarterKit
Message-ID: <20140619040230.GA15073@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403106200-777-1-git-send-email-balbi@ti.com>
 <1403106200-777-3-git-send-email-balbi@ti.com>
 <53A1BADD.7050309@ti.com>
 <20140618193113.GC4570@saruman.home>
 <53A20A7D.3060508@ti.com>
 <20140618231923.GA9855@saruman.home>
 <53A24A39.4080100@ti.com>
 <20140619030520.GA13805@saruman.home>
 <53A2564E.2080600@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <53A2564E.2080600@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 18, 2014 at 10:17:34PM -0500, Nishanth Menon wrote:
> On 06/18/2014 10:05 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Wed, Jun 18, 2014 at 09:26:01PM -0500, Nishanth Menon wrote:
> >> On 06/18/2014 06:19 PM, Felipe Balbi wrote:
> >> [...]
> >>>>>>> Add support for TI's AM437x StarterKit Evaluation
> >>>>>>> Module.
> >>>>>>
> >>>>>> is there a link for this platform?
> >>>>>
> >>>>> internal only
> >>>>
> >>>> but will eventually be sold externally? I assume this is not an TI
> >>>
> >>> probably, but there's nothing public yet.
> >>>
> >>>> internal only board.
> >>>
> >>> correct assumption for all I know.
> >>
> >> Yikes.. ok.. I'd let Tony et.al make the call on this, I guess.
> >=20
> > would we really block a DTS just because there's no public wiki page
> > available (yet) ?
> >=20
> > Sounds a bit extreme to me.
>=20
> If this is an TI internal board without anyone outside that a few
> select developers being able to get and work on it... I am a bit
> skeptical on upstream kernel support and burden for forseeable future
> in ensuring it is tested and continually maintained. if it an
> one-off.. maybe fork might be good enough.. upstream not too attractive.

dude, this is a Starter Kit after all. The probability of being sold
eventually is really, really high. I just can't confirm it certainly
will right now.

> I mean, if it is targeted to be sold eventually, I have no objections
> or blocks - just make it clear in commit message. I can imagine folks
> wondering what the heck this is and googling without results(just like
> I did).

I'll point you to schematics and internal wiki tomorrow if you want. I'm
sure there will be a public ti.com address for it though.

> [...]
>=20
> >>>>>>> +	cd-gpios =3D <&gpio0 6 GPIO_ACTIVE_HIGH>;
> >>>>>>> +};
> >>>>>>> +
> >>>>>>> +&usb2_phy1 {
> >>>>>>> +	status =3D "okay";
> >>>>>>> +};
> >>>>>>> +
> >>>>>>> +&usb1 {
> >>>>>>> +	dr_mode =3D "peripheral";
> >>>>>>> +	status =3D "okay";
> >>>>>>> +};
> >>>>>>> +
> >>>>>>> +&usb2_phy2 {
> >>>>>>> +	status =3D "okay";
> >>>>>>> +};
> >>>>>>> +
> >>>>>>> +&usb2 {
> >>>>>>> +	dr_mode =3D "host";
> >>>>>>> +	status =3D "okay";
> >>>>>>> +};
> >>>>>> none of the above need pinctrl? no regulator supplies?
> >>>>>
> >>>>> pins in default states, drivers don't use regulators.
> >>>>
> >>>> USB works without a supply? even a fixed voltage supply? that is
> >>>> weird.
> >>>
> >>> take a look at the minicom output I posted if you don't believe. Well,
> >>> to be exact, tps63010 [1] is the one which generates the regulated V5=
_0D
> >>> which is used as VBUS_USB. The enable pin in that device is tied to t=
he
> >>> 3v3 rail (dcdc4 regulator in the PMIC as most everything else) but
> >>> there's no way (otherwise) to control that thing. There's no control
> >>> bus, no way to write a driver.
> >>>
> >>> Since the board will anyways turn off if you disable the 3v3 rail, it=
's
> >>> pretty much pointless to figure out a hack just to add this to DTS.
> >>>
> >>> [1] http://www.ti.com/product/TPS63010
> >>
> >> I am sure to trust you on the test log :) ->  but then from dts descri=
ption
> >> perspective, it is good if we describe the supplies, even as a always =
on
> >> fixed-regulator. We had instances like 2430SDP ethernet where... umm..=
=2E we
> >> originally missed describing ethernet supply and boom, one fine mornin=
g, no
> >> more nfs filesystem - I mean, it is a one off scenario there, but desc=
ribing
> >> regulators helps us atleast understand the power tree of the board a l=
ittle
> >> better.
> >>
> >> Again, no strong opinions on my side, it is a good thing to do is all
> >> I feel about it.
> >=20
> > you mean something like:
> >=20
> > 	V5_0D: fixedregulator@0 {
> > 		compatible =3D "regulator-fixed";
> > 		regulator-name =3D "V5_0D";
> > 		regulator-min-microvolt =3D <5000000>;
> > 		regulator-max-microvolt =3D <5000000>;
> > 		regulator-boot-on;
> > 		regulator-always-on;
> > 		vin-supply =3D <&dcdc4>;
> > 	};
> >=20
> > 	VBUS_USB: fixedregulator@1 {
> > 		compatible =3D "regulator-fixed";
> > 		regulator-name =3D "VBUS_USB";
> > 		regulator-min-microvolt =3D <5000000>;
> > 		regulator-max-microvolt =3D <5000000>;
> > 		regulator-boot-on;
> > 		regulator-always-on;
> > 		vin-supply =3D <&V5_0D>;
> > 	};
> >=20
> > I can add that, but note that it's *solely* to make sysfs look nice. And
> > if that's the case, most likely *every* DTS file in tree today as
> > incomplete. OTOH, I really consider this to be hugely unnecessary
> > because of the fact that board will turn off if 3v3 (dcdc4) is disabled.
> >=20
>=20
>=20
> Yes - something along those lines - Again, no strong opinions on my
> side for these - just that it is a good thing to model in and may help
> drivers where can use the awareness.

if you ask me, it's just two extra instances of the fixed regulator
driver for a really marginal added benefit.

--=20
balbi

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTomDWAAoJEIaOsuA1yqREKTQP/jJOrzVZws/wKmelIZPjLwT0
NPfngr+cp68SyuYmdtXrZ0SVbgk3XJq3iVHsXEyXeHXCTqJVbBQk1ceAsX0nxURV
msc4AnOZyuVhvIVmTA++DDPf7PUVkffrYPaww8eoxD4IOVjc6kMsW1WEtW3K7q9U
S5a016+BnIWZ75U1O01P9Oz09YVsNJj89rI0En+ZtJgjnkLeXi3eJTqdiJH2liij
cAxc2wlxBm8QWtP2DnTW6fR0g3FVR1pQOdBbzcj6avDrSonzuR6CCLAKEtMEgOrp
xqLs+Lq60OaRzuI5f7Y58IdtNDOcNQQUglJGdaoeMkDbIC+qRmFyebAFyFfilIB/
utvgyMqYNdwnqx+WFlwR6YMlLeCncRMmdwO4E/dmkQnZAwv6wOi+5gZMLkS6xuPO
HueNnZQfjkowb4U0XBfyTDplLtZzFQnAZeNL3ahyuXwb3Q74dHSMNY0tWheYLsui
KlQY4efhc70mAkeA5MaOpmRAexh761G158QlH5jn0yAwGr3EEsP5XyIBsIuHo/XZ
s+E96aevpHLVBIFkFcX5UTdpeshbZANlDgNxQXu+GBBC6fRGRg4EsKvwkhRYivyV
vu6egYj7gz8DcfYqNMP4pEbIKhcMZiDLe2VHLzciEuljucxsh3mXWmZjISDos+bq
HFKds2WZVkMpz93Ie/IF
=L2TR
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
