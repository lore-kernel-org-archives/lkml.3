Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3L0Spp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 13:45:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35302 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3L0Spn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 13:45:43 -0500
Date: Fri, 27 Dec 2013 12:44:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <balbi@ti.com>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        <gregkh@linuxfoundation.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <davidb@codeaurora.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Daniel Walker <dwalker@fifo99.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 01/15] usb: phy: msm: Move mach dependent code to
 platform data
Message-ID: <20131227184434.GG7819@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
 <1384267910-32066-2-git-send-email-iivanov@mm-sol.com>
 <20131227181009.GF7819@saruman.home>
 <52BDC58E.2040101@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ahP6B03r4gLOj5uD"
Content-Disposition: inline
In-Reply-To: <52BDC58E.2040101@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ahP6B03r4gLOj5uD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 27, 2013 at 10:23:10AM -0800, Stephen Boyd wrote:
> On 12/27/13 10:10, Felipe Balbi wrote:
> > Hi,
> >
> > On Tue, Nov 12, 2013 at 04:51:36PM +0200, Ivan T. Ivanov wrote:
> >> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >>
> >> This patch fix compilation error when driver is compiled
> >> in multi-platform builds.
> >>
> >> drivers/built-in.o: In function `msm_otg_link_clk_reset':
> >> ./drivers/usb/phy/phy-msm-usb.c:314: undefined reference to `clk_reset'
> >> ./drivers/usb/phy/phy-msm-usb.c:318: undefined reference to `clk_reset'
> >>
> >> Use platform data supplied reset handlers and adjust error
> >> messages reported when reset sequence fail.
> >>
> >> This is an intermediate step before adding support for reset
> >> framework and newer targets.
> >>
> >> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> >> Acked-by: David Brown <davidb@codeaurora.org>
> >> Cc: Daniel Walker <dwalker@fifo99.com>
> >> Cc: Felipe Balbi <balbi@ti.com>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > this really looks like you should be using reset framework
> > (drivers/reset/), then your phy driver would simply reset_assert() and
> > reset_deassert().
> >
>=20
> Unfortunately the reset framework is a DT only framework and there are
> still non-DT platforms within mach-msm. Arnd suggested we push the
> non-DT reset code down into the mach directory in the meantime. We're in
> the process of adding the reset framework to DT enabled MSM platforms,
> hopefully those get merged in 3.14.

And this is why the ARM port is in such a messy situation. It's always
better to "push things into the mach- directory" than improving existing
frameworks to cope with wild ARM SoCs.

fell free to push this through your tree. It _does_ make the PHY driver
slightly better and probably buildable on other arches with
COMPILE_TEST.

Still, I *really* want to see this switching over to reset framework on
v3.16.

cheers

ps: for this patch only you can have my

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--ahP6B03r4gLOj5uD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSvcqSAAoJEIaOsuA1yqREOm4P/3SZ0mg53GRNpz0R4pFtyifc
KJU0qPB9g9r4zqsGpU5NSMm0X2WaGrEC8ivn3x20t60EDfDjnS2bDeDpnje0gJHx
1x77VDD+ePrEtaQOARyTAEBl6fwEAD8duaRd8ckRXhSUGpJcy/zhKFMRSPNwdmz0
fDzJRpusyJGcEP66efY65vFwrUfjrqASDNvu6sbpaa/oDorf1PtzBfpxJqYkz6H9
R2h8+6IPyqJnCTbHUAqgUwABxlJkqGTutuXVXzR8uLY4FMhr2+wrQqVTtXWxMPzH
tD47r6Phjg3t7bPBfBmEYsTqDtNSzDhaYwTgjpzvVSQxs4iNM8UXjfqJV/y3p9gE
ZkEmg7flm1mLw0oUerCisxzXRF1LmSjDdjNHOgFAgMm09lxd79nexj22VOmNBLQC
4/SHz2QWsB6vSJ71IzXSptqSa95j0LPzZLCUm3F/PtQi5cOdSsHTGR+Bk8RpSQK4
+igT0Y+3ciKKTxHIPV4IPMiZwcLtaY8T1NVv91/ace2p0o141T0FH58lBee53bmH
G1aCLi0n+xx/LWBwD8blUQZISqJRr+JqljSYXdKk6kLNCDSREybWt/iUGnGPytal
qfmUXwnZ66tfbhGSwJr5WZxNmPNynzHTXYbYKgSyERjyIbywHnKd0KXAafINAyzI
6l0jgBd87JYZdEMMcIQS
=tPVR
-----END PGP SIGNATURE-----

--ahP6B03r4gLOj5uD--
