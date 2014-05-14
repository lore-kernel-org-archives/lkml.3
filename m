Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaENPpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:45:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:50362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaENPpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:45:30 -0400
Date: Wed, 14 May 2014 17:45:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com,
        Mel Gorman <mgorman@suse.de>, Vinod@twins.programming.kicks-ass.net
Subject: Re: [PATCH] sched: call select_idle_sibling when not affine_sd
Message-ID: <20140514154522.GP30445@twins.programming.kicks-ass.net>
References: <1399620873.5200.68.camel@marge.simpson.net>
 <536CE48E.2060305@redhat.com>
 <1399649042.31219.47.camel@marge.simpson.net>
 <536CF346.6080009@redhat.com>
 <1399658123.5187.2.camel@marge.simpson.net>
 <536D1B6D.8060004@redhat.com>
 <1399694090.5146.13.camel@marge.simpson.net>
 <53722754.6040102@redhat.com>
 <1400040489.5157.44.camel@marge.simpson.net>
 <20140514114037.2d93266f@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kBbg7yasUFfE4QK4"
Content-Disposition: inline
In-Reply-To: <20140514114037.2d93266f@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kBbg7yasUFfE4QK4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 11:40:37AM -0400, Rik van Riel wrote:
> Subject: sched: call select_idle_sibling when not affine_sd
>=20
> On smaller systems, the top level sched domain will be an affine
> domain, and select_idle_sibling is invoked for every SD_WAKE_AFFINE
> wakeup. This seems to be working well.
>=20
> On larger systems, with the node distance between far away NUMA nodes
> being > RECLAIM_DISTANCE, select_idle_sibling is only called if the
> waker and the wakee are on nodes less than RECLAIM_DISTANCE apart.
>=20
> This patch leaves in place the policy of not pulling the task across
> nodes on such systems, while fixing the issue that select_idle_sibling
> is not called at all in certain circumstances.
>=20
> The code will look for an idle CPU in the same CPU package as the
> CPU where the task ran previously.
>=20
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 39b63d0..1e58159 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4423,10 +4423,10 @@ select_task_rq_fair(struct task_struct *p, int pr=
ev_cpu, int sd_flag, int wake_f
>  			sd =3D tmp;
>  	}
> =20
> -	if (affine_sd) {
> -		if (cpu !=3D prev_cpu && wake_affine(affine_sd, p, sync))
> -			prev_cpu =3D cpu;
> +	if (affine_sd && cpu !=3D prev_cpu && wake_affine(affine_sd, p, sync))
> +		prev_cpu =3D cpu;
> =20
> +	if (sd_flag & SD_WAKE_AFFINE) {

I think you meant SD_BALANCE_WAKE?

>  		new_cpu =3D select_idle_sibling(p, prev_cpu);
>  		goto unlock;
>  	}


--kBbg7yasUFfE4QK4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc4+SAAoJEHZH4aRLwOS660oP/3V9J1s7xvKVpwcbR3F/MK7S
vIhmemuTZaQSWp1Yz7Q8y3upmEFwJ2yY6W04EHs8t+kUJ4gI9LeGZXvtVa4xdjb5
lx1u4TCKNjElUd0pXDIn3b8z68nrqjDMvcYNfWp7IZoticAuts3PCmgXGol2XjA1
uYjghmg6iaKC/6NE2wpyMut56RDQ2pDR3J7G11X3Vg9qfzQUgMjcvBPEeZQhFR52
RD4qVH6/gq7JLPlyT/8P7Q1esXZiGLDO6j11XMClfO9r3d6rE719EQJKhixxNynD
DKyqfgKBE5D9rmUUFR0icyA+KxYpEf4dw5HAtHr/PK8/jYr3wAd8dpf0nJeHacUp
3W6XBJpIitgIE7uvyGK0ArhVktMDfcNYJ6IJApckGovezSPNH3Ohc5//2biOkaDR
qgqsh+Ch+PWjKcU+YQHwJ0Ffe7OLGh9Be4tj1psOeBVe64dckRClQW8/bPtqbfa2
obefGoijHkBRrtiFu7qHGZqb4v4bMBolICW13MvT4bYvUrrRwxE0BIJB0BWfqJiJ
bTw9rAnmkYKa6+4iOE48wxhYMqU0WZBXXmEAKAvfc/d/GXMDlxFqJ0vETDRHu/WW
QFBeHZ2KOphhMDWBfEd2vui3hO+3SdLNaf3QwCG4/CrGN5HGWigjf9uK0p8oSgrY
LfLzMQqU+jrYnriWb6xC
=Bp0z
-----END PGP SIGNATURE-----

--kBbg7yasUFfE4QK4--
