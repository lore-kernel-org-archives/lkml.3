Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3A2Djq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:39:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54027 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab3A2Djo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:39:44 -0500
Date: Tue, 29 Jan 2013 11:39:20 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Axel Lin <axel.lin@ingics.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: Re: [PATCH 2/2] regulator: tps65910: Fix using wrong dev argument
 for calling of_regulator_match
Message-ID: <20130129033918.GA6878@opensource.wolfsonmicro.com>
References: <1358994450.20257.1.camel@phoenix>
 <1358994705.20257.4.camel@phoenix>
 <510711D1.3090205@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <510711D1.3090205@wwwdotorg.org>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 28, 2013 at 05:03:29PM -0700, Stephen Warren wrote:
> On 01/23/2013 07:31 PM, Axel Lin wrote:
> > The dev parameter is the device requesting the data.
> > In this case it should be &pdev->dev rather than pdev->dev.parent.

> > The dev parameter is used to call devm_kzalloc in of_get_regulator_init_data(),
> > which means this fixes a memory leak because the memory is allocated every time
> > probe() is called, thus it should be freed when this driver is unloaded.

> With this patch as part of next-20130128, I see a crash when booting my
> system. Reverting this patch solves the problem.

Hrm, there's nothing obviously wrong with the code here - all we do with
dev is call devm_kzalloc().  Can you decode where the crash is actually
occurring, that might give a clue as to what's getting upset?  In the
backtrace it's in regulator_register() but that's a pretty big function.

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRB0RRAAoJELSic+t+oim9n1sP/1o4Me0X5PvFf0OW5SpjSs/m
p8K5rwBQK1uU5ShfayC7fvBXZty+mrz0+grxX5hc9AxFqZJAI9+KnqWrXG6dpVxz
+TQ1dNS6c0QwEqPOZ7pHkbwL7WDV8r/HIDAzSfzCIzNGvcEXnbPSJOnGOG7tKdlL
cEAVZ1518B3Qldw7WbywW6J5XwgkgtNaCv0Ia70vG6ycRQkKqgwzE6vQ3VNIQ6fp
b9TQua5y5qhFrE7IgwZpZ3isOpugVYko4+jAyF36CLiJmy1J3QyJOsilvJQS/eb/
hHOK+tAexMOumVUj44LIAXQ9e0nhjPxujSc4KOMrRAAEOLE1vhNJ2fplat1JHHbl
NDl4+7FhqVpqk5QzRz9QpELHOWaOUWr3eOaA+udURHrhvj9Rq/nYVNeqAA/dn03I
qCXXuXI9NI+YDES3vpfmbazCYoRfHoTji48+uopcf9+ru+VE2XyaKPLIqkdXTmcC
/N0APHtL+l/Dh4BJGE61fyF4+TDrgj/f6IgOU+W9Tfh9pLHHXYOYBo/3R6cknQU3
BEA6vUM2SJ6t7Y1K+NxFlEYiraE4lJiYXphI+R/jH821IYpAx7uRepafJ1LTQfor
QjNpd++xdoYvVsK/H/VSwMCGRNTt4FnytQTA29u3xQ9gSmVCLb+IMjmLp9NB2FBi
wU+dI6w/wm9TZ1hThbhM
=YpQA
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
