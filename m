Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbaFXQqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:46:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384AbaFXQqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:46:17 -0400
Date: Tue, 24 Jun 2014 13:45:14 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Avi Kivity <avi.kivity@gmail.com>, peterz@infradead.org, gleb@kernel.org,
        pbonzini@redhat.com, eranian@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
Message-ID: <20140624164514.GA25220@amt.cnet>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-5-git-send-email-andi@firstfloor.org>
 <53A6E0B9.10408@gmail.com>
 <20140622190225.GN5714@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140622190225.GN5714@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 09:02:25PM +0200, Andi Kleen wrote:
> > First, it's not sufficient to pin the debug store area, you also
> > have to pin the guest page tables that are used to map the debug
> > store.  But even if you do that, as soon as the guest fork()s, it
> > will create a new pgd which the host will be free to swap out.  The
> > processor can then attempt a PEBS store to an unmapped address which
> > will fail, even though the guest is configured correctly.
> 
> That's a good point. You're right of course.
> 
> The only way I can think around it would be to intercept CR3 writes
> while PEBS is active and always pin all the table pages leading 
> to the PEBS buffer. That's slow, but should be only needed
> while PEBS is running.
> 
> -Andi

Suppose that can be done separately from the pinned spte patchset.
And it requires accounting into mlock limits as well, as noted.

One set of pagetables per pinned virtual address leading down to the
last translations is sufficient per-vcpu.


