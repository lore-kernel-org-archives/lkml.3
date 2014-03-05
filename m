Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaCEGd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:33:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46092 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbaCEGdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:33:25 -0500
Message-ID: <5316C508.2000402@ti.com>
Date: Wed, 5 Mar 2014 08:32:40 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, <linux-fbdev@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/3] Reorder drivers/video directory
References: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com> <5314412B.6060502@ti.com> <531627D6.6060007@infradead.org>
In-Reply-To: <531627D6.6060007@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="HxSXmBe5hEpmEaFNg6ksOkRBjcVNlQc7K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HxSXmBe5hEpmEaFNg6ksOkRBjcVNlQc7K
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/03/14 21:21, Randy Dunlap wrote:

>> I have pushed this to my for-next branch. Let's see what happens... At=

>> least I'm able to merge the current linux-next without any conflicts.
>=20
> Thanks, I'm looking at this change in linux-next now.
>=20
> EXYNOS_VIDEO seems to be a little bit odd.  Can you clarify that for me=
?
> (This is not a change that you introduced.)
>=20
>=20
> In particular, under Graphics support, select Framebuffer Devices.
> This lists:
>   Support for frame buffer devices -->
>   Exynos Video driver support
>=20
> It appears to me that Exynos either is a Framebuffer Device and should =
depend
> on FB like the other drivers here do OR (actually XOR) it is not a fram=
e buffer
> device and it should not be listed here.
>=20
> Then once that is cleared up :), we don't need 2 levels of menu to get =
to the
> list of FB drivers -- i.e., one of those levels can be removed.

There are others. For my config, I have:

{*} Support for frame buffer devices  --->
<M> OMAP2+ Display Subsystem support  --->
[ ] Exynos Video driver support  ----
< > Solomon SSD1307 framebuffer support

I didn't want to start fixing those at the moment, as I have no idea
about exynos or solomon, and I wanted to just try to do the reorder,
without any other changes.

I agree that there's something wrong with the items. For the OMAP DSS,
there are non-fbdev related items under that menu, used also by omapdrm.
So it should probably be split into different components.

> Oh, and if you keep the new menu item "Framebuffer Devices", please spe=
ll it
> like the other entry (Frame Buffer).

Ok, fixed.

> Other than those nits, I like this change very much.  Thanks.

Thanks. After pushing this to for-next, I'm getting compile error
reports from Fengguang and Stephen. Let's see if I manage to avoid
those... This is not the easiest change to manage.

 Tomi



--HxSXmBe5hEpmEaFNg6ksOkRBjcVNlQc7K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFsULAAoJEPo9qoy8lh71rJcP/0BW6/QHly9c7AVDsU5UA/b4
EA24lrGl9dS7z7oPQHeEh0tjPOfvGGo2raZ4fnm5gGkewWSZAYHyhVjDf3HqgZEA
2wfcR7n9/Y4PC3L1ZrL1Utof4PjN3JWLUA6IiBK54xlB1rABKWjPguQP7E1EboHC
xhDKwz8f/adRHH3QVJVzkEUH2d7d/X58WuC/x02/sFlYvxl2RU15A9AdXJ/no5Qp
POw6CmUcpsfiWD5oKFWy8CprZWr2Hto45FOQEhDFHb/YmRmva8EFJFcTo3Wu72fi
T81kTNA22qEA31vIttqMxtq+9sQlAfNKN3GhzuuatIP9M63x2/y3mbVybNrRw0i1
c14Lv1JwTI5bqwpij4xJ69qWasc+1Ln9rIwBZYLdz+8Bo4ddkZOoz24oXMRaR3uZ
hy9v+lVTYNYeRpk/HhHlXeTIpqOKXhN4OKKH142fo3WEfD4l1pvdxHupr4LqgByG
5xKskmVfyUwomBHDN1eLXs3wWYe1ZPzilwlU4HzDkoPnqx8tqpRwINmG0a5/Ses/
huu6TNxzBHXG2yJtJa8sBKZ7qvsw/LG3TQ+DDt+KGNW53CS8BMoGcEW7i3YEBVr/
fTODC7PiZ5x5xa17bRntakqh6AAPwPfM9NGPEqvdzghqhB6BDJ4f+Z5K5h4D7gAk
4wzdU0SOf11FDC9N2BXf
=17dJ
-----END PGP SIGNATURE-----

--HxSXmBe5hEpmEaFNg6ksOkRBjcVNlQc7K--
