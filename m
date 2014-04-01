Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaDAXBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:01:45 -0400
Received: from www.sr71.net ([198.145.64.142]:50645 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbaDAXBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:01:43 -0400
Message-ID: <533B4555.3000608@sr71.net>
Date: Tue, 01 Apr 2014 16:01:41 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Johannes Weiner <hannes@cmpxchg.org>,
        John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>,
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
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <20140401212102.GM4407@cmpxchg.org> <533B313E.5000403@zytor.com>
In-Reply-To: <533B313E.5000403@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 02:35 PM, H. Peter Anvin wrote:
> On 04/01/2014 02:21 PM, Johannes Weiner wrote:
>> Either way, optimistic volatile pointers are nowhere near as
>> transparent to the application as the above description suggests,
>> which makes this usecase not very interesting, IMO.
> 
> ... however, I think you're still derating the value way too much.  The
> case of user space doing elastic memory management is more and more
> common, and for a lot of those applications it is perfectly reasonable
> to either not do system calls or to have to devolatilize first.

The SIGBUS is only in cases where the memory is set as volatile and
_then_ accessed, right?

John, this was something that the Mozilla guys asked for, right?  Any
idea why this isn't ever a problem for them?
