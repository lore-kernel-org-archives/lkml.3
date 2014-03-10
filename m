Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaCJRWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:22:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49172 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaCJRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:22:41 -0400
Date: Mon, 10 Mar 2014 17:22:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Message-ID: <20140310172221.GT28112@sirena.org.uk>
References: <1392755543-28335-1-git-send-email-nm@ti.com>
 <1392755543-28335-4-git-send-email-nm@ti.com>
 <20140224015826.GU25940@sirena.org.uk>
 <530B594F.2030500@ti.com>
 <20140303035426.GC2411@sirena.org.uk>
 <531DF250.5060100@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8kUASS5K4BSNeq5L"
Content-Disposition: inline
In-Reply-To: <531DF250.5060100@ti.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 3/6] PM / Voltagedomain: introduce voltage domain
 driver support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8kUASS5K4BSNeq5L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 12:11:44PM -0500, Nishanth Menon wrote:
> On 03/02/2014 09:54 PM, Mark Brown wrote:
> > On Mon, Feb 24, 2014 at 08:38:07AM -0600, Nishanth Menon wrote:

> >> Intent here is to allow drivers such as cpufreq-cpu0 to be reused on
> >> platforms such as TI's OMAP derivatives, and other SoCs which differ
> >> only by the sequence involved in voltage scale operations. So, this
> >> patch provides a framework for registering the underlying
> >> implementation of the SoC specific voltage change methodology.

> > That bit is clear, what's very opaque from the code is how this is going
> > to be accomplished.

> The SoC specific voltage domain drivers register with
> devm_voltdm_register. the fops provide the abstraction needed for the
> SoC (example in patch #5 - which introduces OMAP specific voltage
> domain which handles ABB and VDD regulators).

> What would you suggest that we do to clarify the usage here?

Probably saying something about this in the commit message would be
enough - mentioning how the registration occurs and that things are
triggered by clock frequency changes.

> > So the first question I have here is what happens if multiple clocks
> > need to be updated in lock step - if we're only triggering off clock
> > notifiers that seems tricky.  The other thing here is that the fact that

> Yes, that is true, however, there are ways to implement them, for
> example: We could implement an higher level clock that takes care of
> the multiple clock node control to handle this kind of scenario.

That seems concerning given the fact that people seem to like describing
their entire clock trees in DT, we shouldn't be putting implementation
stuff there.

--8kUASS5K4BSNeq5L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHfTKAAoJELSic+t+oim9/kUQAIUvz2655/fFegzVWJ0LDCLK
ATWtEJA1/XIFOYBnPQvHtEaoVhCGToHJZD6pzmy8rT+7D15ZYXZQbvwybTHrQsp3
A35Qms8i675kRHvvWT/1PpooKyBkJCQWQe5m/zqnR92HM/Ml/vdf+hqq6lqT8JFP
AxEUY71U5TGyFrVp1ueUcoymDCu097tFeZ1JiWCF1B3680WSG4+opUs7IdrpWhEm
sBLhpN04/XlPkfrT1tlvuwEtbnqDpUPw8Z5vQ1Mgc68U/CNweuZsJQKpZLPQsk+6
G99asrG03LO/d7tms0vqGGGgpqDcUuR3371cNRjHvaRqHI4Qsdpj8ksNqVKeoZdq
VAud/sse+++ODS6crhOG6PlJt8jgwytHS5MVCdBRk/pVTyDvvWEgVDiBKRW3nW/3
Mt7XxryqnUdPZvjsdzbb5UZ5iYGtB5oVLyUAeqoY8r51b/BWcvlPYdyxBsOn0Ml5
WUECc61s+jb3la6CxVXhulq/e+Gv+Ti1D63viVJsQGnV0B3TDSS0WHdUCMYxVbX1
MEiObZ+Uo+GMpW4GgdFxEVwXGmD5nh48ggTSY1XbXfeLRokcJcP4w+AOoCLDMccM
x3MBjFgVDTryGG/PrANkD9AQe2pOpSXoD3r9GeQVpT0XdYeDmBCpuoqFRb2XFXWI
6DbVVfLPKWVtWMZJn+LN
=K5n7
-----END PGP SIGNATURE-----

--8kUASS5K4BSNeq5L--
