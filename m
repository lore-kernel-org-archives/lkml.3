Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbaJVTtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:49:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaJVTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:49:32 -0400
Date: Wed, 22 Oct 2014 12:49:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dominik Dingel <dingel@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
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
        kvm@vger.kernel.org, linux390@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 2/4] mm: introduce mm_forbids_zeropage function
Message-Id: <20141022124930.d723008daf5465be0a761b82@linux-foundation.org>
In-Reply-To: <20141022214552.0c954692@BR9TG4T3.de.ibm.com>
References: <1413976170-42501-1-git-send-email-dingel@linux.vnet.ibm.com>
	<1413976170-42501-3-git-send-email-dingel@linux.vnet.ibm.com>
	<20141022122223.f3bef0f497941fa8e0805dbf@linux-foundation.org>
	<20141022214552.0c954692@BR9TG4T3.de.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 21:45:52 +0200 Dominik Dingel <dingel@linux.vnet.ibm.com> wrote:

> > > +#ifndef mm_forbids_zeropage
> > > +#define mm_forbids_zeropage(X)  (0)
> > > +#endif
> > 
> > Can we document this please?  What it does, why it does it.  We should
> > also specify precisely which arch header file is responsible for
> > defining mm_forbids_zeropage.
> > 
> 
> I will add a comment like:
> 
> /*
>  * To prevent common memory management code establishing
>  * a zero page mapping on a read fault.
>  * This function should be implemented within <asm/pgtable.h>.

s/function should be implemented/macro should be defined/

>  * s390 does this to prevent multiplexing of hardware bits
>  * related to the physical page in case of virtualization.
>  */
> 
> Okay?

Looks great, thanks.
