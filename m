Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaBXFeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:34:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50590 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaBXFep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:34:45 -0500
Date: Mon, 24 Feb 2014 10:58:26 +0900
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Message-ID: <20140224015826.GU25940@sirena.org.uk>
References: <1392755543-28335-1-git-send-email-nm@ti.com>
 <1392755543-28335-4-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NIjw7+ppZq6Cg8/r"
Content-Disposition: inline
In-Reply-To: <1392755543-28335-4-git-send-email-nm@ti.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 3/6] PM / Voltagedomain: introduce voltage domain
 driver support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NIjw7+ppZq6Cg8/r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 02:32:20PM -0600, Nishanth Menon wrote:

> The current regulator model provides the basic building blocks for the
> transitions, however SoC drivers specific to each of these devices, be
> it cpufreq/devfreq have to replicate the logic for functionality.

> To simply the logic, we can hence introduce a layer that takes care
> of the mundane transition logic, registration mechanisms to provide
> the "user drivers" such as cpufreq/devfreq a generic interface, whose
> details are abstracted by the device tree description for the SoC on
> which the driver operates on.

This doesn't really provide a picture of what the generic interface
that's being offered is and...

>  drivers/power/voltdm/Kconfig                  |    5 +
>  drivers/power/voltdm/Makefile                 |    3 +
>  drivers/power/voltdm/core.c                   |  347 +++++++++++++++++++++++--
>  drivers/power/voltdm/voltage_domain_private.h |   86 ++++++
>  4 files changed, 424 insertions(+), 17 deletions(-)

...the diffstat doesn't make it obvious what the external interface is
either.  It would be much easier to review this with a clearer picture
of what it's aiming to implement.

> +	voltdm_np = of_parse_phandle(np, prop_name, 0);
> +	if (voltdm_np) {
> +		ret = of_parse_phandle_with_args(np, prop_name, "#voltdm-cells",
> +						 0, args);
> +		if (ret)
> +			return ERR_PTR(ret);

There seems to be some DT stuff going on here, is the interface DT only?

--NIjw7+ppZq6Cg8/r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCqc/AAoJELSic+t+oim99JAQAIvNUcSKJZ4qH3VU6X2AgGLF
FM0PjxD0KzEiS6YIduwO7lFodm0X45TFCwQ6XXtMpppHMMcnPK6tb9p4lVZqisyZ
dMu/9GlurCLSbYcBaG2kjmMmdaAnxzh4qNP/FySe9R2f6MATRAZ/NmNM2HSRK2QS
8+aRfk6OI0iv/qSh7q9KP4ondA0FuxA8oQ6a2fVtsz+SyfN5w5j8k30zQu5XCB8G
EpbEr9XueWiFm0zeqUMSdNO9YRYqeyk7z+uUCtN5DJ/ytUG8RNWt/ppF/h7Ss6Wr
Mlh9bzH1WkiUUcsAnXq6yvNfIbFZNxyxXKxrmYIH/5hzvydjbkqPedVnZX94eBKU
d8l+N9supzjBlKeUSRd7BcDhZ4j0gtYfkzmQ5VlShp/cac/sgShHaSx3aEXmI7g8
xY5L7JVE3K0WyCXVSQhqesfQtHWp8yUe5ErFV3Y+rhmjxEnRdetLOFiAe/BFWeZc
w/7M9J4EMgpgz59XvPK/ADNOgoDweab/s86I6XBdB4KzQpf566hX7CiCExZw4tdo
PhyvFtsfJC5Mtzd6X5OgITeP4nZjrmuA7OSiLkDXp1Km2z0Mok8YorzeRR4P49SW
fzeEwb+2QRPivAVjvzHDMD2fI8Tv9YBqe2yejfgmdsTHnvN6OkFwVaMmcxORVIcc
w0CjuzDTcDCDwNqYlPuu
=E9AS
-----END PGP SIGNATURE-----

--NIjw7+ppZq6Cg8/r--
