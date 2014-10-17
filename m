Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaJQNzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:55:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33318 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaJQNzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:55:08 -0400
Date: Fri, 17 Oct 2014 15:54:41 +0200
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141017135441.GR1820@sirena.org.uk>
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413478133-2577-6-git-send-email-javier.martinez@collabora.co.uk>
 <20141017115701.GE1820@sirena.org.uk>
 <54410DF3.5020005@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MI2pJyvBeFc4alSb"
Content-Disposition: inline
In-Reply-To: <54410DF3.5020005@collabora.co.uk>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/7] regulator: max77802: Document regulator opmode DT
 properties
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MI2pJyvBeFc4alSb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 17, 2014 at 02:39:15PM +0200, Javier Martinez Canillas wrote:

> Just to be sure I understood correctly, are you suggesting something like this?

> 	ldo1_reg: LDO1 {
> 		regulator-name = "vdd_1v0";
> 		regulator-min-microvolt = <1000000>;
> 		regulator-max-microvolt = <1000000>;
> 		regulator-state-mem {
> 			regulator-on-in-suspend;
> 			regulator-mode = <MAX77802_OPMODE_LP>;
> 		};
> 	};

> In other words, extending Chanwoo Choi's original suspend state binding to add
> the regulator-mode property that was present in his v3 [0] but instead trying
> to use the standard REGULATOR_MODE_*, say that each regulator driver should
> define it's own device-specific set of modes and a do the translation to fill
> standard modes in the struct regulation_constraints {initial,disk,mem} mode?

> That way adding new suspend states, will only require changing the generic
> regulator binding but not the regulator driver specific bindings.

Something like that, yes.  Not sure if numbers or strings are the best
way of doing the mode but it probably doesn't matter too much now we
have preprocessor support for inclue files.

--MI2pJyvBeFc4alSb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQR+gAAoJECTWi3JdVIfQoSQH/3lXRw4+iCyGgZClCg0e7a0W
xGCV3VR+AYf7e29nrWWnwkTQcRvvMYXN2DxeblRwhhv/iyvXqVODtHMDU1MGcKMH
Uki7sSfZDW9/9FYeDROkYC5cxcMBSaJ7Nyf3Y83nUBFAuwioxpzplOkKHL9loq9O
+atFDxJdWDWlOODtPc3W5i/JxDpkNd0CwQlqARMPJXXV6FMlnFdIS5yAswa8RnBA
tQCWzgPTw+7SLQrJosuckGlkS6kq/DQU3Y1UUZeM5Thnfv43oXSdiCRlE3QxX/tM
ExBfyLtxMUHL+ooY8IBoJJJHs2/Daqr3S+Dpu/JV3YqS56u7mBoskWwX0dxrr0A=
=oMc+
-----END PGP SIGNATURE-----

--MI2pJyvBeFc4alSb--
