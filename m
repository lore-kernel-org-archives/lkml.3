Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3JGQTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:19:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59776 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab3JGQTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:19:32 -0400
Date: Mon, 7 Oct 2013 18:19:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Subject: Re: [PATCH v1 0/2] perf,x86: add Intel RAPL PMU support
Message-ID: <20131007161928.GC5517@pd.tnic>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381162158-24329-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 06:09:15PM +0200, Stephane Eranian wrote:
> The counters all count in the same unit. The perf_events API
> exposes all RAPL counters as 64-bit integers counting in unit
> of 1/2^32 Joules (or 0.23 nJ). User level tools must convert
> the counts by multiplying them by 0.23 and divide 10^9 to
> obtain Joules.  The reason for this is that the kernel avoids
> doing floating point math whenever possible because it is
> expensive (user floating-point state must be saved). The method
> used avoids kernel floating-point and minimizes the loss of
> precision (bits). Thanks to PeterZ for suggesting this approach.
> 
> To convert the raw count in Watt: W = C * 0.23 / (1e9 * time)

...

> $ perf stat -a -e rapl/rapl-energy-cores/,rapl/rapl-energy-pkg/ -I 1000 sleep 10
>             time             counts events
>      1.000345931        772 278 493 rapl/rapl-energy-cores/
>      1.000345931     55 539 138 560 rapl/rapl-energy-pkg/    
>      2.000836387        771 751 936 rapl/rapl-energy-cores/  
>      2.000836387     55 326 015 488 rapl/rapl-energy-pkg/

So can we do the Watt conversion in perf tool and make that "counts"
output more human-friendly like what those numbers are, to which
core/LLC they belong, etc, etc?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
