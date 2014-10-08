Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaJHSUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:20:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41085 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaJHSUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:20:42 -0400
Date: Wed, 8 Oct 2014 19:19:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141008181959.GG4609@sirena.org.uk>
References: <1412671438-25399-1-git-send-email-zyw@rock-chips.com>
 <CAD=FV=W_6_JSn5ZWEG7YBDw5xf+tGReSB-WCV798gBqXyhikgg@mail.gmail.com>
 <20141008124935.GA24947@sirena.org.uk>
 <CAD=FV=U5ng8egj4b5Mz1gwFpJPFxJmnSzhT0iRtOj=7VxFTbSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D5hdKamO53XmQjsc"
Content-Disposition: inline
In-Reply-To: <CAD=FV=U5ng8egj4b5Mz1gwFpJPFxJmnSzhT0iRtOj=7VxFTbSA@mail.gmail.com>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: rk808: Add support setting suspend voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D5hdKamO53XmQjsc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 09:12:59AM -0700, Doug Anderson wrote:
> On Wed, Oct 8, 2014 at 5:49 AM, Mark Brown <broonie@kernel.org> wrote:

> > No, this is not the case.  The suspend mode settings are a completely
> > different set of settings activated when the system goes into suspend
> > with explicit hardware support.  If no configuration for this mode is
> > provided then

> I think maybe you missed finishing your sentence?

nothing will be changed.

> >> I believe that won't be the case for your driver.  The rk808 will (I
> >> think) automatically transition to the "suspend voltage" settings for
> >> ALL regulators at suspend time.  If you didn't explicitly set the
> >> suspend voltage then you'll move to whatever the default voltage is,
> >> right?

> > As ever the hardware configuration won't be touched by the kernel unless
> > it's explicitly told to do something.

> I guess my point is that the kernel's inaction is actually causing
> something unexpected to happen.  Robots can't let humans come to harm
> by inaction any more than they can harm them by action.

> Specifically I would expect that voltages would stay constant when the
> rk808 "sleep" pin is asserted if I didn't explicitly say to disable
> this regulator at sleep time and I didn't explicitly specify a voltage
> at sleep time.  As Chris's patch stands right now this isn't the case.

The assumption has to be that the configuration that the device has is
essential to bringing the system into and out of suspend, if we went and
overrode everything with the current runtime configuration I'd expect
we'd break a whole bunch of systems and severely impact the power
consumption in suspend of more.  What you're asking for is just not how
these systems are designed, complain to your electrical engineers.  With
this model for doing things suspend entry and exit is defined and
sequenced at system design time (often with limited configuration so
really at tapeout time). =20

> When the kernel driver sets it to 1.9V, it will go through
> regulator_set_voltage_sel_regmap() which will set the BUCK4_ON_VSEL
> register and we'll be at 1.9V.  Great, we're at 1.9V.  Now we're ready
> to go to sleep.  I'd expect that the voltage would stay at 1.9V, but
> it won't.  BUCK4_SLP_VSEL was never programmed so it's at whatever the
> default is (1.8V) and we will transition there.

No, if the driver needs a particular state during suspend it needs to
explicitly set the suspend mode, that's what those APIs are there for.
Remember that a suspended device is supposed to not be doing anything
anyway most of the time...

--D5hdKamO53XmQjsc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNYBOAAoJECTWi3JdVIfQeqEH/jS8pizxUt7Hhnuex3Ugr8Si
k3tQmIf/xknx42d/fZLO3qAyXH+G9K/xru1SOJmGPu1Ij9845dwjr4f5z1iY2Qjh
dYuoaxBDXBxXHNaBlpYmplOME1SMSa8+BeCBlrEFxzUii8pICkxp6wmsvt48RtzB
Ch96YT2l6ZkOKcQ26wz1XGg5zPn1iwFGpXJj0hBLdLw0E5i9idHVHQloFbP8BUcU
RfvkibZRI75LgBgXIOuLeMUQMwVBNPX3Jf+nt0/KjXQaqtlMsE9tPz++Z4USXWS8
LcLGxBTP7f+ky9zxnRM8OoLkffRVcC/LWkPH+8P0xJ55WsoTcpVH0toiPOf43fc=
=G0Rn
-----END PGP SIGNATURE-----

--D5hdKamO53XmQjsc--
