Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171AbaCUVvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:51:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:30622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaCUVvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:51:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,706,1389772800"; 
   d="scan'208";a="504196656"
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Wu <peter@lekensteyn.nl>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
References: <4055058.qLAukpngnj@al>
	<20140321192938.GJ3132@tassilo.jf.intel.com>
	<970fd799-8d4c-4759-8a96-1291b411f307@email.android.com>
	<20140321213753.GK3132@tassilo.jf.intel.com>
	<532CB21B.4040502@zytor.com>
Date: Fri, 21 Mar 2014 14:48:37 -0700
In-Reply-To: <532CB21B.4040502@zytor.com> (H. Peter Anvin's message of "Fri,
	21 Mar 2014 14:41:47 -0700")
Message-ID: <8761n7nryi.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> That's why at least to some extent The Right Thing is not to try to
> pretend to be a CPU you don't even know how to emulate.
>
> But again, that has its own issues, too, mostly with userspace
> optimization, and making the Linux code more resilient wouldn't hurt.
> In that sense #GP(0) is *much* better than 0: it unambiguously gives an
> error to work with.

That means we could just throw rdmsr() away and it would be completely
replaced with rdmsr_safe(). But then that will likely cause all kinds
of problems with how to handle these errors and where and how to handle
these exceptions.

I much prefer just to fix KVM. I cannot think of any case
where 0 would cause a major issue.

After all it's virtualization not "rewrite complete kernel for it"

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
