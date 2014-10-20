Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaJTSPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:15:04 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34383 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJTSPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:15:01 -0400
Message-ID: <5445511D.1090603@redhat.com>
Date: Mon, 20 Oct 2014 20:14:53 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
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
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 2/4] mm: introduce new VM_NOZEROPAGE flag
References: <1413554990-48512-1-git-send-email-dingel@linux.vnet.ibm.com>	<1413554990-48512-3-git-send-email-dingel@linux.vnet.ibm.com>	<54419265.9000000@intel.com> <20141018164928.2341415f@BR9TG4T3.de.ibm.com> <54429521.80402@intel.com>
In-Reply-To: <54429521.80402@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2014 06:28 PM, Dave Hansen wrote:
> > Currently it is an all or nothing thing, but for a future change we might want to just
> > tag the guest memory instead of the complete user address space.
>
> I think it's a bad idea to reserve a flag for potential future use.  If
> you_need_  it in the future, let's have the discussion then.  For now, I
> think it should probably just be stored in the mm somewhere.

I agree with Dave (I thought I disagreed, but I changed my mind while 
writing down my thoughts).  Just define mm_forbids_zeropage in 
arch/s390/include/asm, and make it return mm->context.use_skey---with a 
comment explaining how this is only for processes that use KVM, and then 
only for guests that use storage keys.

Paolo (who was just taught what storage keys really are)
