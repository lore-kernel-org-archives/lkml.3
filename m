Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaCKNR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:17:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53542 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaCKNRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:17:55 -0400
Date: Tue, 11 Mar 2014 14:17:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC 0/6] rework sched_domain topology description
Message-ID: <20140311131719.GY9987@twins.programming.kicks-ass.net>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
 <5317B092.7070805@arm.com>
 <CAKfTPtDGbT717Y5F1GoBgr4pnvApG5Gphu2Me_bAFrM0+qsfAg@mail.gmail.com>
 <53186A8A.9060406@arm.com>
 <CAKfTPtCspVk+X3O23ikTt3MZUHVrrp21PyhmrcLF-GwW3OjOqA@mail.gmail.com>
 <531B0FDA.2040302@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531B0FDA.2040302@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 12:40:58PM +0000, Dietmar Eggemann wrote:
> >
> >I don't have a strong opinion about using or not a cpu argument for
> >setting the flags of a level (it was part of the initial proposal
> >before we start to completely rework the build of sched_domain)
> >Nevertheless, I see one potential concern that you can have completely
> >different flags configuration of the same sd level of 2 cpus.
> 
> Could you elaborate a little bit further regarding the last sentence? Do you
> think that those completely different flags configuration would make it
> impossible, that the load-balance code could work at all at this sd?

So a problem with such an interfaces is that is makes it far too easy to
generate completely broken domains.

You can, for two cpus in the same domain provide, different flags; such
a configuration doesn't make any sense at all.

Now I see why people would like to have this; but unless we can make it
robust I'd be very hesitant to go this route.


