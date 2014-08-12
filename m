Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaHLWL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 18:11:29 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57052 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbaHLWL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 18:11:28 -0400
Date: Tue, 12 Aug 2014 15:11:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pranith Kumar <bobby.prani@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "open list:SCHEDULER" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Remove ACCESS_ONCE() for jiffies
In-Reply-To: <CAJhHMCAk3VQVE_wqojF48ozB52igHGGdJQQVV+rrOCFTf-RqdQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1408121510310.26811@chino.kir.corp.google.com>
References: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com> <1407797503-24727-3-git-send-email-bobby.prani@gmail.com> <20140812055527.GI9918@twins.programming.kicks-ass.net> <CAJhHMCAk3VQVE_wqojF48ozB52igHGGdJQQVV+rrOCFTf-RqdQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014, Pranith Kumar wrote:

> It looks more like an inconsistency. These are the only three places
> which use ACCESS_ONCE() for jiffies. Also, in doc/memory-barriers.txt,
> it explicitly states that ACCESS_ONCE(jiffies) is not necessary. I
> grepped for this usage after reading that document just to make sure
> and found these three uses.
> 
> But yes, there is no harm being done by using ACCESS_ONCE().
> 

One could argue that doing ACCESS_ONCE(jiffies) is always better because 
of the context it which it is used rather than qualifying jiffies itself 
as volatile.
