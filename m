Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbbAINd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:33:57 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:34305 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbbAINdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:33:55 -0500
Date: Fri, 9 Jan 2015 14:33:51 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-tegra@vger.kernel.org,
        Allen Martin <amartin@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>, pwalmsley@nvidia.com
Subject: Re: [PATCH] clocksource: tegra: wrap arch/arm-specific sections in
 CONFIG_ARM
Message-ID: <20150109133349.GA27876@ulmo>
References: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com>
 <54AEB719.5060103@linaro.org>
 <alpine.DEB.2.02.1501090135280.28771@utopia.booyaka.com>
 <54AF91CC.2090007@linaro.org>
 <20150109122120.GJ16465@ulmo>
 <54AFD688.5000304@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <54AFD688.5000304@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 02:24:24PM +0100, Daniel Lezcano wrote:
> On 01/09/2015 01:21 PM, Thierry Reding wrote:
> >On Fri, Jan 09, 2015 at 09:31:08AM +0100, Daniel Lezcano wrote:
> >>On 01/09/2015 03:09 AM, Paul Walmsley wrote:
> >>>Hello Daniel
> >>>
> >>>On Thu, 8 Jan 2015, Daniel Lezcano wrote:
> >>>
> >>>>On 12/09/2014 11:07 PM, Paul Walmsley wrote:
> >>>>>
> >>>>>Like several of the other files in drivers/clocksource,
> >>>>>tegra20_timer.c contains code that can only compile when CONFIG_ARM =
is
> >>>>>enabled.  This causes obvious problems when trying to compile this
> >>>>>code for NVIDIA ARM64-based SoCs, such as Tegra132.  The same timer =
IP
> >>>>>blocks exist, so it seems appropriate to provide support for them.
> >>>>>
> >>>>>So until we figure out a better way to partition this code, wrap the
> >>>>>delay_timer and persistent_clock support code with preprocessor tests
> >>>>>for CONFIG_ARM.
> >>>>>
> >>>>>  (The delay_timer code should not be needed at all on
> >>>>>ARM64 due to the presence of the ARMv8 architected timer.  The
> >>>>>persistent_clock support code could become important once power
> >>>>>management modes are implemented that turn off the CPU complex.)
> >>>>
> >>>>IIUC, the cpuidle driver is not yet ready, right ?
> >>>>
> >>>>If it is the case, this driver is not needed yet, no ?
> >>>
> >>>The point of the patch is to allow the hardware drivers selected by
> >>>CONFIG_ARCH_TEGRA to build for an arm64 kernel, just as they build for
> >>>32-bit ARM.
> >>>
> >>>There's nothing CPUIdle-specific about the patch - that is, this timer=
 can
> >>>be selected as a clockevent and clocksource provider without the use of
> >>>CPUIdle - although low-power PM idle is likely to be a primary use-cas=
e.
> >>
> >>What I meant is this timer is not needed for the moment.
> >>
> >>>>Perhaps you can rework a bit this driver in the meantime to have a be=
tter fix
> >>>>than disabling the code with macros ?
> >>>
> >>>I'm happy to do that, but it would be nice to get the driver compiling
> >>>first for ARM64 :-)
> >>>
> >>>>Otherwise, please try at least to group the code into a minimal set o=
f macros.
> >>>
> >>>So, would it be accurate to say that you would prefer a patch that cha=
nges
> >>>more lines of code, but minimizes preprocessor directives, to the curr=
ent
> >>>patch?
> >>
> >>Yes at least an attempt to factor out a bit the driver. Those #ifdef are
> >>like #if 0, which is a quick fix. I am not strongly against this patch,=
 but
> >>it would be nice to take the opportunity to reorganize it a bit.
> >
> >How about we do something like the attached patch instead for now. That
> >avoids any #ifdef'ery and still we don't attempt (and fail) to build the
> >driver on 64-bit ARM.
> >
> >With that applied we can incrementally make the changes to untangle the
> >ARM-specific parts and when the driver can build on 64-bit ARM we simply
> >select TEGRA_TIMER via Kconfig.
>=20
> Yes, that is exactly what I was thinking about after sending the previous
> email. And by this way, you also fixed the Kconfig option selection logic.

Great. Will you give your Acked-by so that I can take that patch through
the Tegra tree to resolve the build dependency?

Thierry

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr9i9AAoJEN0jrNd/PrOhlW0QAJ35JLPzCG6l4zNkyZk04T+u
T51N6gToQk+BoeuEsLGsnI1KclFXTsrXIhvVhcd8mFLz4UGZB2GHfSOP2FV2WGqy
V1PLBkI06l4P/a933nT7NY89LZgjwx/tc0kOG5H7Vp2DBmaaEICPN3y69FHpKwZt
70Uax1obJGtqwoeLmI0YIJZBXL9SRt7nt9LH/awJVNlpjFD3EIysX2W0BYLfmGcS
ceG8qnDZF/4doN57QbjhdmS0EWPNTGqmv2eCroH6oN8Pqkic8Fk7QsAfQEnBVI7o
pW49v7ZpX0ta4GdTK/AUiI5/H9yEJhoQQNVRV5cHMsDCmu2mhSgpP7H8g2LS2YZo
y33xpEsPpRiTh8Hkt9bRUhezsz9CKdxh3Jh/NOzIA0iLItxr9HaFBoKjpIavlMN+
9AX4RZNzjUUkLb9w5ZVHqm6LsnoPTwU2CtRJNKKpw0hryyMPXO7hbCxcDEolWswp
/dpO59R7+JssZlQXd3lbtBSqpIfo21I5cE7ro+P+jPQk+XeXzwgBXqyZa0+/6JRZ
UhhkCicEythsJYRrm4mgUHHUAvbs7i+E+tYlcKpyynflnD1vYofBx0Bmv919nR56
dwg9mG4cX9zu755McUoolXHSU+4pSRakJvtdxBfSNEfl03X7UaOWOK0PYBPY4I/v
ayJShYr2edXPPwA2Y/I7
=i8VH
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
