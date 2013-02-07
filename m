Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab3BGER3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:17:29 -0500
Received: from ozlabs.org ([203.10.76.45]:57069 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab3BGERX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:17:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 00/40] CPU hotplug rework - episode I
In-Reply-To: <alpine.LFD.2.02.1302011128490.11905@ionos>
References: <20130131120348.372374706@linutronix.de> <20130131122342.31b28664.akpm@linux-foundation.org> <alpine.LFD.2.02.1301312233480.11905@ionos> <CA+55aFx=cv+HxKGx+oQk4iLnnTGO7P0u3+DnvuOWbYzM-wvEeQ@mail.gmail.com> <alpine.LFD.2.02.1301312302290.11905@ionos> <CA+55aFypNfzA1HZMmAiyFo48MhUTr+gt+1uvM7SHFzXh60-KQQ@mail.gmail.com> <alpine.LFD.2.02.1302011128490.11905@ionos>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 07 Feb 2013 14:31:04 +1030
Message-ID: <87obfwixhb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
> On Fri, 1 Feb 2013, Linus Torvalds wrote:
>> So for me it's the "expose these states" that I get worried about.. A
>> random driver should not necessarily even be able to *see* this, and
>> decide to be clever and take advantage of the ordering.
>> 
>> So I'd hope there would be some visibility restrictions. We currently
>> have drivers already being confused by DOWN_PREPARE vs DOWN_FAILED etc
>> etc random state transitions, and giving them even more flexibility to
>> pick random states sounds like a really bad idea. I'd like to make
>> sure that drivers and filesystems etc do not even *see* the states
>> that are meant for the scheduler or workqueues, for example).

Yeah, I assume Episode II is where we collapse each into sane states
as Thomas clarified.  That can be reviewed: I'd hate to try to do it
in one go.

Cheers,
Rusty.
