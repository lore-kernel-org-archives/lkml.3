Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaCRAhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:37:02 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61852 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaCRAhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:37:00 -0400
Message-ID: <53279525.7090101@linaro.org>
Date: Mon, 17 Mar 2014 17:36:53 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/3] vrange: Add vrange syscall and handle splitting/merging
 and marking vmas
References: <1394822013-23804-1-git-send-email-john.stultz@linaro.org> <1394822013-23804-2-git-send-email-john.stultz@linaro.org> <20140317092118.GA2210@quack.suse.cz> <20140317094339.GC2210@quack.suse.cz>
In-Reply-To: <20140317094339.GC2210@quack.suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 02:43 AM, Jan Kara wrote:
> On Mon 17-03-14 10:21:18, Jan Kara wrote:
>> On Fri 14-03-14 11:33:31, John Stultz wrote:
>>> +	for (;;) {
>>> +		unsigned long new_flags;
>>> +		pgoff_t pgoff;
>>> +		unsigned long tmp;
>>> +
>>> +		if (!vma)
>>> +			goto out;
>>> +
>>> +		if (vma->vm_flags & (VM_SPECIAL|VM_LOCKED|VM_MIXEDMAP|
>>> +					VM_HUGETLB))
>>> +			goto out;
>>> +
>>> +		/* We don't support volatility on files for now */
>>> +		if (vma->vm_file) {
>>> +			ret = -EINVAL;
>>> +			goto out;
>>> +		}
>>> +
>>> +		new_flags = vma->vm_flags;
>>> +
>>> +		if (start < vma->vm_start) {
>>> +			start = vma->vm_start;
>>> +			if (start >= end)
>>> +				goto out;
>>> +		}
>   One more question: This seems to silently skip any holes between VMAs. Is
> that really intended? I'd expect that marking unmapped range as volatile /
> non-volatile should return error... In any case what happens should be
> defined in the description.

So.. initially it was by design, but as I look at madvise and think
about it further, it does make more sense to throw errors if memory in
the range is not mapped.

I'll try to rework things to adapt to this.

thanks
-john
