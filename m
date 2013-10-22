Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3JVH1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:27:15 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:60753 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3JVH1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:27:13 -0400
Date: Tue, 22 Oct 2013 09:24:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to set fops in "struct platform_pwm_backlight_data"?
Message-ID: <20131022072443.GB8681@ulmo.nvidia.com>
References: <525F8895.5010806@gmail.com>
 <20131017071445.GA2502@ulmo.nvidia.com>
 <5260BD8C.7000200@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <5260BD8C.7000200@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2013 at 12:48:12PM +0800, Mark Zhang wrote:
> On 10/17/2013 03:14 PM, Thierry Reding wrote:
> > On Thu, Oct 17, 2013 at 02:49:57PM +0800, Mark Zhang wrote:
> >> Hi,
> >>
> >> This is the first time I send mail to linux-pwm, I didn't read through
> >> the mails in this list, so if somebody already asked this question, I'm
> >> sorry about that.
> >>
> >> I wanna set some fops in "struct platform_pwm_backlight_data". But the
> >> currrent probe function in pwm_bl.c says:
> >>
> >> -------
> >> if (!data) {
> >> 	ret =3D pwm_backlight_parse_dt(&pdev->dev, &defdata);
> >> 	if (ret < 0) {
> >> 		dev_err(&pdev->dev, "failed to find platform data\n");
> >> 		return ret;
> >> 	}
> >>
> >> 	data =3D &defdata;
> >> }
> >> -------
> >>
> >> This looks like if we set the platform data for pwm backlight device,
> >> "pwm_backlight_parse_dt" will never have a chance to be called, which
> >> means the stuffs I defined in backlight DT node will be ignored.
> >>
> >> If I don't set the platform data for pwm backlight device, according to
> >> the pwm_backlight_probe, I will never have a chance to set some fops
> >> which I need(like "notify", "check_fb"...).
> >>
> >> So, what I suppose to do now? Maybe there is a way to set function
> >> pointers in DT?
> >=20
> > Perhaps you could describe in more detail what you need the functions
> > for.
> >=20
>=20
> Okay, I just want to set the "notify" function pointer in "struct
> platform_pwm_backlight_data", because I want to tune the brightness
> value before the pwm-bl sets the brightness to hardware. I don't know
> how to do that, unless we define the platform data explicitly.

Okay, my question should have been what you need the functions for and
why you think you need them.

Thierry

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZig7AAoJEN0jrNd/PrOhJ7gQAI5+k7ucEsnu3hfCLDjvoDli
0sye8jAPKrLpAT70uPuA20xyPxvGWJg+gNfXrTMyPCjgrjvf+z3+VYIwkHPIrpFt
ePaFvxewTlJgBGVkfubkQJioWcq8bqMog0VJQlaC66+1xhOaGXx63wSVFxEI5oPu
YpxI3M51ZyB2zE4By8QFjRTXWzelfkRbIClCfY4BGLeKjFdm90qiKkjyZZybhHK+
23E6hiiDEkEYZTCyibTZeYzhpJESL9bSAh0uK2lfPyuCipR0dHA+sUr7851xGlQU
ImIbKQsUzL0QPWJMcGyA42L83rBiPYGXb69hhMr9xEj6damtVeiJAXipyQdVykEM
aJm12Yb6eLZEsTBx65e2hu+d7zOTyLbwSBR0swPLcjhxZxFdpBZCFAqj7xzmXxTi
28YWQS8KIBp+QbpP25YeHjOiONLgznuKpbYpD36CNHR4p83aeL6Vt+C/7NPc3Nde
KWhA+Cvd4kEoz/n9jdJsuLaSioXWCss0Bgc+sR0+iekBHyflAyTlWgzrzfWJgVb0
5G6s42ctfzdiZEA0mEM9NjV8ODQGa5SscaNSVuqplvbesbOmQbR74yclIwJXAlBe
Iu250CPEvf1NNsjF2kuuC1+CDl4FA49P2jlucCWzvbiiUBQlrYir6K9IyVsG+X5+
BfgvISb/P6bbTD7obdWk
=HCAn
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
