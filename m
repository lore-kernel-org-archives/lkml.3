Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbaFRXVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:21:01 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42876 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053AbaFRXU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:20:59 -0400
Date: Thu, 19 Jun 2014 01:20:53 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: =?utf-8?B?U3TDqXBoYW5l?= Marchesin <stephane.marchesin@gmail.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, myungjoo.ham@samsung.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
Message-ID: <20140618232049.GH26514@mithrandir>
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
 <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com>
 <539F4D44.3070309@wwwdotorg.org>
 <53A03186.3040703@collabora.com>
 <53A069B6.6070902@wwwdotorg.org>
 <53A1CB23.5090307@collabora.com>
 <20140618220008.GC26514@mithrandir>
 <CACP_E+Jr5QyYm92Mc2=WVhKMbk=9Ty1fvJuH+fqOmDnYmdqFRg@mail.gmail.com>
 <53A213C3.2020207@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fd5uyaI9j6xoeUBo"
Content-Disposition: inline
In-Reply-To: <53A213C3.2020207@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fd5uyaI9j6xoeUBo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 04:33:39PM -0600, Stephen Warren wrote:
> On 06/18/2014 04:19 PM, St=C3=A9phane Marchesin wrote:
> > On Wed, Jun 18, 2014 at 3:00 PM, Thierry Reding
> > <thierry.reding@gmail.com> wrote:
> >> On Wed, Jun 18, 2014 at 07:23:47PM +0200, Tomeu Vizoso wrote:
> >>> On 06/17/2014 06:15 PM, Stephen Warren wrote:
> >>>> On 06/17/2014 06:16 AM, Tomeu Vizoso wrote:
> >>>>> On 06/16/2014 10:02 PM, Stephen Warren wrote:
> >>>>>> On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
> >>>>>>> +#ifdef CONFIG_TEGRA124_EMC
> >>>>>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsign=
ed
> >>>>>>> long rate);
> >>>>>>> +void tegra124_emc_set_floor(unsigned long freq);
> >>>>>>> +void tegra124_emc_set_ceiling(unsigned long freq);
> >>>>>>> +#else
> >>>>>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsign=
ed
> >>>>>>> long rate)
> >>>>>>> +{ return -ENODEV; }
> >>>>>>> +void tegra124_emc_set_floor(unsigned long freq)
> >>>>>>> +{ return; }
> >>>>>>> +void tegra124_emc_set_ceiling(unsigned long freq)
> >>>>>>> +{ return; }
> >>>>>>> +#endif
> >>>>>>
> >>>>>> I'll repeat what I said off-list so that we can have the whole
> >>>>>> conversation on the list:
> >>>>>>
> >>>>>> That looks like a custom Tegra-specific API. I think it'd be much =
better
> >>>>>> to integrate this into the common clock framework as a standard cl=
ock
> >>>>>> constraints API. There are other use-cases for clock constraints b=
esides
> >>>>>> EMC scaling (e.g. some in audio on Tegra, and I'm sure many on oth=
er
> >>>>>> SoCs too).
> >>>>>
> >>>>> Yes, I wrote a bit in the cover letter about our requirements and h=
ow
> >>>>> they map to the CCF. Could you please comment on that?
> >>>>
> >>>> My comments remain the same. I believe this is something that belong=
s in
> >>>> the clock driver, or at the least, some API that takes a struct cloc=
k as
> >>>> its parameter, so that drivers can use the existing DT clock lookup
> >>>> mechanism.
> >>>
> >>> Ok, let me put this strawman here to see if I have gotten close to wh=
at you
> >>> have in mind:
> >>>
> >>> * add per-client accounting (Rabin's patches referenced before)
> >>>
> >>> * add clk_set_floor, to be used by cpufreq, load stats, etc.
> >>>
> >>> * add clk_set_ceiling, to be used by battery drivers, thermal, etc.
> >>>
> >>> * an EMC driver would collect bandwidth and latency requests from con=
sumers
> >>> and call clk_set_floor on the EMC clock.
> >>>
> >>> * the EMC driver would also register for rate change notifications in=
 the
> >>> EMC clock and would update the latency allowance registers at that po=
int.
> >>
> >> Latency allowance registers are part of the MC rather than the EMC. So=
 I
> >> think we have two options: a) have a unified driver for MC and EMC or =
b)
> >> provide two parts of the API in two drivers.
> >>
> >> Or perhaps c), create a generic framework that both MC and EMC can
> >> register with (bandwidth for EMC, latency for MC).
> >=20
> > Is there any motivation for keeping MC and EMC separate? In my mind,
> > the solution was always to handle those together.
>=20
> Well, they are documented as being separate HW modules in the TRM.
>=20
> I know there's an interlock in HW so that when the EMC clock is changed,
> the EMC registers can flip atomically to a new configuration.
>=20
> I'm not aware of any similar HW interlock between MC and EMC registers.
> That would imply that very tight co-ordination shouldn't be required.
>=20
> Do the MC latency allowance registers /really/ need to be *very tightly*
> managed whenever the EMC clock is changed, or is it just a matter of it
> being a good idea to update EMC clock and MC latency allowance registers
> at roughly the same time?

