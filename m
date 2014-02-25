Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaBYLf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:35:26 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:47361 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaBYLfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:35:25 -0500
Date: Tue, 25 Feb 2014 12:35:21 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: sagar.a.kamble@intel.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, "G, Pallavi" <pallavi.g@intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/1] drm/i915: Enabling 128x128 and 256x256 ARGB Cursor
 Support
Message-ID: <20140225113520.GA723@ulmo.nvidia.com>
References: <1392718186-12453-1-git-send-email-sagar.a.kamble@intel.com>
 <20140218131333.GR3852@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20140218131333.GR3852@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2014 at 03:13:33PM +0200, Ville Syrj=C3=A4l=C3=A4 wrote:
[...]
> Once we have drm_planes for cursors, I was thinking we might add some kind
> of enum property that lists all the supported sizes for the plane.

This comment was intriguing, so I was wondering whether you could
elaborate a little on this. The reason why I ask is that we have a
fairly similar issue on Tegra, where recent hardware supports 128x128
and 256x256 hardware cursors, whereas older generations support only
32x32 and 64x64. Also very early generations don't support ARGB cursors,
but a somewhat funky pixel format (2 bpp, background, foreground,
transparent, invert).

With the current set of cursor IOCTLs it isn't really practical to
support the legacy kind of cursors, but representing the cursor as a
plane would have the benefit of attaching a number of supported formats
as well as resolutions to it. That would make it a whole lot easier to
support these additional modes.

As for the supported sizes enumeration, how do you intend to handle the
correlation between horizontal and vertical sizes, since an enumeration
property is only a single 32-bit value. I suppose if we limit ourselves
to supporting only cursors with 64Kx64K we could stash horizontal and
vertical dimensions into a single 32-bit value.

Also, is there a plan to add a type field to the planes so that
userspace can determine if it's a proper overlay or a cursor?

Thierry

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDH/3AAoJEN0jrNd/PrOhk9IP/jXk1LRT8I4M1mHBXiD3syL8
AYiblzPMjjR+oU6FsQQwM7mf/RHk2B5jIQgjgI8K4NriU5lhA4/6o0DRjVv1d7DH
29h2qIodOpjXJg7b2KRf2biVArEiZS5vvF8AZc90qAKky847BT9ylAMk4i3/f2l3
GsHuQMiYUwlKT6MPA1le744bJrChW8yPFfN+yDpbGui5sWt/8MjqPuVhYgtp0m/O
IoUNgpOVLdOFhkQDIMUu+V8aDxI02szAxIIOKTpTsQ/C5LoFfzrHw5X6eGXzvcF7
D/cKJ7YyKwg1gtLLlSnSHAvE/La2a7IMEVd+/lHm3vrhvcrhyqXetJjnszElZ20q
0Vqpca6WA/+hBzY2fwVV469Kd+7tqglkDEsTt8GeLnT069Sse5bTJ5wbDDphbmhc
2YoTtV86/JIncuP3MBYraN4hsIm2PxM2DRf2XhLLZvbjztkt2hV2VGiuJKYGcJ7y
pc0IGit0Ezf47lnOWAK7R3kQJMsCY00NVZBwAIkcEHL+8tsj6ye/Kgpsm+/YoasP
3Oxlar7w3B95RcRxzN3UJELO9c2Gwn9+N9vbMcDczfrMGktg79mTRgQ7irgWsR88
fKcgd5TYRRcNTo6trXnM9j1Gv+xTsROJ4uyaTMbC7xYcEwwHefQ7OW2obf4wOBff
FT/WDCNzkEh1ikIbAeDo
=DftP
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
