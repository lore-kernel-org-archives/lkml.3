Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaHUGgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:36:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47646 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaHUGgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:36:41 -0400
Date: Thu, 21 Aug 2014 08:36:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc: Doug Anderson <dianders@chromium.org>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: rockchip: rk3288: Switch to use the proper PWM
 IP
Message-ID: <20140821063637.GB4486@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
 <20140820153801.GB3427@ulmo>
 <CAD=FV=Xf4Hm5tCaaW3QG-ZSQGovh6RKH=1Og1K-yxj+jKyGsmA@mail.gmail.com>
 <2927513.T62GI7nq9T@phil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <2927513.T62GI7nq9T@phil>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 06:20:31PM +0200, Heiko St=C3=BCbner wrote:
> Am Mittwoch, 20. August 2014, 08:55:09 schrieb Doug Anderson:
> > Thierry,
> >=20
> > On Wed, Aug 20, 2014 at 8:38 AM, Thierry Reding
> >=20
> > <thierry.reding@gmail.com> wrote:
> > > On Wed, Aug 20, 2014 at 08:20:53AM -0700, Doug Anderson wrote:
> > >> Thierry,
> > >>=20
> > >> On Tue, Aug 19, 2014 at 11:08 PM, Thierry Reding
> > >>=20
> > >> <thierry.reding@gmail.com> wrote:
> > >> > On Tue, Aug 19, 2014 at 08:18:54AM -0700, Doug Anderson wrote:
> > >> >> Thierry,
> > >> >>=20
> > >> >> On Tue, Aug 19, 2014 at 12:10 AM, Thierry Reding
> > >> >>=20
> > >> >> <thierry.reding@gmail.com> wrote:
> > >> >> > On Mon, Aug 18, 2014 at 10:09:06AM -0700, Doug Anderson wrote:
> > >> >> >> The rk3288 SoC has an option to switch all of the PWMs in the
> > >> >> >> system
> > >> >> >> between the old IP block and the new IP block.  The new IP blo=
ck is
> > >> >> >> working and tested and the suggested PWM to use, so setup the =
SoC
> > >> >> >> to
> > >> >> >> use it and then we can pretend that the other IP block doesn't
> > >> >> >> exist.
> > >> >=20
> > >> > A few more questions as to how this actually works. Does it mean t=
here
> > >> > are two physically separate blocks (with different physical addres=
ses)
> > >> > to control the same PWM? And this register simply causes some of t=
he
> > >> > pins to be routed to one or another? As far as I recall there are a
> > >> > number of instances of the PWM block, so the above would need to c=
ount
> > >> > for all of them. Or are there separate bits for each of them?
> > >>=20
> > >> All I have is the TRM (technical reference manual) which doesn't give
> > >> me much more info than I've provided you.  But I can answer some of
> > >> your questoins:
> > >>=20
> > >> 1. If there are two physically separate blocks then the "old" block =
is
> > >> not documented in my TRM.
> > >>=20
> > >> 1a) It's entirely possible it's located at some memory address that =
is
> > >> marked "Reserved" in the TRM, but I have no idea.
> > >>=20
> > >> 1b) It's entirely possible that the old IP block and the new IP block
> > >> are supposed to be "compatible" but that the old block is broken and
> > >> thus isn't behaving properly.
> > >>=20
> > >> 1c) It's entirely possible that the old IP block and the new IP block
> > >> are located at the same physical addresses but somehow work
> > >> differently.  If so, the old IP block isn't documented.
> > >>=20
> > >>=20
> > >> 2. As per the patch description, there is a single bit that controls
> > >> all of the PWMs.  My guess is that there's actually a single IP block
> > >> that implements all 4 PWMs.
> > >=20
> > > Looking at the register offsets in the device tree that seems likely.=
 At
