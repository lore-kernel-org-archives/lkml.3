Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaEHQjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:39:54 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35700 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaEHQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:39:53 -0400
Message-ID: <536BB354.2070402@linaro.org>
Date: Thu, 08 May 2014 09:39:48 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Keith Packard <keithp@keithp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] MADV_VOLATILE: Add page purging logic & SIGBUS trap
References: <1398806483-19122-1-git-send-email-john.stultz@linaro.org> <1398806483-19122-5-git-send-email-john.stultz@linaro.org> <20140508051559.GC5282@bbox>
In-Reply-To: <20140508051559.GC5282@bbox>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 10:16 PM, Minchan Kim wrote:
> On Tue, Apr 29, 2014 at 02:21:23PM -0700, John Stultz wrote:
>> +	update_hiwater_rss(mm);
>> +	if (PageAnon(page))
>> +		dec_mm_counter(mm, MM_ANONPAGES);
>> +	else
>> +		dec_mm_counter(mm, MM_FILEPAGES);
> We can add file-backed page part later when we move to suppport vrange-file.

Fair enough. That bit is easy to drop for now.

thanks
-john
