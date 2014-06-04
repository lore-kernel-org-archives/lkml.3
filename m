Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaFDKj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:39:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52916 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaFDKjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:39:24 -0400
Date: Wed, 4 Jun 2014 11:38:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140604103846.GF2520@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
 <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
 <20140528173858.GG5099@sirena.org.uk>
 <CAKohpo=T3BG9X0gHfRA-x8B3ou3Y=XHcs=OTYAHikX61iAJ9xw@mail.gmail.com>
 <20140603145347.GE31751@sirena.org.uk>
 <CAKohpo=VLCf2nz1WsL-iGw6BWwpmqZ+8JwGFFHFFtjZyAS9LrA@mail.gmail.com>
 <20140603154854.GG31751@sirena.org.uk>
 <CAKohpon9G=JdZ1jSStHZH29VZDggZXm+EOqDAwedk2K0ZxD0Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FeAIMMcddNRN4P4/"
Content-Disposition: inline
In-Reply-To: <CAKohpon9G=JdZ1jSStHZH29VZDggZXm+EOqDAwedk2K0ZxD0Qg@mail.gmail.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FeAIMMcddNRN4P4/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 11:16:37AM +0530, Viresh Kumar wrote:

> - But for platforms without regulators support (CONFIG_REGULATOR=n),
> regulator_get() will return NULL (a valid regulator though) and
> regulator_set_voltage() will fail. Because the platform doesn't care much
> about regulators it must go on and change frequency as if nothing
> happened.

No, approximately none of this is true.  CONFIG_REGULATOR tells you
nothing about the hardware, it tells you what someone selected in the
kernel config.  There is nothing stopping anyone enabling the API on any
platform, and there is nothing stopping anyone disabling the API when
building a kernel for a platform which can do something with regulators
with CONFIG_REGULATOR disabled.

Please, go and *think* about what's going on here.  I've repeatedly
asked you to consider the case where we need to raise the voltage prior
to raising the frequency for cpufreq but you've not responded to these
requests either directly or in showing any sign of having understood the
issue.

If the code fails to change the voltage it needs to handle that
(including remembering that attempts to lower the voltage fail); if the
code handles the errors sensibly I would expect that to handle
everything.

--FeAIMMcddNRN4P4/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjvczAAoJELSic+t+oim9AEMQAJVEwGI59MNoz7sFpAYba7Lz
3PJUK+QsWIXiMzvikzSbf9Cc7+JvISb1vRywEvTCZlGhvODXd51tTQDCZw7aIKFn
wgN/5c5rmIzekqz+hrCpG4E2LHmL1QQ+x5gIzecWak38PL8AlSil/TsEOo65GZ9Q
06gQHctBK64yhPywpKkVdfDr7ShlWYe0+9BFYTi0DzArglR2XaIaxwFryMY66ivo
kW/TofAt84eV/KU1rRIsFnz5HUzxn+Id+tSg8yjOOw3pix3AmffLnJqZCPXyF1w9
3pwIlJu/MyCaLtCWBJy2HzVxDL8y4IfL45fcqoBqz+hzZ6UGm0c6iP2UVpjvW11+
xAmUOZSTN7oBRECeSf4/IyH239UM7LuHTUrHRF89Hg7DN4ALFhAgSUacOiA+XidM
KU3XnOqf0aOwFr6kSdr8tDFgLuF9Xwo+ITYsEX6fzy4NqbE0kx0fM0EpUVtXz6rn
xz94BVsxtgSnayMexg2Q0D0+EXZiLSf/XTveGJwP8YH4T1bpv0iGVdPu02gMifLQ
rwJZ3gFeSGKRaYB6Rs71zIwy2x5m/+ZUUAgBUTrldS4GBRfnvE/HikN/cjh2zPlZ
VE8e7gv0ke02Cy9yfMM6Iy/u0sCEIuO/Y39+g7u3JLl75QFLLoXb2NNellQT9XEP
w8LHe0tKQJ5oo4T3EnuS
=J+fe
-----END PGP SIGNATURE-----

--FeAIMMcddNRN4P4/--
