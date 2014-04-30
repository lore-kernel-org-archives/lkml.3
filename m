Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbaD3SDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:03:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53078 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaD3SDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:03:46 -0400
Date: Wed, 30 Apr 2014 11:03:14 -0700
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        sbkim73@samsung.com, rdunlap@infradead.org, dianders@chromium.org
Message-ID: <20140430180314.GA3245@sirena.org.uk>
References: <1398243705-31151-1-git-send-email-tushar.behera@linaro.org>
 <20140424133920.GA12304@sirena.org.uk>
 <5359E18B.60600@linaro.org>
 <20140429222915.GU15125@sirena.org.uk>
 <5360E5E7.8090807@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <5360E5E7.8090807@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 96.24.72.52
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] ASoC: SAMSUNG: Add sound card driver for Snow board
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2014 at 05:30:39PM +0530, Tushar Behera wrote:

> XCLKOUT mux register (0x10040a00) is not part of core clock SFR range,
> rather it is part of pmu-system-controller node.

> One option would be to add a clock provider for XCLKOUT. That would
> require me to extend current clock driver to get the
> pmu-system-controller phandle which in turn is dependent on the patch to
> early initialize syscon driver.[1]

> Will it be okay to configure XCLKOUT in snow sound-card driver by taking
> the phandle of pmu-system-controller from device tree? The
> implementation is provided below.

I can't think of any reason why we'd not want to have this visible as a
clock?  Ideally we don't want to have any ASoC specific clock APIs when
we're done, the reason we do at the minute is that the clock API isn't
available as standard.

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYTrZAAoJELSic+t+oim9oUYP/2pJyGSWadsihsAISnlYXZw8
XDUmpFDNf8XQCOn6RyiY3vZdeQtnVkmmuMCIoKYJrLdnddHu/yrN6KQ5nx8TQyME
bpomOqs5cJ6BcIQ8AGIaDTqimGZ4kIP6I+H9t3MLOuET2mArmJNJnMcj/TRKAhYL
/edSQNcx+vpJYJU3h3MYFYSqQTt6DRBb1IG0CzegJ5IfOdSCFhwr0wut/2m727rn
GKwQyPmV7YySyodFF7WEhJweYchEdWPbK7vMGRCfwSH2TSvlGEilIvsgiNvMXZiX
H5CWk1KFfMEUdcHz2VxfBXwq7CjvMWjdS4RQBx73JpOyjHOopr9CJgnVXqKakF1I
o0Sq62i0HpQk+o/e3BNmUyDsmo99ZDRTVj6LnMDAkZZ5rSfO06qVIQMQ4tHnCplR
dlhEyqWkbNwX2Hhd1kftfiwQm9alvao7KhoPmZ1eNF78JO8a+NrG/xV4GG+H9xBU
Ajs537yybrZAnPEKo3uLB46MU3G7SF3Mza1a/IJSvDBYl3XbxHb5rGXViiEVlrb7
9euCrxfRf5C2LABWHw697YVljXy4jU5I2Ld17NVWBYlR8GXWU7fJ3T/imoprZWKW
l13YzgUEhQ6QU2JJ6eH4SjXMOWql4oVxD7EZuUdrmXfxE7mUiCyxJLU2BB2z/WgX
zjdX73g/rxlN1qTn5uXx
=2ALA
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
