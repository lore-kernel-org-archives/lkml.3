Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab3APHOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:14:12 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37827 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898Ab3APHOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:14:09 -0500
Date: Wed, 16 Jan 2013 09:13:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: "B, Ravi" <ravibabu@ti.com>, "Balbi, Felipe" <balbi@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCH 0/7] usb: musb: add driver for control module
Message-ID: <20130116071351.GC610@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358239378-10030-1-git-send-email-kishon@ti.com>
 <201301151341.08297.arnd@arndb.de>
 <50F56A1A.3040504@ti.com>
 <20130115150432.GB26272@arwen.pp.htv.fi>
 <6C6B28D4DC342643927BEAFCE8707BF63EA5ACAB@DBDE01.ent.ti.com>
 <50F6423C.2020307@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
Content-Disposition: inline
In-Reply-To: <50F6423C.2020307@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 11:31:32AM +0530, kishon wrote:
> Hi Ravi,
>=20
> On Tuesday 15 January 2013 09:36 PM, B, Ravi wrote:
> >>Hi,
> >>
> >>On Tue, Jan 15, 2013 at 08:09:22PM +0530, kishon wrote:
> >>>Hi Arnd,
> >>>
> >>>On Tuesday 15 January 2013 07:11 PM, Arnd Bergmann wrote:
> >>>>On Tuesday 15 January 2013, Kishon Vijay Abraham I wrote:
> >>>>>Added a new driver for the usb part of control module.
> >>This has an
> >>>>>API to power on the USB2 phy and an API to write to the mailbox
> >>>>>depending on whether MUSB has to act in host mode or in
> >>device mode.
> >>>>>
> >>>>>Writing to control module registers for doing the above
> >>task which
> >>>>>was previously done in omap glue and in omap-usb2 phy is removed.
> >>>>>
> >>>>>Also added the dt data to get MUSB working in OMAP platforms.
> >>>>>This series has patches for both drivers and ARCH
> >>folders, so If it
> >>>>>has to be split I'll do it.
> >>>>>
> >>>>
> >>>>The series looks good to me, I just had a minor comment on
> >>one patch.
> >>>>
> >>>>One a somewhat related topic, I wonder whether there are
> >>any plans on
> >>>>your side to change this driver to support multiple bus
> >>glues to be
> >>>>built for one kernel image. With a multiplatform kernel,
> >>we may need
> >>>>all of TUSB6010/OMAP2PLUS/DSPS/UX500 for instance.
> >>>
> >>>We don't have plans as of now. I actually don't expect any
> >>changes in
> >>>the driver other than the Kconfig changes. Anyways the
> >>probe of glue's
> >>>other than the platform it's running won't get called. right Felipe?
> >
> >If understand correctly the control module driver used to configure the =
respective usb phy of SoC to respective usb modes using the common set of c=
ontrol module APIs.
> What if, if control module interface (register defintions) varies b/w
> different revision or spin of same type of SoCs, if usbphy type is
> changed.
> Well in that case, we can write to the registers based on the IP
> revision check (I think thats the common practice to do).
>=20
> In this case whether the single instance of control module driver is
> good enough to cater of all cpu types of same SoC series ?
> Of course. I don't see why we can't have the same driver to handle
> different versions of the same IP.
> The only reason where we might need multiple instance is if the SoC
> have multiple control module which Arnd already pointed out.
>=20
> >Whether cpu_is_xxx() can be used to differentiate b/w different cpu type=
s in CM driver?
> Not needed at all IMHO. We can use revision register to differentiate.
>=20
> Btw I think Felipe looped you for a different reason ;-)

right, it was to look at removing <mach/*> inclusion from all
davinci-link glue layers (they should be combined, btw).

--=20
balbi

--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9lMvAAoJEIaOsuA1yqREO/AQAIwAHg6dYr4x0bi2305oS1EU
gi0A/7MZfAPgMs0Xkg3H9frW8b2SKxMKocod7d8cnyehDjgy+ZWve4D46un6H7Pf
fjGZDJ1LtwxNfqwL1+Gpu0h5MicTg7AQFFZ8BMu/Nna7pMOfYlY3FF7TBgXPqIXM
ffLhbTaLXKcTuuqIkkeC8uJzui5lit7VTDVjGcMRIs1fErXsdRKqLlJiQhjtugQI
uTKz88BXkuqLpad454EeDOjXAi4ICfKkptpRXTwdleStKH1jFKS1NGv4vKZS9GOG
9OiXKzyJskgdAytfXStmaqU8xKL0gEnEXYy6hYbX0c7sAB13Q/r7FFq16l5d/Ciq
94f9sKwATKy2K4TqRRv0v3j1xcUqs56COrP2OjoLmOVXDj+U0roAL098sfl82g7n
xLbmmIxfm9lMAMzaO+oTNQjRAacEOQed+MkcKXffigAVEg/InHYQUJPfpvybCsyL
HpqgNzPeyUYOWcprymwB+DVfod7neDRrHbGnBAwyFc3j7OMxmxDooQ5eQtcOUirA
Skbk/Ao0BzsBS3RSogSNvf37C1o7Z5VkckbMJQVQQLRy1rWaitNQej061207DuhX
RvBMlN/7y1bbT3zJujNHMJXQYmvPjaW4/vp/4zwlVvzQ77NzVJN+iCVvUnJB+d6e
RU3os564k207B3m3VYyW
=l0eC
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--
