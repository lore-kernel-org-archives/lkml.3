Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaHUQrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:47:12 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:33448 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaHUQrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:47:10 -0400
Date: Thu, 21 Aug 2014 18:47:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 1/4] ARM: rockchip: rk3288: Switch to use the proper PWM
 IP
Message-ID: <20140821164705.GA1172@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
 <20140820153801.GB3427@ulmo>
 <CAD=FV=Xf4Hm5tCaaW3QG-ZSQGovh6RKH=1Og1K-yxj+jKyGsmA@mail.gmail.com>
 <2927513.T62GI7nq9T@phil>
 <20140821063637.GB4486@ulmo>
 <CAD=FV=XKr0T-mwma1WdTKQDVyS06rbj3=J4GwbAkc1KsXQspOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <CAD=FV=XKr0T-mwma1WdTKQDVyS06rbj3=J4GwbAkc1KsXQspOw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 08:38:57AM -0700, Doug Anderson wrote:
> Thierry,
>=20
> On Wed, Aug 20, 2014 at 11:36 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Wed, Aug 20, 2014 at 06:20:31PM +0200, Heiko St=C3=BCbner wrote:
> >> Am Mittwoch, 20. August 2014, 08:55:09 schrieb Doug Anderson:
> >> > Thierry,
> >> >
> >> > On Wed, Aug 20, 2014 at 8:38 AM, Thierry Reding
> >> >
> >> > <thierry.reding@gmail.com> wrote:
> >> > > On Wed, Aug 20, 2014 at 08:20:53AM -0700, Doug Anderson wrote:
> >> > >> Thierry,
> >> > >>
> >> > >> On Tue, Aug 19, 2014 at 11:08 PM, Thierry Reding
> >> > >>
> >> > >> <thierry.reding@gmail.com> wrote:
> >> > >> > On Tue, Aug 19, 2014 at 08:18:54AM -0700, Doug Anderson wrote:
> >> > >> >> Thierry,
> >> > >> >>
> >> > >> >> On Tue, Aug 19, 2014 at 12:10 AM, Thierry Reding
> >> > >> >>
> >> > >> >> <thierry.reding@gmail.com> wrote:
> >> > >> >> > On Mon, Aug 18, 2014 at 10:09:06AM -0700, Doug Anderson wrot=
e:
> >> > >> >> >> The rk3288 SoC has an option to switch all of the PWMs in t=
he
> >> > >> >> >> system
> >> > >> >> >> between the old IP block and the new IP block.  The new IP =
block is
> >> > >> >> >> working and tested and the suggested PWM to use, so setup t=
he SoC
> >> > >> >> >> to
> >> > >> >> >> use it and then we can pretend that the other IP block does=
n't
> >> > >> >> >> exist.
> >> > >> >
> >> > >> > A few more questions as to how this actually works. Does it mea=
n there
> >> > >> > are two physically separate blocks (with different physical add=
resses)
> >> > >> > to control the same PWM? And this register simply causes some o=
f the
> >> > >> > pins to be routed to one or another? As far as I recall there a=
re a
> >> > >> > number of instances of the PWM block, so the above would need t=
o count
> >> > >> > for all of them. Or are there separate bits for each of them?
> >> > >>
> >> > >> All I have is the TRM (technical reference manual) which doesn't =
give
> >> > >> me much more info than I've provided you.  But I can answer some =
of
> >> > >> your questoins:
> >> > >>
> >> > >> 1. If there are two physically separate blocks then the "old" blo=
ck is
> >> > >> not documented in my TRM.
> >> > >>
> >> > >> 1a) It's entirely possible it's located at some memory address th=
at is
> >> > >> marked "Reserved" in the TRM, but I have no idea.
> >> > >>
> >> > >> 1b) It's entirely possible that the old IP block and the new IP b=
lock
> >> > >> are supposed to be "compatible" but that the old block is broken =
and
> >> > >> thus isn't behaving properly.
> >> > >>
> >> > >> 1c) It's entirely possible that the old IP block and the new IP b=
lock
> >> > >> are located at the same physical addresses but somehow work
> >> > >> differently.  If so, the old IP block isn't documented.
> >> > >>
> >> > >>
> >> > >> 2. As per the patch description, there is a single bit that contr=
ols
> >> > >> all of the PWMs.  My guess is that there's actually a single IP b=
lock
> >> > >> that implements all 4 PWMs.
> >> > >
> >> > > Looking at the register offsets in the device tree that seems like=
ly. At
> >> > > least PWMs 0 and 1 as well as 2 and 3 seem like they could be in t=
he
> >> > >
> >> > > same IP block. Their placement in the register map is somewhat str=
ange:
> >> > >         pwm0: pwm@20030000 {
> >> > >
> >> > >                 ...
> >> > >                 reg =3D <0x20030000 0x10>;
> >> > >                 ...
> >> > >                 clocks =3D <&cru PCLK_PWM01>;
> >> > >                 ...
> >> > >
> >> > >         };
> >> > >
> >> > >         pwm1: pwm@20030010 {
> >> > >
> >> > >                 ...
> >> > >                 reg =3D <0x20030010 0x10>;
> >> > >                 ...
> >> > >                 clocks =3D <&cru PCLK_PWM01>;
> >> > >                 ...
> >> > >
> >> > >         };
> >> > >
> >> > >         ...
> >> > >
> >> > >         pwm2: pwm@20050020 {
> >> > >
> >> > >                 ...
> >> > >                 reg =3D <0x20050020 0x10>;
> >> > >                 ...
> >> > >                 clocks =3D <&cru PCLK_PWM23>;
> >> > >                 ...
> >> > >
> >> > >         };
> >> > >
> >> > >         pwm3: pwm@20050030 {
> >> > >
> >> > >                 ...
> >> > >                 reg =3D <0x20050030 0x10>;
> >> > >                 ...
> >> > >                 clocks =3D <&cru PCLK_PWM23>;
> >> > >                 ...
> >> > >
> >> > >         };
> >> >
> >> > Ah, you're looking at "rk3xxx.dtsi".  That doesn't apply to rk3288
> >> > (the downsides of trying to guess ahead of time what SoC vendors will
> >> > name new models).
> >>
> >> It did sound like a nice idea at the time to hold the common stuff of
> >> rk3066/rk3188 and all their derivatives and I assumed a SoC that chang=
ed
> >> dramatically (including the core) would be called 4xxx or so :-) .
> >>
> >> >
> >> > In rk3288 they have the same clocks.  See patch #3 in this series.
> >> >
> >> > > The clocks would also indicate that there are actually two blocks.=
 I
