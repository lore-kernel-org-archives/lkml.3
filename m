Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab3KFUT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:19:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:16815 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab3KFUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:19:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="317892732"
From: Andi Kleen <andi@firstfloor.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	<1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
	<1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
Date: Wed, 06 Nov 2013 12:19:52 -0800
In-Reply-To: <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com> (Neil
	Horman's message of "Wed, 6 Nov 2013 10:23:19 -0500")
Message-ID: <87iow58eqf.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> do_csum was identified via perf recently as a hot spot when doing
> receive on ip over infiniband workloads.  After alot of testing and
> ideas, we found the best optimization available to us currently is to
> prefetch the entire data buffer prior to doing the checksum

On what CPU? Most modern CPUs should not have any trouble at all
prefetching a linear access.

Also for large buffers it is unlikely that all the prefetches
are actually executed, there is usually some limit.

As a minimum you would need:
- run it with a range of buffer sizes
- run this on a range of different CPUs and show no major regressions
- describe all of this actually in the description

But I find at least this patch very dubious.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
