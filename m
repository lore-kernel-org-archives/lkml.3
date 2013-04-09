Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655Ab3DINQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:16:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11473 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532Ab3DINQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:16:11 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DRErq4JoInYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=7MGjZ8EY_YsA:10 a=JfrnYn6hAAAA:8 a=D19gQVrFAAAA:8 a=v5fiLApgLk14Jc-GrVQA:9 a=QEXdDO2ut3YA:10 a=3Rfx1nUSh_UA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365513368.25498.47.camel@gandalf.local.home>
Subject: Re: [PATCH v4] sched: fix wrong rq's runnable_avg update with rt
 tasks
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>
Date: Tue, 09 Apr 2013 09:16:08 -0400
In-Reply-To: <CAKfTPtDKSkhi+nNsFV9Z6hsLxhbHd-Na9YxvNzr9iXG8SdQvhQ@mail.gmail.com>
References: <1365084959-28374-1-git-send-email-vincent.guittot@linaro.org>
	 <1365497753.2609.163.camel@laptop>
	 <CAKfTPtDKSkhi+nNsFV9Z6hsLxhbHd-Na9YxvNzr9iXG8SdQvhQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 14:18 +0200, Vincent Guittot wrote:
> On 9 April 2013 10:55, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2013-04-04 at 16:15 +0200, Vincent Guittot wrote:
> >> Changes since V2:
> >> - remove useless definition for UP platform
> >> - rebased on top of Steven Rostedt's patches :
> >> https://lkml.org/lkml/2013/2/12/558
> >
> > So what's the status of those patches? I still worry about the extra
> > context switch overhead for the high-frequency idle scenario.
> 
> I don't know. I have seen a pulled answer from Ingo but can't find the
> commits in the tip tree.
> 
> Steve, have you got more info about the status of your patches ?
> 

Yeah, I asked Ingo to revert it due to Peter's concerns. I was able to
get the latencies I needed without that patch set. That made it not so
urgent.

Can you rebase your patches doing something similar? That is, still use
the pre/post_schedule_idle() calls, but don't base it off of my patch
set.

Thanks,

-- Steve


