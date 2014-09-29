Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaI2Iy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:54:29 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:33958 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaI2Iy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:54:26 -0400
Date: Mon, 29 Sep 2014 10:54:22 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Luc Verhaegen <libv@skynet.be>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-sunxi] Re: [PATCH 4/4] simplefb: add clock handling code
Message-ID: <20140929085421.GH12506@ulmo>
References: <53FDE0CE.5030807@redhat.com>
 <20140827141632.GB32243@ulmo>
 <53FF1D6C.6090205@redhat.com>
 <20140829070116.GC13106@ulmo>
 <20140829141244.GH15297@lukather>
 <20140829143812.GC31264@ulmo>
 <20140902092508.GR15297@lukather>
 <20140927235601.19023.31593@quantum>
 <20140929080637.GB12506@ulmo>
 <CAMuHMdV8job81-sf88Dx6w=0GZsWD02h94picAtYw2BtSz=Kgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JIpyCmsTxyPLrmrM"
Content-Disposition: inline
In-Reply-To: <CAMuHMdV8job81-sf88Dx6w=0GZsWD02h94picAtYw2BtSz=Kgw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JIpyCmsTxyPLrmrM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 10:27:41AM +0200, Geert Uytterhoeven wrote:
> Hi Thierry,
>=20
> (CC linux-pm, as PM is the real reason behind disabling unused clocks)
> (CC gregkh and lkml, for driver core)
>=20
> On Mon, Sep 29, 2014 at 10:06 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Sat, Sep 27, 2014 at 04:56:01PM -0700, Mike Turquette wrote:
> >> Quoting Maxime Ripard (2014-09-02 02:25:08)
> >> > On Fri, Aug 29, 2014 at 04:38:14PM +0200, Thierry Reding wrote:
> >> > > On Fri, Aug 29, 2014 at 04:12:44PM +0200, Maxime Ripard wrote:
> >> > > > On Fri, Aug 29, 2014 at 09:01:17AM +0200, Thierry Reding wrote:
> >> > > > > I would think the memory should still be reserved anyway to ma=
ke sure
> >> > > > > nothing else is writing over it. And it's in the device tree a=
nyway
> >> > > > > because the driver needs to know where to put framebuffer cont=
ent. So
> >> > > > > the point I was trying to make is that we can't treat the memo=
ry in the
> >> > > > > same way as clocks because it needs to be explicitly managed. =
Whereas
> >> > > > > clocks don't. The driver is simply too generic to know what to=
 do with
> >> > > > > the clocks.
> >> > > >
> >> > > > You agreed on the fact that the only thing we need to do with the
> >> > > > clocks is claim them. Really, I don't find what's complicated th=
ere
> >> > > > (or not generic).
> >> > >
> >> > > That's not what I agreed on. What I said is that the only thing we=
 need
> >> > > to do with the clocks is nothing. They are already in the state th=
at
> >> > > they need to be.
> >> >
> >> > Claim was probably a poor choice of words, but still. We have to keep
> >> > the clock running, and both the solution you've been giving and this
> >> > patch do so in a generic way.
> >> >
> >> > > > > It doesn't know what frequency they should be running at
> >> > > >
> >> > > > We don't care about that. Just like we don't care about which
> >> > > > frequency is the memory bus running at. It will just run at what=
ever
> >> > > > frequency is appropriate.
> >> > >
> >> > > Exactly. And you shouldn't have to care about them at all. Firmwar=
e has
> >> > > already configured the clocks to run at the correct frequencies, a=
nd it
> >> > > has made sure that they are enabled.
> >> > >
> >> > > > > or what they're used for
> >> > > >
> >> > > > And we don't care about that either. You're not interested in wh=
at
> >> > > > output the framebuffer is setup to use, which is pretty much the=
 same
