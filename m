Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3HPLAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 07:00:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab3HPLAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 07:00:34 -0400
Date: Fri, 16 Aug 2013 13:00:31 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Tebulin <tebulin@googlemail.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [Bug] Reproducible data corruption on i5-3340M: Please continue
 your great work! :-)
Message-ID: <20130816110031.GA13507@dhcp22.suse.cz>
References: <520BB225.8030807@gmail.com>
 <20130814174039.GA24033@dhcp22.suse.cz>
 <CA+55aFwAz7GdcB6nC0Th42y8eAM591sKO1=mYh5SWgyuDdHzcA@mail.gmail.com>
 <20130814182756.GD24033@dhcp22.suse.cz>
 <CA+55aFxB6Wyj3G3Ju8E7bjH-706vi3vysuATUZ13h1tdYbCbnQ@mail.gmail.com>
 <520C9E78.2020401@gmail.com>
 <CA+55aFy2D2hTc_ina1DvungsCL4WU2OTM=bnVb8sDyDcGVCBEQ@mail.gmail.com>
 <CA+55aFxuUrcod=X2t2yqR_zJ4s1uaCsGB-p1oLTQrG+y+Z2PbA@mail.gmail.com>
 <520D5ED2.9040403@gmail.com>
 <CA+55aFwFx7uhtDTX5vfiYRo+keLmuvxvSFupU4nB8g1KCN-WVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwFx7uhtDTX5vfiYRo+keLmuvxvSFupU4nB8g1KCN-WVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-08-13 17:33:28, Linus Torvalds wrote:
> On Thu, Aug 15, 2013 at 4:05 PM, Ben Tebulin <tebulin@googlemail.com> wrote:
> >
> >> Ben, please test. I'm worried that the problem you see is something
> >> even more fundamentally wrong with the whole "oops, must flush in the
> >> middle" logic, but I'm _hoping_ this fixes it.
> >
> > It's gone.
> >
> > Really!
> >
> > I git-fsck'ed successfully around 30 times in a row.
> > And even all the other things still seem to work ;-)
> 
> Goodie. I think I'm just going to commit it (with the speling fixes
> for other architectures) asap. It's bigger than I'd like, but it's a
> lot simpler than the alternatives of trying to figure out exactly
> which call chain got things wrong with the previous confusing model.

I was thinking about teaching __tlb_remove_page to update the range
automatically from the given address.

But your patch looks good to me as well.

Feel free to add
Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks!
-- 
Michal Hocko
SUSE Labs
