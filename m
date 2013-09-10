Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3IJUtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:49:12 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54447 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3IJUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:49:11 -0400
Date: Tue, 10 Sep 2013 13:50:27 -0700
From: Sean V Kelley <sean.v.kelley@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@redhat.com>, Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm tree for 3.12-rc1
Message-ID: <20130910205027.GI23294@tallgrass.jf.intel.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
 <CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
 <CA+qSnqh1X6_xHD4GX1P=acEUg9+0=3dVSZHm-NYXvCvupFB8_g@mail.gmail.com>
 <CA+55aFzRCNteHoSBRL9cVAHtZwA419G+fPBAaofYextsHpDLYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iRjOs3ViPWHdlw/I"
Content-Disposition: inline
In-Reply-To: <CA+55aFzRCNteHoSBRL9cVAHtZwA419G+fPBAaofYextsHpDLYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iRjOs3ViPWHdlw/I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2013 at 08:49:58AM -0700, Linus Torvalds writes :
> [ Dave - your linux.ie email generates bounces for me, trying redhat inst=
ead ]
>=20
> On Mon, Sep 9, 2013 at 11:25 PM, Sean V Kelley <sean.v.kelley@intel.com> =
wrote:
> >>
> >> I'm also a bit bummed that hw acceleration of video doesn't seem to
> >> work on Haswell, meaning that full-screen is now a jerky mess. I fear
> >> that that is user-space libraries/X.org, but I thought I'd mention it
> >> in the hope of getting a "oh, it's working for us, you'll get a fix
> >> for it soon".
> >
> > Can you give a little more detail about video not working?  Video
> > accel should work fine with the current versions of libva/intel-driver
> > available in Fedora 19 - assuming that's what you're using.
>=20
> It is indeed F19.
>=20
> Easy test: go to youtube, and watch things that are in 1080p HD. They
> play fine in a window (using about 70% CPU), but full-screened to
> 2560x1440 they play at about one or two frames per second.

Yep.  I see the same.  Chrome is brain dead and appears to simply
rely on Flash + FFmpeg software codecs.  At least with Firefox you
know it will suck and not be hw accelerated. Unless that has changed...

>=20
> Non-HD content seems to be fine even full-screen. Either just because
> it's so much easier to do, or because some level of scaling is
> hw-accelerated.

SD content should be relatively fine with software codecs. Ideally,
full-screen would disable composition and use hw-overlay in addition
to an actual hw accel codec, h.264 or vp8 for html5 video.  But that
is not the case.  That being said HSW does not support vp8 hw decode.

>=20
> It may well be that I'm using chrome (and chrome seems to tend to use
> its own library versions), and firefox indeed seems to be a bit
> better. But by "a bit better" I mean closer to full frame rate in
> full-screen, but lots of tearing - and it was stil using 70% CPU when
> displaying in a window. So I think firefox is also still doing
> everything in software but may be better about using threads for it.

Sadly none of those would be hw accel without some specific flavor
of flash plugin that favors hw accel over FFmpeg software accel (i.e.,
has older flash + wrapper for vdpau or vaapi).  As someone else in this
thread mentioned, it is quite a pain in the arse.

Ironically, it is relatively trivial for me to do a chromium browser
build form source myself and enable libva/intel-driver HW accel, h.264.  An=
d say
screw you to flash et al, and leave that out.  And that will
work fine for html5 video on youtube with fallback to SW accel for VP8
based content.  Why it is a chore for Google is not clear to me...

Sean

>=20
> My previous i5-670 which was inferior in almost every other way didn't
> have these problems.. It had the same 2560x1440 display.
>=20
>               Linus

--iRjOs3ViPWHdlw/I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSL4YTAAoJEEScsp9M+IBY5vAP/iqvNG36SIrStbIb7LlYuoSl
STi5FUCXOCf4ByBB1H2w2FmmSis5Jmn8VRa27rlP13C08iHVQsUaQIsPNKkyvafk
RXrKXhr6hTMai+CuZWbCWJxQCnmr+VLzJHC6Ol285KppRv9moe/6NQ/YLV/Isfno
D94c/VaCVU4J5Z1Yk83W50nFu61iS/tKqKvWcMBU+GR3Ol8WcIg8T35CU/HI+Xyg
Q+vjEeM0gpWaPUoBcI0u/NsQrJpOcgJZml5fyKX/SNtXrsQtCcdTfdOaYDLIPsF5
LcQTGCXYnOIzqTLe0Bhf5VhMeRCH2fuwVd6NloEogSSX3G2h/OS5k7N7tlbv8DVl
ZPlcrQCpurzMbbeD736ij/XzNWX78wIE4y4+kwg19c99pafBaAK+jaV8bPRbsPtr
tVMDkoE242fulJ9KUGy4ugTnbNt9fxMbnDz4JLP3UxQaqNBiBf4YOHxRdxJvX18v
223+vBD1EP4lYuWm+WWiuCYFN1HH02Vi5gt0AA9fpwxIjrJFZJhSRvqlMdGjKQN1
Jm5vBoO+N+cHJGKwr97l6YnMXtCuKurOOzZro9DwM8tB91cbLZ26Bs4WEyxzxavt
GCDsVmx3SoBL0zxw426ZwBIJ0l4AMoRsR+c3s87uIa2KCbBhBasqFN+g1h/6TB8A
KOCDtx8TMtpvYqT+L0SH
=px1k
-----END PGP SIGNATURE-----

--iRjOs3ViPWHdlw/I--
