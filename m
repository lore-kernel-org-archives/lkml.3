Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3GXU0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:26:38 -0400
Received: from home.keithp.com ([63.227.221.253]:52026 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3GXU0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:26:37 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/5] drm/i915: Add async page flip support for IVB
In-Reply-To: <20130723052856.GD5939@phenom.ffwll.local>
References: <1374544202-15496-1-git-send-email-keithp@keithp.com> <1374544202-15496-5-git-send-email-keithp@keithp.com> <20130723052856.GD5939@phenom.ffwll.local>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i486-pc-linux-gnu)
Date: Wed, 24 Jul 2013 13:26:32 -0700
Message-ID: <86li4v3ds7.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Daniel Vetter <daniel@ffwll.ch> writes:

> Matching tiling modes is actually already a requirement on gen4+ (since
> the tiling bit and the linear/tiled offset registers can't be changed with
> a MI_DISPLAY_FLIP command).

Async flip has a harder requirement -- you must use X tiling, both
before and after the flip. Oh, and async flips require a 32KB aligned
buffer, which I'm not actually checking for. Not sure how to

> But atm we fail to check that in the common
> code, so imo better to move that to there.
>
> We already check for matching strides in common code, so with the tile
> check added we could drop this all here.

I don't see a requirement for matching stride and tile parameter in the
MI_DISPLAY_FLIP docs for synchronous operations, at least on DevGT+. Is
the common code too restrictive?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUfA4eDYtFsjWk68qAQjMyxAApYhcEHkPxMF/yo8Dt5fRqrwos2HdP5jf
Q1pMRGBEH9uHaHUGshomzTfsLZi3qyTaEqfsVhuB0Lr83jLItjyQY1s/ppoeeGn1
PCCwsXyG+pxbTKniWkxUcEyIFxHm5YgS3+BPmX7iv44nFdDdgFnDF9XOwYaSoHyl
Jj0SEJ5wTbgsrGYZsl3WRaxnsszN5xh1kzv6GVoJ8ldGOzvKbiSsIVVPr1CFeqvD
mqz7+nqeTeeviZSyIi5XI6HTeJhZCY2YicsoMIllBRA84M3GFslgF5C6zj3w+pVg
5aFNddMOgqj0Ii7EHHLSxGIB+9RbeXhp8FocEQlW8n45kIGsXnme39+x0YOm1pk6
UYiFPGCKxeao6suj8ADNju4ORVg5kXCpHqgxjVmjCD4XBSwu+EidDDyu+3T62hYP
LwX04cf5tapIlXx8Kc/ws6zQVmCHA77bplIZY7ml5N9D72Eo6vPKQq1lElQR/79Q
vYAhPw5Y061xHFlQwrSoUJZJzIQ6/Ir/nJCfL2ulyW4MrxoHoTIJNsMTZbokNj43
As6bHbnWh8H6+37XrPa6FAcX69bs/WqC5jFmAh/y/7Qb8vRkS0GfDro2uP77DEUG
j5ebvtQzjxfPexxHH3Bu8bgM8flKmO9YB1oZPbLCByx08Ycuy8/iId58P8j1eVe1
aPvFqzYrbq0=
=nONA
-----END PGP SIGNATURE-----
--=-=-=--
