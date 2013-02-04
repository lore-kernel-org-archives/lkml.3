Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3BDTl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:41:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37669 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833Ab3BDTl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:41:27 -0500
Date: Mon, 4 Feb 2013 19:41:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/73] regulator: core: Show consumers that hold a
 regulator in Sysfs
Message-ID: <20130204194125.GW4720@opensource.wolfsonmicro.com>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
 <1359978868-28736-13-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Wg5Vd7si6EhrIHA"
Content-Disposition: inline
In-Reply-To: <1359978868-28736-13-git-send-email-lee.jones@linaro.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1Wg5Vd7si6EhrIHA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 04, 2013 at 11:53:27AM +0000, Lee Jones wrote:

> +	int use;

Better to call it use_count like the other use_count.

> +	list_for_each_entry(reg, &rdev->consumer_list, list) {
> +		if (!reg->use)
> +			continue;
> +
> +		if (reg->dev != NULL)
> +			size += sprintf((buf + size), "%s (%d) ",
> +					dev_name(reg->dev), reg->use);
> +		else
> +			size += sprintf((buf + size), "unknown (%d) ",
> +					reg->use);

Should really check we don't go over PAGE_SIZE, and since this isn't a
simple value it should go in debugfs (a simple count would be OK in
sysfs, I'd suggest adding both).

>  	if (ret != 0 && rdev->supply)
>  		regulator_disable(rdev->supply);
> +	else
> +		regulator->use++;

This will increase the usage count in the case where we get an error but
don't have a parent supply.

--1Wg5Vd7si6EhrIHA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREA7fAAoJELSic+t+oim9bl8P/2hY8/pn4uPMDprnDm/temsR
9pRHhgGkPRBkeZgB0+kpvX2p9XlYdCOxcO9pIGbVhgpe4z96fQ6etH+Af7RTnYQS
6hz5MtX9TAaDhQ6SrU4MxlOwSr2lM0BGnjbM464L07t9vSFmFANVL7sLM9G+QXqx
eQeNz2dUcTZY8i8OwLzvoZPX9bBHfDi4vKn3gF6ASlqARz5woTJB9LDPADFO3lmx
dAm6JNGxgijrI4aKNYi2dbf5fnqjb0X+c5u9/WTJP3VlsahsVQ+MJV1xCelkpkrZ
T1bWxzbpFBPDsFJTxsnOU2Y+iTkIsPfCTrUeENDg7X+MZHinrtdYcba16X4JFMFB
7FrzwTSndK/Tty3ntmjOZWFce0BLEa0D0xe+aI10IqvpvFGgC2PX5fL7csLwdGPt
AQmDN0DkAFPwJi3peJSGJ3c64PtYLXvW8Gm51Ilex9KtdvEa6LwwOylFYLy5nroa
anoxWqsCqdaNcnaf4/KjM3WWiDdfX/wBMATqAqK30XlQADvAJP4EbUO6mgCkRBLB
ZhBPhiXUdgG0pHmPYrklstOwwOtNkcJgz5LXsKk540jtO4mKhE8RiLB8jQAAHEzf
uuyeU9svU7z/fxExYaOh+E5rIg1mV62X3Y4dZpd4z9GqtR+fGJo1Cu+1naink3SF
G0Y7B1W9rvJAJvVKnIHg
=ctZy
-----END PGP SIGNATURE-----

--1Wg5Vd7si6EhrIHA--
