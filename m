Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbaGCPfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:35:51 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:44766 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaGCPfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:35:50 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw6CF0La9FO5jX_BvukjwW618vihqVm-hPXfUpL_5dhBA@mail.gmail.com>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
	<20140702162749.GP19379@twins.programming.kicks-ass.net>
	<1404320356.3170.12.camel@j-VirtualBox>
	<20140702172333.GQ19379@twins.programming.kicks-ass.net>
	<1404322203.3170.17.camel@j-VirtualBox>
	<1404362358.8764.6.camel@j-VirtualBox>
	<CA+55aFw6CF0La9FO5jX_BvukjwW618vihqVm-hPXfUpL_5dhBA@mail.gmail.com>
Date: Thu, 3 Jul 2014 08:35:49 -0700
X-Google-Sender-Auth: hjJWkcTbDuYkDFMg_YQnSFgwk4s
Message-ID: <CA+55aFy=CnCLet=B9Q5dYU9w885sXNuYVDSkjHAp5V+nczbn3Q@mail.gmail.com>
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

On Thu, Jul 3, 2014 at 8:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I don't think we'll support 2 _billion_ processes/threads waiting on
> the same semaphore any time soon, so the 'long' seems a bit of an
> overkill on 64-bit architectures.

Oh, never mind. The 'struct semaphore' uses it as just a plain count,
but the rwsem ends up splitting up the bits for readers/writers, so we
actually do want the full 64-bit value there.

             Linus
