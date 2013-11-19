Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab3KSAeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:34:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab3KSAef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:34:35 -0500
Date: Mon, 18 Nov 2013 19:34:22 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        akpm@linux-foundation.org, dhillf@gmail.com,
        Mel Gorman <mgorman@suse.de>
Message-ID: <1384821262-c0ms59jr-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <528A94C4.80101@sr71.net>
References: <20131115225550.737E5C33@viggo.jf.intel.com>
 <20131115225553.B0E9DFFB@viggo.jf.intel.com>
 <1384800714-y653r3ch-mutt-n-horiguchi@ah.jp.nec.com>
 <1384800841-314l1f3e-mutt-n-horiguchi@ah.jp.nec.com>
 <528A6448.3080907@sr71.net>
 <1384806022-4718p9lh-mutt-n-horiguchi@ah.jp.nec.com>
 <528A7D36.5020500@sr71.net>
 <1384811778-7euptzgp-mutt-n-horiguchi@ah.jp.nec.com>
 <528A94C4.80101@sr71.net>
Subject: Re: [PATCH] mm: call cond_resched() per MAX_ORDER_NR_PAGES pages copy
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <528A94C4.80101@sr71.net>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 02:29:24PM -0800, Dave Hansen wrote:
> On 11/18/2013 01:56 PM, Naoya Horiguchi wrote:
> >> > Why bother trying to "optimize" it?
> > I thought that if we call cond_resched() too often, the copying thread can
> > take too long in a heavy load system, because the copying thread always
> > yields the CPU in every loop.
> 
> I think you're confusing cond_resched() and yield().  The way I look at it:
> 
> yield() means: "Hey scheduler, go right now and run something else I'm
> done running"
> 
> cond_resched() means: "Schedule me off if the scheduler has already
> decided something else _should_ be running"
> 
> I'm sure I'm missing some of the subtleties, but as I see it, yield()
> actively goes off and finds something else to run.  cond_resched() only
> schedules you off if you've *already* run too long.

I see.
Thanks for the explanation!

Naoya
