Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaI2KkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:40:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40540 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaI2KkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:40:07 -0400
Date: Mon, 29 Sep 2014 12:40:02 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Michal Suchanek <hramrach@gmail.com>
Cc: linux-sunxi <linux-sunxi@googlegroups.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>,
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
Message-ID: <20140929103959.GC26008@ulmo>
References: <53FF1D6C.6090205@redhat.com>
 <20140829070116.GC13106@ulmo>
 <20140829141244.GH15297@lukather>
 <20140829143812.GC31264@ulmo>
 <20140902092508.GR15297@lukather>
 <20140927235601.19023.31593@quantum>
 <20140929080637.GB12506@ulmo>
 <CAMuHMdV8job81-sf88Dx6w=0GZsWD02h94picAtYw2BtSz=Kgw@mail.gmail.com>
 <20140929085421.GH12506@ulmo>
 <CAOMqctThLAX7UfO+ogeKkgBwsvBywUi598DcbnpgTkkcww1CZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Content-Disposition: inline
In-Reply-To: <CAOMqctThLAX7UfO+ogeKkgBwsvBywUi598DcbnpgTkkcww1CZA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 11:44:19AM +0200, Michal Suchanek wrote:
> On 29 September 2014 10:54, Thierry Reding <thierry.reding@gmail.com> wro=
te:
> > On Mon, Sep 29, 2014 at 10:27:41AM +0200, Geert Uytterhoeven wrote:
> >> Hi Thierry,
> >>
> >> (CC linux-pm, as PM is the real reason behind disabling unused clocks)
> >> (CC gregkh and lkml, for driver core)
> >>
> >> On Mon, Sep 29, 2014 at 10:06 AM, Thierry Reding
> >> <thierry.reding@gmail.com> wrote:
> >> > On Sat, Sep 27, 2014 at 04:56:01PM -0700, Mike Turquette wrote:
> >> >> Quoting Maxime Ripard (2014-09-02 02:25:08)
> >> >> > On Fri, Aug 29, 2014 at 04:38:14PM +0200, Thierry Reding wrote:
> >> >> > > On Fri, Aug 29, 2014 at 04:12:44PM +0200, Maxime Ripard wrote:
> >> >> > > > On Fri, Aug 29, 2014 at 09:01:17AM +0200, Thierry Reding wrot=
e:
> >> >> > > > > I would think the memory should still be reserved anyway to=
 make sure
> >> >> > > > > nothing else is writing over it. And it's in the device tre=
e anyway
> >> >> > > > > because the driver needs to know where to put framebuffer c=
ontent. So
> >> >> > > > > the point I was trying to make is that we can't treat the m=
emory in the
> >> >> > > > > same way as clocks because it needs to be explicitly manage=
d. Whereas
> >> >> > > > > clocks don't. The driver is simply too generic to know what=
 to do with
> >> >> > > > > the clocks.
> >> >> > > >
> >> >> > > > You agreed on the fact that the only thing we need to do with=
 the
> >> >> > > > clocks is claim them. Really, I don't find what's complicated=
 there
> >> >> > > > (or not generic).
> >> >> > >
> >> >> > > That's not what I agreed on. What I said is that the only thing=
 we need
> >> >> > > to do with the clocks is nothing. They are already in the state=
 that
> >> >> > > they need to be.
> >> >> >
> >> >> > Claim was probably a poor choice of words, but still. We have to =
keep
> >> >> > the clock running, and both the solution you've been giving and t=
his
> >> >> > patch do so in a generic way.
> >> >> >
> >> >> > > > > It doesn't know what frequency they should be running at
> >> >> > > >
> >> >> > > > We don't care about that. Just like we don't care about which
> >> >> > > > frequency is the memory bus running at. It will just run at w=
hatever
> >> >> > > > frequency is appropriate.
> >> >> > >
> >> >> > > Exactly. And you shouldn't have to care about them at all. Firm=
ware has
> >> >> > > already configured the clocks to run at the correct frequencies=
, and it
> >> >> > > has made sure that they are enabled.
> >> >> > >
> >> >> > > > > or what they're used for
> >> >> > > >
> >> >> > > > And we don't care about that either. You're not interested in=
 what
