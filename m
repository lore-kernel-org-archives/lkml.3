Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbbAGPM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:12:26 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61818 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbbAGPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:12:23 -0500
Date: Wed, 7 Jan 2015 16:12:07 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        swarren@wwwdotorg.org, gnurou@gmail.com, bskeggs@redhat.com,
        martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150107151206.GG1621@ulmo>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
 <1419426990.2179.7.camel@lynxeye.de>
 <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com>
 <54AD0F37.5080609@nvidia.com>
 <20150107141254.GS10073@tbergstrom-lnx.Nvidia.com>
 <20150107141938.GA7392@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Zw+/jwnNHcBRYYu"
Content-Disposition: inline
In-Reply-To: <20150107141938.GA7392@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Zw+/jwnNHcBRYYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 10:19:52PM +0800, Vince Hsu wrote:
> On 04:12:54PM Jan 07, Peter De Schrijver wrote:
> > On Wed, Jan 07, 2015 at 06:49:27PM +0800, Vince Hsu wrote:
> > >=20
> > > On 01/07/2015 06:19 PM, Peter De Schrijver wrote:
> > > >On Mon, Jan 05, 2015 at 04:09:33PM +0100, Thierry Reding wrote:
> > > >>* PGP Signed by an unknown key
> > > >>
> > > >>On Thu, Dec 25, 2014 at 10:28:08AM +0800, Vince Hsu wrote:
> > > >>>On 12/24/2014 09:16 PM, Lucas Stach wrote:
> > > >>>>Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
> > > >>>>>The Tegra124 and later Tegra SoCs have a sepatate rail gating re=
gister
> > > >>>>>to enable/disable the clamp. The original function
> > > >>>>>tegra_powergate_remove_clamping() is not sufficient for the enab=
le
> > > >>>>>function. So add a new function which is dedicated to the GPU ra=
il
> > > >>>>>gating. Also don't refer to the powergate ID since the GPU ID ma=
kes no
> > > >>>>>sense here.
> > > >>>>>
> > > >>>>>Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> > > >>>>To be honest I don't see the point of this patch.
> > > >>>>You are bloating the PMC interface by introducing another exported
> > > >>>>function that does nothing different than what the current functi=
on
> > > >>>>already does.
> > > >>>>
> > > >>>>If you need a way to assert the clamp I would have expected you to
> > > >>>>introduce a common function to do this for all power partitions.
> > > >>>I thought about adding an tegra_powergate_assert_clamping(), but t=
hat
> > > >>>doesn't make sense to all the power partitions except GPU. Note the
> > > >>>difference in TRM. Any suggestion for the common function?
> > > >>I don't think extending the powergate API is useful at this point. =
We've
> > > >>long had an open TODO item to replace this with a generic API. I did
> > > >>some prototyping a while ago to use generic power domains for this,=
 that
> > > >>way all the details and dependencies between the partitions could be
> > > >>properly modeled.
> > > >>
> > > >>Can you take a look at my staging/powergate branch here:
> > > >>
> > > >>	https://github.com/thierryreding/linux/commits/staging/powergate
> > > >>
> > > >>and see if you can use that instead? The idea is to completely hide=
 the
> > > >>details of power partitions from drivers and use runtime PM instead.
> > > >>
> > > >>Also adding Peter whom I had discussed this with earlier. Can we fi=
nally
> > > >>get this converted? I'd rather not keep complicating this custom AP=
I to
> > > >>avoid making the conversion even more difficult.
> > > >Conceptually I fully agree that we should use runtime PM and powerdo=
mains.
> > > >However I don't think the implementation you mentioned is correct. T=
he resets
> > > >of all modules in a domain need to be asserted and the memory client=
s need to
> > > >be flushed. All this needs to be done with module clocks enabled (re=
sets are
> > > >synchronous).  Then all module clocks need to be disabled and then t=
he
> > > >partition can be powergated. After ungating, the module resets need =
to be
> > > >deasserted and the FLUSH bit cleared with clocks enabled.
> > > Yeah. I plan to have the information of all the clock client of the
> > > partitions and
> > > the memory clients be defined statically in c source, e.g. pmc-tegra1=
24.c.
> > > All modules can declare which domain they belong to in DT. One domain=
 can
