Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946341Ab3BHLq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:46:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48748 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946292Ab3BHLq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:46:57 -0500
Date: Fri, 8 Feb 2013 11:46:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v3] regmap: debugfs: Add a registers `range' file
Message-ID: <20130208114654.GQ8879@opensource.wolfsonmicro.com>
References: <1359720339-14862-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="glwmnIOgU1tcuP7N"
Content-Disposition: inline
In-Reply-To: <1359720339-14862-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--glwmnIOgU1tcuP7N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 01, 2013 at 12:05:39PM +0000, Dimitris Papastamos wrote:

> +struct regmap_reg_range  {
> +	unsigned int start;
> +	unsigned int end;
> +	unsigned int attr;
> +};

> +	i = start_reg;
> +	while (i <= map->max_register) {
> +		reg_attr = regmap_attr_bitmap(map, i);
> +		switch (state) {

We're doing a linear scan through the entire register map here in order
to build up a list of which registers exist, doing it every time the
file is read.  This data structure looks *very* like the one we have for
the reads themselves, it seems like we should be sharing the work here
and using the same cache.

--glwmnIOgU1tcuP7N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFOWOAAoJELSic+t+oim9TcYP+wZUyeA8xD81kPaeBkhjeRPR
vj7HlknsGeHtmNReW1Z/8OONCG83uS/HnbLWhCc34SxfWYszFbfZK6rtngKePXeh
2hpeymbmX7ARrf3GGLrzqw3XUUbl/UhOd/wr2OnjZGUOax+LD3gO/ji9ze58W21A
JeMRGMqxk7lSaALgmqWHeImOY2krIbxE1Y3WlURf45ypyhlwFDqMjvdJPo34SgtD
WI7+B8//xXu6J5Ovlg7XABRuUfFu4ekV74T0K1Tpeks4G7QpOkmKBo+sZYLT7STJ
W8dR0qU7Vuz862B4TC9YPpKjYsYKLeIUmMvOD0Px/haEHtBJLfxjQ3o2qgQ1QtCz
gdZtTX0d9TFN4m9ixDV8KQZEXwtMNBdUuYUJD8aT7CmprNPhu9z/exjZfMlfzFcf
utxfl1388q0t+8RPBsTJA1olwVlFXk4QeoscgYE+GYemJQ5vmMgzQQGPmTrYadJF
+QtvhX6rtPRl+lQPOOGdh4Pqsx8e3Cz5LR0TAkIhvmAjDhamieZqnsF8P1yU8Rvt
MESkJwsSkbcAikj9WmLXDYFbSk5JVUMBXZk1vHw0ZTCwL4517BLWPlXQaCF/JNCX
xaKiVqsMQwRp4n4WYRf4meMBZ4xTg0YnXhmwpZ1/PX6lGmO7AeagTwNJQ+0BMcCB
Id8jKYN8Z2yzuPD8aEUv
=xDLR
-----END PGP SIGNATURE-----

--glwmnIOgU1tcuP7N--
