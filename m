Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaKZRFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:05:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaKZRFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:05:13 -0500
Date: Wed, 26 Nov 2014 19:04:47 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141126170447.GC11202@redhat.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
 <20141126070258.GA25523@redhat.com>
 <20141126110504.511b733a@thinkpad-w530>
 <20141126151729.GB9612@redhat.com>
 <20141126152334.GA9648@redhat.com>
 <20141126163207.63810fcb@thinkpad-w530>
 <20141126154717.GB10568@redhat.com>
 <5475FAB1.1000802@de.ibm.com>
 <20141126163216.GB10850@redhat.com>
 <547604FC.4030300@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547604FC.4030300@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 05:51:08PM +0100, Christian Borntraeger wrote:
> > But this one was > giving users in field false positives.
> 
> So lets try to fix those, ok? If we cant, then tough luck.

Sure.
I think the simplest way might be to make spinlock disable
premption when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.

As a result, userspace access will fail and caller will
get a nice error.



> But coming up with wrong statements is not helpful.

True. Sorry that I did that.

> > 
> > The point is that *_user is safe with preempt off.
> > It returns an error gracefully.
> > It does not sleep.
> > It does not trigger the scheduler in that context.
> 
> There are special cases where your statement is true. But its not in general.
> copy_to_user might fault and that fault might sleep and reschedule.

Yes. But not if called inatomic.



> For example handle_mm_fault might go down to pud_alloc, pmd_alloc etc and all these functions could do an GFP_KERNEL allocation. Which might sleep. Which will schedule.
> 
> 
> > 
> > 
> > David's patch makes it say it does, so it's wrong.
> > 
> > 
> > 

Absolutely.
I think you can already debug your case easily, by enabling CONFIG_PREEMPT.
This seems counter-intuitive, and distro debug kernels don't seem to do this.

-- 
MST
