Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab3JDFd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 01:33:28 -0400
Received: from sauhun.de ([89.238.76.85]:44610 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab3JDFd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 01:33:27 -0400
Date: Fri, 4 Oct 2013 07:33:23 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 3/3] i2c: xilinx: Use devm_* functions
Message-ID: <20131004053323.GB3194@katana>
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com>
 <83ec9558211389896f21d9682e9824cd7979466c.1380550490.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <83ec9558211389896f21d9682e9824cd7979466c.1380550490.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> +	i2c->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(i2c->base)) {
> +		dev_err(&pdev->dev, "Could not allocate iomem\n");

devm_ioremap_resource already prints error messages.

> +	ret = devm_request_irq(&pdev->dev, irq, xiic_isr, 0, pdev->name, i2c);

This is too early. Can you find out why?

> +	pdata = (struct xiic_i2c_platform_data *)dev_get_platdata(&pdev->dev);

Casting a void pointer?


--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSTlMiAAoJEBQN5MwUoCm2gJcP/RkSsvPNjrK3RgKAAWfHjHmU
ZSn12a/jHOfzKEr9ZHiwEsYPk/jFNVljnwDTtzXExyU8ckuG45dTRAwnZUkcX03/
w3LJsRJtrwXkT8AGLCshaclRxjy0Z45hUD2jJzJqThSH/nRdkUZNu11rbrXaPvSp
52SZOSg+nqLAXaV/l8zM2Bdi/EHgop6XGY7I0AYy5MSw52zh3yxMgxkD6a91HB5T
8DH1EF3xJIgqJ79bdeee9AwqQksgSxev83aBhV3dP5H3W6qTN8bUClZPLjzYIF1H
pAYnXylzPpVTgrJbD7X2+LoYx7j1iTwT4AfoS74SMwT+Oa7+fK9dG89j68EhBd2Z
zqAMkxURGMd44uX5hTvde+bUHVD6UckHNXgx9s4G6K7b2I6eefv0Po+/8Onnk/VF
m6MVWRH16GjQlrpdRVLMAyEmItbY5prZL+yRZfcNdHBdL2I+9Nhv5nhp9TAU0Co4
oajCUdvWzb1XN5KqfKmQprfcp9EpNF7+IthW9Yor6p119G1L9c8ydAVmR2ZGl7FP
Oz0jk7WdtH9IEEnbMEThWSwC43COMJRoAhoeFkfhIEHNTxc8vjjvgr1q9yMtIF6s
Y4QKFirG+Vzudn8YT6a9eVRQX9djzcuXHT7J00D0WzQXWHggCpe/Pm80/qziD1aZ
jpSgEir0YanuehMiE6FN
=hh5Q
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
