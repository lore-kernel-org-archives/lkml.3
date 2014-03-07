Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaCGOYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:24:12 -0500
Received: from sauhun.de ([89.238.76.85]:50054 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbaCGOYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:24:11 -0500
Date: Fri, 7 Mar 2014 15:24:05 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux@arm.linux.org.uk
Subject: Re: [PATCH] i2c: mv64xxx: Fix circular dependencies warning and
 compilation breakage
Message-ID: <20140307142405.GB28943@katana>
References: <20140307111858.GB12274@katana>
 <1394199795-5516-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <1394199795-5516-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


New patch -> new thread, please.

> This patch fixes the circular dependency introduced by commit 370136bc67c3
> ("i2c: mv64xxx: Add reset deassert call"):
>=20
> drivers/video/Kconfig:42:error: recursive dependency detected!

Please base it on i2c-next. I already applied my patch.
Your patch fixes the build error discovered by it.

> Since the reset framework doesn't define dummy stubs whenever
> CONFIG_RESET_CONTROLLER is not defined, it's the only sane way to have a =
driver
> that compiles in any cases.

Paragraph needs reformat. And please drop "sane". #ifdefs are not sane.
Fixing the reset framework would be sane.

> @@ -900,7 +902,8 @@ mv64xxx_i2c_probe(struct platform_device *pd)
>  exit_free_irq:
>  	free_irq(drv_data->irq, drv_data);
>  exit_reset:
> -	if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
> +	if (pd->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
> +	    !IS_ERR(drv_data->rstc))

Why don't you simply set rstc to some ERR_PTR above if not
RESET_CONTROLLER?


--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTGdaFAAoJEBQN5MwUoCm2IWkP/0Br+9EdpPTwXb6yBDl8Zt7g
qcbGp2cw7D9+n2FN0vKfCw89TZFYRDp2YrUAtRE4i/Fa9mAGbc45jyhjSekHmUOY
D6hcSNxN2wvuwUo1JkJdoqcEMBoH1gDCvtxUFdmKuyoCnb+TnO7B9q4EHqfs2SqV
Fxpq41tyPdH26zvpcfPp9OazBTT/etNWTffefURHb+szUmtIw9ZVownP6n0weGr8
CixgDhELp8Ka4A2rZIJI3EDZb9TtMGf21uEIcqZq8paMiFKYEC4RLfV9OU0IEKAM
YRmOi+6Nex1tSGcICaqGGmRR9gZNrc7Tkw4W+39J9eUQWSq6DR8S+0LV+3HjO2Yh
7Vsot+Tf8+Bn/uwe+dv5slY5t5Ab/sUcJIED6WXG6zbfurGUQRQX8GfQjJsmDWrY
RqKMUQ66jrWjm8St1mejZMX8XrIFfTALaPKFNan2CAhehpx45/ntoqE2gAJcPi7N
iP/wty1Vhd1emLxRHvFIkAz6VGbe+F0HWWXdBCORhzp+3QT/ljjZDdvdPJWg8gBf
IAjW1WMeHRjusPqkE3Hsk1QtTg1uyOpL9mttaZY9geesxHNlyCMtUuVVOGBcTxu7
hoRBuW7h3SqzMdjCNXCsp+EPHUWIclcS/HlbuZSkmOvhyPNBGTUuAKD/DpnB8LCn
vIC9865B1zjQ94Uk3ztJ
=h30J
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
