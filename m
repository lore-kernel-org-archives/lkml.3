Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaIVRNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:13:08 -0400
Received: from sauhun.de ([89.238.76.85]:51482 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbaIVRNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:13:06 -0400
Date: Mon, 22 Sep 2014 19:13:27 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Max Schwarz <max.schwarz@online.de>, Chris Zhong <zyw@rock-chips.com>,
        linux-rockchip@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-rk3x: move setup to the earlier subsys initcall
Message-ID: <20140922171325.GB1404@katana>
References: <1411370675-27866-1-git-send-email-zyw@rock-chips.com>
 <7192455.FveG5nGWsJ@xq-nb>
 <CAD=FV=VUoK8SDng6O4-VVq8UZf88b3bSe-hQMht3R2nmYXqMFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <CAD=FV=VUoK8SDng6O4-VVq8UZf88b3bSe-hQMht3R2nmYXqMFQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> In general you are correct.  You can get by with lots of probe
> deferrals.  I don't personally know of any case where things are
> broken with the current code, but it's really nice to avoid the
> deferrals if possible.

Yes, we all want proper dependencies and ordering, yet deferred probing
is the best we have.

> Given that this is a core SoC i2c bus and is used for _a lot_ of
> external connectivity (including for connecting to the primary
> regulator on most boards), bumping up the priority in the init order
> makes a lot of sense to me.
>=20
> This also matches the i2c busses of most other major SoCs.  A selected
> few examples:
>=20
> i2c-gpio.c:subsys_initcall(i2c_gpio_init);
> i2c-omap.c:subsys_initcall(omap_i2c_init_driver);
> i2c-s3c2410.c:subsys_initcall(i2c_adap_s3c_init);
> i2c-tegra.c:subsys_initcall(tegra_i2c_init_driver);

They were "lucky" to be around before deferred probing and using
subsys_initcall was always considered a hack. I am not accepting new
users of this hack unless there is really no other solution.

So, NACK, since it doesn't solve a problem.

Regards,

   Wolfram


--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIFi1AAoJEBQN5MwUoCm2qO8P/30WwuZ8atHElTOyMQEp+st1
CjKiEFQGvM9FL9Ms5iEcwvghyRp2r2tMNXoM/aScVpH+jjrwvIAbroZZSRbLO3u2
YhEC4qSUpoZL85lfqn1/1CDJErWuA/5vZQFzTxGVZNujv4jR101eQ9RkTuQ/SWF/
5Cpsi7G/UxFhXIKqx6Dg8zqEZrtyA9dMCoq3P+vLIoyv39tT0AhGqy52ika3RmUI
NT9YsFlfaljRuSC/GBP0CVUCg1RkC9QMUFO9psD1kiE2FLcay9mR+g8nIOfFvC4t
Yjqtsmc+sJoCIrbXcGem6FJ33pbmc2Teivne0tZfpjUJb56IKqxKpCla0TNMTj1h
HVw6Lq9HiN+c0+kiFVIL8CVnggdWmWKUST0qlfJSRnNuTAusZqx2KcIXpvP4/As/
1V5OtP5cn1t4QvZVHOiec0AMu325ZFUSUuVo3JDo5un+40Oruf88sTcCEk3SNK/Y
Baj2rs051yAXPNj9zu+o8NfIJPev+wl5B1SHoFW/klSpD3OtKFTBC32bSjP0DwYN
dcejTo4ylF8Kf+aNdqMCKkhwx4i8ovwH/pdwP76nmxuC97AfEa58M59UvMfeouKt
+NNv278g863auc72GIdLx9F/4JMXXDtYwnFjF5AN7rzivk5wBsjJ8NpO8VF7KbAN
JKjjgmk4NsCIZtD79u+S
=kkDh
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