I guess depending on the timing you could get FIFO underflows if the
registers aren't updated promptly enough. Once the programming takes
effect things should be able to catch up again, but it's possible that
there could be glitches.

> Even if there's some co-ordination required,
> maybe it can be handled rather like cpufreq notifications; use clock
> pre-rate change notifications to set MC up in a way that'll work at both
> old/new EMC clocks, and then clock post-rate notifications to the final
> MC configuration?

Yes, I think something like that should work. As I understand it, the
latency allowance is dependent on the EMC frequency, so in case where
the EMC frequency is increased, adjusting in a post-rate notifier should
be fine. When the EMC frequency is decreased, then programming the
latency allowance registers in a pre-rate notifier should allow glitch-
free transition.

Note that this is all purely theoretical knowledge, so I have no idea if
it'll actually work like that in practice.

Thierry

--fd5uyaI9j6xoeUBo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToh7RAAoJEN0jrNd/PrOh54IQAKiTeCaIPral/GyzTMU3lq7N
V4/msk3/27OFIIx2jEKBP1Lg62gEAcGH8ZQjjd/PXcE4ZVk72XolR6H9yrhRIMyr
DilCFET9yik3vYyOoAL8aMRf6OHYyFw3owCWyV+s4P7ZFFKv3YWVRJ2ATD2l081G
BbFVelm5uiarfMWLkUtqIGuN26MSl8Ynego8hYubZsgcDmU2y+KGW+JylQHyVL+k
WSrMLDu/os8m2GK0q5XAeltfY24BSpE6DOTctjaE5ktqUzlTSjfh3AKZpHKbYucS
1+0qdJrTJL8LWZjBvZMwO6kUdHmMMQTm1tWc+lNcxQmUANf4Yjv0TP0CV9zxLzmm
czcHqBqevXvc6+Il/LYj4FbzVUJ2rovHLSTWcsq3K4Q6lxLPJFsZUZ0zQ9ravweu
LHWxj2p8YRNFBmAUjSgBHSthAOvU4kFjwfv2e5FUHYRMHblrFODwdk5/OykfFujG
g++sFoEWXslKk1zM2A+KUp8TNnBds0Iai+SyneTSxL3ULSw4zawO4BbmE2+xu4YD
Fa78oGMMQTj+kI6IKOC2Tq0sNdZe8MigE6rdpKYtMFVSCQ6L7jl/D37UouKdYLvc
cohbB4UqXPiVBHdyhbUyVWBCdvopI7MNG53JVbdB9VCMMAHqL6u7d/FrCn5Bfpq0
cRIa9FnIdb3fmwjwM4zl
=gKEi
-----END PGP SIGNATURE-----

--fd5uyaI9j6xoeUBo--
