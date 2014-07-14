Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaGNKaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:30:06 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46330 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaGNKaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:30:01 -0400
Date: Mon, 14 Jul 2014 12:29:56 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
Message-ID: <20140714102954.GD9870@ulmo>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
 <1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
 <20140711145146.GA6523@ulmo>
 <53C00A57.5070102@kapsi.fi>
 <53C38D07.4030402@nvidia.com>
 <20140714081524.GI2081@ulmo>
 <53C39D98.9040802@nvidia.com>
 <20140714093136.GB9755@ulmo>
 <53C3A986.9050602@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ycz6tD7Th1CMF4v7"
Content-Disposition: inline
In-Reply-To: <53C3A986.9050602@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 12:57:26PM +0300, Mikko Perttunen wrote:
> On 14/07/14 12:31, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Mon, Jul 14, 2014 at 12:06:32PM +0300, Mikko Perttunen wrote:
> >>On 14/07/14 11:15, Thierry Reding wrote:
> >>>>Old Signed by an unknown key
> >>>
> >>>On Mon, Jul 14, 2014 at 10:55:51AM +0300, Mikko Perttunen wrote:
> >>>>On 11/07/14 19:01, Mikko Perttunen wrote:
> >>>>>On 07/11/2014 05:51 PM, Thierry Reding wrote:
> >>>>>>On Fri, Jul 11, 2014 at 05:18:30PM +0300, Mikko Perttunen wrote:
> >>>>>>>...
> >>>>>>...
> >>>>>
> >>>>>In this case, all the registers that will be written are such that t=
he
> >>>>>MC driver will never need to write them. They are shadowed registers,
> >>>>>meaning that all writes are stored and are only effective starting f=
rom
> >>>>>the next time the EMC rate change state machine is activated, so wri=
ting
> >>>>>them from anywhere except than the EMC driver would be pointless.
> >>>>>
> >>>>>I can find two users of these registers in downstream:
> >>>>>1) mc.c saves and loads them on suspend/restore (I don't know why, t=
hat
> >>>>>shouldn't do anything. They will be overridden anyway during the next
> >>>>>EMC rate change).
> >>>>>2) tegra12x_la.c reads MC_EMEM_ARB_MISC0 during a core_initcall to
> >>>>>calculate a value which it then writes to a register that is also
> >>>>>shadowed and that is part of downstream burst registers so that does=
n't
> >>>>>do anything either.
> >>>>>
> >>>>>The reason I implemented two ways to specify the MC register area was
> >>>>>that this could be merged before an MC driver and retain
> >>>>>backwards-compatibility after the MC driver arrives.
> >>>>>
> >>>>>If this is not acceptable, we can certainly wait for the MC driver t=
o be
> >>>>>merged first. (Although with the general rate of things, I hope I wo=
n't
> >>>>>be back at school at that point..) I assume that this is blocked on =
the
> >>>>>IOMMU bindings discussion? In that case, there are several options: =
the
> >>>>>MC driver could have its own tables for each EMC rate or we could ju=
st
> >>>>>make the EMC tables global (i.e. not under the EMC node). In any cas=
e,
> >>>>>the MC driver would need to implement a function that would just wri=
te
> >>>>>these values but be guaranteed to not do anything else, since that c=
ould
> >>>>>cause nasty things during the EMC rate change sequence.
> >>>>
> >>>>Having taken another look at the code, I don't think the MC driver co=
uld do
> >>>>anything that bad. There are also two other places where the EMC driv=
er
> >>>>needs to read MC registers: Inside the sequence, it reads a register =
but
> >>>>discards its contents. According to comments, this acts as a memory b=
arrier,
> >>>>probably for the preceding step that writes into MC memory. If the re=
gister
> >>>>writes are moved to the MC driver, it could also handle that. In anot=
her
> >>>>place it reads the number of RAM modules from a MC register. The MC d=
river
> >>>>could export this as another function.
> >>>
> >>>Exporting this functionality from the MC driver is the right thing to =
do
> >>>in my opinion.
> >>
> >>Ok, let's do that then. Do you think I could make a bare-bones MC drive=
r to
> >>support the EMC driver before your MC driver with IOMMU/LA is ready? Ca=
n the
> >>MC device tree node be stabilized yet? Of course, if things go well, th=
at
> >>concern might turn out to be unnecessary.
> >
> >Well, at this point this isn't 3.17 material anyway, so there's no need
> >to rush things.
>=20
> Very true.
>=20
> >I'd prefer to take a patch on top of my proposed MC
> >driver patch in anticipation of merging that for 3.18. But if it turns
> >out that for whatever reason we can't do that, having a separate patch
> >makes it easy to extract the changes into a bare-bones driver.
>=20
> Yes, this sounds sensible. I'll make such a patch. I suppose having anoth=
er
> timings table in the MC node with just the rate and mc-burst-data would
> separate the concerns best. It occurs to me that we could also write the
> regs in the pre-rate change notifier, but this would turn the dependency
> around and would mean that the regs are not written when entering backup
> rates. The latter shouldn't be a problem but the reversed dependency woul=
d,
> so I guess a custom function is the way to go, and we need to add at least
> one anyway.

It sounds like maybe moving enough code and data into the MC driver to
handle frequency changes would be a good move. From the above it sounds
like all the MC driver needs to know is that a frequency change is about
to happen and what the new frequency is.

In addition to exposing things like number of DRAM banks, etc.

> The downstream kernel also overwrites most LA registers during EMC rate
> change without regard for the driver-set values, and we might have to read
> those values from the device tree too. Upstream can do this in rate change
> notifiers if needed. I'll look into this a bit more.

As I understand it, the latency allowance should be specified in terms
of the maximum amount of time that requests are delayed, so that the
proper values for the LA registers can be recomputed on an EMC rate
change.

Thierry

--Ycz6tD7Th1CMF4v7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw7EiAAoJEN0jrNd/PrOhRw8QAI0fEOme82P70RA7ymPO81Bv
ngLq2X2qiRrlPD05zCnBR1Yjf2GJUl1G1KDUmSX7ew1qbea2RCM6Yr2bIkReciGy
twRje+t641eF6dxWcuQObpqYMJaIhMAPnhfADmm9UqRsrg+LD0HukTRYcFuv12gu
yIpuzJ6o/f7iIL2IFMSWXs38hr+s3TM+kmSHQQ4I3JYw5LQhElUtwcn8/HoHBgcq
hQTt0dfYDOhvT9RDpqzpkyZjju2C721GsMuOVTtbDTcG9t/vbGn1e2VskMvJKGzX
33Z98dgxu8nHXGcSxHXu9/HzUWi/rREbRkBI7tYnYNRf7AHNDXspqPNFyvPX0ZiS
dUlz8Z1Mrga9UTJrULgQI6lZkFeUjAtkhj5TAI3VypLiUuxQ1AOETJyF3OB7ww/Q
PcR0zUy/bSMlmn2orFa2uRRrmlV3XsFjJOdahTw7WlbYfiB/cGeL0I4i74QSFITE
DeH+fEMlDUfy6LhDTp3UdcvcuK+GE3qgpS3WGRQxoIFyyZrU409dEmdIsp1MwWcq
CFkZEVIu0zhkk6q/C3feCizIZyTYtSYLiNpFBg9k7mEEID4//VF+cKOyhJKmlTui
zaG5d+JkIHxjp0+cb7dRaqLThrBa60oGosYehFGeQ7VjuEF0DPZzBZceBlM99qMc
Jud0fn9rCOOFRX7z2Wuj
=D1UY
-----END PGP SIGNATURE-----

--Ycz6tD7Th1CMF4v7--
