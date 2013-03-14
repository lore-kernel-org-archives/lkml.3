Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab3CNMjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:39:40 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:42575 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab3CNMjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:39:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130314091342.GB1377@redhat.com>
References: <1363196663-4258-1-git-send-email-fweisbec@gmail.com>
	<20130314071427.GB7869@gmail.com>
	<20130314091342.GB1377@redhat.com>
Date: Thu, 14 Mar 2013 13:39:35 +0100
Message-ID: <CAFTL4hzTwiN8b8=SYVbt0NxMu1Y6ijO4-7aV1JVCBuvUbNmc5Q@mail.gmail.com>
Subject: Re: [GIT PULL] sched: Cputime update for 3.10
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/14 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Thu, Mar 14, 2013 at 08:14:27AM +0100, Ingo Molnar wrote:
>> Hm, is this a new bug? When was it introduced and is upstream affected as
>> well?
>
> Commit 0cf55e1ec08bb5a22e068309e2d8ba1180ab4239 start to use scalling
> for whole thread group, so increase chances of hitting multiplication
> overflow, depending on how many CPUs are on the system.

Yeah, it was introduced with that commit. Although problems was there
back when we started scaling cputime against precise sched runtime.
But certainly that commit 0cf55e1ec08bb5a22e068309e2d8ba1180ab4239
made the bug visible and happening in practice.

And indeed upstream is affected.
