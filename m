Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaGOO3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:29:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53908 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaGOO3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:29:53 -0400
Date: Tue, 15 Jul 2014 16:29:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH v2 2/5] perf/x86: add support for sampling PEBS machine
 state registers
Message-ID: <20140715142939.GJ9918@twins.programming.kicks-ass.net>
References: <1405384304-26816-1-git-send-email-eranian@google.com>
 <1405384304-26816-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kIf/M4+cOKmnPkRL"
Content-Disposition: inline
In-Reply-To: <1405384304-26816-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kIf/M4+cOKmnPkRL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 02:31:41AM +0200, Stephane Eranian wrote:
> PEBS can capture machine state regs at retiremnt of the sampled
> instructions. When precise sampling is enabled on an event, PEBS
> is used, so substitute the interrupted state with the PEBS state.
> Note that not all registers are captured by PEBS. Those missing
> are replaced by the interrupt state counter-parts.
>=20
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/=
cpu/perf_event_intel_ds.c
> index 980970c..d612bcd 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -925,6 +925,25 @@ static void __intel_pmu_pebs_event(struct perf_event=
 *event,
>  	regs.bp =3D pebs->bp;
>  	regs.sp =3D pebs->sp;
> =20
> +	if (sample_type & PERF_SAMPLE_REGS_INTR) {
> +		regs.ax =3D pebs->ax;
> +		regs.bx =3D pebs->bx;
> +		regs.cx =3D pebs->cx;
> +		regs.si =3D pebs->si;
> +		regs.di =3D pebs->di;
> +
> +		regs.r8 =3D pebs->r8;
> +		regs.r9 =3D pebs->r9;
> +		regs.r10 =3D pebs->r10;
> +		regs.r11 =3D pebs->r11;
> +		regs.r12 =3D pebs->r12;
> +		regs.r13 =3D pebs->r13;
> +		regs.r14 =3D pebs->r14;
> +		regs.r14 =3D pebs->r15;
> +
> +		data.regs_intr.regs =3D &regs;

This last assignment is superfluous. Note how you previous patch's
perf_sample_regs_intr() is unconditionally writing its .regs value, and
in turn, perf_sample_regs_intr() is called unconditionally from
perf_prepare_sample().



--kIf/M4+cOKmnPkRL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxTrTAAoJEHZH4aRLwOS6J08QAKpU5qruTFm91vAku34Il7KW
if+CLT5Y8Y06vFE1kSHIocst987eyNPzMWl3HHi7neaxF/nd5ZAMIIUZTkFrM+9J
oqXjHiNG/KU6PeOxcpPCjUbN1B8Cyoc6u06p/rn9HkEVG74NpPhPhn/ShWn1Z9Z7
3P1c1oX66I73L/+/dgs1Tpk845WLNYNC0zrK35x/0IzWQA82rG5wVrZFOdBSR4qD
2Pd18NYdBxXnv49um9lXm+SizJBmd5gDlEQzACsdDAtlcyPM9MqFdK8wUxgUX9fR
w6ntXmWKXA9jWI/3ocGlIT6jVZCCHPiaxVCNyaLc34e5q3XSuyFmFV0Xym+78bmW
1flN6pLO1EQQheLwdv/eqlJDSx94b1f9tAz+yFhSzE1OHbGyrQrHwvimgsQIlwvC
CnaZLqM1LrDp0QrRog6q7rbw+NW7mu4f15ReDjmQ9SQEwMdgIzkKLvGy5+4bKrqd
vQ14lI+47C6udqK4Uz4I7SEqriF/gySNeYPWVzWBjkwpoHIZWQ/bRCfp0AAuHCI/
DBKRd8UB/5cBYABBiR/W/TWujws+DCBA3RBN3a3DV/8eDFDyCzYucTqYyRw4X62e
8Bh3UA9r5B734XSReSJrG8MEw4IGLOlt9V15IR+1OOcSYz4LkONlcNVcALBQ6zMw
MzpaRcNKTxnn6h3xKu2E
=cklU
-----END PGP SIGNATURE-----

--kIf/M4+cOKmnPkRL--
