Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab3HMUiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:38:00 -0400
Received: from relay3.sgi.com ([192.48.152.1]:38604 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759239Ab3HMUh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:37:59 -0400
Message-ID: <520A9924.7050301@sgi.com>
Date: Tue, 13 Aug 2013 13:37:56 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Zimmer <nzimmer@sgi.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC v3 0/5] Transparent on-demand struct page initialization
 embedded in the buddy allocator
References: <1375465467-40488-1-git-send-email-nzimmer@sgi.com> <1376344480-156708-1-git-send-email-nzimmer@sgi.com> <CA+55aFwTQLexJkf67P0b7Z7cw8fePjdDSdA4SOkM+Jf+kBPYEA@mail.gmail.com> <520A6DFC.1070201@sgi.com> <CA+55aFwRHdQ_f6ryUU1yWkW1Qz8cG958jLZuyhd_YdOq4-rfRA@mail.gmail.com> <520A7514.9020008@sgi.com> <520A83B0.40607@sgi.com> <CAE9FiQXdHWEF9aTQtTa8AjM8BTUZWg6TSUebqBr9aT8JL58c8A@mail.gmail.com>
In-Reply-To: <CAE9FiQXdHWEF9aTQtTa8AjM8BTUZWg6TSUebqBr9aT8JL58c8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/13/2013 1:24 PM, Yinghai Lu wrote:
>> > FYI, the system at this time had 128 nodes each with 256GB of memory.
>> > About 252GB was inserted into the absent list from nodes 1 .. 126.
>> > Memory on nodes 0 and 128 was left fully present.

Actually, I was corrected, it was 256 nodes with 128GB (8 * 16GB dimms -
which are just now coming out.)  So there were 254 concurrent initialization
processes running.

