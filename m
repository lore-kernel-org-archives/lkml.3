Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaGGTqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:46:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGGTqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:46:52 -0400
Date: Mon, 7 Jul 2014 21:46:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf stat: events inheritance can break task targets
Message-ID: <20140707194635.GZ6758@twins.programming.kicks-ass.net>
References: <874myt86ju.wl%yarygin@linux.vnet.ibm.com>
 <20140707170040.GB2070@krava.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YMoJtYXQBeUqimUz"
Content-Disposition: inline
In-Reply-To: <20140707170040.GB2070@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YMoJtYXQBeUqimUz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 07:00:40PM +0200, Jiri Olsa wrote:
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_p=
erf.c
> index 5d12bb4..b44184b 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -24,6 +24,9 @@ static int	total_ref_count;
>  static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
>  				 struct perf_event *p_event)
>  {
> +	struct task_struct owner =3D p_event->parent ? p_event->parent->owner :
> +						     p_event->owner;
> +
>  	if (tp_event->perf_perm) {
>  		int ret =3D tp_event->perf_perm(tp_event, p_event);
>  		if (ret)
> @@ -32,7 +35,7 @@ static int perf_trace_event_perm(struct ftrace_event_ca=
ll *tp_event,
> =20
>  	/* The ftrace function trace is allowed only for root. */
>  	if (ftrace_event_is_function(tp_event)) {
> -		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
> +		if (perf_paranoid_tracepoint_raw() && !has_capability(owner, CAP_SYS_A=
DMIN))
>  			return -EPERM;
> =20
>  		/*
> @@ -65,7 +68,7 @@ static int perf_trace_event_perm(struct ftrace_event_ca=
ll *tp_event,
>  	 * ...otherwise raw tracepoint data can be a severe data leak,
>  	 * only allow root to have these.
>  	 */
> -	if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
> +	if (perf_paranoid_tracepoint_raw() && !has_capability(owner, CAP_SYS_AD=
MIN))
>  		return -EPERM;
> =20
>  	return 0;

You need to either hold rcu_read_lock() or otherwise ensure the owner is
still valid.

--YMoJtYXQBeUqimUz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTuvkbAAoJEHZH4aRLwOS6/goP/Rhe/do1PfXbRHbDjQfIJO9X
vCcH/2nIHm4u/xrISUCIjyJ/M6EW69t+eSaTwnccxERI/X5fsPtZDt4ofQP1wc/I
s/PK2GsulZ2wiE1LInlnXFJrDOTipXQ0tbCDmbBzmSXDqd33eSwKtx4y9JaF9BlG
72eHoqVnvyiXU8L8SmjfDE8bvpqYLjSx9UH3EgRRkQ6vq/2BAtEjINH+IzN4Vbe7
Uxn8DynLxREwCUELTdOz0GxWSUP4Q8k7EwbPigmlldrPmjewBWFHFt6DZ9pYlKfQ
ytI2HSn8HuJq23LFwXFWNFzuztAZscMX2tYETs5vtg2hxw5OznEUFNRkrzIxtSGb
FLvU+03KCBByH02ILBKmkIWPpYxTmfPVin7I+xY6mlt4g6UhmpgQYnQDitcOcc/i
7oeprv2V+DcgNSA2Nn8yraLBUHj5XXRyIKIni5UVFXJyMWxEitKrESXXENqDh1ZM
Yx+8D4+AepcqCCS86JbNgafVM3JZ3qB94tWs/3CgU7h7C1hbHMXuaj/RfpJQxLNu
pp0WLJNXpMSewGav2xMznh+HwxtKHnDvhmU2GNEmhF/WgDJzyu8xuoZUEtkmwppS
ULp19uHxpp2jUq6TQrMNf0clIHjka5UvmcU9uLxmxAem4i6PfBashiJCWckfIGTh
oVzmJtXkenBJK66UU0VM
=Ki9f
-----END PGP SIGNATURE-----

--YMoJtYXQBeUqimUz--
