Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3KRUtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:49:51 -0500
Received: from www.sr71.net ([198.145.64.142]:36337 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab3KRUtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:49:49 -0500
Message-ID: <528A7D36.5020500@sr71.net>
Date: Mon, 18 Nov 2013 12:48:54 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        akpm@linux-foundation.org, dhillf@gmail.com,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: call cond_resched() per MAX_ORDER_NR_PAGES pages
 copy
References: <20131115225550.737E5C33@viggo.jf.intel.com> <20131115225553.B0E9DFFB@viggo.jf.intel.com> <1384800714-y653r3ch-mutt-n-horiguchi@ah.jp.nec.com> <1384800841-314l1f3e-mutt-n-horiguchi@ah.jp.nec.com> <528A6448.3080907@sr71.net> <1384806022-4718p9lh-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1384806022-4718p9lh-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 12:20 PM, Naoya Horiguchi wrote:
>> > Really, though, a lot of things seem to have MAX_ORDER set up so that
>> > it's at 256MB or 512MB.  That's an awful lot to do between rescheds.
> Yes.
> 
> BTW, I found that we have the same problem for other functions like
> copy_user_gigantic_page, copy_user_huge_page, and maybe clear_gigantic_page.
> So we had better handle them too.

Is there a problem you're trying to solve here?  The common case of the
cond_resched() call boils down to a read of a percpu variable which will
surely be in the L1 cache after the first run around the loop.  In other
words, it's about as cheap of an operation as we're going to get.

Why bother trying to "optimize" it?
