Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3IPNXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:23:50 -0400
Received: from a9-97.smtp-out.amazonses.com ([54.240.9.97]:34515 "EHLO
	a9-97.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab3IPNXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:23:49 -0400
Date: Mon, 16 Sep 2013 13:23:47 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [gcv v4 05/38] percpu: Add preemption checks to __this_cpu ops
In-Reply-To: <20130916103052.GB29018@twins.programming.kicks-ass.net>
Message-ID: <0000014126f0f0e3-72d56ba0-98d8-4bdc-8a67-89c191f49ca0-000000@email.amazonses.com>
References: <20130903190014.794420260@linux.com> <00000140e5f56965-daead878-020f-4dd9-b239-5547db26f274-000000@email.amazonses.com> <20130916103052.GB29018@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.16-54.240.9.97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013, Peter Zijlstra wrote:

> On Tue, Sep 03, 2013 at 10:33:20PM +0000, Christoph Lameter wrote:
> > We define a check function in order to avoid trouble with the
> > include files. Then the higher level __this_cpu macros are
> > modified to involve the check before any operation.
> >
>
> So this_cpu_ptr() is the one with the check, and __this_cpu_ptr() is the
> one without. But for the other this_cpu ops __this_cpu_$OP() is going to
> be the one with a check and this_cpu_$OP() the one without?
>
> Sounds like a bloody marvelous idea :/

Well it was the easiest way to get the preemption checks in given.
__this_cpu has no checks like __this_cpu_ptr before this patchset.

We could rename __this_cpu_ptr to raw_cpu_ptr to make it symmetric. A
simple alias would be good for starters.