> >> >> > > > output the framebuffer is setup to use, which is pretty much =
the same
> >> >> > > > here, this is the same thing here.
> >> >> > >
> >> >> > > That's precisely what I've been saying. The only thing that sim=
plefb
> >> >> > > cares about is the memory it should be using and the format of =
the
> >> >> > > pixels (and how many of them) it writes into that memory. Every=
thing
> >> >> > > else is assumed to have been set up.
> >> >> > >
> >> >> > > Including clocks.
> >> >> >
> >> >> > We're really discussing in circles here.
> >> >> >
> >> >> > Mike?
> >> >> >
> >> >>
> >> >> -EHIGHLATENCYRESPONSE
> >> >>
> >> >> I forgot about this thread. Sorry.
> >> >>
> >> >> In an attempt to provide the least helpful answer possible, I will =
stay
> >> >> clear of all of the stuff relating to "how simple should simplefb b=
e"
> >> >> and the related reserved memory discussion.
> >> >>
> >> >> A few times in this thread it is stated that we can't prevent unused
> >> >> clocks from being disabled. That is only partially true.
> >> >>
> >> >> The clock framework DOES provide a flag to prevent UNUSED clocks fr=
om
> >> >> being disabled at late_initcall-time by a clock "garbage collector"
> >> >> mechanism. Maxime and others familiar with the clock framework are =
aware
> >> >> of this.
> >> >>
> >> >> What the framework doesn't do is to allow for a magic flag in DT, in
> >> >> platform_data or elsewhere that says, "don't let me get turned off =
until
> >> >> the right driver claims me". That would be an external or alternati=
ve
> >> >> method for preventing a clock from being disabled. We have a method=
 for
> >> >> preventing clocks from being disabled. It is as follows:
> >> >>
> >> >> struct clk *my_clk =3D clk_get(...);
> >> >> clk_prepare_enable(my_clk);
> >> >>
> >> >> That is how it should be done. Period.
> >> >>
> >> >> With that said I think that Luc's approach is very sensible. I'm not
> >> >> sure what purpose in the universe DT is supposed to serve if not for
> >> >> _this_exact_case_. We have a nice abstracted driver, usable by many
> >> >> people. The hardware details of how it is hooked up at the board le=
vel
> >> >> can all be hidden behind stable DT bindings that everyone already u=
ses.
> >> >
> >> > simplefb doesn't deal at all with hardware details. It simply uses w=
hat
> >> > firmware has set up, which is the only reason why it will work for m=
any
> >>
> >> It doesn't deal with "hardware details for hardware components for whi=
ch
> >> no driver is available (yet)". That's why the hardware is still in a u=
sable
> >> state, after the firmware has set it up.
> >>
> >> Clocks, regulators, PM domains typically have system-wide implications,
> >> and thus need system-wide drivers (in the absence of such drivers,
> >> things would work as-is).
> >>
> >> Note that the driver still requests resources (ioremap the frame buffe=
r),
> >> so it needs to know about that tiny piece of hardware detail.
> >
> > That's not a hardware detail. Or at least it isn't hardware specific. It
> > is needed and the same irrespective of display hardware. Clocks, power
> > domains, regulators and all those are not always the same.
>=20
> The framebuffer address, format, etc. is as hardware specific as the
> clocks needed to run the crtc, regulators to power the backlight, etc.

Framebuffer address and format are not hardware specific. Every display
driver requires them.

> You see this from the point of view of a platform that has not clock
> driver.

Wrong. What platform's point of view do you think I look at this from?

