Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3FELzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:55:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49868 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3FELzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:55:51 -0400
Date: Wed, 5 Jun 2013 13:55:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        viro@zeniv.linux.org.uk, vincent.weaver@maine.edu, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf: Fix perf mmap bugs
Message-ID: <20130605115538.GI27176@twins.programming.kicks-ass.net>
References: <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <tip-26cb63ad11e04047a64309362674bcbbd6a6f246@git.kernel.org>
 <20130604084421.GI8923@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604084421.GI8923@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 10:44:21AM +0200, Peter Zijlstra wrote:
> 
> Ingo asked for a delta against the patch already included in -tip.
> 
> Vince; perf_fuzzer crashed after about 5670000 iterations -- not sure
> you're aware it will crash at times. Anyway at this time accounting was
> still good.
> 
> ---
> Subject: perf: Fix mmap() accounting hole
> 
> Vince's fuzzer once again found holes. This time it spotted a leak in
> the locked page accounting.
> 
> When an event had redirected output and its close() was the last
> reference to the buffer we didn't have a vm context to undo accounting.
> 
> Change the code to destroy the buffer on the last munmap() and detach
> all redirected events at that time. This provides us the right context
> to undo the vm accounting.
> 
> Reported-by: Vince Weaver <vincent.weaver@maine.edu>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Vince, can you confirm?
