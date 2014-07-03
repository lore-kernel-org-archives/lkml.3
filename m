Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbaGCPbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:31:24 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:60376 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaGCPbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:31:23 -0400
MIME-Version: 1.0
In-Reply-To: <1404362358.8764.6.camel@j-VirtualBox>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
	<20140702162749.GP19379@twins.programming.kicks-ass.net>
	<1404320356.3170.12.camel@j-VirtualBox>
	<20140702172333.GQ19379@twins.programming.kicks-ass.net>
	<1404322203.3170.17.camel@j-VirtualBox>
	<1404362358.8764.6.camel@j-VirtualBox>
Date: Thu, 3 Jul 2014 08:31:22 -0700
X-Google-Sender-Auth: T5g_KOBvi_mVF-vXb3HByHprpsU
Message-ID: <CA+55aFw6CF0La9FO5jX_BvukjwW618vihqVm-hPXfUpL_5dhBA@mail.gmail.com>
Subject: Re: [RFC] Cancellable MCS spinlock rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jej B <James.Bottomley@hansenpartnership.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 9:39 PM, Jason Low <jason.low2@hp.com> wrote:
>
> And due to padding, the additional modification below reduces the
> size of struct rw_semaphore by 64 bits on my machine  :)

Well, I think you could also make 'count' just be 'int' instead of 'long'.

I don't think we'll support 2 _billion_ processes/threads waiting on
the same semaphore any time soon, so the 'long' seems a bit of an
overkill on 64-bit architectures.

          Linus.
