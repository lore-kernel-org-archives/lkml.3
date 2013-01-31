Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab3AaWAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:00:39 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:40832 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab3AaWAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:00:11 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1301312233480.11905@ionos>
References: <20130131120348.372374706@linutronix.de> <20130131122342.31b28664.akpm@linux-foundation.org>
 <alpine.LFD.2.02.1301312233480.11905@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Feb 2013 08:59:49 +1100
X-Google-Sender-Auth: nYl-uZ6kM_q1mG4hH368Py0IssI
Message-ID: <CA+55aFx=cv+HxKGx+oQk4iLnnTGO7P0u3+DnvuOWbYzM-wvEeQ@mail.gmail.com>
Subject: Re: [patch 00/40] CPU hotplug rework - episode I
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 8:48 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> Methinks Tejun needed a cc on this lot ;)
>
> Not really.

I think we want as many people as possible cc'd on this. You may think
it's an obvious improvement, but maybe it's just because you now
understand the code because you wrote it yourself, not because it's
*actually* better.

Having some explicitly documented states may be nice, but do we need
eleven of them? And do we want to expose them? At least not for the
f*cking notifiers, I hope. Notifiers are a disgrace, and almost all of
them are a major design mistake. They all have locking problems, the
introduce internal arbitrary API's that are hard to fix later (because
you have random people who decided to hook into them, which is the
whole *point* of those notifier chains).

Since the patches themselves weren't cc'd, I don't know if you
actually made each state transition do those insane notifiers or not,
but I seriously hope you didn't. With that many states, hopefully the
idea is that you don't have any notifiers at all, and you just then
call the people associated with a particular state directly. Yes? No?

Because if this adds tons of new notifiers, I'm going to say that we
need about a hundred people signing off on the patches.  Part of your
explanation made me think you got rid of the notifiers, but then it
became clear that you just renamed them as "state callbacks". If
that's some generic exposed interface, I'll NAK it. No way in hell do
we want to expose eleven states with some random generic "SMP state
callback interface". F*ck no.

                Linus
