Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3AaW4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:56:11 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:64480 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab3AaW4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:56:09 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1301312302290.11905@ionos>
References: <20130131120348.372374706@linutronix.de> <20130131122342.31b28664.akpm@linux-foundation.org>
 <alpine.LFD.2.02.1301312233480.11905@ionos> <CA+55aFx=cv+HxKGx+oQk4iLnnTGO7P0u3+DnvuOWbYzM-wvEeQ@mail.gmail.com>
 <alpine.LFD.2.02.1301312302290.11905@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Feb 2013 09:55:48 +1100
X-Google-Sender-Auth: 57g56RPlB7OGkjxD2xOwCqj_ii0
Message-ID: <CA+55aFypNfzA1HZMmAiyFo48MhUTr+gt+1uvM7SHFzXh60-KQQ@mail.gmail.com>
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

On Fri, Feb 1, 2013 at 9:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Just face it. The current hotplug maze has 100+ states which are
> completely undocumented. They are asymetric vs. startup and
> teardown. They just exists and work somehow aside of the occasional
> hard to decode hickup.
>
> Do you really want to preserve that state by all means [F*ck no]?

No., But I also don't want to replace it with "there's now eleven
documented states, and random people hook into random documented
states".

So for me it's the "expose these states" that I get worried about.. A
random driver should not necessarily even be able to *see* this, and
decide to be clever and take advantage of the ordering.

So I'd hope there would be some visibility restrictions. We currently
have drivers already being confused by DOWN_PREPARE vs DOWN_FAILED etc
etc random state transitions, and giving them even more flexibility to
pick random states sounds like a really bad idea. I'd like to make
sure that drivers and filesystems etc do not even *see* the states
that are meant for the scheduler or workqueues, for example).

So 11 states (although some of those seem to have lots of substates,
so there may be many more) is too many to *expose*. It's not
necessarily too many to "have and document", if you see the
difference.

                   Linus
