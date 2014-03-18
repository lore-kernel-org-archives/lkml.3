Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbaCRRxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:53:06 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:65475 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902AbaCRRxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140318122425.GD3191@dhcp22.suse.cz>
References: <1394822013-23804-1-git-send-email-john.stultz@linaro.org>
	<20140318122425.GD3191@dhcp22.suse.cz>
Date: Tue, 18 Mar 2014 10:53:03 -0700
Message-ID: <CALAqxLU30YQs9PQaybWnTXOkVWGVX2Y7zOSLJH3Y4YSq_KDp3Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] Volatile Ranges (v11)
From: John Stultz <john.stultz@linaro.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dgiani@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 5:24 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Fri 14-03-14 11:33:30, John Stultz wrote:
> [...]
>> Volatile ranges provides a method for userland to inform the kernel that
>> a range of memory is safe to discard (ie: can be regenerated) but
>> userspace may want to try access it in the future.  It can be thought of
>> as similar to MADV_DONTNEED, but that the actual freeing of the memory
>> is delayed and only done under memory pressure, and the user can try to
>> cancel the action and be able to quickly access any unpurged pages. The
>> idea originated from Android's ashmem, but I've since learned that other
>> OSes provide similar functionality.
>
> Maybe I have missed something (I've only glanced through the patches)
> but it seems that marking a range volatile doesn't alter neither
> reference bits nor position in the LRU. I thought that a volatile page
> would be moved to the end of inactive LRU with the reference bit
> dropped. Or is this expectation wrong and volatility is not supposed to
> touch page aging?

Hrmm. So you're right, I had talked about how we'd end up purging
pages in a range together (as opposed to just randomly) because the
pages would have been marked together. On this pass, I was trying to
avoid touching all the pages on every operation, but I'll try to add
the referencing to keep it consistent with what was discussed (and
we'll get a sense of the performance impact).

Though subtleties like this are still open for discussion. For
instance, Minchan would like to see the volatile pages moved to the
front of the LRU instead of the back.

thanks
-john
