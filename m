Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaJUGLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 02:11:48 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:43524 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJUGLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 02:11:46 -0400
Date: Tue, 21 Oct 2014 08:11:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Bob Liu <lliubbo@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jianyu Zhan <nasa4836@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konstantin Weitz <konstantin.weitz@gmail.com>, kvm@vger.kernel.org,
        linux390@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 2/4] mm: introduce new VM_NOZEROPAGE flag
Message-ID: <20141021081131.641c6104@mschwide>
In-Reply-To: <5445511D.1090603@redhat.com>
References: <1413554990-48512-1-git-send-email-dingel@linux.vnet.ibm.com>
	<1413554990-48512-3-git-send-email-dingel@linux.vnet.ibm.com>
	<54419265.9000000@intel.com>
	<20141018164928.2341415f@BR9TG4T3.de.ibm.com>
	<54429521.80402@intel.com>
	<5445511D.1090603@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102106-0013-0000-0000-00000187ECA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 20:14:53 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 10/18/2014 06:28 PM, Dave Hansen wrote:
> > > Currently it is an all or nothing thing, but for a future change we might want to just
> > > tag the guest memory instead of the complete user address space.
> >
> > I think it's a bad idea to reserve a flag for potential future use.  If
> > you_need_  it in the future, let's have the discussion then.  For now, I
> > think it should probably just be stored in the mm somewhere.
> 
> I agree with Dave (I thought I disagreed, but I changed my mind while 
> writing down my thoughts).  Just define mm_forbids_zeropage in 
> arch/s390/include/asm, and make it return mm->context.use_skey---with a 
> comment explaining how this is only for processes that use KVM, and then 
> only for guests that use storage keys.

The mm_forbids_zeropage() sure will work for now, but I think a vma flag
is the better solution. This is analog to VM_MERGEABLE or VM_NOHUGEPAGE,
the best solution would be to only mark those vmas that are mapped to
the guest. That we have not found a way to do that yet in a sensible way
does not change the fact that "no-zero-page" is a per-vma property, no?

But if you insist we go with the mm_forbids_zeropage() until we find a
clever way to distinguish the guest vmas from the qemu ones.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

