Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbaCSDVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 23:21:16 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62423 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaCSDVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 23:21:15 -0400
Date: Tue, 18 Mar 2014 20:20:15 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Suleiman Souhlal <suleiman@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: performance regression due to commit e82e0561("mm: vmscan: obey
 proportional scanning requirements for kswapd")
In-Reply-To: <20140318063822.GS29270@yliu-dev.sh.intel.com>
Message-ID: <alpine.LSU.2.11.1403182012350.975@eggly.anvils>
References: <20140218080122.GO26593@yliu-dev.sh.intel.com> <20140312165447.GO10663@suse.de> <alpine.LSU.2.11.1403130516050.10128@eggly.anvils> <20140314142103.GV10663@suse.de> <alpine.LSU.2.11.1403152040380.21540@eggly.anvils>
 <20140318063822.GS29270@yliu-dev.sh.intel.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Yuanhan Liu wrote:
> On Sat, Mar 15, 2014 at 08:56:10PM -0700, Hugh Dickins wrote:
> > On Fri, 14 Mar 2014, Mel Gorman wrote:
> > > 
> > > You say it's already been tested for months but it would be nice if the
> > > workload that generated this thread was also tested.
> > 
> > Yes indeed: Yuanhan, do you have time to try this patch for your
> > testcase?  I'm hoping it will prove at least as effective as your
> > own suggested patch, but please let us know what you find - thanks.
> 
> Hi Hugh,
> 
> Sure, and sorry to tell you that this patch introduced another half
> performance descrease from avg 60 MB/s to 30 MB/s in this testcase.

Thanks a lot for trying it out.  I had been hoping that everything
would be wonderful, and I wouldn't have think at all about what's
going on.  You have made me sad :( but I can't blame your honesty!

I'll have to think a little after all, about your test, and Mel's
pertinent questions: I'll come back to you, nothing to say right now.

Hugh

> 
> Moreover, the dd throughput for each process was steady before, however,
> it's quite bumpy from 20 MB/s to 40 MB/s w/ this patch applied, and thus
> got a avg of 30 MB/s:
> 
>     11327188992 bytes (11 GB) copied, 300.014 s, 37.8 MB/s
>     1809373+0 records in
>     1809372+0 records out
>     7411187712 bytes (7.4 GB) copied, 300.008 s, 24.7 MB/s
>     3068285+0 records in
>     3068284+0 records out
>     12567691264 bytes (13 GB) copied, 300.001 s, 41.9 MB/s
>     1883877+0 records in
>     1883876+0 records out
>     7716356096 bytes (7.7 GB) copied, 300.002 s, 25.7 MB/s
>     1807674+0 records in
>     1807673+0 records out
>     7404228608 bytes (7.4 GB) copied, 300.024 s, 24.7 MB/s
>     1796473+0 records in
>     1796472+0 records out
>     7358349312 bytes (7.4 GB) copied, 300.008 s, 24.5 MB/s
>     1905655+0 records in
>     1905654+0 records out
>     7805558784 bytes (7.8 GB) copied, 300.016 s, 26.0 MB/s
>     2819168+0 records in
>     2819167+0 records out
>     11547308032 bytes (12 GB) copied, 300.025 s, 38.5 MB/s
>     1848381+0 records in
>     1848380+0 records out
>     7570964480 bytes (7.6 GB) copied, 300.005 s, 25.2 MB/s
>     3023133+0 records in
>     3023132+0 records out
>     12382748672 bytes (12 GB) copied, 300.024 s, 41.3 MB/s
>     1714585+0 records in
>     1714584+0 records out
>     7022936064 bytes (7.0 GB) copied, 300.011 s, 23.4 MB/s
>     1835132+0 records in
>     1835131+0 records out
>     7516696576 bytes (7.5 GB) copied, 299.998 s, 25.1 MB/s
>     1733341+0 records in
>     
> 
> 	--yliu
> 
