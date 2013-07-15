Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3GOS0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:26:18 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58793 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753580Ab3GOS0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:26:17 -0400
Date: Mon, 15 Jul 2013 13:26:15 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, Yinghai Lu <yinghai@kernel.org>,
        Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC 4/4] Sparse initialization of struct page array.
Message-ID: <20130715182615.GF3421@sgi.com>
References: <1373594635-131067-1-git-send-email-holt@sgi.com>
 <1373594635-131067-5-git-send-email-holt@sgi.com>
 <CAE9FiQW1s2UwCY6OjzD3+2wG8SjCr1QyCpajhZbk_XhmnFQW4Q@mail.gmail.com>
 <20130715174551.GA58640@asylum.americas.sgi.com>
 <51E4375E.1010704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E4375E.1010704@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 10:54:38AM -0700, H. Peter Anvin wrote:
> On 07/15/2013 10:45 AM, Nathan Zimmer wrote:
> > 
> > I hadn't actually been very happy with having a PG_uninitialized2mib flag.
> > It implies if we want to jump to 1Gb pages we would need a second flag,
> > PG_uninitialized1gb, for that.  I was thinking of changing it to
> > PG_uninitialized and setting page->private to the correct order.
> > Thoughts?
> > 
> 
> Seems straightforward.  The bigger issue is the amount of overhead we
> cause by having to check upstack for the initialization status of the
> superpages.
> 
> I'm concerned, obviously, about lingering overhead that is "forever".
> That being said, in the absolutely worst case we could have a counter to
> the number of uninitialized pages which when it hits zero we do a static
> switch and switch out the initialization code (would have to be undone
> on memory hotplug, of course.)

Is there a fairly cheap way to determine definitively that the struct
page is not initialized?

I think this patch set can change fairly drastically if we have that.
I think I will start working up those changes and code a heavy-handed
check until I hear of an alternative way to cheaply check.

Thanks,
Robin
