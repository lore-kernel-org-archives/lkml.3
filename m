Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3JQHRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 03:17:09 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:59696 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3JQHRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 03:17:06 -0400
Date: Thu, 17 Oct 2013 09:14:46 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to set fops in "struct platform_pwm_backlight_data"?
Message-ID: <20131017071445.GA2502@ulmo.nvidia.com>
References: <525F8895.5010806@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <525F8895.5010806@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2013 at 02:49:57PM +0800, Mark Zhang wrote:
> Hi,
>=20
> This is the first time I send mail to linux-pwm, I didn't read through
> the mails in this list, so if somebody already asked this question, I'm
> sorry about that.
>=20
> I wanna set some fops in "struct platform_pwm_backlight_data". But the
> currrent probe function in pwm_bl.c says:
>=20
> -------
> if (!data) {
> 	ret =3D pwm_backlight_parse_dt(&pdev->dev, &defdata);
> 	if (ret < 0) {
> 		dev_err(&pdev->dev, "failed to find platform data\n");
> 		return ret;
> 	}
>=20
> 	data =3D &defdata;
> }
> -------
>=20
> This looks like if we set the platform data for pwm backlight device,
> "pwm_backlight_parse_dt" will never have a chance to be called, which
> means the stuffs I defined in backlight DT node will be ignored.
>=20
> If I don't set the platform data for pwm backlight device, according to
> the pwm_backlight_probe, I will never have a chance to set some fops
> which I need(like "notify", "check_fb"...).
>=20
> So, what I suppose to do now? Maybe there is a way to set function
> pointers in DT?

Perhaps you could describe in more detail what you need the functions
for.

Generally you're not supposed to mix DT and platform data. Without more
info that's about all I can say.

Thierry

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSX45lAAoJEN0jrNd/PrOh27MQAKzXkIAA16rGqivlJHQAaGTb
GownGIn9NIAfc2vKVnUK1omHe9kcYMojehJwvU58AC4yQL9nRyQ0ogwM6aywBjOD
Dv05clJ9CzNcfIOcQXx6cTgqrwIEtSV0aVuvwTARsAyYuiOJEqJ7qQbC3doQlB6B
7DdSQg7TN1tPYiswHpYy0qHHX44EKmdXVt1D6NOm68HziHjm0ZdPINfYF/egucCj
jgAHEHLvJH6OlBn3kn9FvmwnUItmqTxuYmp8BN76l3txfXevhNf6CDhJs/5VTlVD
Cx5pIxU9GXMhRp19omzrnIPdl8pseWIwxbylrGTaa2HUl++kjU9RHq/NwVG2ttmx
9k4jDgqQapyMHPFvYYSwDxbm0fRaUbdklt6N23iSBGoXRDeWKQA2+yb64O3wBtPK
8WEbrNrydbf8Gjep/AUNTzObzrKFUw4AScY3sa6MeFMabJxgCoUUgzgjxi8Wvxu4
weimHtxl/3jRZ5tJ4w7IKY1z/Bkdra9xWFnz9ntxbrFDxaS8pteNI4P9oC+NwzrB
hohvnk03RyphGfAE++Djpn5zoKds3qMIcWTsxbNrrllwQTOwruDRAyM5656XWESY
n8VRg23BP4DZghE7zGf3SsU8ucBxMIcILFKFXiP+b95bOlBdl0iJhBkFxPLFxKnh
bLe2d58vauGSwwurxIxG
=MbB3
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
