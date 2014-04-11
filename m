Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaDKTcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 15:32:31 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45792 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaDKTc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 15:32:29 -0400
Message-ID: <53484349.1000806@linaro.org>
Date: Fri, 11 Apr 2014 12:32:25 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Dave Hansen <dave@sr71.net>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Volatile Ranges (v12) & LSF-MM discussion fodder
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <20140401212102.GM4407@cmpxchg.org> <533B313E.5000403@zytor.com> <533B4555.3000608@sr71.net> <533B8E3C.3090606@linaro.org> <20140402163638.GQ14688@cmpxchg.org> <CALAqxLUNKJQs+q__fwqggaRtqLz5sJtuxKdVPja8X0htDyaT6A@mail.gmail.com> <20140402175852.GS14688@cmpxchg.org> <CALAqxLXs+tB3h6wqZ3m5qOFWfgeJcH03k-0dsj+NUoB5D5LEgQ@mail.gmail.com> <20140402194708.GV14688@cmpxchg.org> <533C6F6E.4080601@linaro.org>
In-Reply-To: <533C6F6E.4080601@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 01:13 PM, John Stultz wrote:
> On 04/02/2014 12:47 PM, Johannes Weiner wrote:
>
>> It's really nothing but a use-after-free bug that has consequences for
>> no-one but the faulty application.  The thing that IS new is that even
>> a read is enough to corrupt your data in this case.
>>
>> MADV_REVIVE could return 0 if all pages in the specified range were
>> present, -Esomething if otherwise.  That would be semantically sound
>> even if userspace messes up.
> So its semantically more of just a combined mincore+dirty operation..
> and nothing more?
>
> What are other folks thinking about this? Although I don't particularly
> like it, I probably could go along with Johannes' approach, forgoing
> SIGBUS for zero-fill and adapting the semantics that are in my mind a
> bit stranger. This would allow for ashmem-like style behavior w/ the
> additional  write-clears-volatile-state and read-clears-purged-state
> constraints (which I don't think would be problematic for Android, but
> am not totally sure).
>
> But I do worry that these semantics are easier for kernel-mm-developers
> to grasp, but are much much harder for application developers to
> understand.

So I don't feel like we've gotten enough feedback for consensus here.

Thus, to at least address other issues pointed out at LSF-MM, I'm going
to shortly send out a v13 of the patchset which keeps with the previous
approach instead of adopting Johannes' suggested approach here.

If folks do prefer Johannes' approach, please speak up as I'm willing to
give it a whirl, despite my concerns about the subtle semantics.

thanks
-john