> >> > > seem to remember a discussion about whether to handle them as a si=
ngle
> >> > > block or two/four, but I can't seem to find a reference to it. May=
be I'm
> >> > > confusing it with another driver.
> >> >
> >> > At this point it seems like the choice has already been made to hand=
le
> >> > them as separate PWMs.  I can change this choice if you want...
> >> >
> >> > >> >> >> This code could go lots of other places, but we've put it h=
ere.
> >> > >> >> >> Why?
> >> > >> >> >> - Pushing it to the bootloader just makes the code harder t=
o update
> >> > >> >> >> in
> >> > >> >> >>
> >> > >> >> >>   the field.  If we later find a bug in the new IP block an=
d want
> >> > >> >> >>   to
> >> > >> >> >>   change our mind about what to use we want it to be easy to
> >> > >> >> >>   update.
> >> > >> >
> >> > >> > Depending on how this muxing works you won't be able to change =
your
> >> > >> > mind
> >> > >> > anyway. If the IP blocks are different then the device tree will
> >> > >> > effectively make the decision for you. So if you really want to=
 be safe
> >> > >> > you'd need to have code in the kernel that parses the device tr=
ee and
> >> > >> > checks that all PWM instances are of the new type, then set this
> >> > >> > register accordingly.
> >> > >>
> >> > >> Since there is no documentation about how you would instantiate t=
he
> >> > >> "old" type in the TRM and no good reason I can think of why someo=
ne
> >> > >> would want to do this, it doesn't seem super fruitful.
> >> > >
> >> > > Okay, so if it's not at all documented and never used then yes, we=
'd
> >> > > better just ignore it.
> >> >
> >> > Heiko just pointed me at the base address for the other block.
> >> > There's nothing in the rk3288 TRM about it, but we can see the base
> >> > address.  We could probably guess that it behaves the same as the
> >> > older PWM if we need to.  I'm still not convinced there's a good
> >> > reason for someone to use it.
> >>
> >> From what I understood the old one was included as a fallback in case =
some
> >> drastic problem appeared with the newly developed IP. Similarly for th=
e I2C
> >> the rk2928 and before contained the old IP, the rk3xxx SoCs did contai=
n both
> >> old and new i2c IP and now the rk3288 only contains the new one, as th=
e new IP
> >> seems to have proven stable.
> >>
> >> So there really is no incentive to use the old one if no drastic issue=
 has
