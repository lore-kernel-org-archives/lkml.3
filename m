Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaFRWAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:00:17 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:51301 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaFRWAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:00:14 -0400
Date: Thu, 19 Jun 2014 00:00:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
Message-ID: <20140618220008.GC26514@mithrandir>
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
 <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com>
 <539F4D44.3070309@wwwdotorg.org>
 <53A03186.3040703@collabora.com>
 <53A069B6.6070902@wwwdotorg.org>
 <53A1CB23.5090307@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <53A1CB23.5090307@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 07:23:47PM +0200, Tomeu Vizoso wrote:
> On 06/17/2014 06:15 PM, Stephen Warren wrote:
> >On 06/17/2014 06:16 AM, Tomeu Vizoso wrote:
> >>On 06/16/2014 10:02 PM, Stephen Warren wrote:
> >>>On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
> >>>>+#ifdef CONFIG_TEGRA124_EMC
> >>>>+int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned
> >>>>long rate);
> >>>>+void tegra124_emc_set_floor(unsigned long freq);
> >>>>+void tegra124_emc_set_ceiling(unsigned long freq);
> >>>>+#else
> >>>>+int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned
> >>>>long rate)
> >>>>+{ return -ENODEV; }
> >>>>+void tegra124_emc_set_floor(unsigned long freq)
> >>>>+{ return; }
> >>>>+void tegra124_emc_set_ceiling(unsigned long freq)
> >>>>+{ return; }
> >>>>+#endif
> >>>
> >>>I'll repeat what I said off-list so that we can have the whole
> >>>conversation on the list:
> >>>
> >>>That looks like a custom Tegra-specific API. I think it'd be much bett=
er
> >>>to integrate this into the common clock framework as a standard clock
> >>>constraints API. There are other use-cases for clock constraints besid=
es
> >>>EMC scaling (e.g. some in audio on Tegra, and I'm sure many on other
> >>>SoCs too).
> >>
> >>Yes, I wrote a bit in the cover letter about our requirements and how
> >>they map to the CCF. Could you please comment on that?
> >
> >My comments remain the same. I believe this is something that belongs in
> >the clock driver, or at the least, some API that takes a struct clock as
> >its parameter, so that drivers can use the existing DT clock lookup
> >mechanism.
>=20
> Ok, let me put this strawman here to see if I have gotten close to what y=
ou
> have in mind:
>=20
> * add per-client accounting (Rabin's patches referenced before)
>=20
> * add clk_set_floor, to be used by cpufreq, load stats, etc.
>=20
> * add clk_set_ceiling, to be used by battery drivers, thermal, etc.
>=20
> * an EMC driver would collect bandwidth and latency requests from consume=
rs
> and call clk_set_floor on the EMC clock.
>=20
> * the EMC driver would also register for rate change notifications in the
> EMC clock and would update the latency allowance registers at that point.

Latency allowance registers are part of the MC rather than the EMC. So I
think we have two options: a) have a unified driver for MC and EMC or b)
provide two parts of the API in two drivers.

Or perhaps c), create a generic framework that both MC and EMC can
register with (bandwidth for EMC, latency for MC).

Thierry

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTogvoAAoJEN0jrNd/PrOhMf4QAKKMXnLhZIJ6WU1MXERj6DoH
PamUhHa6MlEhXjygSdRiPJ5xMCdmEzwY/ZZfj1Tz+FmBELxbVdb0WrPbrzXmkE5v
VDYTurEEV+yaaYBemZv1oRa/GjJwzgi9rYmKOBaMlO6ldLlsxsTYnVIPa5mWXnBO
WVUGsOohbC05iVyL2tInJhyT0+GXmABsCNhFpPQ+xc8aqTHwT+bJcP/f37pSzxF2
jzrVMXHCQtMSSyEBkbHQE9uVEbZY8SpF+YsZ7Fozzw7uMseL5LUpLWhuWPKJIcnq
xSVEGXHGfOUu8DuSHohWcypgCulW9+ZcFxobhbnsvZFPCK4JGD6YYDt/Q6kWTypz
AVD6te2pXYCGZHPfEuBkGDn4xY17AGpizMAgqMSKrLwB0My1JRfGqW/lNkJDu2JL
TTQAJmlS3eClqwfx4hNnymVAvzI8TBiE6kpcQT2i8vg9d7PASEajh1ZOF/yUnSiB
jVcqP3eJu5AujzLUKPTRrje5gjvnx5kIYFdELdP1s9W/ePwZ6K9cDbEIPhewuZbR
cQ9C8bNWn+t7+xg53W73mZk/J/jTB6rN7tveLfAw9rWMKYK5SsYDWQ5nOkVIhbl8
G4Vq1QZntqrpOvG1rxpq5hWHjhKfJKrrzBm34E5+SalexPuk1fEwPlIR8Jxz3BVf
2b9lc5PRE4PG7qtBVE1n
=CRS8
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