> Then the platform has no clock information whatsoever, for any
> driver. That's platform specific too.
>=20
> Why do we have to go back to this *again*?

What exactly are we going back to again?

> >> > There may be also resets involved. Fortunately the reset framework is
> >> > minimalistic enough not to care about asserting all unused resets at
> >> > late_initcall. And other things like power domains may also need to =
be
> >> > kept on.
> >>
> >> Fortunately, unlike clocks, PM domains are first class citizens in the
> >> device framework, as they're handled by the driver core.
> >> So just adding a power-domains property to DTS will work, without any
> >> driver change.
> >
> > Well, the device driver would also need to call into the PM runtime
> > framework to enable all the first class citizen magic. But even if it
> > were to do that, you'd still need to add all the domains to the DTB.
> >
> > Note that I'm saying DT*B* here, because the firmware needs to fill in
> > those properties after the DTS has been compiled. And since most of
> > these resources are linked via phandle you actually need to resolve
> > these first before you can fill in the new properties of this
> > dynamically created node.
> >
> > So firmware needs to know exactly what device tree node to look for,
> > find a corresponding phandle and then put the phandle value in the
> > simplefb device tree node. And it needs to know intimate details about
> > the clock provider binding because it needs to add an appropriate
> > specifier, too.
> >
> > And then all of a sudden something that was supposed to be simple and
> > generic needs to know the specifics of some hardware device.
>=20
> Note however that all the specific is in the firmware driver. The
> linux simplefb driver only needs to read DT entries which is generic
> hardware-neutral thing.

No. The DT entries are very hardware-specific. That's precisely the
reason why I think it's wrong to put this into the simplefb node,
because simplefb is an abstraction of the real hardware underneath.

> >> > Passing in clock information via the device tree already requires a =
non-
> >> > trivial amount of code in the firmware. A similar amount of code wou=
ld
> >> > be necessary for each type of resource that needs to be kept enabled=
=2E In
> >> > addition to the above some devices may also require resources that h=
ave
> >> > no generic bindings. That just doesn't scale.
> >>
> >> [*] The firmware does need to make sure the clocks, regulators, PM dom=
ains,
> >> ... are up and running for the initial video mode, too. So it already =
needs
> >> to have this knowledge (unless enabled by SoC reset-state).
> >
> > Certainly. But not all firmware will use a DTB (or in fact the same DTB
> > as the kernel) to derive this information from, so it still needs to
> > inspect the DTB that will be passed to the kernel and painfully extract
> > information from various nodes and put it into a new node.
> >
> > But that's not even the issue. You say yourself that the firmware set
> > everything up itself already. My point is: why should the kernel have to
> > do everything again, only to come to the conclusion that it doesn't have
> > to touch hardware at all because it's already in the state that it
> > should be?
>=20
> It will do nothing. It will just read from DTB what firmware has set
> up and inform all the relevant generic frameworks that these resources
> are in use. The device-specific driver (if any) will then keep the
> resource in question enabled. So all that is this patch doing is to
> correct the kernel's resource bookkeeping.

It's the device-specific driver that should be doing the book-keeping.
simplefb is only a stop-gap until a proper driver has been loaded. It
should never be considered a fully-functional driver, because it does
not know anything about the display hardware.

> > In fact, Linux will at some point set things up from scratch anyway with
> > a fully-fledged driver. But doing it in simplefb too would be doubly
> > wasteful.
>=20
> It may or may not. And by having the bookkeeping straight we give that
> choice to the user.

What I'm proposing isn't really all that different. All it does is
prevent resources from being considered unused by default if a driver
that we know relies on an unspecified set of resources is active.

