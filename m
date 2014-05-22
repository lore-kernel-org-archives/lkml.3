Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbaEVQa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:30:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaEVQa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:30:57 -0400
Date: Thu, 22 May 2014 17:30:51 +0100
From: Mel Gorman <mgorman@suse.de>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Dave Chinner <david@fromorbit.com>, Bob Liu <bob.liu@oracle.com>,
        Jan Kara <jack@suse.cz>, Rik van Riel <riel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Shrinkers and proportional reclaim
Message-ID: <20140522163051.GJ23991@suse.de>
References: <1400749779-24879-1-git-send-email-mgorman@suse.de>
 <20140522161416.GD25013@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140522161416.GD25013@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 12:14:16AM +0800, Yuanhan Liu wrote:
> On Thu, May 22, 2014 at 10:09:36AM +0100, Mel Gorman wrote:
> > This series is aimed at regressions noticed during reclaim activity. The
> > first two patches are shrinker patches that were posted ages ago but never
> > merged for reasons that are unclear to me. I'm posting them again to see if
> > there was a reason they were dropped or if they just got lost. Dave?  Time?
> > The last patch adjusts proportional reclaim. Yuanhan Liu, can you retest
> > the vm scalability test cases on a larger machine? Hugh, does this work
> > for you on the memcg test cases?
> 
> Sure, and here is the result. I applied these 3 patches on v3.15-rc6,
> and head commit is 60c10afd. e82e0561 is the old commit that introduced
> the regression.  The testserver has 512G memory and 120 CPU.
> 
> It's a simple result; if you need more data, I can gather them and send
> it to you tomorrow:
> 
> e82e0561        v3.15-rc6       60c10afd
> ----------------------------------------
> 18560785        12232122        38868453
>                 -34%            +109
> 
> As you can see, the performance is back, and it is way much better ;)
> 

Thanks a lot for that and the quick response. It is much appreciated.

-- 
Mel Gorman
SUSE Labs
