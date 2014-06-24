Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaFXR1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:27:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:54156 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaFXR1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:27:33 -0400
Date: Tue, 24 Jun 2014 19:27:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC v2 6/7] perf: add api for pmus to write to AUX space
Message-ID: <20140624172723.GS3213@twins.programming.kicks-ass.net>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1402501310-31940-7-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oXUzUgc67Nrfa9SE"
Content-Disposition: inline
In-Reply-To: <1402501310-31940-7-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oXUzUgc67Nrfa9SE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 11, 2014 at 06:41:49PM +0300, Alexander Shishkin wrote:
> +void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
> +			 bool truncated)
> +{
> +	struct ring_buffer *rb = handle->rb;
> +	unsigned long aux_head;
> +
> +	aux_head = local_read(&rb->aux_head);
> +	local_add(size, &rb->aux_head);
> +
> +	rb->user_page->aux_head = local_read(&rb->aux_head);
> +	smp_wmb();
> +
> +	perf_output_wakeup(handle);
> +	handle->event = NULL;
> +
> +	ring_buffer_put(rb);
> +}

This thing is distinctly less complex than perf_output_put_handle().. ?

--oXUzUgc67Nrfa9SE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTqbT7AAoJEHZH4aRLwOS6nhgP/1ZSl5DUdPBp2MYg/uz4txWx
71mk2EGjSkjIaGqZFeJ4SB+qLzqmSLX16T9kOOr2qbm1/qXW4QO0Niu8p0NepTOx
CpZpk8TMdW3vgKjKkCqlzsAB/+2Bt/aDEZ8DEfEYCSYO+sw+RPaEm92GueFFqHOb
5lAMCt8TsVZ9T8kCG0gjhzJ7ispXX6x+k4wmknYghKhuXrrq3PRdEh0ISiOhOkz8
+k/aKn+VV922IownFaupkivbOjQcES15/6jTUN3/GcYO3SZ8fiJ0BQmShQMYymVg
z5HXyYU4BPC9pp5Fgrbf/I73RhRjUihQPaMaCmr/EIeJmVhzistOcWEgByNF1gMl
r1wC/UgI7k/obCbv9aFLBkpn90YAyS7YRPBB6/nVg6Fylc0/svVphterZ9Jivp/s
zBlX7HXXGP6NufBqQ5mqi9cUfFEg36fV6Q6XQLP4tetBxG5N+hm43UIr2bZGpa2n
G/62wRxntqbuXP1dnWCOWHfxgtN89XrfgWQgj7p1PFsdzENXKe2T5KJTqt7INwn9
AVpohfL0N+BIRMRdgk7zDHEAGHnYYjwDINmZRrhpVWI6RbCYHRj1ARYp5XvjJuqJ
MFWmU4bpXVhllLG5Lt7WyQmp4ePq94Dz3h4hgJqBy69a1OP9BKEy3o0LFCjsxpCJ
ENkRze4jTG916kBLcsKK
=NlLv
-----END PGP SIGNATURE-----

--oXUzUgc67Nrfa9SE--
