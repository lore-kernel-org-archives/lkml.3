Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbaFBT5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:57:14 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53413 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaFBT5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:57:13 -0400
Date: Mon, 2 Jun 2014 21:57:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Northup <digitaleric@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        gleb@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
Message-ID: <20140602195711.GQ25366@two.firstfloor.org>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-5-git-send-email-andi@firstfloor.org>
 <CAG7+5M2h1_h2fW1KiD-ReXuxDe_EwmBUOJRwjgAvR79sUBxtgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG7+5M2h1_h2fW1KiD-ReXuxDe_EwmBUOJRwjgAvR79sUBxtgA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems to me that with this patch, there is no way to expose a
> PMU-without-PEBS to the guest if the host has PEBS.

If you clear the CPUIDs then noone would ilikely access it.

But fair enough, I'll add extra checks for CPUID.

> It would be a bigger concern if we expected virtual PMU migration to
> work, but I think it would be nice to update kvm_pmu_cpuid_update() to
> notice the presence/absence of the new CPUID bits, and then store that
> into per-VM kvm_pmu->pebs_allowed rather than relying only on the
> per-host perf_pebs_virtualization().

I hope at some point it can work. There shouldn't be any problems
with migrating to the same CPU model, in many cases (same event 
and same PEBS format) it'll likely even work between models or
gracefully degrade.

BTW in practice it'll likely work anyways because many profilers
regularly re-set the PMU. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
