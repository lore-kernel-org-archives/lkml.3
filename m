Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbbAHIDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:03:47 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:43400 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbbAHIDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:03:45 -0500
Date: Thu, 8 Jan 2015 09:03:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        swarren@wwwdotorg.org, gnurou@gmail.com, bskeggs@redhat.com,
        martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150108080338.GA27845@ulmo.nvidia.com>
References: <1419426990.2179.7.camel@lynxeye.de>
 <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com>
 <54AD0F37.5080609@nvidia.com>
 <20150107132709.GA6988@ulmo>
 <20150107140852.GR10073@tbergstrom-lnx.Nvidia.com>
 <20150107142828.GB7392@nvidia.com>
 <20150107144805.GF1621@ulmo>
 <54AE06AE.8080603@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <54AE06AE.8080603@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 12:25:18PM +0800, Vince Hsu wrote:
>=20
> On 01/07/2015 10:48 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Wed, Jan 07, 2015 at 10:28:29PM +0800, Vince Hsu wrote:
> >>On 04:08:52PM Jan 07, Peter De Schrijver wrote:
> >>>On Wed, Jan 07, 2015 at 02:27:10PM +0100, Thierry Reding wrote:
> >>>
> >>>>>Yeah. I plan to have the information of all the clock client of the
> >>>>>partitions and
> >>>>>the memory clients be defined statically in c source, e.g. pmc-tegra=
124.c.
> >>>>>All modules can declare which domain they belong to in DT. One domai=
n can
> >>>>>be really power gated only when no module is awake. Note the clock c=
lients
> >>>>>of
> >>>>>one domain might not equal to the clocks of the module. The reset is=
 not
> >>>>>either.
> >>>>>So I don't get the clock and reset from module. How do you think?
> >>>>This whole situation is quite messy. The above sequence basically mea=
ns
> >>>>that drivers can't reset hardware modules because otherwise they might
> >>>>race with the power domain code. It also means that we can't powergate
> >>>The powerdomain framework won't call any powergating method as long as=
 a
> >>>module in the domain is still active. So as long as drivers don't try =
to
> >>>reset the hw without having done a pm_runtime_get(), we shouldn't have=
 such
> >>>a race?
> >>Agree. And as long as the driver has the correct reset procedure, that =
should
> >>be fine to occur between power ungating and gating sequences.
> >>
> >>>>modules on demand because they might be in the same power domain as o=
ne
> >>>>other module that's still busy.
> >>>>
> >>>The powerdomain framework keeps track of which modules are active (by =
hooking
> >>>into runtime pm) and won't try to shutdown a domain unless all modules=
 are
> >>>inactive.
> >>Yeah. By the way, that means we should start supporting runtime pm for =
all
> >>the modules to use generic power domain.
> >Indeed, that'll be a prerequisite before we can merge power domain
> >support. I do have a couple of local patches that add very rudimentary
> >runtime PM for various drivers. For starters we could probably just do
> >the
> >
> >	pm_runtime_enable(...);
> >	pm_runtime_get_sync(...)
> >
> >in the ->probe() and
> >
> >	pm_runtime_put_sync(...);
> >	pm_runtime_disable(...);
> >
> >in the ->remove() callbacks for those drivers. That's by no means
> >optimal but should get us pretty close to what we do now and still
> >support the generic power domains.
> Cool. Could you send me the patches?

Here are two examples:

	https://github.com/thierryreding/linux/commit/36b5c34f68edb8135b9afb3e62c7=
ce9a527d6793
	https://github.com/thierryreding/linux/commit/6a6145d9e0fcbd4f9599552181fc=
02f4606b6a0e

Thierry

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrjnaAAoJEN0jrNd/PrOhz14P/3RdQpqGO/h/IVMDnKHldey3
ObcS6z2uatoTfVhAM74FRTEtfwvIyPbSfy+OYfSXcMf4mZ7t/j7FLYiDVyatNoEe
8VODBU4JYoVhkcqcYCAK8PCAudR1kB4qQxuNeimUle4z0rXGJ4EFap9RrIOxwbtU
0Wa/v2XxAiUx19dq3DDjvxEa1Qe+x0AndYPRIA4uWl6S6kB98odMSMMNQ7dupNq6
qns5cMdLI44lJ7uZYPfA1wBsgrM3OTqQK2ClbAi7SDa0LPEMc/7gX6OQV6KaclCl
TafJuFGX4jWwmS5/LoHLp5dzeQRCf4oPbHhvLhOPhQpLHa6rCUeGn/fNMSHJXDGJ
4gjVmYyWWbnKaWc/nEf9DF/NCU0F2vZVjBhatQ+1EDQpcMDPKzK6gI+qDGKDbTK/
RXJvT1jfBxOKx6g+5Caz+OM7HRyIFmJk93dpZY4wJoBRHK/e1drg6bfekvn9Hxu8
ZlFi9mzoBMeWw/oiqRy73VGPh40n1Rf4Df4isPZ+2WM2uehSgyHpvgqUcCiW0K2J
3/+a2F2psmfrZiJYgbIzDV8+4QZFcrWGtxv7RWt5umLEfxnxhxTMaoV925ZraHK0
VpCgPWL1wOW54e4fzrVjlOCScrsMKKlvYhgcD3wopeUeXOUwB/+uKggavux9JfKs
ptyWW1EOejsPWgCT2nYq
=18vR
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
