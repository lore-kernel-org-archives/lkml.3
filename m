Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3DUSWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 14:22:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38073 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab3DUSWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 14:22:31 -0400
Date: Sun, 21 Apr 2013 20:22:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/amd: Add support for AMD NB and L2I "
 uncore" counters
Message-ID: <20130421182227.GA4587@pd.tnic>
References: <20130419213428.GA8229@jshin-Toonie>
 <tip-c43ca5091a374c1f6778bd7e4a39a5a10735a917@git.kernel.org>
 <20130421170232.GA4172@pd.tnic>
 <20130421180627.GA21049@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130421180627.GA21049@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 01:06:27PM -0500, Jacob Shin wrote:
> From 2ac60428e58f7bfd7dec4baa772f523eeedfecc6 Mon Sep 17 00:00:00 2001
> From: Jacob Shin <jacob.shin@amd.com>
> Date: Sun, 21 Apr 2013 12:58:21 -0500
> Subject: [PATCH 1/1] perf, amd: fix lockdep warning, don't __GFP_FS alloc
>  with IRQs disabled
> 
> Fix lockdep warning by not calling kzalloc in smp_call_function_single.

This should say something about "do not allocate memory in the
IRQ handler or so." And I think the flag is __GFP_WAIT. Look at
allocate_slab() in slub.c:

        if (flags & __GFP_WAIT)
                local_irq_enable();

The local_irq_enable() calls into lockdep with trace_hardirqs_on().

Other than that:

Tested-by: Borislav Petkov <bp@suse.de>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
