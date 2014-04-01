Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaDASbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:31:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbaDASbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:31:44 -0400
Message-ID: <533B0603.7040301@redhat.com>
Date: Tue, 01 Apr 2014 14:31:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, shli@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] x86,mm: delay TLB flush after clearing accessed bit
References: <20140331113442.0d628362@annuminas.surriel.com>	<CA+55aFzG=B3t_YaoCY_H1jmEgs+cYd--ZHz7XhGeforMRvNfEQ@mail.gmail.com>	<533AE518.1090705@redhat.com> <CA+55aFx9KYTV_N3qjV6S9uu6iTiVZimXhZtUa9UYRkNR9P-7RQ@mail.gmail.com>
In-Reply-To: <CA+55aFx9KYTV_N3qjV6S9uu6iTiVZimXhZtUa9UYRkNR9P-7RQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 12:21 PM, Linus Torvalds wrote:
> On Tue, Apr 1, 2014 at 9:11 AM, Rik van Riel <riel@redhat.com> wrote:
>>
>> Memory pressure is not necessarily caused by the same process
>> whose accessed bit we just cleared. Memory pressure may not
>> even be caused by any process's virtual memory at all, but it
>> could be caused by the page cache.
> 
> If we have that much memory pressure on the page cache without having
> any memory pressure on the actual VM space, then the swap-out activity
> will never be an issue anyway.
> 
> IOW, I think all these scenarios are made-up. I'd much rather go for
> simpler implementation, and make things more complex only in the
> presence of numbers. Of which we have none.

We've been bitten by the lack of a properly tracked accessed
bit before, but admittedly that was with the KVM code and EPT.

I'll add my Acked-by: to Shaohua's original patch then, and
will keep my eyes open for any problems that may or may not
materialize...

Shaohua?

-- 
All rights reversed
