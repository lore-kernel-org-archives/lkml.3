Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaCGDXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:23:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57170 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaCGDXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:23:01 -0500
Date: Fri, 7 Mar 2014 10:37:47 +0800
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Message-ID: <20140307023747.GT13126@sirena.org.uk>
References: <1394011373-4057-1-git-send-email-k.kozlowski@samsung.com>
 <1394011373-4057-3-git-send-email-k.kozlowski@samsung.com>
 <20140306093826.GO13126@sirena.org.uk>
 <1394116942.25853.14.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MEV2wDf7tVMeN0L4"
Content-Disposition: inline
In-Reply-To: <1394116942.25853.14.camel@AMDC1943>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: s2mps11: Add set_suspend_disable for
 S2MPS14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MEV2wDf7tVMeN0L4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2014 at 03:42:22PM +0100, Krzysztof Kozlowski wrote:

> However in that case the driver won't be able later to change that value
> back to "normal enable" (enable_mask). Consider such flow:
> 1. System is going to suspend.
> 2. Some regulator has "rstate->disabled" so set_suspend_disable() is
> called on it.
> 3. The "suspend" value is written to the device for given regulator and
> it is stored as "enable" value.
> 4. If regulator is enabled during here then the same "suspend" value
> will be written.
> 5. System is suspended.
> 6. After resuming regulator_suspend_finish() calls
> _regulator_do_enable() on the regulator... which will write the
> "suspend" value because the driver cannot differentiate between this
> enable and previous.

> I assume that this may not be a problem because:
> 1. Regulator will be still turned on (the "suspend" value tells PMIC to
> enable the regulator when SoC enables power).
> 2. The first disable of regulator may bring back "enable" value back to
> normal mode.

> Am I thinking here correctly?=20

I'm not entirely sure I follow here.  Why would a disable reset the
enable value?  My understanding is that this is a bitfield with several
values, off, on always and on when they system is active.  The suspend
state is being tracked with a variable so I'm not sure why disabling
would reset it?

There is a bit of an issue if the regulator is disabled during runtime
but enabled in suspend but that's hard to resolve and I'm not sure that
it's a realistic issue.

--MEV2wDf7tVMeN0L4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTGTDzAAoJELSic+t+oim9ONgP/1x3+RTRahvA8jZ4BEPEtURb
iAKmqsatOSb9sGdJ6yZADQLrY7xTar0e5ZBJq4o2ef8kLOlJJWQb0NmQGJiZCpU/
prE8FVWBhNk7U37IQttzTOFqm9p88BQT0JXntW7dn9Z+ulS0WDFSp5C1jQAMbjVv
S+RNSgwpE9QINujOhCzugdjhOQabDPbAyIcx0MxNc6WqRJQCncgbDRHI+B1zPqk8
OpQVS2vf0bSHW6GKWPFV6Qtn3kE119b2VUoYxh9TGI8s8nBWZ7t4mZY7pvB2q0Jd
ktpihki1HiABF1BJxATd26dU0xyLcF30oR2Tf4reSv1T1b1ANgFXiuxK442Yft/X
cvLj8V4O7Hw9dJMl11g84kxbF5FWI1ogm9sCFxGQuBiVZ/PEI8735HF1EeB1V8In
p3Yx02SyS3VM/7fVk94cmvYWdCNlvXOnpcpt+vXUs8lClfSIkGepXYFdXVGCrIGf
Q9nVUwby5f+4ox4KD8znKjAixBh5cfDodIC76TDDfcRu58B15t7ecqfgTZp+Kohr
4pUDg4+Op4mI1TkgKbg5tokbJ3fzf1eP9iQst0QBpCDxSHAIaR/uS2f4RMiFagiq
X+27869LoXLYVjKu5NJsDAy1lLdI7pFBkR73Hg59z0Z2wRGFcwUNzOYdkj/X/Ffd
XDU58mm3L+32kp0o2B0t
=+qGg
-----END PGP SIGNATURE-----

--MEV2wDf7tVMeN0L4--
