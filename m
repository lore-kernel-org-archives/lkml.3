Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925AbaE3Q0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:26:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:64667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933500AbaE3Q0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:26:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,942,1392192000"; 
   d="scan'208";a="439064826"
Date: Fri, 30 May 2014 09:24:24 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Gleb Natapov <gleb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org,
        pbonzini@redhat.com, eranian@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
Message-ID: <20140530162424.GC8876@tassilo.jf.intel.com>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-5-git-send-email-andi@firstfloor.org>
 <20140530082136.GA4715@minantech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530082136.GA4715@minantech.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > To avoid any problems with guest pages being swapped by the host we
> > pin the pages when the PEBS buffer is setup, by intercepting
> > that MSR.
> It will avoid guest page to be swapped, but shadow paging code may still drop
> shadow PT pages that build a mapping from DS virtual address to the guest page.

You're saying the EPT code could tear down the EPT mappings?

OK that would need to be prevented too. Any suggestions how?

> With EPT it is less likely to happen (but still possible IIRC depending on memory
> pressure and how much memory shadow paging code is allowed to use), without EPT
> it will happen for sure.

Don't care about the non EPT case, this is white listed only for EPT supporting 
CPUs.

> There is nothing, as far as I can see, that says what will happen if the
> condition is not met. I always interpreted it as undefined behaviour so
> anything can happen including CPU dies completely.  You are saying above
> on one hand that CPU cannot handle any kinds of faults during write to
> DS area, but on the other hand a guest could only crash itself. Is this
> architecturally guarantied?

You essentially would get random page faults, and the PEBS event will
be cancelled. No hangs.

It's not architecturally guaranteed, but we white list anyways so 
we only care about the white listed CPUs at this point. For them
I have confirmation that it works.

-Andi
