Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3JJSA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:00:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55678 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab3JJSA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:00:56 -0400
Date: Thu, 10 Oct 2013 20:00:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Subject: Re: [PATCH v2 0/3] perf,x86: add Intel RAPL PMU support
Message-ID: <20131010180049.GD9929@pd.tnic>
References: <1381416608-2741-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381416608-2741-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 04:50:05PM +0200, Stephane Eranian wrote:
> $ perf stat -a -e rapl/rapl-energy-cores/,rapl/rapl-energy-pkg/ -I 1000 sleep 10
>             time             counts events
>      1.000345931        772 278 493 rapl/rapl-energy-cores/
>      1.000345931     55 539 138 560 rapl/rapl-energy-pkg/    
>      2.000836387        771 751 936 rapl/rapl-energy-cores/  
>      2.000836387     55 326 015 488 rapl/rapl-energy-pkg/

Hmm, so I'm looking at builtin-stat.c::print_interval() and since
it gets the perf_evsel counters and you can deduce the counter name
from it, you probably could match the rapl counters and do the Watts
conversion above as a special case.

I dunno, it is much better than having some naked numbers for which
people have to go stare at the sources + CPU vendor docs as to what they
actually mean.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
