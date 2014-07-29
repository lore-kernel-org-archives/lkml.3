Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaG3GaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:30:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:8165 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbaG3GaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:30:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="577510798"
Date: Wed, 30 Jul 2014 06:27:52 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140729222752.GA28673@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
 <20140727173616.GA22986@intel.com>
 <CAKfTPtBR1dK-8nFGAMvEa2AC6ByZgOskkZpWEOXwzDrUD6xBDg@mail.gmail.com>
 <20140729014343.GE5203@intel.com>
 <CAKfTPtAj1sye899ac5eMwgrHOLbGmrQhmRK5xEF3s2W6y0BReQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtAj1sye899ac5eMwgrHOLbGmrQhmRK5xEF3s2W6y0BReQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 03:17:29PM +0200, Vincent Guittot wrote:
> >>
> >> IMHO, we should apply the same policy than the one i mentioned for
> >> task. So the load_avg of an entity or a cfs_rq will not be disturbed
> >> by an old but no more valid weight
> >>
> >
> > Well, I see your point. But the problem is what matters is load_avg vs. load_avg, not a
> > load_avg itself. So, if load_avg1 discards old weight if weight is changed, but load_avg2
> > has no weight changed or has weight changed, the comparison load_avg1 vs. load_avg2 is not
> > fair, but too impacted by the new weight. The point is, we count in history, so connt in the
> > real history, which is the whole point of why we count the history. Make sense?
> 
> IIUC, you want to soften the impact of weight change on cfs_rq-> load_avg ?
> 

Yes, that would be the effect.

Isn't the entire effort starting from PJT and Ben up to now to soften the extremely
dynamic changes (runnable or not, weight change, etc)? Assume task does not change
weight much, but group entity does as Peter mentioned.

