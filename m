Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaG3ImY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:42:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:47908 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaG3ImW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:42:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="577567860"
Date: Wed, 30 Jul 2014 08:40:07 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140730004007.GC28673@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
 <20140727173616.GA22986@intel.com>
 <CAKfTPtBR1dK-8nFGAMvEa2AC6ByZgOskkZpWEOXwzDrUD6xBDg@mail.gmail.com>
 <20140729014343.GE5203@intel.com>
 <CAKfTPtAj1sye899ac5eMwgrHOLbGmrQhmRK5xEF3s2W6y0BReQ@mail.gmail.com>
 <20140729222752.GA28673@intel.com>
 <20140730083008.GD19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730083008.GD19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 10:30:08AM +0200, Peter Zijlstra wrote:
> > 
> > Isn't the entire effort starting from PJT and Ben up to now to soften the extremely
> > dynamic changes (runnable or not, weight change, etc)? Assume task does not change
> > weight much, but group entity does as Peter mentioned.
> 
> No, softening isn't the point at all. But an integrator is the only
> means of predicting the future given the erratic past.
> 
> The whole point we got into this game is to better compute per cpu group
> weights, not to soften stuff, that's just a necessarily evil to more
> accurately predict erratic/unknown behaviour.
> 
> 
Yes, I totally agree. I think what I meant by "soften" is the *effect* of the integrator
that takes/averages the infinite history to predict the tufure.