> >> appeared with the new one until now.
> >>
> >>
> >> > >> >> >> diff --git a/arch/arm/mach-rockchip/rockchip.c
> >> > >> >> >> b/arch/arm/mach-rockchip/rockchip.c index 8ab9e0e..99133b9 =
100644
> >> > >> >> >> --- a/arch/arm/mach-rockchip/rockchip.c
> >> > >> >> >> +++ b/arch/arm/mach-rockchip/rockchip.c
> >> > >> >> >> @@ -24,6 +24,24 @@
> >> > >> >> >>
> >> > >> >> >>  #include <asm/hardware/cache-l2x0.h>
> >> > >> >> >>  #include "core.h"
> >> > >> >> >>
> >> > >> >> >> +static void __init rk3288_init_machine(void)
> >> > >> >> >> +{
> >> > >> >> >> +     void *grf =3D ioremap(0xff770000, 0x10000);
> >> > >> >> >
> >> > >> >> > This region of memory is part of the "grf" "syscon" device
> >> > >> >> > (according to
> >> > >> >> > arch/arm/boot/dts/rk3288.dtsi) so the register should be acc=
essed
> >> > >> >> > from
> >> > >> >> > that driver. It looks as if no such driver currently exists,=
 but
> >> > >> >> > given
> >> > >> >> > the existence of the device tree node it's fair to assume th=
at one
> >> > >> >> > will
> >> > >> >> > eventually be merged.
> >> > >> >>
> >> > >> >> The "grf" syscon device is the "general register file".  It's a
> >> > >> >> collection of totally random registers stuffed together in one=
 address
> >> > >> >> space.  Sometimes a single 32-bit register has things you need=
 to
> >> > >> >> tweak for completely different subsystems.
> >> > >> >>
> >> > >> >> Most drivers referene the syscon using this in dts:
> >> > >> >>   rockchip,grf =3D <&grf>;
> >> > >> >>
> >> > >> >> Then the drivers do:
> >> > >> >>   grf =3D syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
> >> > >> >>
> >> > >> >> See the Rockchip i2c, pinctrl, or clock drivers for examples.
> >> > >> >
> >> > >> > That's one way to do it. But if it's really just a one-time thi=
ng, then
> >> > >> > you could easily perform the register write from the syscon dri=
ver
> >> > >> > where
> >> > >> > the memory is already parsed from device tree and mapped. That =
way you
> >> > >> > don't have to hardcode the physical address in some other rando=
m piece
> >> > >> > of code and map the memory again.
> >> > >>
> >> > >> Well, except that we're using the general "syscon" driver.  I cou=
ld
> >> > >> create a whole new driver that "subclasses" this syscon driver I
> >> > >> suppose.
> >> > >
> >> > > Ah, I wasn't aware that there was even something like a generic sy=
scon
> >> > > driver. But yes, subclassing it sounds like a reasonable thing to =
do.
> >> >
> >> > I will do that if need be, but it's not my favorite.  I will let
> >> > others chime in.
> >>
> >> I guess personally I like the idea best of just setting the relevant b=
it in
> >> _probe of the pwm driver, like the i2c driver does:
> >>
> >> if (of_device_is_compatible(np, "rockchip,rk3288-pwm") {
> >>       /* get regmap and set bit */
> >> }
> >>
> >> The downside would be that the bit would be written 4 times, but I gue=
ss this
> >> shouldn't matter to much. And I don't think anybody will get the idea =
of
> >> combining both ip variants in one dts anyway.
> >> And of course in the next SoC the old IP will mostly have gone away an=
d keep
> >> this somewhat close to the driver and not scatter pwm settings into ot=
her
> >> kernel parts.
> >>
> >> Hacking up the syscon driver feels bad to me, especially as it is mean=
t to be
> >> generic and export such shared registers to other drivers for just the=
se stuff.
> >
> > I think using syscon in the first place is bad. In my opinion it would
> > be far better to export an explicit API from drivers that are currently
> > "implemented" as syscon. The thing is, nothing about syscon is truly
> > generic. All it provides is a memory-mapped I/O region and lets drivers
> > do to that memory region whatever they wants. But ioremap() can be used
> > for that purpose already. Yet we have infrastructure to prevent drivers
> > from doing that (request_resource() and friends) because it's usually a
> > bad idea. All syscon really gives us is a ratified way of doing things
> > that are otherwise frowned upon.
>=20
> Agreed that it's a bit awkward, but it's the generally accepted way of
> doing things across multiple drivers as far as I can tell...

But that's exactly what I've been saying. I consider it a very bad thing
that this is a generally accepted way. Sure, it's a very easy solution,
but it also means that all the details about how the syscon registers
need to be programmed are moved into drivers. That makes them inherently
non-portable. Consider for example if you have a driver for an IP block
that's used in one device and needs some registers set in a "syscon"
device to work on that device. Now somebody licenses the same IP block
and instantiates it in a completely different design. Now with some luck
it won't need a syscon's help in the second design, so you can make the
syscon optional and ignore it. But what if you need to program some
syscon in the second design as well but it has a different register
layout?

Admittedly this will also be a problem if you have an explicit API, but
then it's still better to create the proper abstraction that can be made
to work on both SoCs, or as in the case of this PWM block you move the
code that needs to be executed only once into the syscon driver where it
belongs. That way the driver becomes completely generic, no need to play
tricks because you (or somebody else for that matter) chose the easy way
out.

> In exynos we were also doing this.  Another alternative (which I saw
> used before syscon) was just to list a second address in the "reg =3D
> <>".  The second address might only be 4 bytes big if only a single
> 32-bit register was needed.  That started failing because sometimes
> two drivers needed to access the same 32-bit register.

That's /exactly/ what syscon does as well (albeit with a bunch of
overhead).

> At the moment I'm not planning to spin this patch.  If folks come up
> with a solution that they definitely like better I'm happy to spin it,
> but for now this seems to work and doesn't seem (to me) to be terribly
> worse than the alternatives proposed so far.

I still think having a separate syscon driver that does this one-time
initialization is the proper thing to do.

Thierry

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9iKJAAoJEN0jrNd/PrOhOl0P/Ry8Xv1d1dOscXkLsT8/p8fL
LRYKdo8OrI7sRI9PyUD5LhGG687eLRiGeBrBFNFsWXfXrlgnJm5sCwiCvsmIwSSu
6B4j1CCDionZsOz60I33SPooi9KGzGD2arNhYBEf+U6uUItCgE3SToA12AdvcK7P
CpkrJumgjg8Iy89Dz+9FbXt/rYtWdM900YkxSDwOFELrBjoJqVgnu35chFtNT9/m
OOZdNVZ89dfECaI8PlcgqVo1ddeS9uIUGLNbtDGuBa1bzBxDN2wQ8bee6nckBhCY
CTHd2iOE6/Vi0EQUsGuRovBdiGDuP5IRRFDMxrsnoWgh8wvJ9ownay3jHROemp59
xvIHEeC4TKLjpKJ2Rmz7mZbfkwzJqqSUQVE0FhajAoO4N3fLjvi27AFcS3AVj8nk
PU85EfeTne/y+btBjHN26AhY5InalUcN+ecg2U+m5/CB86Azgo3oO8T1TgaCHHqE
Frof/QcqtsdDPM4xeBtKK9L0RSg5BWvi+0MSPzFJm5RuNt5jTsmCtaAcG93BL5Vx
1luw8HYWDahkpJLqgGkRf3K9BuHd3MZ5Vy+RNJs78kvzdr8osRUuOCTtuGt7Pz7r
GL/ymOJs4hM9zEtqr/h2qY6DcL8WWKmXAhXswN9LzfLYw3/DNfbRsWGtgOB1/txF
X6MCPsmdJM/E5Z1Dq5zg
=VEjz
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
