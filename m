Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaHUPyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:54:10 -0400
Received: from gloria.sntech.de ([95.129.55.99]:59133 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaHUPyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:54:08 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: rockchip: rk3288: Switch to use the proper PWM IP
Date: Thu, 21 Aug 2014 17:53:43 +0200
Message-ID: <3306005.N0EURaUzl3@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140821062420.GA4486@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org> <CAD=FV=Xf4Hm5tCaaW3QG-ZSQGovh6RKH=1Og1K-yxj+jKyGsmA@mail.gmail.com> <20140821062420.GA4486@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2086323.hgZ54ZBGt7"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2086323.hgZ54ZBGt7
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Donnerstag, 21. August 2014, 08:24:22 schrieb Thierry Reding:
> On Wed, Aug 20, 2014 at 08:55:09AM -0700, Doug Anderson wrote:
> > On Wed, Aug 20, 2014 at 8:38 AM, Thierry Reding <thierry.reding@gmail.com> 
wrote:
> [...]
> 
> > > Looking at the register offsets in the device tree that seems likely. At
> > > least PWMs 0 and 1 as well as 2 and 3 seem like they could be in the
> > > 
> > > same IP block. Their placement in the register map is somewhat strange:
> > >         pwm0: pwm@20030000 {
> > >         
> > >                 ...
> > >                 reg = <0x20030000 0x10>;
> > >                 ...
> > >                 clocks = <&cru PCLK_PWM01>;
> > >                 ...
> > >         
> > >         };
> > >         
> > >         pwm1: pwm@20030010 {
> > >         
> > >                 ...
> > >                 reg = <0x20030010 0x10>;
> > >                 ...
> > >                 clocks = <&cru PCLK_PWM01>;
> > >                 ...
> > >         
> > >         };
> > >         
> > >         ...
> > >         
> > >         pwm2: pwm@20050020 {
> > >         
> > >                 ...
> > >                 reg = <0x20050020 0x10>;
> > >                 ...
> > >                 clocks = <&cru PCLK_PWM23>;
> > >                 ...
> > >         
> > >         };
> > >         
> > >         pwm3: pwm@20050030 {
> > >         
> > >                 ...
> > >                 reg = <0x20050030 0x10>;
> > >                 ...
> > >                 clocks = <&cru PCLK_PWM23>;
> > >                 ...
> > >         
> > >         };
> > 
> > Ah, you're looking at "rk3xxx.dtsi".  That doesn't apply to rk3288
> > (the downsides of trying to guess ahead of time what SoC vendors will
> > name new models).
> > 
> > In rk3288 they have the same clocks.  See patch #3 in this series.
> > 
> > > The clocks would also indicate that there are actually two blocks. I
> > > seem to remember a discussion about whether to handle them as a single
> > > block or two/four, but I can't seem to find a reference to it. Maybe I'm
> > > confusing it with another driver.
> > 
> > At this point it seems like the choice has already been made to handle
> > them as separate PWMs.  I can change this choice if you want...
> 
> Well, looking at patch 3/4 this really does seem to be one single block
> providing four PWM channels, so the right thing to do would be to
> represent it in one device tree node. But I'll leave it up to Heiko to
> decide how he wants to handle this.
> 
> One downside of describing it as one device is that it would make the
> pinmux handling slightly more difficult, since presumably you'd only
> want to apply the pinmux settings when a channel is actually being used.
> Currently the pinmux doesn't apply as long as the device remains
> disabled in device tree (though enabling it doesn't necessarily mean
> that it's being used).

yeah, the pinctrl settings would need to move to the board files, to only set 
the pins necessary on the relevant board. But I don't see that as a problem.


> Like I said, it's up to Heiko to decide whether it's worth making this
> change (and it'd make sense to apply it to existing DTS files
> retroactively) or better to keep what we have.

hmm, I guess I don't really have a hard opinion on this. Generally I like the 
"right thing" approach, but the current option also looks ok to me.
So I guess I'm not much help in deciding this :-)


Heiko
--nextPart2086323.hgZ54ZBGt7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABCAAGBQJT9hYHAAoJEPOmecmc0R2B/4wH/j3DThFpjTYuwzIKlds97xcz
ratT9TyEn8AMWGDpfNgWRu1QJSmklspyxfpWnne0BZzUnv9YMdf+afh49EawKogG
zOCivnBPU1n1clvRUfzUbval1vE1mAcAB+cj8TzF7Sg+5FRGSZ98bQfVG+iI3qnP
mROn/UUvkHgunU7+WHZRMIkoIVfV96naPopKw2q5YammO8iYtmvH/X8At2k+VuU8
diAVBCupCyPtZdz9uMOOtNstodM5vVITY59p9sTWyYnuNtXy4GpG7RlZ7EL0Usjb
CORLTLEQYfXuk728StYbrj/2OoXVrwQ6oQjeG/1K+C+GV7/CiE30baxK7B9yCpE=
=eBxg
-----END PGP SIGNATURE-----

--nextPart2086323.hgZ54ZBGt7--