> >> > > > here, this is the same thing here.
> >> > >
> >> > > That's precisely what I've been saying. The only thing that simple=
fb
> >> > > cares about is the memory it should be using and the format of the
> >> > > pixels (and how many of them) it writes into that memory. Everythi=
ng
> >> > > else is assumed to have been set up.
> >> > >
> >> > > Including clocks.
> >> >
> >> > We're really discussing in circles here.
> >> >
> >> > Mike?
> >> >
> >>
> >> -EHIGHLATENCYRESPONSE
> >>
> >> I forgot about this thread. Sorry.
> >>
> >> In an attempt to provide the least helpful answer possible, I will stay
> >> clear of all of the stuff relating to "how simple should simplefb be"
> >> and the related reserved memory discussion.
> >>
> >> A few times in this thread it is stated that we can't prevent unused
> >> clocks from being disabled. That is only partially true.
> >>
> >> The clock framework DOES provide a flag to prevent UNUSED clocks from
> >> being disabled at late_initcall-time by a clock "garbage collector"
> >> mechanism. Maxime and others familiar with the clock framework are awa=
re
> >> of this.
> >>
> >> What the framework doesn't do is to allow for a magic flag in DT, in
> >> platform_data or elsewhere that says, "don't let me get turned off unt=
il
> >> the right driver claims me". That would be an external or alternative
> >> method for preventing a clock from being disabled. We have a method for
> >> preventing clocks from being disabled. It is as follows:
> >>
> >> struct clk *my_clk =3D clk_get(...);
> >> clk_prepare_enable(my_clk);
> >>
> >> That is how it should be done. Period.
> >>
> >> With that said I think that Luc's approach is very sensible. I'm not
> >> sure what purpose in the universe DT is supposed to serve if not for
> >> _this_exact_case_. We have a nice abstracted driver, usable by many
> >> people. The hardware details of how it is hooked up at the board level
> >> can all be hidden behind stable DT bindings that everyone already uses.
> >
> > simplefb doesn't deal at all with hardware details. It simply uses what
> > firmware has set up, which is the only reason why it will work for many
>=20
> It doesn't deal with "hardware details for hardware components for which
> no driver is available (yet)". That's why the hardware is still in a usab=
le
> state, after the firmware has set it up.
>=20
> Clocks, regulators, PM domains typically have system-wide implications,
> and thus need system-wide drivers (in the absence of such drivers,
> things would work as-is).
>=20
> Note that the driver still requests resources (ioremap the frame buffer),
> so it needs to know about that tiny piece of hardware detail.

That's not a hardware detail. Or at least it isn't hardware specific. It
is needed and the same irrespective of display hardware. Clocks, power
domains, regulators and all those are not always the same.

> > people. What is passed in via its device tree node is the minimum amount
> > of information needed to draw something into the framebuffer. Also note
> > that the simplefb device tree node is not statically added to a DTS file
> > but needs to be dynamically generated by firmware at runtime.
>=20
> The latter indeed complicates things. But see below... [*]
>=20
> > If we start extending the binding with board-level details we end up
> > duplicating the device tree node for the proper video device. Also note
> > that it won't stop at clocks. Other setups will require regulators to be
> > listed in this device tree node as well so that they don't get disabled
> > at late_initcall. And the regulator bindings don't provide a method to
> > list an arbitrary number of clocks in a single property in the way that
> > the clocks property works.
>=20
> Then (optional) regulator support needs to be added.

Can you elaborate?

> > There may be also resets involved. Fortunately the reset framework is
> > minimalistic enough not to care about asserting all unused resets at
> > late_initcall. And other things like power domains may also need to be
> > kept on.
>=20
> Fortunately, unlike clocks, PM domains are first class citizens in the
> device framework, as they're handled by the driver core.
> So just adding a power-domains property to DTS will work, without any
> driver change.

Well, the device driver would also need to call into the PM runtime
framework to enable all the first class citizen magic. But even if it
were to do that, you'd still need to add all the domains to the DTB.

Note that I'm saying DT*B* here, because the firmware needs to fill in
those properties after the DTS has been compiled. And since most of
these resources are linked via phandle you actually need to resolve
these first before you can fill in the new properties of this
dynamically created node.

So firmware needs to know exactly what device tree node to look for,
find a corresponding phandle and then put the phandle value in the
simplefb device tree node. And it needs to know intimate details about
the clock provider binding because it needs to add an appropriate
specifier, too.

And then all of a sudden something that was supposed to be simple and
generic needs to know the specifics of some hardware device.

> > Passing in clock information via the device tree already requires a non-
> > trivial amount of code in the firmware. A similar amount of code would
> > be necessary for each type of resource that needs to be kept enabled. In
> > addition to the above some devices may also require resources that have
> > no generic bindings. That just doesn't scale.
>=20
> [*] The firmware does need to make sure the clocks, regulators, PM domain=
s,
> ... are up and running for the initial video mode, too. So it already nee=
ds
> to have this knowledge (unless enabled by SoC reset-state).

