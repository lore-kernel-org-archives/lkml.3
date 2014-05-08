Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaEHRMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:12:45 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42682 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaEHRMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:12:44 -0400
Message-ID: <536BBB08.3000503@linaro.org>
Date: Thu, 08 May 2014 10:12:40 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@sr71.net>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] Volatile Ranges (v14 - madvise reborn edition!)
References: <1398806483-19122-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1398806483-19122-1-git-send-email-john.stultz@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 02:21 PM, John Stultz wrote:
> Another few weeks and another volatile ranges patchset...
>
> After getting the sense that the a major objection to the earlier
> patches was the introduction of a new syscall (and its somewhat
> strange dual length/purged-bit return values), I spent some time
> trying to rework the vma manipulations so we can be we won't fail
> mid-way through changing volatility (basically making it atomic).
> I think I have it working, and thus, there is no longer the
> need for a new syscall, and we can go back to using madvise()
> to set and unset pages as volatile.

Johannes: To get some feedback, maybe I'll needle you directly here a
bit. :)

Does moving this interface to madvise help reduce your objections?  I
feel like your cleaning-the-dirty-bit idea didn't work out, but I was
hoping that by reworking the vma manipulations to be atomic, we could
move to madvise and still avoid the new syscall that you seemed bothered
by. But I've not really heard much from you recently so I worry your
concerns on this were actually elsewhere, and I'm just churning the
patch needlessly.

thanks
-john



