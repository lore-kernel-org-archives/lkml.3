Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbaJVKJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:09:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54921 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbaJVKJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:09:39 -0400
Message-ID: <5447825B.5040608@redhat.com>
Date: Wed, 22 Oct 2014 12:09:31 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
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
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 3/4] s390/mm: prevent and break zero page mappings in
 case of storage keys
References: <1413966624-12447-1-git-send-email-dingel@linux.vnet.ibm.com> <1413966624-12447-4-git-send-email-dingel@linux.vnet.ibm.com>
In-Reply-To: <1413966624-12447-4-git-send-email-dingel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 10:30 AM, Dominik Dingel wrote:
> As use_skey is already the condition on which we call s390_enable_skey
> we need to introduce a new flag for the mm->context on which we decide
> if zero page mapping is allowed.

Can you explain better why "mm->context.use_skey = 1" cannot be done
before the walk_page_range?  Where does the walk or __s390_enable_skey
or (after the next patch) ksm_madvise rely on
"mm->context.forbids_zeropage && !mm->context.use_skey"?

The only reason I can think of, is that the next patch does not reset
"mm->context.forbids_zeropage" to 0 if the ksm_madvise fails.  Why
doesn't it do that---or is it a bug?

Thanks, and sorry for the flurry of questions! :)

Paolo
