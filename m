Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaA0Wnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:43:51 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56142 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaA0Wno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:43:44 -0500
Message-ID: <52E6E11C.8080105@linaro.org>
Date: Mon, 27 Jan 2014 14:43:40 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, Rob Clark <robdclark@gmail.com>,
        Jason Evans <je@fb.com>, pliard@google.com
Subject: Re: [PATCH v10 00/16] Volatile Ranges v10
References: <1388646744-15608-1-git-send-email-minchan@kernel.org> <CAHGf_=qiQtG_7W=SfKfGHgV6p6aT3==Wnj65UAegejeoS6fLBA@mail.gmail.com>
In-Reply-To: <CAHGf_=qiQtG_7W=SfKfGHgV6p6aT3==Wnj65UAegejeoS6fLBA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 02:23 PM, KOSAKI Motohiro wrote:
> Hi Minchan,
>
>
> On Thu, Jan 2, 2014 at 2:12 AM, Minchan Kim <minchan@kernel.org> wrote:
>> Hey all,
>>
>> Happy New Year!
>>
>> I know it's bad timing to send this unfamiliar large patchset for
>> review but hope there are some guys with freshed-brain in new year
>> all over the world. :)
>> And most important thing is that before I dive into lots of testing,
>> I'd like to make an agreement on design issues and others
>>
>> o Syscall interface
>> o Not bind with vma split/merge logic to prevent mmap_sem cost and
>> o Not bind with vma split/merge logic to avoid vm_area_struct memory
>>   footprint.
>> o Purging logic - when we trigger purging volatile pages to prevent
>>   working set and stop to prevent too excessive purging of volatile
>>   pages
>> o How to test
>>   Currently, we have a patched jemalloc allocator by Jason's help
>>   although it's not perfect and more rooms to be enhanced but IMO,
>>   it's enough to prove vrange-anonymous. The problem is that
>>   lack of benchmark for testing vrange-file side. I hope that
>>   Mozilla folks can help.
>>
>> So its been a while since the last release of the volatile ranges
>> patches, again. I and John have been busy with other things.
>> Still, we have been slowly chipping away at issues and differences
>> trying to get a patchset that we both agree on.
>>
>> There's still a few issues, but we figured any further polishing of
>> the patch series in private would be unproductive and it would be much
>> better to send the patches out for review and comment and get some wider
>> opinions.
>>
>> You could get full patchset by git
>>
>> git clone -b vrange-v10-rc5 --single-branch git://git.kernel.org/pub/scm/linux/kernel/git/minchan/linux.git
> Brief comments.
>
> - You should provide jemalloc patch too. Otherwise we cannot
> understand what the your mesurement mean.
> - Your number only claimed the effectiveness anon vrange, but not file vrange.
> - Still, Nobody likes file vrange. At least nobody said explicitly on
> the list. I don't ack file vrange part until
>   I fully convinced Pros/Cons. You need to persuade other MM guys if
> you really think anon vrange is not
>   sufficient. (Maybe LSF is the best place)

I do agree that the semantics for volatile-ranges on files is more
difficult for folks to grasp (and like after doing so). I've almost
gotten to the point (as I've discussed with Minchan privately) where I'm
willing to hold back on volatile-ranges on files in the shrort-term just
to see if it helps to get key mm folks to review and comment the
volatile-ranges on anonymous memory.

That said, I do think volatile ranges on files is an important concept,
and I'd like to make sure we don't design something that can't be used
for files in the future.

Part of the major interest in volatile memory has been from web
browsers. Both Chrome and Firefox are already making use of the
file-based ashmem, where available, in order to have this "discardable
memory" feature.

And while the Mozilla developers don't see file based volatile memory as
critical right now for their needs, I can imagine as they continue to
work on multi-process firefox
(http://billmccloskey.wordpress.com/2013/12/05/multiprocess-firefox/)
for performance and security reasons, the need to have memory volatility
shared between processes will become more important.


thanks
-john

