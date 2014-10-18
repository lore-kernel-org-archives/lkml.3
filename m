Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaJRQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 12:28:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:3386 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaJRQ2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 12:28:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,745,1406617200"; 
   d="scan'208";a="616581327"
Message-ID: <54429521.80402@intel.com>
Date: Sat, 18 Oct 2014 09:28:17 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Dominik Dingel <dingel@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
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
References: <1413554990-48512-1-git-send-email-dingel@linux.vnet.ibm.com>	<1413554990-48512-3-git-send-email-dingel@linux.vnet.ibm.com>	<54419265.9000000@intel.com> <20141018164928.2341415f@BR9TG4T3.de.ibm.com>
In-Reply-To: <20141018164928.2341415f@BR9TG4T3.de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2014 07:49 AM, Dominik Dingel wrote:
> On Fri, 17 Oct 2014 15:04:21 -0700
> Dave Hansen <dave.hansen@intel.com> wrote:
>> Is there ever a time where the VMAs under an mm have mixed VM_NOZEROPAGE
>> status?  Reading the patches, it _looks_ like it might be an all or
>> nothing thing.
> 
> Currently it is an all or nothing thing, but for a future change we might want to just
> tag the guest memory instead of the complete user address space.

I think it's a bad idea to reserve a flag for potential future use.  If
you _need_ it in the future, let's have the discussion then.  For now, I
think it should probably just be stored in the mm somewhere.

>> Full disclosure: I've got an x86-specific feature I want to steal a flag
>> for.  Maybe we should just define another VM_ARCH bit.
>>
> 
> So you think of something like:
> 
> #if defined(CONFIG_S390)
> # define VM_NOZEROPAGE	VM_ARCH_1
> #endif
> 
> #ifndef VM_NOZEROPAGE
> # define VM_NOZEROPAGE	VM_NONE
> #endif
> 
> right?

Yeah, something like that.

