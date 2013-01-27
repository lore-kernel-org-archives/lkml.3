Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3A0GKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:10:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38298 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727Ab3A0GKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:10:48 -0500
Date: Sun, 27 Jan 2013 14:10:37 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] regulator-core: free requested GPIOs and manage
 the enable list
Message-ID: <20130127061034.GC8952@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E12B3D@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E12B3D@DQHE02.ent.ti.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 15, 2013 at 04:35:50AM +0000, Kim, Milo wrote:
>  The regulator_ena_gpio_request() allocates the enable GPIO and add the list.
>  Related resources should be released if they are not used any more.
>  To free requested GPIO and remove it from the enable GPIO list,
>  new function, 'regulator_ena_gpio_free()' is added.

Ah, sorry - I hadn't realised this patch had the cleanup code.  This
needs a bit of an update - as I said for one of the earlier patches we
need to reference count to make sure we only free the GPIO when it has
no users.  With this patch we will free the GPIO when the first
regulator to use it is freed which might mean other regulators are still
using it.

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBMS0AAoJELSic+t+oim9hMQP/27AyHCeauBLlBtUFDYFc+IC
sJbifx3R5wWsKN82QUB74BwAfRXVhppHlENtHvZzkb0hBi+5i5d5UkyJht96WZtJ
GC+ZH5dTW1iIJzIU2/feDbTDTeWnriiGN60h1FRq86kd2Z1YU/jhY4VLXt4sBwXu
1gEHl69erAszPNJLMlj4fxv4P8OlaDHo37RqNKjXakWLSHnwIUuDF1tCF3izqSFf
J6dN66QrEh4FOYgoVXv1qVTeGifWF/NZHHfdfPHUsXaA9lCFa1cqSActxfC0Doh8
wzvMtLm4WZzuyrx7NKExhlpqq/eLYYa3ocNYzpdamuMZvdm9R4kqDe+7MxCYw9BA
mqqgIUnIpLEdnFfcsH9Av4UU/+eJDtauoSTNo+DjtiFCKPmvL6gvD+Dre6QI0Btv
xB10ReLW1VT9lJLbTFvxzJyndeKXg8FNmLIHiQrfuJmblQNrZygYyg5QPI3Y5y3/
3745fYRNQv/I94svuIkjSBcIahrmrmuZh3XaYKvtKBkdNztEyjmN4HlJCUNivWIG
4LT1bEqFPz3qnPD/Kw6vz/ekQUk7JG22B401db9zHAeVOGQuh4TjVKW7tesooULX
+xCsOVzsL17G2jKZ+fBa9Xo4ncY10eKpcw6TCFK7T0KGw6fthMR2vNSMxRzNUlxj
xoYDbwOXxkChNdO9ozSU
=wjRU
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
