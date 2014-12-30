Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaL3RFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 12:05:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56012 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaL3RFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 12:05:17 -0500
Date: Tue, 30 Dec 2014 17:04:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20141230170445.GP17800@sirena.org.uk>
References: <1418612879-16094-1-git-send-email-zyw@rock-chips.com>
 <1418612879-16094-3-git-send-email-zyw@rock-chips.com>
 <20141229172555.GE17800@sirena.org.uk>
 <54A216E2.4090504@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vpcjF8Qude6+yKQm"
Content-Disposition: inline
In-Reply-To: <54A216E2.4090504@rock-chips.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/2] regulator: rk808: add dvs support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vpcjF8Qude6+yKQm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 30, 2014 at 11:07:14AM +0800, Chris Zhong wrote:
> On 12/30/2014 01:25 AM, Mark Brown wrote:

> >So, this seems a bit odd.  What we appear to be doing here is
> >alternating between the two different voltage setting registers which is
> >all well and good but makes me wonder why we're bothering - it's a bit
> >more work than just sticking with one.  We do get...

> you mean check the old_selector and selector? I think
> _regulator_do_set_voltage have done it.

No, I mean that we may as well just always write to the same register
and save a bunch of code.

> >...this but unless the voltage typically ramps much faster than spec
> >it's never clear to me that we're actually winning by polling the pin
> >instead of just dead reckoning the time, it's more work for the CPU to
> >poll the GPIO than to sleep after all.

> Actually, it's slower than spec, so I think getting this dvsok pin state
> is safer than delay.

Well, that suggests that the spec is wrong which ought to be fixed
anyway oughtn't it?  Or are you saying that the delay is inconsistent as
well as slower than advertised?

--vpcjF8Qude6+yKQm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUotssAAoJECTWi3JdVIfQk+gH/3AwbBe0fCzP2CGNrD+HwNUl
wW0ztBBkZyn5y8K8XjH8gG1mhVxKvakNTBFbfI+mA1EsC3Z3KPyyJcDSIevHXg0N
JRrPqS10O2fDUrvffSEXJLZHziL8MseszzVkyKosSfcW4vMv2nBruamOFRHeC7hr
3kBhRh2JnRAPsaTA1HPUYx7Rgvgz4OCqmxfEMmWdWVgyVuxfNUvjDP39S6EYMoHg
JbZwQVZ2M3DKqTcqp2GAjk20S0ILRaKEG9/Y+LnbseKuHmMdhnobRjGLzk8NlCyM
l2YemLbsbIneIsbhw6C9SnDAEPKMV7P/HCE9jd4UeP3maMQ3N0jVAdkAJNZn1dQ=
=ydOK
-----END PGP SIGNATURE-----

--vpcjF8Qude6+yKQm--
