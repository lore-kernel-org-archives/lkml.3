Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaGBKUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:20:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:59880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaGBKUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:20:06 -0400
Date: Wed, 2 Jul 2014 12:19:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 06/16] perf, core: always switch pmu specific data
 during context switch
Message-ID: <20140702101959.GY6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-7-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXLO4waKsIScBrDz"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-7-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXLO4waKsIScBrDz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 30, 2014 at 04:50:43PM +0800, Yan, Zheng wrote:
> @@ -2347,6 +2348,11 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
>  			next->perf_event_ctxp[ctxn] = ctx;
>  			ctx->task = next;
>  			next_ctx->task = task;
> +
> +			ctx_data = next_ctx->task_ctx_data;
> +			next_ctx->task_ctx_data = ctx->task_ctx_data;
> +			ctx->task_ctx_data = ctx_data;
> +

		swap(ctx->task_ctx_data, next_ctx->task_ctx_data);

?

--OXLO4waKsIScBrDz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs9zOAAoJEHZH4aRLwOS6YnUP/irKstYnqfoPHFYSFQ+sHTeb
ICoplLIHrNp75S2Am6irRQIgtEJRmeevoPbTra0JyNF4Ybw6g+tMSmJorLqkgI+I
jsX9uLEWbwdV+hpKkBHBckvv5Qt7BN6r7BDNzG+PBzdfDkzuZyi0MyikOZedKDAY
4z/xtmHiRUCCx/h1XN+wkr2IfONSA94JzdfbWnnk5mt8WXDFl6N9Sjs9MVzx0OCW
OqC+AiY89ZtzhelxZQHZYOHnnvJ0KvfjBnoFrXzwwMqc/7Rn5WAXY4T/rf5PiW8A
kW3evzDOpnsJFWIuDfkmxD+4nvQV+CCzY/MX+AlZcedZcVO1tdEVScFdTaXBBpKi
oF8aQtMk4EsP7LfH4REPF7sJQWsmQIxyMPADC4rIXymmJxZZNuS8v4iJDhNllDWI
xf8GcyCptTbgf2ii81gMxsTDQqn3uUZcEB2fSpPjExKaxi+u1NAtbgHs2pyWLzJu
6WAS2/1X3NNzOO+3DwmPR7orhCdu6SQfr8pkGQ5QPEMBZK1F3KtwAU8caRQzwSjC
inU6DP9NzIkJ/quOBTo/leZl/c1y+2vnqbJ3qtoYy/VTMCTczrluphaT02le3jSS
8Mtk0WvNbQ6+HxLanYlJg3U3S2zcnVLtTu4zVc/YcRIqCZ6To4zkJ8GbBlvkX7SK
MTunjtnz4p6jkDZqp1Qm
=L3cJ
-----END PGP SIGNATURE-----

--OXLO4waKsIScBrDz--
