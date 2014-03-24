Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbaCXABv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 20:01:51 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43849 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaCXABu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 20:01:50 -0400
MIME-Version: 1.0
In-Reply-To: <1395436655-21670-5-git-send-email-john.stultz@linaro.org>
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <1395436655-21670-5-git-send-email-john.stultz@linaro.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 23 Mar 2014 17:01:29 -0700
Message-ID: <CAHGf_=qMSKTG0_2hAETm_KPgovObJE=kXY4RTN5wWN7SuPgVBA@mail.gmail.com>
Subject: Re: [PATCH 4/5] vrange: Set affected pages referenced when marking volatile
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 2:17 PM, John Stultz <john.stultz@linaro.org> wrote:
> One issue that some potential users were concerned about, was that
> they wanted to ensure that all the pages from one volatile range
> were purged before we purge pages from a different volatile range.
> This would prevent the case where they have 4 large objects, and
> the system purges one page from each object, casuing all of the
> objects to have to be re-created.
>
> The counter-point to this case, is when an application is using the
> SIGBUS semantics to continue to access pages after they have been
> marked volatile. In that case, the desire was that the most recently
> touched pages be purged last, and only the "cold" pages be purged
> from the specified range.
>
> Instead of adding option flags for the various usage model (at least
> initially), one way of getting a solutoin for both uses would be to
> have the act of marking pages as volatile in effect mark the pages
> as accessed. Since all of the pages in the range would be marked
> together, they would be of the same "age" and would (approximately)
> be purged together. Further, if any pages in the range were accessed
> after being marked volatile, they would be moved to the end of the
> lru and be purged later.

If you run after two hares, you will catch neither. I suspect this patch
doesn't make happy any user.
I suggest to aim former case (object level caching) and aim latter by
another patch-kit.
