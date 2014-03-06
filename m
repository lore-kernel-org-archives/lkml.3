Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaCFJHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:07:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48347 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaCFJHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:07:08 -0500
Date: Thu, 6 Mar 2014 10:06:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tony Lu <zlu@tilera.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tile/perf: Support perf_events on tilegx and tilepro
Message-ID: <20140306090655.GF9987@twins.programming.kicks-ass.net>
References: <BAB94DBB0E89D8409949BC28AC95914C5D67FF3E@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C5D67FF3E@USMAExch1.tad.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 06:26:11AM +0000, Tony Lu wrote:
> +static const int tile_cache_event_map[PERF_COUNT_HW_CACHE_MAX]
> +                                    [PERF_COUNT_HW_CACHE_OP_MAX]
> +                                    [PERF_COUNT_HW_CACHE_RESULT_MAX] = {
> +[C(L1D)] = {
> +       [C(OP_READ)] = {
> +               [C(RESULT_ACCESS)] = TILE_OP_UNSUPP,
> +               [C(RESULT_MISS)] = 0x21, /* RD_MISS */
> +       },
> +       [C(OP_WRITE)] = {
> +               [C(RESULT_ACCESS)] = 0x22, /* WR_MISS */
> +               [C(RESULT_MISS)] = TILE_OP_UNSUPP,
> +       },

If that's the wr_miss event as the comment says, it should probably be
listed one down.
