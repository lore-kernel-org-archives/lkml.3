Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaG2O7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:59:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:37975 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaG2O7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:59:12 -0400
Date: Tue, 29 Jul 2014 16:59:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Rik van Riel <riel@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        jhladky@redhat.com, ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
Message-ID: <20140729145910.GH3935@laptop>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
 <1406571388-3227-2-git-send-email-riel@redhat.com>
 <CAKfTPtDuFLOf3Kzt4PSdox3HpBoz9aWXb-QzkibAL-Z4xBm=tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDuFLOf3Kzt4PSdox3HpBoz9aWXb-QzkibAL-Z4xBm=tw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 11:04:50AM +0200, Vincent Guittot wrote:
> > In situations where all the domains are overloaded, or where only the
> > busiest domain is overloaded, that code is also superfluous, since
> > the normal env->imbalance calculation will figure out how much to move.
> > Remove the load_above_capacity calculation.
> 
> IMHO, we should not remove that part which is used by prefer_sibling
> 
> Originally, we had 2 type of busiest group: overloaded or imbalanced.
> You add a new one which has only a avg_load higher than other so you
> should handle this new case and keep the other ones unchanged

Right, so we want that code for overloaded -> overloaded migrations such
as not to cause idle cpus in an attempt to balance things. Idle cpus are
worse than imbalance.

But in case of overloaded/imb -> !overloaded migrations we can allow it,
and in fact want to allow it in order to balance idle cpus.
