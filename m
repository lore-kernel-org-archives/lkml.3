Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3BPAkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 19:40:40 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:40175 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3BPAkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 19:40:39 -0500
MIME-Version: 1.0
In-Reply-To: <20130216000435.GY4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk> <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk> <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Feb 2013 16:40:18 -0800
X-Google-Sender-Auth: SmDOOtyS3ktvxofL1Jm_KvTaCTM
Message-ID: <CA+55aFyzGenPNnKxf_PnAWVa1tZP294XUrhAVXgi0EuKm1x=vA@mail.gmail.com>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Shentino <shentino@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 4:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Feb 15, 2013 at 03:12:30PM -0800, Shentino wrote:
>> > +                               send_sig(SIGSEGV, current, 0);
>>
>> This might be a stupid miscue on my part, but shouldn't it be
>> force_sig instead of send_sig?
>>
>> I've got this crazy hunch that having SEGV masked might muck something up.
>
> How would you manage to have it masked at that point?  setup_new_exec()
> is inevitable after success of flush_old_exec() and it will do
> flush_signal_handlers() for us.

I have to agree with Shentino on this one: it's entirely possible that
send_sig() is always equivalent to force_sig() in this circumstance,
but rather than depend on that kind of non-local subtlety, we should
just make it obvious. This is what "force_sig()" exists for - making
it clear that we punch through any signal handlers. Whether such a
signal handler can exist or not is kind of immaterial.

               Linus
