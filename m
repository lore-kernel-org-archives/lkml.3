Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3FLKGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:06:55 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:57614 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3FLKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:06:52 -0400
Date: Wed, 12 Jun 2013 12:06:49 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-sh@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v2 04/11] pwm: Add Renesas TPU PWM driver
Message-ID: <20130612100647.GA30841@mithrandir>
References: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1366836616-21475-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20130523214517.GA18249@avionic-0098.adnet.avionic-design.de>
 <22098838.zqKo9eB0Jt@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <22098838.zqKo9eB0Jt@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2013 at 05:48:50PM +0200, Laurent Pinchart wrote:
> Hi Thierry,
>=20
> On Thursday 23 May 2013 23:45:17 Thierry Reding wrote:
> > On Wed, Apr 24, 2013 at 10:50:09PM +0200, Laurent Pinchart wrote:
[...]
> > > +struct tpu_device {
> > > +	struct platform_device *pdev;
> > > +	struct pwm_chip chip;
> > > +	spinlock_t lock;
> > > +
> > > +	void __iomem *base;
> > > +	struct clk *clk;
> > > +
> > > +	struct tpu_pwm_device pwms[TPU_CHANNEL_MAX];
> > > +};
> >=20
> > Can't you reuse the infrastructure built into the PWM subsystem? You can
> > associate chip-specific data with each PWM device. You can look at the
> > pwm-atmel-tcb and pwm-bfin drivers for usage examples. In a nutshell you
> > hook the .request() function and setup the driver-specific structure and
> > associate them with the PWM using pwm_set_chip_data().
> >=20
> > This has the advantage that you don't need the pwms array in tpu_device
> > and you also don't need TPU_CHANNEL_MAX because only the pwm_chip.npwm
> > field needs to contain the number of channels.
>=20
> I've actually thought about that, but decided not to do so. It looked pre=
tty=20
> weird to allocate PWM devices at .request() time, so I decided to allocat=
e the=20
> devices once only at probe time. Is it considered better to allocate/free=
 PWM=20
> devices every time they're requested/released ?

Well, I consider it better because it postpones memory allocation until
it is actually used. Typically requesting a PWM device happens at probe
time of other drivers so it isn't actually as bad as it may sound. Also
allocating at request time allows you to easily associate the data with
the PWM device using pwm_set_chip_data(), which was intended to be used
for exactly this purpose.

Doing so will keep the driver-specific data in a well-defined location
instead of putting it somewhere driver-specific.

Thierry

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuEg3AAoJEN0jrNd/PrOhl48QAL+zKS8bo3v+4S6W7MTG9dbl
fPICtwQ04hGCirJcO83Wz81eDHPPsI2ouburSUTRxjwYogXM/jQvzj5H4EbDrEsG
LXHF8j9u35sRN2FuNSun1v0FnBEd4v8EFPYgh41RH3Ycc2gPn+0d/7hIfHhBv9k5
IXXaJ2hwBuU4vYtHFT4MtPZLJiY7Dq4WE2NqtTXSwiUNvVgyZ0+6vkY200v79L06
dz9bP/1HRaTFqLMfjrpOUu1OHLtk6TKJncY9XUDwIXcsIOMFevfnJv4buAdXx/pT
T6guJ0+zK7M+0x8ue8e5y1Yt/4pa14axdeP+vnfLo5vMXG4KDhj89iq5mgfveH62
ETNwMMOJGMcoD+Cyjnw1p5M3UPGZHRFvbkiJDhBqRBZ4wj/LCKOwau6Xau2Cmgvs
wC/jg46gf9WVlnD7uDlVgvC88QIKyG7KjtkcUiJc6hg00H9cKN0CzgdBC5ci4lsK
XqvRabv8gRbfG0D9930GhcsCO9vYnyECWBtCIxIhzmHX+49jje2iDIf7lKIAOYuC
vTohdgCfNyhdixUDm6ig8hgQO6mtu1p5Ieg/6LjZXSJEMUbdp3/qEzns32T/Wlw8
6FlOmkNMjDPaj209quKGCuQXFF0Cqb1nvIYgwHo77ATI05T29JYeshHdFPh3peMs
4fL+Kk79S6PhNUgz9Hx7
=FTF6
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
