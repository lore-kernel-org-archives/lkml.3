Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab3BSJjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:39:45 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:50595 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab3BSJjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:39:43 -0500
MIME-Version: 1.0
In-Reply-To: <511E9480.5070202@redhat.com>
References: <1360768595-31943-1-git-send-email-avagin@openvz.org>
	<511E8223.6010506@redhat.com>
	<20130215194356.GA12413@redhat.com>
	<511E9480.5070202@redhat.com>
Date: Tue, 19 Feb 2013 13:39:42 +0400
Message-ID: <CANaxB-yS5pFNBDe8v7jhRDk=zcxavR=Oxn_mD7wD2ygJKjs=fQ@mail.gmail.com>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without removing
 them from a queue
From: Andrey Wagin <avagin@gmail.com>
To: Pedro Alves <palves@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-api@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/16 Pedro Alves <palves@redhat.com>:
> Forgot to reply to this bit:
>
> On 02/15/2013 07:43 PM, Oleg Nesterov wrote:
>>> We'd miss the poke
>>> > variant, but that looks like something that could be always be added
>>> > later.
>> Yes. _POKE_ or _QUEUE_ or _DEQUEUE_, we can add more features if user-
>> space wants them.
>
> In general, IMO, I agree with Roland at https://lkml.org/lkml/2002/12/20/84
> in that it's good to have setters for completeness, so that you can
> change all the state via ptrace that you can read via ptrace.
>
> But I'm not doing any of this work, hence my "could always be
> added later" comment instead of actually requesting it.  But if
> we had it, we could make e.g., gdb inspect the signal queues,
> and then be able to tweak a realtime signal before it is
> delivered.

PTRACE_POKESIGINFO is more complicated than PTRACE_PEEKSIGINFO.
Looks like PTRACE_POKESIGINFO should replace a siginfo with the
specified sequence number. Should it be able to change signo? If it is
able, what to do with signalfd, which already got a notification about
the previous signal?..

My opinion is that it "could always be added later", when we will
understand what exactly we want to have.

>
> --
> Pedro Alves
