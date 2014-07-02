Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaGBKV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:21:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36259 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaGBKV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:21:56 -0400
Date: Wed, 2 Jul 2014 12:21:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 07/16] perf, x86: track number of events that use LBR
 callstack
Message-ID: <20140702102147.GZ6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-8-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U/OZNOFFJieNpJU4"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-8-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U/OZNOFFJieNpJU4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 04:50:44PM +0800, Yan, Zheng wrote:
> +static inline bool branch_user_callstack(unsigned br_sel)
> +{
> +	return (br_sel & X86_BR_USER) && (br_sel & X86_BR_CALL_STACK);
> +}
> +
>  void intel_pmu_lbr_enable(struct perf_event *event)
>  {
>  	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
> +	struct x86_perf_task_context *task_ctx;
> =20
>  	if (!x86_pmu.lbr_nr)
>  		return;
> @@ -214,6 +220,10 @@ void intel_pmu_lbr_enable(struct perf_event *event)
>  	}
>  	cpuc->br_sel =3D event->hw.branch_reg.reg;
> =20
> +	task_ctx =3D event->ctx ? event->ctx->task_ctx_data : NULL;
> +	if (branch_user_callstack(cpuc->br_sel))
> +		task_ctx->lbr_callstack_users++;
> +

So what happens if we make a per-cpu event which satisfies
branch_user_callstack() ?

--U/OZNOFFJieNpJU4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs907AAoJEHZH4aRLwOS6kswQAIMpnPpP43ctIcmyGERZ8tHA
X/mKhQeN9/KuDjhcaVDUHnltrFpC6iBju16+CT1xJQD9jko3zi93ZxvwU7jI7YLn
3UB6aXQJUVOOGtW1VxfcpmplyA1CYM1OlSDEo7bH8ODPrayu1q75DRLu/xx6j3gi
8rsVOVpWricV5X46Ha9wXTJ8riUdK4dEDOqvCF5Q9SXRg2I35NYDj/6h5k/hKDnr
IvFD6f5iaV1j87JVQHB/4idG9Hc8nWz36IZNZXe32OyxRkiuEFsMT/CuR6/YiSAU
trypju5+GGAQJ3bp9ZHPSg07sPsrwCgb9m7bsSs+kHq7iJy0ijadMUHhGU9gb/4H
tKwMfttAUzVqTD3wblgZHngN4LMiVvVFXTeLYzEbj8duvTD60/RixNqviqmanwse
GvGoUF7KT96zbdMpL5PkDXlapH7Sjm7S3cbHoFGy5Umm5VRJCAFV1gue8IYitJ7y
yEmyClMWw8uk0oLzqHDkuDwxTB2GeP6ZdAGGiym1b1tOcULkk+PhKhAB+prxiDK9
WffpPuN6SbKEOCB2oOPNE+OiXYrYs8KA6NHpPM+eHDQSFvbE8GIi+ZrPjVPOWmgJ
D7k914Y8AXgVwGbzcfEKUu3O18CdvI003RAyRfOmX5SuNH30RuVp+dlZcdut2PMf
svJ+xDnPSkdxyy51ncPw
=9Zpf
-----END PGP SIGNATURE-----

--U/OZNOFFJieNpJU4--