> > No. The way this works is that your firmware shim driver, simplefb in
> > this case, will call clk_ignore_unused() to tell the clock framework
> > that it uses clocks set up by the firmware, and therefore requests that
> > no clocks should be considered unused (for now). Later on when the
> > proper driver has successfully taken over from the shim driver, the shim
> > driver can unregister itself and call clk_unignore_unused(), which will
> > drop its "reference" on the unused clocks. When all references have been
> > dropped the clock framework will then disable all remaining unused
> > clocks.
>=20
> > In practice this will mean that all unused clocks will remain in their
> > current state until the shim driver relinquishes control to the proper
> > OS driver. And if that never happens then we're at least still left with
> > a working framebuffer.
>=20
> This does not work. Firstly if you do not have a full driver (because
> there is none or because kernel did not find the module, ...) then you
> could run with the shim driver and have all clocks managed properly.
> This is not possible with clk_ignore_unused.

Huh? Why not?

> Secondly clk_ignore_unused does not really mark clock as used.

Right. If that were the case it'd be called clk_use_unused() or similar.

>                                                                It only
> skips disabling them at certain point at kernel startup so that kernel
> survives that point and clock problems can be debugged. It is not
> meant as an option to be used for running the kernel indefinitely. It
> is indeed flawed: if at later point enabling or disabling a clock
> results in a parent clock becoming unused it is still disabled. This
> can affect many clocks if enabling a clock results in clock
> reparenting.
>=20
> Sure, clk_ignore_unused could be fixed to actually mark all clocks
> enabled at boot time as used so that they are never disabled but
> that's orthogonal to fixing simplefb so that when it is in use the
> clock framework can work normally and can be tested, debugged, and
> used for saving power by disabling unused clocks.

Look, nobody's claiming that using the clk_ignore_unused command-line
argument is a good long-term solution. And it doesn't have to. Once you
have a proper display driver for your platform the problem goes away
entirely.

That is unless you also want to use simplefb for early boot and seamless
transition between firmware and kernel, in which case we'll return to
this discussion.

> So please stop repeating that managing system resources is
> system-specific and not fit for simplefb driver. It's been said enough
> times, and enough times pointed out that simplefb driver must as any
> other driver manage its resources (or more specifically tell the
> kernel to manage them) to work properly.

simplefb isn't anything like any other driver. If you want a proper
driver, go write a DRM/KMS driver and we can all stop having this
discussion. That's the right thing to do.

Thierry

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUKTb/AAoJEN0jrNd/PrOhrCAQAIdcZu6ci3PpdcAFSNEwM103
K3bGisYesIzbeRrAGC3KKzz0Ux8G2Hzocya/gA4qieuwdgg9k/31mOmSuDTtVOXN
UBi0B9TnWTosDSsG9TvZ/VOno70n9FyRDJwRyo6NSQ/8/VyKMMhSmUKvXPjWpkS8
QL4GBD3umvv47aw0tHgp8pPtTNHGVJS3R+GQzl1E2SoNySorVLqh7pYBMkbIkBNA
tcFnokSndrUvyiyt07Nt/SPav6Y1JPrVptJSDTkyqkKYqPwa/nOPP7bzwc9tNu6f
8XzqQt+ySLlkn2/sBF4FjBsWBoOAq7ypcmXXJWQLI2urMT5tbfsz+5uohM1zTytG
O8ZUnOKGOeh/s/vMAlItkYIMZwB5Hrd+z9PahqCC4XuSxuDvW5QVuXov2xdFWcl6
ZKlhIociPApVL+UW2H9w7W9Sxs63+3b2A3xgpCza58MYWGRE+F3WEJxiBU/o9KZj
IABCH/IqQPG0fweHL2Mv4gny31VtDigIqPYbVOcZ2JB1ZcwNB22DGusRZH2N0zj7
UrY7YZTG1CnPKXgE6G15Z5dPG4nKicJSMOHvR9aetZdjUnphJu2cLuq+GtxogYpj
GvxOS3FTI/t6ky8FUA1aCI2A9cXNdUEzCLLPiK/ZoQt495DH8VKXI4HmmCr4UO0i
O1I4iKEWZR4+9lfhk9DY
=5ceU
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
