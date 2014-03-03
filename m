Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaCCDz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:55:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54621 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaCCDzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:55:19 -0500
Date: Mon, 3 Mar 2014 11:54:26 +0800
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Message-ID: <20140303035426.GC2411@sirena.org.uk>
References: <1392755543-28335-1-git-send-email-nm@ti.com>
 <1392755543-28335-4-git-send-email-nm@ti.com>
 <20140224015826.GU25940@sirena.org.uk>
 <530B594F.2030500@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r6fxLKBTHCmC166Z"
Content-Disposition: inline
In-Reply-To: <530B594F.2030500@ti.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 3/6] PM / Voltagedomain: introduce voltage domain
 driver support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r6fxLKBTHCmC166Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2014 at 08:38:07AM -0600, Nishanth Menon wrote:

> Intent here is to allow drivers such as cpufreq-cpu0 to be reused on
> platforms such as TI's OMAP derivatives, and other SoCs which differ
> only by the sequence involved in voltage scale operations. So, this
> patch provides a framework for registering the underlying
> implementation of the SoC specific voltage change methodology.

That bit is clear, what's very opaque from the code is how this is going
to be accomplished.

> Overall the sequence takes place after this patch is as follows:
> a) voltage domain drivers such as those of TI or others register with
> voltage domain with devm_voltdm_register.
> b) cpufreq-cpu0/devfreq drivers:
> of_pm_voltdm_notifier_register(introduced as part of patch #1) to
> register notifiers around clk of interest. This request is linked to
> the specific voltage domain using phandle in device tree.
> c) when cpufreq-cpu0/devfreq does a clk_set_rate, the common clock
> framework triggers notifiers in voltage domain core which in turn,
> invokes the corresponding handlers for the voltage domain driver
> ensuring the right dvfs sequence specific to the SoC is triggered.

So the first question I have here is what happens if multiple clocks
need to be updated in lock step - if we're only triggering off clock
notifiers that seems tricky.  The other thing here is that the fact that
your API is "of_" suggests that it is in fact linked very srongly to DT
- it'd be good to split out the layers to make sure things make sense
standalone, the DT helpers are obviously good but the API should be able
to stand separately.

--r6fxLKBTHCmC166Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTE/zvAAoJELSic+t+oim9cMcP/i0JAKgjHEbGVsgjUDypV9q1
iF7cDi5/DSCxirm9mNtVG6UbR5iy8XuYJznaHcNct5K5CGc5Eydan5+NZr556M2E
RG5G/KjNIukhvVT1eBhBm7S81uoF5wSJAsJnu/xUM9WCpJenbI7FqEEscYIMfU9o
mZJ8uHn4t9VvEnmhEwTZcg2Qyq+6vP5eooRtb0BbO7t7COPcSFAdCji6XZJ2alAk
PilOoP2Gh/ip3A7+mmMWiDvbRrfJUUkELruhDScvRwt6jY1y0HD8x5iUu1gIqRRJ
Qifu2etbCcejsSEa6DfnyjbRhRRTeL6FnJR9dHnv0qs9tzryW+DEVXYT5DvYa5oi
KkJoQaLsb2tJ1HlMmBSxtavqBz6yx2VD4t4PREWfTx+ZH6FRZOVifanSJUhggtKG
RtQduD1GAkHZwu6yRrXND1YoPz0Ihrldb08tgqxQYVBqZaN/fX6ncX3/Jpl38Cih
3EoAnm2UOSkZ1NjkeMT6ZB/ap5j6hwu4i7QJgcbrvf68J+RJAposA/5mj4OwVg3e
+thB2kaTtV1jOxi7T9mOtAff/1oOkEB+Xc1Q3E7q7t1vcV/VNmCS2St0BMffzQeS
pAiAe8OCQjHQ5TQIblrIf9SsvEmE+Du9TmpG6DwniCzAJvjL6aUr7mObanihfeeA
IMTO0jrdB42Sh6/55OMI
=PhJi
-----END PGP SIGNATURE-----

--r6fxLKBTHCmC166Z--