> > > least PWMs 0 and 1 as well as 2 and 3 seem like they could be in the
> > >=20
> > > same IP block. Their placement in the register map is somewhat strang=
e:
> > >         pwm0: pwm@20030000 {
> > >        =20
> > >                 ...
> > >                 reg =3D <0x20030000 0x10>;
> > >                 ...
> > >                 clocks =3D <&cru PCLK_PWM01>;
> > >                 ...
> > >        =20
> > >         };
> > >        =20
> > >         pwm1: pwm@20030010 {
> > >        =20
> > >                 ...
> > >                 reg =3D <0x20030010 0x10>;
> > >                 ...
> > >                 clocks =3D <&cru PCLK_PWM01>;
> > >                 ...
> > >        =20
> > >         };
> > >        =20
> > >         ...
> > >        =20
> > >         pwm2: pwm@20050020 {
> > >        =20
> > >                 ...
> > >                 reg =3D <0x20050020 0x10>;
> > >                 ...
> > >                 clocks =3D <&cru PCLK_PWM23>;
> > >                 ...
> > >        =20
> > >         };
> > >        =20
> > >         pwm3: pwm@20050030 {
> > >        =20
> > >                 ...
> > >                 reg =3D <0x20050030 0x10>;
> > >                 ...
> > >                 clocks =3D <&cru PCLK_PWM23>;
> > >                 ...
> > >        =20
> > >         };
> >=20
> > Ah, you're looking at "rk3xxx.dtsi".  That doesn't apply to rk3288
> > (the downsides of trying to guess ahead of time what SoC vendors will
> > name new models).
>=20
> It did sound like a nice idea at the time to hold the common stuff of=20
> rk3066/rk3188 and all their derivatives and I assumed a SoC that changed=
=20
> dramatically (including the core) would be called 4xxx or so :-) .
>=20
> >=20
> > In rk3288 they have the same clocks.  See patch #3 in this series.
> >=20
> > > The clocks would also indicate that there are actually two blocks. I
> > > seem to remember a discussion about whether to handle them as a single
> > > block or two/four, but I can't seem to find a reference to it. Maybe =
I'm
> > > confusing it with another driver.
> >=20
> > At this point it seems like the choice has already been made to handle
> > them as separate PWMs.  I can change this choice if you want...
> >=20
> > >> >> >> This code could go lots of other places, but we've put it here=
=2E=20
> > >> >> >> Why?
> > >> >> >> - Pushing it to the bootloader just makes the code harder to u=
pdate
> > >> >> >> in
> > >> >> >>=20
> > >> >> >>   the field.  If we later find a bug in the new IP block and w=
ant
> > >> >> >>   to
> > >> >> >>   change our mind about what to use we want it to be easy to
> > >> >> >>   update.
> > >> >=20
> > >> > Depending on how this muxing works you won't be able to change your
> > >> > mind
> > >> > anyway. If the IP blocks are different then the device tree will
> > >> > effectively make the decision for you. So if you really want to be=
 safe
