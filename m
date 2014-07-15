Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbaGOLMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:12:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:56904 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbaGOLMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:12:22 -0400
Date: Tue, 15 Jul 2014 13:12:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 6/7] perf, x86: enable large PEBS interrupt threshold
 for SNB/IVB/HSW
Message-ID: <20140715111210.GB9918@twins.programming.kicks-ass.net>
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
 <1405414739-31455-7-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fwVzdwcpG0LlK9IO"
Content-Disposition: inline
In-Reply-To: <1405414739-31455-7-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fwVzdwcpG0LlK9IO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 04:58:58PM +0800, Yan, Zheng wrote:
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu=
/perf_event_intel.c
> index cb5a838..dba03b3 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2456,6 +2456,7 @@ __init int intel_pmu_init(void)
>  		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =3D
>  			X86_CONFIG(.event=3D0xb1, .umask=3D0x01, .inv=3D1, .cmask=3D1);
> =20
> +		x86_pmu.multi_pebs =3D true;
>  		pr_cont("SandyBridge events, ");
>  		break;
>  	case 58: /* IvyBridge */
> @@ -2484,6 +2485,7 @@ __init int intel_pmu_init(void)
>  		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =3D
>  			X86_CONFIG(.event=3D0x0e, .umask=3D0x01, .inv=3D1, .cmask=3D1);
> =20
> +		x86_pmu.multi_pebs =3D true;
>  		pr_cont("IvyBridge events, ");
>  		break;
> =20
> @@ -2511,6 +2513,8 @@ __init int intel_pmu_init(void)
>  		x86_pmu.get_event_constraints =3D hsw_get_event_constraints;
>  		x86_pmu.cpu_events =3D hsw_events_attrs;
>  		x86_pmu.lbr_double_abort =3D true;
> +
> +		x86_pmu.multi_pebs =3D true;
>  		pr_cont("Haswell events, ");
>  		break;

NAK for the very same reason. All (PEBS capable) hardware supports this.

--fwVzdwcpG0LlK9IO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxQyKAAoJEHZH4aRLwOS6E+cP/27/j8wE4BXTPqLc4DMcZxw9
QkNatFuSC2NSHWbQ9gEBy/Ij7JDAacGELVqjcxmtWxqrTSWLVReDgfr/NEAZ93Bv
2A/tnBHwyiFqYIYQF4lhq+RfDMCZ+z/TdpeCt4jhM4N5p2IjJp3nUEx9kDNgvhjm
3zOafyKF/1sC8sssnDidHYjpd5kZPEClZ02Uvw9FcBB6TPxDGoFnksEc0ri6UT0W
JRYc6lxs8X8076MsLLJ6GvzZmvEV3WxfAJ3fAsyZAkPoABRvPKu98UTLOsWqv04E
CPHkoGOZ9CBPVueav2lcDUdINy2djFx8d1tdBusbKOlvYDWVBFrZ4qmekWwrDkmh
skKCL0y/N5M8T7QmPMLi9oolKAKJnAKqYlzPHBqtrgMSBkdeYJmUII+IdWqakzCY
x99x0cZolO2qF3+TTYt7ZCShqW8qALVZkqUcFtEHiGVCLWX62IFmlZ6pvdtFLXSA
gKnIpURpCbp1y2UMbOC7lDyx4+DvkamqsuQcpt46ywyu82fvArkV7jd847JJUFiw
aHWvuNsPlNqh+jWBGcqGgFjDHlRIcVVMnRAHwfl4RLYH635KjJsVrQVjIFd1bUtU
CoQWtd9/IMZ8rbg70IUP4/1AOugap2VosKqh1fx6vREaihM8TzSSGpq+Bl2BR4Cl
knPwoglH/oMMvrwk69AT
=EukU
-----END PGP SIGNATURE-----

--fwVzdwcpG0LlK9IO--
