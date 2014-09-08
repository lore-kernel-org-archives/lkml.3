Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaIHPWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:22:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:39788 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaIHPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:22:11 -0400
Date: Mon, 8 Sep 2014 17:22:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf: Do not check PERF_EVENT_STATE_EXIT on syscall read
 path
Message-ID: <20140908152206.GH6758@twins.programming.kicks-ass.net>
References: <CABPqkBRREcix0TtLLUgiq8uabUqG=m2un79WKLqPXF=LccSQbw@mail.gmail.com>
 <20140908124945.GD17728@krava.brq.redhat.com>
 <CABPqkBRPWh+=CfXBYaYW=P6FJke3KB-7y-U1ky8JAKjDY3JaEg@mail.gmail.com>
 <20140908143107.GG17728@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S0bejtPoMQWM2IlW"
Content-Disposition: inline
In-Reply-To: <20140908143107.GG17728@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S0bejtPoMQWM2IlW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 04:31:07PM +0200, Jiri Olsa wrote:
> Revert PERF_EVENT_STATE_EXIT check on read syscall path.
> It breaks standard way to read counter, which is to open
> the counter, wait for the monitored process to die and
> read the counter.
>=20
> Reported-by: Stephane Eranian <eranian@google.com>
> Acked-by: Stephane Eranian <eranian@google.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Thanks!=20

> ---
>  kernel/events/core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d8cb4d21a346..6d1c9ce1643e 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3600,8 +3600,7 @@ perf_read_hw(struct perf_event *event, char __user =
*buf, size_t count)
>  	 * error state (i.e. because it was pinned but it couldn't be
>  	 * scheduled on to the CPU at some point).
>  	 */
> -	if ((event->state =3D=3D PERF_EVENT_STATE_ERROR) ||
> -	    (event->state =3D=3D PERF_EVENT_STATE_EXIT))
> +	if (event->state =3D=3D PERF_EVENT_STATE_ERROR)
>  		return 0;
> =20
>  	if (count < event->read_size)
> --=20
> 1.8.3.1
>=20

--S0bejtPoMQWM2IlW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDcmeAAoJEHZH4aRLwOS6ZUoP/25pdLuvNdcqTb53Q7PkRkER
lAr2aVjD9ub18F6BF/vzE3xdpaf6o/i6dC5FkonoGNS3IFCrTNzUyIrufX0ouO0G
Tiich/z/bmiLNezvSLG7qTGRxhY3B7dxAQ1dcj+lVPfpwIgUQoG0TGuZRJxCJaFf
lKL8gXSe2OP7afT0lF6HX5Jllum0eg/e4TBbd5cCkOvZbMKGh5mzzGRsD5F0i/eO
a0NxXk2Lm+cUqBxqqr0chRvHqBvxTAMzKq0XgtaIYUdd75Curk0U/WjOSkbm5QIR
YS812DLTGD/whVr3a6VVhWDDdALc9MXk2TRPp7krNWa63CbsHyEUYKVQ++vpTcQZ
KVoA53iEnJsI4+ZNJT3YiRgK2ESh4p+bQ0yNpU38DN2xxG1aHCzmdEiC9Ql6qA6o
7YYOYQm1z7lXr+IUvg7kGH9Z6SRHZbJcgOBHPZ45CDe3otwA6RaJlu6Ez8EGJUpB
+T8282WcVX72EKpJV3DVFVbbtiSZM1Vq+Oaa1gu+ftu4gNcdEpfewGrlCM68uvPZ
ZmwNDc8L9OZe9/M3Nd8v5lXoVIgBb+xOGvUVaREeMezEhBcHD1t9VIRgx+fnb+O6
po0n9CKgJbHOMhvs8ijy5ET65jblzuYOxRLBkAVhlmnUWeIT0tef8OvHOppQGuwm
KyXgtVlWCRJa4vE60msw
=s9gD
-----END PGP SIGNATURE-----

--S0bejtPoMQWM2IlW--
