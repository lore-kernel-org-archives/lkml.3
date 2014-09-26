Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaIZPn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:43:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46034 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaIZPnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:43:55 -0400
Date: Fri, 26 Sep 2014 10:43:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <devicetree@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>,
        Peter Chen <peter.chen@freescale.com>, <p.zabel@pengutronix.de>,
        <jszhang@marvell.com>, <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140926154306.GE26227@saruman>
Reply-To: <balbi@ti.com>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <20140926003750.GA12770@saruman>
 <20140926003934.GD12770@saruman>
 <3346642.tZaefcZubX@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AsxXAMtlQ5JHofzM"
Content-Disposition: inline
In-Reply-To: <3346642.tZaefcZubX@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AsxXAMtlQ5JHofzM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 26, 2014 at 09:20:54AM +0200, Arnd Bergmann wrote:
> On Thursday 25 September 2014 19:39:34 Felipe Balbi wrote:
> > >=20
> > > why would a glue layer need to access registers from the core ? That
> > > sounds very odd. I haven't seen that and will, definitely, NACK such a
> > > patch=20
> > >=20
> > > can you further describe why you think a glue layer might need to acc=
ess
> > > core IP's registers ?
> >=20
> > I just realised we're talking about chipidea here... in any case, it's
> > still valid to ask why would glue need to fiddle with core IP's
> > registers.
>=20
> Generally, the glue driver wouldn't access the registers, but I don't
> think it's important to prevent it from doing that. In some cases,=20

sure it is. Have already gone through debugging sessions just because
someone fiddled with registers they shouldn't. Also RMK's L2 rework
patchset is another example of why it's important to prevent other
layers from messing with registers they don't really own.

> a glue driver needs to override a function of the core driver, e.g.
> to work around an errata. We have a lot of those quirks in ATA drivers,

pass a quirk flag and let core driver handle it.

> one example from ahci_mvebu.c is
>=20
> static void ahci_mvebu_regret_option(struct ahci_host_priv *hpriv)
> {
>         /*
>          * Enable the regret bit to allow the SATA unit to regret a
>          * request that didn't receive an acknowlegde and avoid a
>          * deadlock
>          */
>         writel(0x4, hpriv->mmio + AHCI_VENDOR_SPECIFIC_0_ADDR);
>         writel(0x80, hpriv->mmio + AHCI_VENDOR_SPECIFIC_0_DATA);

I would rather see:

	if (this_is_one_of_the_broken_mvebu_versions(hpriv))
		quirks |=3D AHCI_NEEDS_REGRET_BIT;

then let core handle the rest. If other glue has the same bug and needs
the workaround, we don't duplicate code.

--=20
balbi

--AsxXAMtlQ5JHofzM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJYmKAAoJEIaOsuA1yqREd+QP+gMT9mRfPY+Tc7gb/L9ltPvu
IfVPneXdEdoSDYnMmPYiiIGyn3ilqzcNnrgREdsO27CNqS3nmfnMu3HJXUVralLI
ztR0LzSaqG2bwdAj4PqCv3P6NPMyAvWnFCwrGAcWDdysaQJuT2UQxxJ4yHZFcK88
JT7wghPSTAbHJrwN5BaW5jzhrVnapOGGaaxBDTBC55gFmferWbwiY4QZJjniWi62
apMQo77ZfZad8V47dmYQxp6Qv02YXHgGoKD9GYfbDsvGzMX0EWrYVg7IklmZStNG
II+MiuhmVdDtXwHbQIW28iYd2M+d0b9a6LnvlghLdwAN3ZZqClwIhd9KENs6IoZK
60p58kUBez+NUZrEx7aag/ikFqVUsrVtaj7SaHJrKFJHxu9Aoyu4PaNom/cZFG/X
7IPoJ3gzDonsNkPU4WR1Xk/QXsSVDi1ObgKUug0j+EZYPPRY296kSwpAdJlrsUwu
K0pM3rwMFoEWJBJxXh6uSJ78xGC0oTqKEPRGS1BOMnLUOaisRQZWw4AGRMzmSKmh
ZySjVPStjwzPrhwhEerUus+6KigibQyzJREOyepOJTEXRvZCfr6yKA/1oEwCaHx4
ccV0r6yxTtShdly5o5V/sE15VnKW59rMjxzMEx/vx6wYLCo89oeR1VPpJ4ae8zcu
AM+janwF4xSj3+OWX9lk
=1Ma1
-----END PGP SIGNATURE-----

--AsxXAMtlQ5JHofzM--
