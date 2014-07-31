Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbaGaKRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:17:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:49223 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaGaKRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:17:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,771,1400050800"; 
   d="scan'208";a="578136826"
Date: Thu, 31 Jul 2014 10:15:33 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140731021532.GE28673@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <20140718153931.GJ8700@e103034-lin>
 <20140727190237.GB22986@intel.com>
 <20140730101331.GB15761@e103687>
 <20140730191739.GD28673@intel.com>
 <20140731085421.GD3001@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731085421.GD3001@e103034-lin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 09:54:21AM +0100, Morten Rasmussen wrote:
> 
> Overall, it is not clear to me why it is necessary to rewrite the
> per-entity load-tracking. The code is somewhat simpler, but I don't see
> any functional additions/improvements. If we have to go through a long
> review and testing process, why not address some of the most obvious
> issues with the existing implementation while we are at it? I don't see
> the point in replacing something sub-optimal with equally sub-optimal
> (or worse).
> 

This is absolutely nonsense. First, we have improvements, second, even
with no functions addition, but do you really understand what has been
changed besides simpler. Even just simpler, simpler means a lot of things..

> > I do think there absolutely can be sub-optimal cases.

I said there absolutely can be sub-optimal cases, which exactly referred to
the example you gave (one 10% 88761 vs. 8 100% 1024). Still, the links
does not say anything about how serious. Exist, yes, serious, don't know.

> > But as I said, I just don't think the problem description is clear enough.

I said your description is not clear enough, and at the time I was not
clear either. Arguably and sadly, none of what you said in this response
made a tiny little progress. About blocked load, prediction, ..., can you
be more wrong?

The problem is not weight scaling. The problem is how weight is accumulated
when not runnable. Why? Consider this, if all tasks are always runnalbe,
weight scaling cann't be more right.

WRT runnalbe weight, currently, it is runnalbe% * weight (simplified).
Since weight has so big range, it dwarfs runnable time ratio. So maybe what
can be done is (what I have in mind):

1) runnalbe%^2 * weight
2) bigger weight does faster decay

Still, if you can prove the issue is serious, we can try something..., but just
nothing is perfect.

Thanks,
Yuyang
