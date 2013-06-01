Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3FAUqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 16:46:18 -0400
Received: from one.firstfloor.org ([193.170.194.197]:49115 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3FAUqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 16:46:16 -0400
Date: Sat, 1 Jun 2013 22:46:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, gleb@redhat.com,
        mingo@redhat.com, x86@kernel.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, attilio.rao@citrix.com,
        ouyang@cs.pitt.edu, gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephan.diestelhorst@amd.com, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
Message-ID: <20130601204615.GQ6123@two.firstfloor.org>
References: <20130601082145.22955.33596.sendpatchset@codeblue>
 <20130601201442.GP6123@two.firstfloor.org>
 <51AA5950.6050603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AA5950.6050603@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 01:28:00PM -0700, Jeremy Fitzhardinge wrote:
> On 06/01/2013 01:14 PM, Andi Kleen wrote:
> > FWIW I use the paravirt spinlock ops for adding lock elision
> > to the spinlocks.
> 
> Does lock elision still use the ticketlock algorithm/structure, or are
> they different?  If they're still basically ticketlocks, then it seems
> to me that they're complimentary - hle handles the fastpath, and pv the
> slowpath.

It uses the ticketlock algorithm/structure, but:

- it needs to know that the lock is free with an own operation
- it has an additional field for strong adaptation state
(but that field is independent of the low level lock implementation,
so can be used with any kind of lock)

So currently it inlines the ticket lock code into its own.

Doing pv on the slow path would be possible, but would need
some additional (minor) hooks I think.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
