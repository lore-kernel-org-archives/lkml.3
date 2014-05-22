Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaEVHW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:22:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaEVHW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:22:28 -0400
Date: Thu, 22 May 2014 09:22:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ye olde task_ctx_sched_out trace.
Message-ID: <20140522072222.GR30445@twins.programming.kicks-ass.net>
References: <20140521150613.GA28702@redhat.com>
 <20140521151655.GG2485@laptop.programming.kicks-ass.net>
 <20140521153013.GG5226@laptop.programming.kicks-ass.net>
 <20140521153219.GH5226@laptop.programming.kicks-ass.net>
 <537D9EBE.7030806@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mf8qZHy9ZtPMQ5Ky"
Content-Disposition: inline
In-Reply-To: <537D9EBE.7030806@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mf8qZHy9ZtPMQ5Ky
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 09:52:46AM +0300, Adrian Hunter wrote:
> +/*
> + * PERF_RECORD_MISC_MMAP_DATA and PERF_RECORD_MISC_COMM_EXEC are used on
> + * different events so can reuse the same bit position.
> + */
>  #define PERF_RECORD_MISC_MMAP_DATA		(1 << 13)
> +#define PERF_RECORD_MISC_COMM_EXEC		(1 << 13)
>  /*
>   * Indicates that the content of PERF_SAMPLE_IP points to
>   * the actual instruction that triggered the event. See also
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index ed50b09..760abd0 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5067,7 +5067,7 @@ static void perf_event_comm_event(struct perf_comm_=
event *comm_event)
>  		       NULL);
>  }
> =20
> -void perf_event_comm(struct task_struct *task)
> +void perf_event_comm(struct task_struct *task, bool exec)
>  {
>  	struct perf_comm_event comm_event;
>  	struct perf_event_context *ctx;
> @@ -5093,7 +5093,7 @@ void perf_event_comm(struct task_struct *task)
>  		.event_id  =3D {
>  			.header =3D {
>  				.type =3D PERF_RECORD_COMM,
> -				.misc =3D 0,
> +				.misc =3D exec ? PERF_RECORD_MISC_COMM_EXEC : 0,
>  				/* .size */
>  			},
>  			/* .pid */

OK, now that you pointed out the obvious, yeah, I suppose we can do that :-)

--Mf8qZHy9ZtPMQ5Ky
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfaWuAAoJEHZH4aRLwOS6bK0P/1RskDrY4yaUjSj8Fqy6jVIf
32i18yNmarvpUqgNfcdBK+JILoRQ85gkBsEkgrhKh5mizJ6V2as22Wo6MDuR63wJ
J7lN3JobRFwT62ajZ1QD4J3Zxyi26GryqT0Qonp4Y1V+I5NSOaJTWx/tyRg+2Jxq
8YzrBN8EfuFSE0vSWQD005gmRb3nQjY4EsbjXIRdEc5nj458oPiUsRLknaFe1bL5
PBTzs2NXya6DPTFiI1g+HXZhYVMEVNcRWpkCjTsDqxTGjNQ5dsOoQ6YRBvaHRnS+
pmz3M65r9HTM3XM/uGTrQ+prSoIS4sxRW1T02Ly01Ss2osIvK2fVVMtKPB8QoNNT
IMlpt66zabwhRyR1VSd8Ets8x8EfrBEA3L+u/3VHs5hkFB46YlpShF5we+dfWaK2
PDW5yAkb6tS4aEtX75eIa6+D72CIVxx4pS4LP1PBP4pOsKx8kgufm2IQ5u6BoX3Z
Q3FV/v3HZ4RmGXcpq2kGhYjNDWYVnry2Zf33aZfJ6Qw7+GLdJ4zxiFBK/Lnd3O//
XVB4bC7dfKgZn56oTdCFnAeV2zq0HGsGTdLg++Rgyn8SHdXpgxHUHl++V5/EpT9i
bKLUTieCLCckB1l9uU+ILnO2V923F8gY3Iw6PFrxq8jl1rLOhlHdRRiZh1n5hNT6
bdEWsAu40dxsdycFo95J
=7e+m
-----END PGP SIGNATURE-----

--Mf8qZHy9ZtPMQ5Ky--
