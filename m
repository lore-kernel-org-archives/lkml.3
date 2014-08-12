Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaHLR0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:26:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60205 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaHLR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:26:13 -0400
Date: Tue, 12 Aug 2014 18:25:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140812172552.GU17528@sirena.org.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
 <1407861868-20097-7-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GB3+cIDl1yUQNmKJ"
Content-Disposition: inline
In-Reply-To: <1407861868-20097-7-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/6] ARM: dts: Add tps65090 FETs constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GB3+cIDl1yUQNmKJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2014 at 06:44:28PM +0200, Javier Martinez Canillas wrote:
> The tps65090 PMU data manual [0] has a table that list the
> "Recommended operating conditions" for each regulator. Add
> the information about the FET constraints to its dtsi file.

>  		tps65090_fet1: fet1 {
> +			regulator-min-microvolt = <5000000>;
> +			regulator-max-microvolt = <17000000>;
>  		};

No, this is completely broken and exactly the sort of thing that makes
doing generic device .dtsi a bad idea.  We have absolutely no idea if
these voltage ranges are suitable for use on a given board using the
device, these are the design limits for the device but tell us nothing
about the system they are deployed in.

--GB3+cIDl1yUQNmKJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6k4dAAoJELSic+t+oim9xlMP/RtGcuTvhAnZd+zi6I2ujlF0
ENDNM0PDisCkN+3+FPmznmtl3X0LqW/fieCPfns0CXN4uM/QFSubvlb/lqG4AGqB
UtDOenReZhytGDdytpPsUoV9xnGwFh2zxUh1Gi8JrrDLZAY74PnqQ/2ysdlmVm67
F8SylkoFGFHGpPyKGx4dbJLSTl+Jx4km6WFGKOgv2+ZhJw7CnkH6CIjfXDrO+O3S
P+bsWZpsxKdTGxnX4JgZFMk09JOZkidYIWYXO9amoXe+J73PFKwPdSqDBGzl7o0s
zmDXZmmJ+gCYcOezo/JyYPhVW2wfuyLq2BEdoY+XtbAcd1jUfjnCbRuWqQQEwwq5
J5d4yJA8I08TgFuEURdihya4VU0M+eNOhHtlkhfxBWMLiQmHdhLzMaxzBmQy8Tgf
oVVhHllYCojiygTurTiN9wgw9KRhLZYJzxmZ/QoyMBYqHPlMDhkSvRSA28S1VNzb
dy0Tc4br5rJY6FozYGVMYwBZqNTb+oCQVnuYKob9SF6O/GQKEk9vwR5cUp4kFdX8
YL/zcjkxB0L/SrsMqyvWo5JEBX3PrmHl0bN9/S7IDvs40UQwcwP6SpoCVuYfNqY9
VYAAIgArusTKjAVlBtUCeLhFy4l5kqljCVuE7mlfhe+Y7U96TgXeUMv66CPQTg1e
0XNu7l1Ga5qFNRMcdzjn
=cHH6
-----END PGP SIGNATURE-----

--GB3+cIDl1yUQNmKJ--
