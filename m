Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3KRWaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:30:21 -0500
Received: from www.sr71.net ([198.145.64.142]:36889 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab3KRWaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:30:19 -0500
Message-ID: <528A94C4.80101@sr71.net>
Date: Mon, 18 Nov 2013 14:29:24 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        akpm@linux-foundation.org, dhillf@gmail.com,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: call cond_resched() per MAX_ORDER_NR_PAGES pages
 copy
References: <20131115225550.737E5C33@viggo.jf.intel.com> <20131115225553.B0E9DFFB@viggo.jf.intel.com> <1384800714-y653r3ch-mutt-n-horiguchi@ah.jp.nec.com> <1384800841-314l1f3e-mutt-n-horiguchi@ah.jp.nec.com> <528A6448.3080907@sr71.net> <1384806022-4718p9lh-mutt-n-horiguchi@ah.jp.nec.com> <528A7D36.5020500@sr71.net> <1384811778-7euptzgp-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1384811778-7euptzgp-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 01:56 PM, Naoya Horiguchi wrote:
>> > Why bother trying to "optimize" it?
> I thought that if we call cond_resched() too often, the copying thread can
> take too long in a heavy load system, because the copying thread always
> yields the CPU in every loop.

I think you're confusing cond_resched() and yield().  The way I look at it:

yield() means: "Hey scheduler, go right now and run something else I'm
done running"

cond_resched() means: "Schedule me off if the scheduler has already
decided something else _should_ be running"

I'm sure I'm missing some of the subtleties, but as I see it, yield()
actively goes off and finds something else to run.  cond_resched() only
schedules you off if you've *already* run too long.