> > > be really power gated only when no module is awake. Note the clock
> > > clients of
> > > one domain might not equal to the clocks of the module. The reset is
> > > not either.
> > > So I don't get the clock and reset from module. How do you think?
> > >=20
> >=20
> > I think it's indeed better to have a direct reference to the required c=
locks
> > to powergate/ungate a domain. As you said, there is no easy way to deri=
ve the
> > required clocks from the DT module declarations. My suggestion would be=
 to
> > have powerdomain definitions in DT and for each domain have references =
to
> > the required clocks and resets.
> >=20
> And specify the dependencies between domains in DT?

I think the dependencies could be in the driver. Of course the power
domains are per-SoC data, so really shouldn't be in the DTS either (the
data is all implied by the compatible value) but there's no good way to
get at the clocks and resets without DT, so I think that's a reasonable
trade-off.

It seems to me like there are only two dependencies:

	DIS and DISB depend on SOR
	VE depends on DIS

That's according to 5.6.6 "Programming Guide for Power Gating and
Ungating" of the Tegra K1 TRM. It also seems like a bunch of modules are
part of seemingly unrelated domains. Especially SOR seems to cover a
large range of modules (MIPI-CAL, DPAUX, SOR, HDMI, DSI, DSIB and
HDA2HDMI).

Given that we may want to more fine-grainedly control clocks to save
power, don't we need to control clocks and resets within the drivers? I
think the runtime PM framework makes sure to call this in the right
order, so for suspend, the sequence would be:

	1) device->suspend
	2) domain->suspend

and for resume:

	1) domain->resume
	2) device->resume

But then we're back to square one, namely that the MC flush doesn't work
properly, since it needs to be implemented in domain->suspend. Does that
mean we can't clock-gate modules? In order to ensure a proper powergate
sequence, the domain code would need to clk_enable() the module clock to
make sure it stays on during the reset sequence. But if the domain code
has a reference to the clock, then the driver can't clock-gate the
module anymore by calling clk_disable().

Am I missing something?

Thierry

--/Zw+/jwnNHcBRYYu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrUzGAAoJEN0jrNd/PrOh7ZUP/RAlPbDsy6RCt2ZM8fk8KXDP
wG/PdpP1T1M3SY5YIYa5plX7EN48X2RXdfc8IbI785WxEVFWBgZZcxHqLJSyuGnG
ioGxE6xxRfZB9i6AEGdJar5NGvcvbBR6vnHzVXmwRGnrzKyXNKnkdQFGg94J3Ru9
/YNNhtXwwSp+qC5WJg0V6q1x2cldoEcp3ZkWS89/Nr/bT6bFS81UsfPAmhPpQDPV
7lvdN0TfASSkjLZlywVk5eMc/yW3E1/DrXTp7ExsB6nablUUIZihSJtfGXPD3Erz
eoFPgxA7cZMU1N+yLEbQ/aXgZyTYBKv0wEa5p8doFk1onItMqygVIHEJoisWVn9w
sJgEHHzAYaQ3Irvjx0JR9ZY8UrQ28ENEAfv+T8ljEmdUdSIW56j5ZrVYFlvWDimT
DD/m12kc/CZ1SsfEbinQpJgah+6w3TB/ahuyr9rswbibAvjUcuCO8rnK3IgOFhSJ
PKkEdVy0ac7GigVpqn/EnP/UUA1JtnsfBJlqZuPuNJx7fcqFymi+KO3CiZIFfmbU
3HqOgFL6+qK5Q3PoGienAabLJF+f04OJS3eu5urCKdSS/PK01aEMRoJz1w40xn7u
WK7HMxDgneGC2TeZu/n++BiktNRDKyuRkQQM1oWvQp4n6ot2ADZJQGXKa/fB+waj
hKaPFUaG6wQxG7AYyPLH
=cFgE
-----END PGP SIGNATURE-----

--/Zw+/jwnNHcBRYYu--
