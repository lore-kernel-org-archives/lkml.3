Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3HBKdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:33:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44038 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3HBKdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:33:05 -0400
Date: Fri, 2 Aug 2013 12:32:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: =?utf-8?B?6rmA7KSA7IiY?= <iamjoonsoo.kim@lge.com>,
        "'Ingo Molnar'" <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "'Mike Galbraith'" <efault@gmx.de>, "'Paul Turner'" <pjt@google.com>,
        "'Alex Shi'" <alex.shi@intel.com>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'Morten Rasmussen'" <morten.rasmussen@arm.com>,
        "'Namhyung Kim'" <namhyung@kernel.org>,
        "'Joonsoo Kim'" <js1304@gmail.com>
Subject: Re: [PATCH v2 2/3] sched: factor out code to should_we_balance()
Message-ID: <20130802103247.GL27162@twins.programming.kicks-ass.net>
References: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375408223-10934-3-git-send-email-iamjoonsoo.kim@lge.com>
 <51FB341B.7060104@linux.vnet.ibm.com>
 <001601ce8f5f$7cbe1460$763a3d20$@lge.com>
 <51FB7B36.8030909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FB7B36.8030909@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 02:56:14PM +0530, Preeti U Murthy wrote:
> >> You need to iterate over all the groups of the sched domain env->sd and
> >> not just the first group of env->sd like you are doing above. This is to
> > 
> > I don't think so.
> > IIRC, env->sd->groups always means local group,
> > so we don't need to find our group by iterating over all the groups.
> 
> Take a look at update_sd_lb_stats(). That should clarify this. There is
> an exclusive
> local_group check there.
> 
> sd->groups points to the first group in the list of groups under this sd.

Take a look at: 88b8dac0a