> > >> > you'd need to have code in the kernel that parses the device tree =
and
> > >> > checks that all PWM instances are of the new type, then set this
> > >> > register accordingly.
> > >>=20
> > >> Since there is no documentation about how you would instantiate the
> > >> "old" type in the TRM and no good reason I can think of why someone
> > >> would want to do this, it doesn't seem super fruitful.
> > >=20
> > > Okay, so if it's not at all documented and never used then yes, we'd
> > > better just ignore it.
> >=20
> > Heiko just pointed me at the base address for the other block.
> > There's nothing in the rk3288 TRM about it, but we can see the base
> > address.  We could probably guess that it behaves the same as the
> > older PWM if we need to.  I'm still not convinced there's a good
> > reason for someone to use it.
>=20
> From what I understood the old one was included as a fallback in case som=
e=20
> drastic problem appeared with the newly developed IP. Similarly for the I=
2C=20
> the rk2928 and before contained the old IP, the rk3xxx SoCs did contain b=
oth=20
> old and new i2c IP and now the rk3288 only contains the new one, as the n=
ew IP=20
> seems to have proven stable.
>=20
> So there really is no incentive to use the old one if no drastic issue ha=
s=20
> appeared with the new one until now.
>=20
>=20
> > >> >> >> diff --git a/arch/arm/mach-rockchip/rockchip.c
> > >> >> >> b/arch/arm/mach-rockchip/rockchip.c index 8ab9e0e..99133b9 100=
644
> > >> >> >> --- a/arch/arm/mach-rockchip/rockchip.c
> > >> >> >> +++ b/arch/arm/mach-rockchip/rockchip.c
> > >> >> >> @@ -24,6 +24,24 @@
> > >> >> >>=20
> > >> >> >>  #include <asm/hardware/cache-l2x0.h>
> > >> >> >>  #include "core.h"
> > >> >> >>=20
> > >> >> >> +static void __init rk3288_init_machine(void)
> > >> >> >> +{
> > >> >> >> +     void *grf =3D ioremap(0xff770000, 0x10000);
> > >> >> >=20
> > >> >> > This region of memory is part of the "grf" "syscon" device
> > >> >> > (according to
> > >> >> > arch/arm/boot/dts/rk3288.dtsi) so the register should be access=
ed
> > >> >> > from
> > >> >> > that driver. It looks as if no such driver currently exists, but
> > >> >> > given
> > >> >> > the existence of the device tree node it's fair to assume that =
one
> > >> >> > will
> > >> >> > eventually be merged.
> > >> >>=20
> > >> >> The "grf" syscon device is the "general register file".  It's a
> > >> >> collection of totally random registers stuffed together in one ad=
dress
> > >> >> space.  Sometimes a single 32-bit register has things you need to
> > >> >> tweak for completely different subsystems.
> > >> >>=20
> > >> >> Most drivers referene the syscon using this in dts:
> > >> >>   rockchip,grf =3D <&grf>;
> > >> >>=20
> > >> >> Then the drivers do:
> > >> >>   grf =3D syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
> > >> >>=20
> > >> >> See the Rockchip i2c, pinctrl, or clock drivers for examples.
> > >> >=20
> > >> > That's one way to do it. But if it's really just a one-time thing,=
 then
> > >> > you could easily perform the register write from the syscon driver
> > >> > where
> > >> > the memory is already parsed from device tree and mapped. That way=
 you
> > >> > don't have to hardcode the physical address in some other random p=
iece
> > >> > of code and map the memory again.
> > >>=20
> > >> Well, except that we're using the general "syscon" driver.  I could
> > >> create a whole new driver that "subclasses" this syscon driver I
> > >> suppose.
> > >=20
> > > Ah, I wasn't aware that there was even something like a generic syscon
> > > driver. But yes, subclassing it sounds like a reasonable thing to do.
> >=20
> > I will do that if need be, but it's not my favorite.  I will let
> > others chime in.
>=20
> I guess personally I like the idea best of just setting the relevant bit =
in=20
> _probe of the pwm driver, like the i2c driver does:
>=20
> if (of_device_is_compatible(np, "rockchip,rk3288-pwm") {
> 	/* get regmap and set bit */
> }
>=20
> The downside would be that the bit would be written 4 times, but I guess =
this=20
> shouldn't matter to much. And I don't think anybody will get the idea of=
=20
> combining both ip variants in one dts anyway.
> And of course in the next SoC the old IP will mostly have gone away and k=
eep=20
> this somewhat close to the driver and not scatter pwm settings into other=
=20
> kernel parts.
>=20
> Hacking up the syscon driver feels bad to me, especially as it is meant t=
o be=20
> generic and export such shared registers to other drivers for just these =
stuff.

I think using syscon in the first place is bad. In my opinion it would
be far better to export an explicit API from drivers that are currently
"implemented" as syscon. The thing is, nothing about syscon is truly
generic. All it provides is a memory-mapped I/O region and lets drivers
do to that memory region whatever they wants. But ioremap() can be used
for that purpose already. Yet we have infrastructure to prevent drivers
=66rom doing that (request_resource() and friends) because it's usually a
bad idea. All syscon really gives us is a ratified way of doing things
that are otherwise frowned upon.

Thierry

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9ZN1AAoJEN0jrNd/PrOh964QAJvc8wcmUaLTRyJehXIIky5O
AEDUX7IIDfWwjggTttuubaLukKTCTSoqQiVYpub2IZa5z4kiRQpryaafnjhwo6na
4/pnPnHMFt/jXm0S2ENf/CQxbwbovAEGCC59AbuiLi7CkbpzqIJ0sZiE1YsgNtCi
TUq50F2AzRG0Qfi4v7aI9LV/j3MG6ycGH/XqAj0uv0M1NvnArfvMwSV9RU8NulM9
D82ogGYpNRrocI1AS+aZhrlsOt0DfPDglKFQsTzc6xbOAZErswgzM9w/if195IGF
saP/yuLByzBbem5g+t9IpzDi49Yc153fGWs04gKwbJQkwQVoudNlocqyVr8ZKBGK
rncOZy6Hb8kqoqrp9j5MBpHDOqNVyHcRc7KCxeRdW5J+th3U9ZvSq12OI/G3ZsZY
lkeNCG18/94qbXNoEL6Oh089v6Bcv68Ouxyp3dsKmsI5bYgLPWlt/a4dd7lPJD/l
LC7UO+hH3nrg2Tx/brrMzQUNehhqYUpWF3VSeoNzd/wJyjNVyH8f45GUbkmvJnrc
HF+4qrVapmxGGsaIarAMY7hPAbxz9KGYjpRkcNFresJu/6VOtbGTSBPnkLKpzmk5
1/hz7T4pMn5nYAuW9ylsnF9FHK74dYMJlgNBjKKzk+c/CYceVeitgRSggIvF1hcU
OxP60RHDiwlvFOi/RVgS
=Vdyn
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
