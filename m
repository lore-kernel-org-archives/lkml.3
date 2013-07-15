Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3GORzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:55:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43229 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab3GORy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:54:59 -0400
Message-ID: <51E4375E.1010704@zytor.com>
Date: Mon, 15 Jul 2013 10:54:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: Yinghai Lu <yinghai@kernel.org>, Robin Holt <holt@sgi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC 4/4] Sparse initialization of struct page array.
References: <1373594635-131067-1-git-send-email-holt@sgi.com> <1373594635-131067-5-git-send-email-holt@sgi.com> <CAE9FiQW1s2UwCY6OjzD3+2wG8SjCr1QyCpajhZbk_XhmnFQW4Q@mail.gmail.com> <20130715174551.GA58640@asylum.americas.sgi.com>
In-Reply-To: <20130715174551.GA58640@asylum.americas.sgi.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 10:45 AM, Nathan Zimmer wrote:
> 
> I hadn't actually been very happy with having a PG_uninitialized2mib flag.
> It implies if we want to jump to 1Gb pages we would need a second flag,
> PG_uninitialized1gb, for that.  I was thinking of changing it to
> PG_uninitialized and setting page->private to the correct order.
> Thoughts?
> 

Seems straightforward.  The bigger issue is the amount of overhead we
cause by having to check upstack for the initialization status of the
superpages.

I'm concerned, obviously, about lingering overhead that is "forever".
That being said, in the absolutely worst case we could have a counter to
the number of uninitialized pages which when it hits zero we do a static
switch and switch out the initialization code (would have to be undone
on memory hotplug, of course.)

	-hpa


