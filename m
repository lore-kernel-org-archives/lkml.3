Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbbAWQTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:19:18 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39085 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbbAWQTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:19:16 -0500
Date: Fri, 23 Jan 2015 10:19:09 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] extcon: usb: Introduce USB GPIO extcon driver. Fix
 DRA7 USB.
Message-ID: <20150123161909.GF8585@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1421689942-10201-1-git-send-email-rogerq@ti.com>
 <20150120190237.GG15169@saruman>
 <54C0FBDC.6040803@ti.com>
 <54C10FF4.5030503@ti.com>
 <20150122202907.GC22288@saruman.tx.rr.com>
 <54C1F7C0.4020505@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RE3pQJLXZi4fr8Xo"
Content-Disposition: inline
In-Reply-To: <54C1F7C0.4020505@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RE3pQJLXZi4fr8Xo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 09:26:56AM +0200, Roger Quadros wrote:
> Felipe,
>=20
> On 22/01/15 22:29, Felipe Balbi wrote:
> > On Thu, Jan 22, 2015 at 04:57:56PM +0200, Roger Quadros wrote:
> >>
> >> On 22/01/15 15:32, Roger Quadros wrote:
> >>> Felipe,
> >>>
> >>> On 20/01/15 21:02, Felipe Balbi wrote:
> >>>> On Mon, Jan 19, 2015 at 07:52:17PM +0200, Roger Quadros wrote:
> >>>>> Hi,
> >>>>>
> >>>>> On DRA7 EVMs the USB ID pin is connected to a GPIO line. The USB dr=
ivers
> >>>>> (dwc3 + dwc3-omap) depend on extcon framework to get the USB cable =
state
> >>>>> (USB or USB-Host) to put the controller in the right mode.
> >>>>>
> >>>>> There were earlier attempts [1] to get this working by trying to pa=
tch up
> >>>>> the existing GPIO extcon driver.
> >>>>>
> >>>>> This series attemts to take a different approach by introducing a n=
ew
> >>>>> USB specific extcon driver to handle the USB ID GPIO pin and
> >>>>> interpret a right USB cable state.
> >>>>>
> >>>>> The reasoning to introduce this new driver is:
> >>>>> 1) The existing GPIO extcon driver doesn't understand USB cable sta=
tes
> >>>>> and it can't handle more than one cable per instance.
> >>>>>   =20
> >>>>> For the USB case we need to handle at least 2 cable states.
> >>>>>     a) USB (attach/detach)
> >>>>>     b) USB-Host (attach/detach)
> >>>>> and could possible include more states like
> >>>>>     c) Fast-charger (attach/detach)
> >>>>>     d) Slow-charger (attach/detach)
> >>>>>    =20
> >>>>> 2) This USB specific driver can be easily updated in the future to
> >>>>> handle VBUS events, or charger detect events, in case it happens
> >>>>> to be available on GPIO for any platform.
> >>>>>
> >>>>> 3) The DT implementation is very easy. You just need one extcon nod=
e per USB
> >>>>> instead of one extcon node per cable state as in case of [1].
> >>>>>
> >>>>> 4) The cable state string doesn't need to be encoded in the device =
tree
> >>>>> as in case of [1].
> >>>>>
> >>>>> 5) With only ID event available, you can simulate a USB-peripheral =
attach
> >>>>> when USB-Host is detacted instead of hacking the USB driver to do t=
he same.
> >>>>>
> >>>>> Tested on DRA7-evm and DRA72-evm.
> >>>>
> >>>> while at that, you might want to patch X15 too.
> >>>>
> >>> USB2 port is meant for peripheral use only. ID pin from USB port is n=
ot connected to GPIO.
> >>>
> >>
> >> OK answering myself here :).
> >> Peripheral mode doesn't work on x15-bb as the USB driver (dwc3-omap)
> >> doesn't set the mailbox correctly even when dwc3 node is set as otg =
=3D "peripheral".
> >>
> >> Looks like we need to implement usb-gpio-extcon for x15 even though ID=
 is hard coded.
> >=20
> > right, another option is to have dwc3-omap read the child's DTS to check
> > dr_mode and hardcode things based on that.
> >=20
> I think that option is better as it doesn't require a GPIO line to be
> reserved for ID when USB is not meant for dual-role use.

yeah, let's implement that for 3.21.

--=20
balbi

--RE3pQJLXZi4fr8Xo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwnR9AAoJEIaOsuA1yqREP8IP/0hI6aYpSTIVwCTQpyuqueKx
8EownKqdtaKISUfkkFv6BSLYXcuFBXi7UTCcFq9RCWmrWOxIt2uenWwnWOyh8KJA
Xq4PSpap/xTafR6vcWn3f9WHFFkTXNlkp1mImDAF4+7MC+NZkhSPtUWDjbkWNyHE
A9NwGz2KUXfxIHq1KixgFtQll6RIyh0NMzN2cYOXl8ZlTuN4gkzGOCX0+5hv8sk7
qiL+LbqQ/T1GA4849Cdlb42glkt5l9MJkUMO0MVYqhR3BPnPRKrv0K+FQ7C8B4zi
OdXCL+Uj8Cx7+TNSyVBZj+c6GRG+tq3h7FoE4bhKVP1Mu86SVMCS7FByVyNlbQCe
ES6XlnRvgs+XACqRvbYxsjm8BrZwzUQ9XqdxTPiQdAOkuigsMZwZmdIQCaJgFGbQ
UUqtSVJCj9jU+6030aiQjLQuLFjzH2iq7WOCPRW2QDmjYJ/oYtsttrgAk2i7dunp
Na2/O2QETwDGBiU4Vyr7jmdAKwW04BFBmI4qBmxPSCsQ3AfSbYeGxIKCQz1iw6t5
t1Ve9XZkoDBC3JexjLFvt0zdtmQCdyofIT95rj5o9Q3mRGqKrySWeIp1+qPnY0r3
6egqwcGT1mNJ4golT2J3rwIjHkCbWz2JAWsCuF1u/1ooVVCy5Rcd18OiYGAV7a1+
5ZktkvLmy8poYrixJM60
=/1ku
-----END PGP SIGNATURE-----

--RE3pQJLXZi4fr8Xo--
