Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3AMXSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 18:18:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58059 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756142Ab3AMXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 18:18:42 -0500
Date: Mon, 14 Jan 2013 08:18:37 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: andrey.smirnov@convergeddevices.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [regmap] [RESEND] Add "no-bus" option for regmap API
Message-ID: <20130113231836.GJ5041@opensource.wolfsonmicro.com>
References: <1358024054-9895-1-git-send-email-andrew.smirnov@gmail.com>
 <1358024054-9895-4-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZVh52eu0Ophig4D"
Content-Disposition: inline
In-Reply-To: <1358024054-9895-4-git-send-email-andrew.smirnov@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZVh52eu0Ophig4D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 12, 2013 at 12:54:14PM -0800, Andrey Smirnov wrote:

> +	bool cache_registers;
> +

I'm afraid I don't quite understand this...

> -	if (!map->cache_bypass && map->format.format_write) {
> +	if (!map->cache_bypass && map->cache_registers) {
>  		ret = regcache_write(map, reg, val);

...I think it's mostly to service this check here, but looking at the
code I can't quite think why the code is doing what it's doing - I
suspect we should just remove the check for format_write() here.  I
think it was there to support potential bulk writes from the cache code
(which we don't do yet) but we're not actually doing those and it's not
clear that this should be doing that anyway.

>  	int ret;
> +	void *context = (map->bus) ? map : map->bus_context;
> +

Can you please make this a static inline regmap_map_get_context() or
something?  The same thing appears in quite a few places and the terery
operator isn't great at the best of times.

Otherwise this looks good, thanks a lot for doing this.

--YZVh52eu0Ophig4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ80DEAAoJELSic+t+oim9Y7MP/i6oE7xwLcbnPPS/Dv1fNd0U
BvYDhQiO8NIcW29L/Dv3dkUF5sE1y40YGbZqXsg1zqJ/7jUk1wYyneUXYMSGwu0P
lyRdqJ2+jnTjZf0C59+jxFXVapCzltdJfhPmNGvVQ+TRursciSx2D5cEXqHemQJy
FKQbK+YFgSFVxgdvLk/VugrN/7mNu81pJkxw469udO+zJP5kV8r35ivFEjj+1paO
iWdfasnYzceeGn5RZqW5Q0j9JzimTsePAhZWkU7MIGwsQdsoPnt1UbtXGpxVW7cn
w5Un3iKsHnn65Odv2QgFA9bNFHI+prKslVFrcw6kS/4zqcE/U1+n/aMTlt346Lbw
yx5YF1nP/8c9WrNWq2TuDuDVGnPkdAvK/VJdsMGApr+Sc0CwI40tu3HxH7I1YoZ/
xJP1fkn5vSfHxaweuyb+4GJLwqsB0jYJ5CqyifkqthUiN6xfBlbMuhOIP327tf14
yo3wTzwl/PsHKPtFdqyo/NgKbhBdt6WFPWf+LbiTmCFpklefgCPyXeafUcBvrgEu
g5gprQ7eQxSrmDGjVFvbCzStzWRGbFpczEozd7z9LiEIFlK2t9jYoWt12qrs5s5R
HFx2z55UIwCCd8/j8F5SGTMNQt/h0HZsaZNFa3rzFLgUGROOmNPvpuoeC5ES+OQc
wzn77WGxUCK0A09NgAYo
=x1XJ
-----END PGP SIGNATURE-----

--YZVh52eu0Ophig4D--
