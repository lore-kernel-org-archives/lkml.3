Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3JWICl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:02:41 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:64711 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3JWICg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:02:36 -0400
Date: Wed, 23 Oct 2013 10:00:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to set fops in "struct platform_pwm_backlight_data"?
Message-ID: <20131023080002.GB7404@ulmo.nvidia.com>
References: <525F8895.5010806@gmail.com>
 <20131017071445.GA2502@ulmo.nvidia.com>
 <5260BD8C.7000200@gmail.com>
 <20131022072443.GB8681@ulmo.nvidia.com>
 <52663D6D.5000806@gmail.com>
 <20131022124905.GA24255@ulmo.nvidia.com>
 <52673178.8070805@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <52673178.8070805@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2013 at 10:16:24AM +0800, Mark Zhang wrote:
> On 10/22/2013 08:49 PM, Thierry Reding wrote:
> > On Tue, Oct 22, 2013 at 04:55:09PM +0800, Mark Zhang wrote:
> >> On 10/22/2013 03:24 PM, Thierry Reding wrote:
> >>> On Fri, Oct 18, 2013 at 12:48:12PM +0800, Mark Zhang wrote:
> >> [...]
> >>>>>
> >>>>
> >>>> Okay, I just want to set the "notify" function pointer in "struct
> >>>> platform_pwm_backlight_data", because I want to tune the brightness
> >>>> value before the pwm-bl sets the brightness to hardware. I don't know
> >>>> how to do that, unless we define the platform data explicitly.
> >>>
> >>> Okay, my question should have been what you need the functions for and
> >>> why you think you need them.
> >>>
> >>
> >> If I understanding you correctly, I suppose I've said that: "because I
> >> want to tune the brightness value before the pwm-bl sets the brightness
> >> to hardware".
> >=20
> > Why do you want to tune the brightness value? What are you trying to
> > achieve?
> >=20
>=20
> Oh, Tegra has a feature named PRISM(aka SmartDimmer). It changes the
> color value to make the display looks bright so that we can reduce the
> backlight brightness to save power. So everytime PRISM is triggered, we
> call "backlight_update_status", then in the "notify" callback, we change
> the brightness value which pwm-bl provides by considering the PRISM
> compensations.

If you automatically call backlight_update_status() everytime PRISM
gives you new data, can't you just pass the correct value in in the
first place so that you don't have to tweak it in the .notify()
callback?

Thierry

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZ4ICAAoJEN0jrNd/PrOhZigP/RG48hoAQj1DJb8znndLZZh6
nwsgfbLaeiAepUOcldS0BUOMfZ0e1mi6lPY9Vwiy6tCB32mRV7CxJgMWlbRAUVFk
Ot5D5YLOHkWqvBRUTsFxN2Ihrfprtlgp4ThRE4FvaPu4MDv9ScoKjlJqPb11yAbU
2nwvuscK51edNTlwTywTaUMBO1W1DWULewoJutJbciIKJgYAkpfliz69gvpU0W+D
/TWY5OOPKzNo83YJKEMMMxmQbKcDOZeAE5nZGOMBNZmy7NYmTxkr6MvNBkbbZLMZ
19zBmZVC1rpR81kdgQmngu9Bvg8bepluKjUeIArcV0OU1h4YJ6sXt3ni+zXh73/3
zuoyKomXG7/AZYdH7AjrC5rvaFLLuigUDYUbgq3p5+nCZQgaFPAbi1TOBpDxwyZ9
ktj/aV2x3OJHBE0p/p9GIc78/NT3j1KtqaBsTRNe1BYAZblsj5hApkOlFcoL5F/m
5wq+zYh+9vtAlGhxaLQ0cz2x1rp3R4n2pKd8d3tsYqPu9de77BppBsA6x7K0yqIp
SiT2+VBVFHWGyTIVn9UZJy1pslF0X+9RzJU5Q59avcchUewqPYRhqBEjntuNUHkP
jXlhhmz0bKFlz4wzrL2t65UNJVsqi0jfKNVNEJ7HPc+eIk4t1urU6yCuTz/yx+FK
FFUX4TGP6dc1/j6PjynN
=4PuB
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
