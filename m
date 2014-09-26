Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaIZHLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:11:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42456 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaIZHLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:11:14 -0400
Date: Fri, 26 Sep 2014 09:11:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bart Tanghe <bart.tanghe@thomasmore.be>, tim.kryger@linaro.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [resend rfc v3] pwm: add BCM2835 PWM driver
Message-ID: <20140926071109.GA31106@ulmo>
References: <1398689686-30317-1-git-send-email-bart.tanghe@thomasmore.be>
 <20140825131908.GG4163@ulmo.nvidia.com>
 <5408395E.2030305@thomasmore.be>
 <54088008.9080200@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <54088008.9080200@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2014 at 09:06:48AM -0600, Stephen Warren wrote:
> On 09/04/2014 04:05 AM, Bart Tanghe wrote:
> >No problem. Thanks for the feedback.
> >I've got some question below.
> >
> >On 2014-08-25 15:19, Thierry Reding wrote:
> >>Sorry for taking so long to reply to this, I had completely forgotten.
> >>
> >>On Mon, Apr 28, 2014 at 02:54:46PM +0200, Bart Tanghe wrote:
> >>>	Add some better error handling and Device table support
> >>>	Added Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt
> >>>=09
> >>>Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
>=20
> >>>diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> >>>index 22f2f28..20341a3 100644
> >>>--- a/drivers/pwm/Kconfig
> >>>+++ b/drivers/pwm/Kconfig
> >>>@@ -62,6 +62,18 @@ config PWM_ATMEL_TCB
> >>>  	  To compile this driver as a module, choose M here: the module
> >>>  	  will be called pwm-atmel-tcb.
> >>>
> >>>+config PWM_BCM2835
> >>>+	tristate "BCM2835 PWM support"
> >>>+	depends on MACH_BCM2835 || MACH_BCM2708
> >>>+	help
> >>>+	  PWM framework driver for BCM2835 controller (raspberry pi)
> >>
> >>I think the correct capitalization would be "Raspberry Pi".
> >>
> >>>+	  Only 1 channel is implemented.
> >>
> >>How many can it take? Why haven't all been implemented?
> >
> >BCM2835 can take 2 pwm channels.
> >I can implement 2 channels but can't physically test the second channel.=
 Is that a problem?
>=20
> I don't think that's a problem; I would expect the channels to be identic=
al,
> so testing 1 should be fine.

Agreed. If it turns out not to work it can always be fixed.

> >>I notice that you never prepare or enable the clock here. Perhaps this
> >>isn't required because it's always on, but I think you should still call
> >>clk_prepare_enable() here (and clk_disable_unprepare() in .remove()) to
> >>make sure the driver is more portable.
> >The frequency can be minimized by a clock_divider ( the pwm clock is def=
ault disabled). this has to be done by
> >a clock driver, as mentioned in a previous comment by Stephen Warren.
> >
> >Any clock programming should be performed by a clock driver. We don't
> >have one of those upstream yet, mainly because it would rely on talking
> >to the firmware (running on the VideoCore) to manipulate the clocks, and
> >we don't have a firmware protocol driver either.
> >
> >Nowadays, I'm using a userspace program to change the clock_divider, but=
 would like to implement this in a clock driver.
> >The clock hardware description isn't implemented in the datasheet. I can=
 convert the userspace prog to a clock driver but this is very experimental.
> >If anyone has some suggestions?
>=20
> Oh dear. It sounds like we need at least some form of clock driver for the
> platform then. I still don't think there's complete documentation for the
> HW, even though a lot of register docs were published which presumably co=
ver
> the clock HW? Equally, given that the VC firmware assumes it owns most of
> the HW, it seems best to manipulate the clocks through the firmware
> interface rather than directly touching the HW. Unfortunately, I don't
> believe there's any ABI guarantee on the firmware interface. Perhaps we c=
an
> get one?

Urgs... this VC firmware seems to be more of a headache that I thought
it was. How is this handled in other drivers? Surely PWM isn't the first
one that needs clocks?

> >>>+static const struct of_device_id bcm2835_pwm_of_match[] =3D {
> >>>+	{ .compatible =3D "bcrm,pwm-bcm2835", },
> >>
> >>s/bcrm/brcm/
>=20
> Probably swap the order, so "brcm,bcm2835-pwm". That would be consistent
> with all the other HW on this SoC.

Yes, please.

Thierry

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUJRGNAAoJEN0jrNd/PrOhFyQQAIe/aa5ABgf8wb0fLvd2sEIC
yTfFAfkvLFgmtFkS7pHmAXoVvWW+RbPo+nBKpZEY0DHYStUXySmQyyseRkiWDafa
UYHYZiKvJGyrbxjha+ARGTEn97qtk0iv6PJkzwwTwEIs0jYQ/KR8t/7FU+2Z2OxE
NlP3x/+iFXZVmz1+RPl1xjeWhCC9S98MzRU3ecks3iVbg1EvV9hss5OlOtaNJUSU
3YAnYx6KOH9VWPwp0ed269N3m42hoYkLRHEoqE+tLmTegZyDifas3OoXCUUStMts
J4SGFqTs6fITD2whUgUlHXJKPlvfIs6HWTpUxLoMCxmH/fuc4+5p3ZcBfhPGiJ1X
YQU0KQKOw8F/J/Pkp47laJRMoowSLe5wje3Ao5AKx++LRGoeUpe7dPYTfOJH7tSQ
zB3pCNKmhqYJWnxu0a7CzvZnalnsK3sTaUUFNZFR+TUoTGJ23qOJLvEYfOhOtnmW
+IenA4d95b3lspwll0bCS8Oy06ZwMxeOcl/tpg3xFPSRmh4LT90kfwuz2yV+QgUG
IQSTw9gri/4TwvP3NzR0rzieLaUPOiGZfbKfXPLGPTYDbFc+j62AFtNqTfUFpDHF
CjOmHEiYJng6lG/O1iMP0OuMn4dpIuO2mcSGfJLblAkJyVmI3QB6Pke0exxfYE1N
LfdIUFYs/G4NDhY6n0tv
=pZDR
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
