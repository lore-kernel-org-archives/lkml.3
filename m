Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044Ab3FEEI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 00:08:27 -0400
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:42847
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750713Ab3FEEIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 00:08:23 -0400
Date: Wed, 5 Jun 2013 00:08:02 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Ajitpal Singh <ajitpal.singh@stericsson.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cw1200: fix some obvious mistakes
Message-ID: <20130605040802.GA22735@shaftnet.org>
References: <1370126241-2528420-1-git-send-email-arnd@arndb.de>
 <8513280.folT80711V@wuerfel>
 <20130602144725.GC3875@shaftnet.org>
 <2014948.bdhzSga56L@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <2014948.bdhzSga56L@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2013 at 10:40:42AM +0200, Arnd Bergmann wrote:
> It's much better than what you have today, but not ideal because it
> means the driver cannot be a loadable module any more.

At least not when being built with platform data, anyway.

I suppose the next step here is to define some devicetree mappings for=20
this device.

> At least it's not in a released kernel yet.

Given the boneheaded buffer overflow bug that was just pointed out (and=20
fixed), I'm glad it's getting a lot more scrutiny.

> Regarding a long-term solution, I think what we should do here is to
> move the reset logic into the SDIO framework itself: We have similar
> requirements even for eMMC and SD cards, where you need to provide
> the correct voltage to a device on the MMC port in order for it to
> work. Today this is supported to a varying degree on the MMC controller
> level, where we hook into various frameworks (clk, reset-controller,
> regulator, gpio, pinctrl, power domain) based on platformm data or
> device tree information on the controller node.

If I understand you correctly, the "traditional" platform data -- power=20
supply, clock source, and gpio (ie POWERUP, RESET) lines would be=20
brought up using this mechanism, in order to get the device to attach to=20
the SDIO bus.  One wrinkle here is that the cw1200 has some minimum=20
timing requirements between when each of those signals are brought up; I=20
don't know if there's a way to encode that into the devicetree.

But that's only half the equation.

Once the device has identified it to the SDIO bus and the driver's=20
probe() function is called, the other half of the platform data is=20
needed to successfully probe the hardware.  Namely, the 'ref_clk' field.=20
This would need to be made available to the probe() call (eg via=20
func->dev.platform_data) but from what I can tell there's currently no=20
mechanism to make that connection.

Anyway, it's time for bed.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRrrmiPuLgii2759ARAhzEAJ9JnwOnKkTTsWbbNoznOJ6Ky/L8ggCgtKCx
JognqIBHq43lFyi4EnYLOac=
=kmhf
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
