Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaHUGY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:24:27 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:65047 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaHUGY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:24:26 -0400
Date: Thu, 21 Aug 2014 08:24:22 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: rockchip: rk3288: Switch to use the proper PWM
 IP
Message-ID: <20140821062420.GA4486@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
 <1408381749-14156-2-git-send-email-dianders@chromium.org>
 <20140819071011.GC12859@ulmo>
 <CAD=FV=Xr4ywGT_pPK=r6f6tfVpwbduUY7D5LK61HVtc8=JmkaA@mail.gmail.com>
 <20140820060759.GD13793@ulmo>
 <CAD=FV=Uqm43x0N=eOCQkY_MXviiD2WMw55pOZmC=WVRbD2+veg@mail.gmail.com>
 <20140820153801.GB3427@ulmo>
 <CAD=FV=Xf4Hm5tCaaW3QG-ZSQGovh6RKH=1Og1K-yxj+jKyGsmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <CAD=FV=Xf4Hm5tCaaW3QG-ZSQGovh6RKH=1Og1K-yxj+jKyGsmA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 08:55:09AM -0700, Doug Anderson wrote:
> On Wed, Aug 20, 2014 at 8:38 AM, Thierry Reding <thierry.reding@gmail.com=
> wrote:
[...]
> > Looking at the register offsets in the device tree that seems likely. At
> > least PWMs 0 and 1 as well as 2 and 3 seem like they could be in the
> > same IP block. Their placement in the register map is somewhat strange:
> >
> >         pwm0: pwm@20030000 {
> >                 ...
> >                 reg =3D <0x20030000 0x10>;
> >                 ...
> >                 clocks =3D <&cru PCLK_PWM01>;
> >                 ...
> >         };
> >
> >         pwm1: pwm@20030010 {
> >                 ...
> >                 reg =3D <0x20030010 0x10>;
> >                 ...
> >                 clocks =3D <&cru PCLK_PWM01>;
> >                 ...
> >         };
> >
> >         ...
> >
> >         pwm2: pwm@20050020 {
> >                 ...
> >                 reg =3D <0x20050020 0x10>;
> >                 ...
> >                 clocks =3D <&cru PCLK_PWM23>;
> >                 ...
> >         };
> >
> >         pwm3: pwm@20050030 {
> >                 ...
> >                 reg =3D <0x20050030 0x10>;
> >                 ...
> >                 clocks =3D <&cru PCLK_PWM23>;
> >                 ...
> >         };
>=20
> Ah, you're looking at "rk3xxx.dtsi".  That doesn't apply to rk3288
> (the downsides of trying to guess ahead of time what SoC vendors will
> name new models).
>=20
> In rk3288 they have the same clocks.  See patch #3 in this series.
>=20
>=20
> > The clocks would also indicate that there are actually two blocks. I
> > seem to remember a discussion about whether to handle them as a single
> > block or two/four, but I can't seem to find a reference to it. Maybe I'm
> > confusing it with another driver.
>=20
> At this point it seems like the choice has already been made to handle
> them as separate PWMs.  I can change this choice if you want...

Well, looking at patch 3/4 this really does seem to be one single block
providing four PWM channels, so the right thing to do would be to
represent it in one device tree node. But I'll leave it up to Heiko to
decide how he wants to handle this.

One downside of describing it as one device is that it would make the
pinmux handling slightly more difficult, since presumably you'd only
want to apply the pinmux settings when a channel is actually being used.
Currently the pinmux doesn't apply as long as the device remains
disabled in device tree (though enabling it doesn't necessarily mean
that it's being used).

Like I said, it's up to Heiko to decide whether it's worth making this
change (and it'd make sense to apply it to existing DTS files
retroactively) or better to keep what we have.

Thierry

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9ZCUAAoJEN0jrNd/PrOhLokP/2VPQ+OAof3CJ7W7NI57Jxqd
KHn+3pvex1RimaMTqFWsvz0gNWkduDltyGk8p6PYSqZsaTy+wN1B1e5My2B7pwo/
DkeBbvK1sKV7Yi0TpY11o8cY8SxSKJbZpzelKaSmKcPAvuDQccuW00+erXjltTml
RbNixCyMEURFdXph2Ngo9QejJZX6V4QSPnHqiOunaNTmrzCGh9isEZU6gxYtiTQK
MjIZaizriArZIz18IoLSTZxzqiLudQZkmoUtMUbR7b12gYs/JeViBiupWBwygaR3
+GOENZ/mkzBfoA0GizJ4TbCJm3S+vl+cEmGD9u9cxRpEoimdhu0Rakl8116hbkqA
cyqabGLtUwXl0Uw0rAbwOTTsXV3tgWLL7Bqn1pAsVumRk272xsj0vZqI1NARon4D
B+GNv0ebzfYUrseGmoGdsfHJ7hraNs+m2WxWtfapJ54zd7bXLBQSATgdY9kGv+1k
FObVJzcwpwzwe6JtqlKP1yyiryuPS6NgqcvUQvQpROsJQ54maCn+aelRV/00wm5q
0H6eR75P67QTn8Ruhu1FEGY/PlyUKAtVRMCgzlxIS4xIsf3ZuQtnSkTDJVzA+KLW
c3dWc26vtx8YuNj7nxkV9hDn75WhAzjy9Mt6WOMeA9OP7j54O/Xh9Vg3ffvyJQgS
xNQqSy4E9n9pmLApHkHR
=KZUV
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
