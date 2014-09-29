Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaI2FdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 01:33:18 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57242 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaI2FdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 01:33:17 -0400
Date: Mon, 29 Sep 2014 07:33:13 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bart Tanghe <bart.tanghe@thomasmore.be>, tim.kryger@linaro.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [resend rfc v3] pwm: add BCM2835 PWM driver
Message-ID: <20140929053311.GA12506@ulmo>
References: <1398689686-30317-1-git-send-email-bart.tanghe@thomasmore.be>
 <20140825131908.GG4163@ulmo.nvidia.com>
 <5408395E.2030305@thomasmore.be>
 <54088008.9080200@wwwdotorg.org>
 <20140926071109.GA31106@ulmo>
 <54257C25.2000308@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <54257C25.2000308@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2014 at 08:45:57AM -0600, Stephen Warren wrote:
> On 09/26/2014 01:11 AM, Thierry Reding wrote:
> >On Thu, Sep 04, 2014 at 09:06:48AM -0600, Stephen Warren wrote:
[...]
> >>Oh dear. It sounds like we need at least some form of clock driver for =
the
> >>platform then. I still don't think there's complete documentation for t=
he
> >>HW, even though a lot of register docs were published which presumably =
cover
> >>the clock HW? Equally, given that the VC firmware assumes it owns most =
of
> >>the HW, it seems best to manipulate the clocks through the firmware
> >>interface rather than directly touching the HW. Unfortunately, I don't
> >>believe there's any ABI guarantee on the firmware interface. Perhaps we=
 can
> >>get one?
> >
> >Urgs... this VC firmware seems to be more of a headache that I thought
> >it was. How is this handled in other drivers? Surely PWM isn't the first
> >one that needs clocks?
>=20
> For the other clocks, I've set up dummy fixed-rate clocks in the DT and/or
> "clock driver" code to satisfy references by phandle or clock name
> respectively. Since the other drivers don't actually manipulate the clock
> rates etc., this is enough for the drivers.

Given that this driver only queries the clock frequency adding a fixed-
rate clock to the device tree should work as well. Then the calls to
clk_prepare_enable() and clk_disable_unprepare() can still be added as
appropriate so that the driver doesn't need to change if a proper clock
driver ever gets added.

Or am I missing anything? Perhaps the issue is that the default clock
rate for the PWM clock isn't usable? That would still not prevent the
driver from being merged.

Thierry

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUKO8XAAoJEN0jrNd/PrOh5r0QALGyUv9fqekpXBnZNdhd5dM8
YPUMhcZHWQljsd7sPldFzN735SEM40+wm6akUSmFQsfWmdcavI80duw7p1g0D2r5
/PdkBdJf70c7SQFseSIq9s6nkNvZgJ2nFEaqTw60q/z9MZPhknBOnVsu6L1nZFWR
VWLM84wv8Ux53yACZIyeEBHvZaWG23jkDzr+G3Xp4IcwsbTC6b7KcFktmzQDcYit
ICmDx+499q+PHcBYBFZC/ag8RG/EZagzC6N66geutJ75f+74e6mLech3n31Iv+S0
jTYqRCw6GJeVMMB/e4b24JwjsGLsqqnjqquGA0PZzz5d6/KHAgkvSJYOOoLMwgY7
XlhnmiPRFyIU94aYoj59bWO17KablHKHETD70nFJdUNoQp0k2ISR766wRdiUGgfu
CunGIh0MlcbfIMML4LBA5HFECS8IuV2byTvLnecv1fEh0joLrNsAdHF8DWh4g/lS
WOoXmvR+vooAsdRURALJ6ywTWX31CHvFdgKHPIrZr+LqAEc0twdq8hztRMiKdSQ7
moRfWlUwxsPBq6DMnCjlCe4yREPiX+F0M2Z9ZuwDUp/9EYayzOKjE4rhyrZzPNu/
+B4JxM0F+K/PnMSSmeVTCIljoTW2YZ7quvrtdktyMV3ymkx1tJHQtbyTU4o/oxSs
6Wxq/C39glL5Qwfa8lmm
=27Dv
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
