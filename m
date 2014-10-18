Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaJROtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 10:49:42 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:43939 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaJROtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 10:49:40 -0400
Date: Sat, 18 Oct 2014 16:49:28 +0200
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
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
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 2/4] mm: introduce new VM_NOZEROPAGE flag
Message-ID: <20141018164928.2341415f@BR9TG4T3.de.ibm.com>
In-Reply-To: <54419265.9000000@intel.com>
References: <1413554990-48512-1-git-send-email-dingel@linux.vnet.ibm.com>
	<1413554990-48512-3-git-send-email-dingel@linux.vnet.ibm.com>
	<54419265.9000000@intel.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101814-0021-0000-0000-000001712557
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2014 15:04:21 -0700
Dave Hansen <dave.hansen@intel.com> wrote:
 
> Is there ever a time where the VMAs under an mm have mixed VM_NOZEROPAGE
> status?  Reading the patches, it _looks_ like it might be an all or
> nothing thing.

Currently it is an all or nothing thing, but for a future change we might want to just
tag the guest memory instead of the complete user address space.

> Full disclosure: I've got an x86-specific feature I want to steal a flag
> for.  Maybe we should just define another VM_ARCH bit.
> 

So you think of something like:

#if defined(CONFIG_S390)
# define VM_NOZEROPAGE	VM_ARCH_1
#endif

#ifndef VM_NOZEROPAGE
# define VM_NOZEROPAGE	VM_NONE
#endif

right?


