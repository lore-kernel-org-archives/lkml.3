Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaHOK4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 06:56:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36578 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHOK4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 06:56:37 -0400
Date: Fri, 15 Aug 2014 11:56:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20140815105615.GI17528@sirena.org.uk>
References: <1407976814-21882-1-git-send-email-cw00.choi@samsung.com>
 <1407976814-21882-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLKz6on1ikc6itwj"
Content-Disposition: inline
In-Reply-To: <1407976814-21882-3-git-send-email-cw00.choi@samsung.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3 2/2] dt-bindings: regulator: Add regulator suspend
 state for PM state
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLKz6on1ikc6itwj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 14, 2014 at 09:40:14AM +0900, Chanwoo Choi wrote:

> +- regulator-initial-state: initial state for suspend state, cnd set initial
> +  state among following defined suspend states:
> +  <2>: PM_SUSPEND_STANDBY - Setup regulator according to regulator-state-standby
> +  <3>: PM_SUSPEND_MEM - Setup regulator according to regulator-state-mem
> +  <4>: PM_SUSPEND_MAX - Setup regulator according to regulator-state-disk
> +- regulator-state-standby sub-root node for Standby mode
> +  : the device is in a power-saving state, but can also receive certain events,
> +  specific behavior depends on the specific device.

These are all Linux internal descriptions of the states but the device
tree is supposed to be OS neutral.  For suspend to memory and suspend to
disk that's probably adequately clear but _STANDBY is really unclear.
I would suggest just dropping this without a clearer defintion, it's
something that I'd expect to emerge organically from low power modes
rather than having a specific definition anyway.

> +- regulator-state-[standby/mem/disk] node has following common properties:
> +	- regulator-volt: voltage consumers may set in suspend state.
> +	- regulator-mode: voltage mode in suspend state, can set mode among
> +	following defined regulator modes:
> +	0x1: REGULATOR_MODE_FAST, Regulator can handle fast changes.
> +	0x2: REGULATOR_MODE_NORMAL, Normal regulator power supply mode.
> +	0x4: REGULATOR_MODE_IDLE, Regulator runs in a more efficient mode.
> +	0x8: REGULATOR_MODE_STANDBY, Regulator runs in the most efficient mode.
> +	- regulator-on-in-suspend: regulator should be on in suspend state.
> +	- regulator-off-in-suspend: regulator should be off in suspend state.
> +	If node don't include regulator-[on/off]-in-suspend, can't change
> +	regulator state in suspend mode and only should sustain the regulator
> +	state of normal state.

Modes are a similarly problematic thing - their definition is really
unclear even within Linux and we don't support them at all at present.
I'd just drop them initially and then add them in as a part of adding
mode support in general.

--oLKz6on1ikc6itwj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7edMAAoJELSic+t+oim9T+IP/iLnR6bd3bWVgVMzAJnECkxt
H0G/XqyZJQph8/xd57HPJvKoPgZ43RsSPOaQ6tmbmpFmK52OgCgh9fskFiClNBgL
Q9dumqL7RE+GUXmGZKA7LclC1aRYLQovnzpk4BuDK89rC55wYRfR2ckFJwZPzwgS
uCOPM2eKrKhN4ah4AFQrbHwkSIf7bJchJoAkRyvOCtUJKV1RHqcIg0Y3b7EX/6ao
JUpSTZEzmp4JLqpIK2NUh/1L+MLtH7/aRI1+l1bVSz6skbuWabOy/BqWKEXCVP/j
9c8R6oNo0nBAN23ovDgVPKtPu3u1xy8D9Hq1ZObY4dFnL9U4ONt8QF/kODINPAhJ
tp27ghMOmbO6b59IT7XoKxqNUkZ8/oiieLJdotvynQa0sSvowu15Nbecp49Y5SFa
w/wdaS5XKsd9uPg1dIo4ODHNR5vpUJP1l6ZO4lJ0sfKZO6w42jlqcqSJ67k9xcGe
LR9TZsrjFZedcYW48uExMurIhR7akI0eR54FcDkpJhi5qLKq/6lwnQnfu74VX9QR
F7o6a0snJET7U0rqqHQpjAnG241oUqqmGC0ukafWjJvydEK+gLV+DLJAzxZ8BHEY
KeOyWvK2MtgkExME+SVX/9qJGASHU4U8tUpB3VrumKr0I+O7bWCD5t6V7kk+LDvT
v7i25OXSHSIu8BqhaQXX
=Fmil
-----END PGP SIGNATURE-----

--oLKz6on1ikc6itwj--
