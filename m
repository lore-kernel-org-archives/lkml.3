Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3IPILl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:11:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43701 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab3IPILj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:11:39 -0400
Date: Mon, 16 Sep 2013 10:11:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 1/2] sched: calculate_imbalance: Fix local->avg_load >
 sds->avg_load case
Message-ID: <20130916081132.GP21832@twins.programming.kicks-ass.net>
References: <8f596cc6bc0e5e655119dc892c9bfcad26e971f4.1379252740.git.vdavydov@parallels.com>
 <20130916055202.GL21832@twins.programming.kicks-ass.net>
 <5236BBF0.8030505@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5236BBF0.8030505@parallels.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:06:08PM +0400, Vladimir Davydov wrote:
> On 09/16/2013 09:52 AM, Peter Zijlstra wrote:
> >On Sun, Sep 15, 2013 at 05:49:13PM +0400, Vladimir Davydov wrote:

> >>-	if (busiest->avg_load < sds->avg_load) {
> >>+	if (busiest->avg_load <= sds->avg_load ||
> >>+	    local->avg_load >= sds->avg_load) {
> >>  		env->imbalance = 0;
> >>  		return fix_small_imbalance(env, sds);
> >>  	}
> >Why the = part? Surely 'busiest->avg_load < sds->avg_load ||
> >local->avg_load > sds->avg_load' avoids both underflows?
> 
> Of course it does, but env->imbalance will be assigned to 0 anyway in =
> case, so why not go shortcut?

D'uh right.. hadn't had my morning juice yet.
