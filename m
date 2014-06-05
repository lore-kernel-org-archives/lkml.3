Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaFENso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:48:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:52451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaFENsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:48:43 -0400
Date: Thu, 5 Jun 2014 15:48:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, zheng.z.yan@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20140605134841.GL3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-6-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qyHYMwAXsHLOQihY"
Content-Disposition: inline
In-Reply-To: <1401917658-26065-6-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qyHYMwAXsHLOQihY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 11:34:14PM +0200, Stephane Eranian wrote:

> +static struct event_constraint *
> +intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
> +			   struct event_constraint *c)
> +{

> +	if (!(c->flags & PERF_X86_EVENT_DYNAMIC)) {
> +
> +		/*
> +		 * in case we fail, we assume no counter
> +		 * is supported to be on the safe side
> +		 */
> +		cx = kmalloc(sizeof(*cx), GFP_KERNEL);
> +		if (!cx)
> +			return &emptyconstraint;
> +

Ok, so forgive me if I'm wrong, but the way we get here is through:

x86_schedule_event()
  ->start_scheduling()
    spin_lock()
  ->get_event_constraints()
    intel_get_excl_constraints()
      kmalloc(.gfp=GFP_KERNEL)

How can that ever work?

--qyHYMwAXsHLOQihY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkHU5AAoJEHZH4aRLwOS6w8cQAKij3dPmF1u0ZK+KrznV3Apm
BSsPSuH9yxnPcRqXkpvFbbYZFxvzIwW+MDnnH+wApnqRPecpJAyAnmWiV4v27gFZ
/310iM6kageDMpFlZ/1U1c5HYjsftntYbyKrswsmN1754xN65RtGMxVVcGmw9G9E
oh4f7eCy9iwnB2sexd21cVh/56EXoIqddlANQLVQpfkcAhSFWsZEezsYrDWbVSH8
+ZUGg/VU24R71mk7eFL/vGr4sDvZgoPbGUce+/bfwx/wbgvM++8b7pH668kt4O1h
R1xu8LZMe4ZGSP8WAq6JzJtqlvqoBFzIt8Y1z+D0C+7KRADxywjRFVluZA/3YDDD
EJn78PmIkqB8esTkFt9hNWlsMrfjyexxKzKUjSMUPZo6LFLB8RgG3nWT6IIpGlOD
C1oudREUiBsWsEt13s3dLpH+8t9LGdTpH/aPauww+sdNe9udvmuYmuIc2oq5gYnR
3fO+avja7ph5TiiZXH8wrKi3US1MHl7SZ5DxKzoUseHF09lXHUmKqMJKQUM22uEd
X3Ww+2C1wVk0ygCtwteoutqkRXl14L0AAVuozAHZO5LKeG4S4F86gyF08N4jEBm5
fKPYK38bd8TvUm+E81lB2jpRX+MVmYMgI0adJ9/Rgyw1ZQYX2/Qp+js/bqT24Kb8
CbpLQ1SOS021corBsJ+1
=eaUU
-----END PGP SIGNATURE-----

--qyHYMwAXsHLOQihY--
