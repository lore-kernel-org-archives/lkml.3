Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab3KRIxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 03:53:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34114 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3KRIxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 03:53:44 -0500
Date: Mon, 18 Nov 2013 09:53:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch] perf/trace properly use u64 to hold event_id
Message-ID: <20131118085335.GC3866@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311151236100.11932@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311151236100.11932@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:39:45PM -0500, Vince Weaver wrote:
> 
> The 64-bit attr.config value for perf trace events was being copied into
> an "int" before doing a comparison, meaning the top 32 bits were
> being truncated.
> 
> As far as I can tell this didn't cause any errors, but it did mean
> it was possible to create valid aliases for all the tracepoint ids
> which I don't think was intended.  (For example, 0xffffffff00000018
> and 0x18 both enable the same tracepoint).
> 
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

Thanks!