Certainly. But not all firmware will use a DTB (or in fact the same DTB
as the kernel) to derive this information from, so it still needs to
inspect the DTB that will be passed to the kernel and painfully extract
information from various nodes and put it into a new node.

But that's not even the issue. You say yourself that the firmware set
everything up itself already. My point is: why should the kernel have to
do everything again, only to come to the conclusion that it doesn't have
to touch hardware at all because it's already in the state that it
should be?

In fact, Linux will at some point set things up from scratch anyway with
a fully-fledged driver. But doing it in simplefb too would be doubly
wasteful.

> > The only reasonable thing for simplefb to do is not deal with any kind
> > of resource at all (except perhaps area that contains the framebuffer
> > memory).
> >
> > So how about instead of requiring resources to be explicitly claimed we
> > introduce something like the below patch? The intention being to give
> > "firmware device" drivers a way of signalling to the clock framework
> > that they need rely on clocks set up by firmware and when they no longer
> > need them. This implements essentially what Mark (CC'ing again on this
> > subthread) suggested earlier in this thread. Basically, it will allow
> > drivers to determine the time when unused clocks are really unused. It
> > will of course only work when used correctly by drivers. For the case of
> > simplefb I'd expect its .probe() implementation to call the new
> > clk_ignore_unused() function and once it has handed over control of the
> > display hardware to the real driver it can call clk_unignore_unused() to
> > signal that all unused clocks that it cares about have now been claimed.
> > This is "reference counted" and can therefore be used by more than a
> > single driver if necessary. Similar functionality could be added for
> > other resource subsystems as needed.
>=20
> This still won't work for modules, right? Or am I missing something?
> With modules you will never know in advance what will be used and what
> won't be used, so you need to keep all clocks, regulators, PM domains, ...
> up and running?

No. The way this works is that your firmware shim driver, simplefb in
this case, will call clk_ignore_unused() to tell the clock framework
that it uses clocks set up by the firmware, and therefore requests that
no clocks should be considered unused (for now). Later on when the
proper driver has successfully taken over from the shim driver, the shim
driver can unregister itself and call clk_unignore_unused(), which will
drop its "reference" on the unused clocks. When all references have been
dropped the clock framework will then disable all remaining unused
clocks.

In practice this will mean that all unused clocks will remain in their
current state until the shim driver relinquishes control to the proper
OS driver. And if that never happens then we're at least still left with
a working framebuffer.

Thierry

--JIpyCmsTxyPLrmrM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUKR49AAoJEN0jrNd/PrOhZIkP/RqC2TWlEf0bNlDOIM9fjEmv
+8+fp+rcwqRMIDlpT7zHRSt5mRY9TYmjlKSuHrOAaNbzkWU8gFllOMNe6PrhPtCd
23RxAkM950+6kZgS4OHqHbYcPvP5PesCCorKBE+WY2hAMSjHOMhE06M0efy33QcZ
DoDEnN25DxZ2SzAejmW/ijvzinOqWTpzm6tx6JJtUWre0JnLex0cdCNlY4POI2DE
YN29FSpo7qDn62hRdB7h5ooGIPspuq72RaoXTmlUY77DgqZ2wHqqOmHE6U9YKC2c
0wk9zHsGGLmrTfHRYNnrhPsebX1uqdz1jwm7bIE4pYQbo2ECWtvDNiHbdOSTHKmL
6zHgParlHBYLK+x15o4e4FiG/35pvQjZMIQuVqCqoVtuOTb41CE9CKj77mnMv+wu
PP9iPWxL/Vu/M35k0NX5OfCOLeRFeUz7XDSsjUSpc4uoOdK8fmOh2M7w3rVmJ0Iw
o2rqv3FwePp/s+aPpFVo7hoq+cVYDyVVmOMUlYQVsisivjBG/hAX+4C1EdQcjRh8
U4BLoc7MnQm+9lI7N6aVLlYDoxaCMp2NoJckLyPUuuEhyw4frZx44lP7u+KVdMM8
eVBDuedcDS97ksfnFBh9Ds9JjN9s8MrLikBxmPip0h76JXPtFDcDyrq2vsZQmoMV
90rC9HtGTOv2VAtH0YAo
=+sX3
-----END PGP SIGNATURE-----

--JIpyCmsTxyPLrmrM--
