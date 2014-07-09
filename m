Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaGIJOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:14:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47155 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaGIJOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:14:35 -0400
Date: Wed, 9 Jul 2014 11:14:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Message-ID: <20140709091426.GB9918@twins.programming.kicks-ass.net>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 09:49:40AM -0700, kan.liang@intel.com wrote:
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_=
event.c
> index 2bdfbff..f0e8022 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -118,6 +118,9 @@ static int x86_pmu_extra_regs(u64 config, struct perf=
_event *event)
>  			continue;
>  		if (event->attr.config1 & ~er->valid_mask)
>  			return -EINVAL;
> +		/* Check if the extra msrs can be safely accessed*/
> +		if (!x86_pmu.extra_msr_access[er->idx])
> +			continue;

If you fail here;

>  		reg->idx =3D er->idx;
>  		reg->config =3D event->attr.config1;

> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu=
/perf_event_intel.c
> index adb02aa..2be44be 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1471,11 +1471,14 @@ static void intel_fixup_er(struct perf_event *eve=
nt, int idx)
>  {
>  	event->hw.extra_reg.idx =3D idx;
> =20
> -	if (idx =3D=3D EXTRA_REG_RSP_0) {
> +	/* The extra_reg doesn't update if msrs cannot be accessed safely */
> +	if ((idx =3D=3D EXTRA_REG_RSP_0) &&
> +			x86_pmu.extra_msr_access[EXTRA_REG_RSP_0]) {
>  		event->hw.config &=3D ~INTEL_ARCH_EVENT_MASK;
>  		event->hw.config |=3D x86_pmu.extra_regs[EXTRA_REG_RSP_0].event;
>  		event->hw.extra_reg.reg =3D MSR_OFFCORE_RSP_0;
> -	} else if (idx =3D=3D EXTRA_REG_RSP_1) {
> +	} else if ((idx =3D=3D EXTRA_REG_RSP_1) &&
> +			x86_pmu.extra_msr_access[EXTRA_REG_RSP_1]) {
>  		event->hw.config &=3D ~INTEL_ARCH_EVENT_MASK;
>  		event->hw.config |=3D x86_pmu.extra_regs[EXTRA_REG_RSP_1].event;
>  		event->hw.extra_reg.reg =3D MSR_OFFCORE_RSP_1;

You should never get here..


--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvQfyAAoJEHZH4aRLwOS6hqsP/3vUTJsjdzal9lwGXcnYNrzZ
nyt1BgXwK4mN8H74zpyM7ypJUlBA5f95nXtlciCu8VK5yZEIZzTaqcmCycbNrr9+
ZdhwSMdjJw5ZrFjeFbLjOoPa4Q1VzGhx+UkktjbFTLxdxbYhWDVk7tUstwM4VgHg
vjhh3sF64yXexu48sqsm1LOsfnaudcn1WkP5csEBpIWiW4LGuduW871CI9znaaqO
nsWhs8T+S+xLDvDnFIQ1I09yk44Lbta8Vb1+ci46+IkxYgpxaJzThhgK9QeLCVfJ
L4S1YIskOBLvEDERYxLzB12w01DAYmuzj9cHnMOZCi7vFwmnSpSPfN38uf/F6L/K
tfzLMmJ2zn1ghRVycUuAUsypo2FxQM4Qav/usaIPGecBVK5A/MUAMUoGZMqvvzOB
kt5qXapJvvQmHZnD6oQRRXl9i6Ssnfzd4fGUlksLEGylj/RXKoxeLpIvcVlG6bii
dmZFZW/m7tQhu9VN3EaGm/9PAbw7Zze8GCbSu/jqPROwR++TB6JewpByDMbaRLd1
ATPfBOEixZobbXwbL9JYrRi4TdkLsrZ1rx47Vvg/0aV5paSd6HkCl/RSkW5YATbz
6fkhNcli+POAgWn2C5rwYrul3IpQhqexbQBtAY2LIEoTBDSD8hIYD5dyU2MR57Bb
T9mfMMRMC+SuXBluiLbL
=qsUA
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
