Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbaDWUAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:00:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:25758 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214AbaDWUAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:00:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,913,1389772800"; 
   d="scan'208";a="498331345"
Date: Wed, 23 Apr 2014 13:00:22 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        zheng.z.yan@intel.com
Subject: Re: [PATCH] perf/x86: fix RAPL rdmsrl_safe() usage
Message-ID: <20140423200022.GJ8874@tassilo.jf.intel.com>
References: <20140423170418.GA12767@quad>
 <20140423190015.GF25378@pd.tnic>
 <CAHdzE-_jJOKo5=m2DAAhaAbDv4Cbq6KaQg4w_tZdofY_wrOWug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHdzE-_jJOKo5=m2DAAhaAbDv4Cbq6KaQg4w_tZdofY_wrOWug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Acked-by: Borislav Petkov <bp@suse.de>
> 
> Brown-Paper-Bag-Worn-By: Venkatesh Srinivas <venkateshs@google.com>

Again the bug is really in KVM. We wouldn't need all this crap
if KVM didn't throw the bogus #GPs. I'm sure you missed plenty
of MSR accesses elsewhere, and it's a ticking time bomb.

If the VM lies to the kernel with the family-model you need to at 
least limit the consequences. KVM is spectacularly failing
to do that by throwing bogus #GPs.

The brown paper bad needs to be employed on the KVM code
(or better the bug be fixed there, by defaulting to not #GP
on unknown MSRs)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
