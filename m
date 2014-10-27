Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaJ0RLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:11:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45906 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbaJ0RLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:11:00 -0400
Date: Mon, 27 Oct 2014 12:09:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        <nsekhar@ti.com>, <t-kristo@ti.com>, <j-keerthy@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] rtc: omap: add support for pmic_power_en
Message-ID: <20141027170902.GM14253@saruman>
Reply-To: <balbi@ti.com>
References: <1413913086-12730-1-git-send-email-johan@kernel.org>
 <1414397368-26480-1-git-send-email-johan@kernel.org>
 <20141027164544.GI14253@saruman>
 <20141027165654.GF2006@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NZtAI5QFBF0GmLcW"
Content-Disposition: inline
In-Reply-To: <20141027165654.GF2006@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NZtAI5QFBF0GmLcW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 05:56:54PM +0100, Johan Hovold wrote:
> On Mon, Oct 27, 2014 at 11:45:44AM -0500, Felipe Balbi wrote:
> > On Mon, Oct 27, 2014 at 09:09:28AM +0100, Johan Hovold wrote:
> > > Add new property "ti,system-power-controller" to register the RTC as a
> > > power-off handler.
> > >=20
> > > Some RTC IP revisions can control an external PMIC via the pmic_power=
_en
> > > pin, which can be configured to transition to OFF on ALARM2 events and
> > > back to ON on subsequent ALARM (wakealarm) events.
> > >=20
> > > This is based on earlier work by Colin Foe-Parker and AnilKumar Ch. [=
1]
> > >=20
> > > [1] https://www.mail-archive.com/linux-omap@vger.kernel.org/msg82127.=
html
> > >=20
> > > Tested-by: Felipe Balbi <balbi@ti.com>
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> > >=20
> > > Changes since v2:
> > >  - add two-second delay to allow alarm to trigger before returning
> > >=20
> > > Andrew, can you replace just this patch in the series that you already
> > > have in your tree, or do you prefer I resend the whole series (with
> > > Felipe's Tested-by tags)?
> > >=20
> > > Thanks,
> > > Johan
> > >=20
> > >=20
> > >  Documentation/devicetree/bindings/rtc/rtc-omap.txt |  9 +-
> > >  drivers/rtc/rtc-omap.c                             | 95 ++++++++++++=
++++++++++
> > >  2 files changed, 103 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/rtc/rtc-omap.txt b/Doc=
umentation/devicetree/bindings/rtc/rtc-omap.txt
> > > index 5a0f02d34d95..750efd40c72e 100644
> > > --- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
> > > +++ b/Documentation/devicetree/bindings/rtc/rtc-omap.txt
> > > @@ -5,11 +5,17 @@ Required properties:
> > >  	- "ti,da830-rtc"  - for RTC IP used similar to that on DA8xx SoC fa=
mily.
> > >  	- "ti,am3352-rtc" - for RTC IP used similar to that on AM335x SoC f=
amily.
> > >  			    This RTC IP has special WAKE-EN Register to enable
> > > -			    Wakeup generation for event Alarm.
> > > +			    Wakeup generation for event Alarm. It can also be
> > > +			    used to control an external PMIC via the
> > > +			    pmic_power_en pin.
> > >  - reg: Address range of rtc register set
> > >  - interrupts: rtc timer, alarm interrupts in order
> > >  - interrupt-parent: phandle for the interrupt controller
> > > =20
> > > +Optional properties:
> > > +- ti,system-power-controller: whether the rtc is controlling the sys=
tem power
> >=20
> > isn't there a discussion going on to drop the vendor prefix ? I wonder
> > if we should just use the final binding to avoid supporting this for
> > rtc-omap too. OTOH, all of that can be hidden under
> > of_is_system_power_controller() itself.
>=20
> Exactly, Romain intends to support both versions (i.e. with and without
> the prefix) with his helper function as there are already other uses of
> this variant in the wild.
>=20
> As I believe I mentioned in my cover letter, I suggest simply updating
> to the generic property name (i.e. use the helper and drop the prefix)
> once that code has been merged. Either way, we should always be able
> to change the property name before it has been used in a mainline
> release (as long as we update the driver and any dts use in one commit
> in order not to break bisectability).

fine by me :-) cheers

--=20
balbi

--NZtAI5QFBF0GmLcW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTnwuAAoJEIaOsuA1yqREaRwQAK/uVKHZMNnsTCMkt+qAWjDi
aq+8od64pBXdPa/uIiOQcpbg8GTUQXwR7K9p/mhR2EXjTIfHGC6XPGgzbYWd48gy
hNxauEHL5lhXN3QDJY8BXpnZNvz4HmT2ekwwvA+2hTkDh+NY4UvbDD5jljTQIom5
WUS/LdT31MkZTwNqnkglG0GpkjCCTC5ovrgpIR2Uiy8JRLjaLZkAyO4scjT7e8Ep
cGQIUs2FEPP072kkAoSf8xNbpdNU2I7PszaoV+QfgMQns/mbD3+HF9pi5FJ+UhDi
4rDDw4JDKkAzZb6JZqs1LZkIQWoTd46HRCWNBMV9Pv5pHZZfCtDRFugv5wBwqjAT
xCIA/Mv7x1V8NoReZxQT2U2iGWW8ba1Q20IAOqMqGhUaV8WCrdEXkiw7ElhQy652
rV4MTMyjBuhn6kZwbpSJ9HI6eceC11e5HjKxJlSeJ4dRiKRVJtpyUKfurtJSwPn4
gKseSeV3fVourqf6vwEP1mEXs5YIdigGUcda3N8WlOCKrzxjnfsLBXqCIVdlzRlR
h/tzJKBRakulbd9knFpYlbq8EMa015oKW0MaFfhzVFDl5bSARD5wRPa6JD0suj3j
mevOHeA/H2phe3fgBJabRogT4dMnIWlUs+Q5qeUAnrveFnLlgeSGsb3iC1AXuiE6
iwOnp6FvwH7HLwP4q+GL
=5sv2
-----END PGP SIGNATURE-----

--NZtAI5QFBF0GmLcW--
