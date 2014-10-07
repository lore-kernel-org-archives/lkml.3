Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaJGH3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:29:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37842 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaJGH3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:29:48 -0400
Date: Tue, 7 Oct 2014 09:29:42 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] workqueue: add quiescent state between work items
Message-ID: <20141007072942.GA2088@nanopsycho.orion>
References: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
 <1412529862-17954-2-git-send-email-joe.lawrence@stratus.com>
 <20141005192119.GE8549@htj.dyndns.org>
 <20141005194748.GG8549@htj.dyndns.org>
 <20141006042158.GW5015@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006042158.GW5015@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, Oct 06, 2014 at 06:21:58AM CEST, paulmck@linux.vnet.ibm.com wrote:
>On Sun, Oct 05, 2014 at 03:47:48PM -0400, Tejun Heo wrote:
>> On Sun, Oct 05, 2014 at 03:21:19PM -0400, Tejun Heo wrote:
>> > On Sun, Oct 05, 2014 at 01:24:21PM -0400, Joe Lawrence wrote:
>> > > Similar to the stop_machine deadlock scenario on !PREEMPT kernels
>> > > addressed in b22ce2785d97 "workqueue: cond_resched() after processing
>> > > each work item", kworker threads requeueing back-to-back with zero jiffy
>> > > delay can stall RCU. The cond_resched call introduced in that fix will
>> > > yield only iff there are other higher priority tasks to run, so force a
>> > > quiescent RCU state between work items.
>> > > 
>> > > Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
>> > > Link: https://lkml.kernel.org/r/20140926105227.01325697@jlaw-desktop.mno.stratus.com
>> > > Link: https://lkml.kernel.org/r/20140929115445.40221d8e@jlaw-desktop.mno.stratus.com
>> > > Fixes: b22ce2785d97 ("workqueue: cond_resched() after processing each work item")
>> > > Cc: <stable@vger.kernel.org>
>> > 
>> > Applied to wq/for-3.17-fixes.  If 3.17 comes out before this gets
>> > merged, I'll send it as for-3.18.
>> 
>> Oops, the rcu calls aren't in mainline yet.  I think it'd be best to
>> route these through the RCU tree.  Paul, can you please route these
>> two patches?
>> 
>> Acked-by: Tejun Heo <tj@kernel.org>
>
>Will do!
>
>I will try 3.17, failing that, 3.18.


Paul, Tehun, how do you propose to fix this on older kernels which do
not have rcu_note_voluntary_context_switch? I'm particullary interested
in 3.10.

Thanks.
