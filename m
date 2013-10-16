Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab3JPIgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:36:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48639 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab3JPIgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:36:04 -0400
Date: Wed, 16 Oct 2013 10:35:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/6] net: ip4_datagram_connect: Use correct form of
 statistics update
Message-ID: <20131016083545.GP10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
 <20131015174745.197380080@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015174745.197380080@linux.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 12:47:23PM -0500, Christoph Lameter wrote:
> ip4_datagram_connect is called with BH processing enabled. Therefore
> we cannot use IP_INC_STATS_BH but must use IP_INC_STATS which disables
> BH handling before incrementing the counter.
> 
> The following trace is triggered without this patch:
> 
> [ 9293.806634] __this_cpu_add operation in preemptible [00000000] code: ntpd/2150

You lost the BUG there; that really needs to be there:

 - BUG makes people pay attention
 - This was an actual BUG wasn't it?

Sure there can be false positives, but in all cases people should amend
the code. Sometimes with a comment explaining why the raw primitive
should be used; sometimes to fix an actual bug, but a patch needs to be
written. Therefore BUG!
