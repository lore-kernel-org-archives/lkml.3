Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3H0SP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:15:58 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:52741 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3H0SP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:15:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130827174916.GA802@redhat.com>
References: <20130825194844.GA16717@redhat.com>
	<CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com>
	<20130826153301.GA15890@redhat.com>
	<20130826163704.GA21763@redhat.com>
	<20130826175441.GA28856@redhat.com>
	<CA+55aFzCghYYF1_dcvBY9XZ82TU9b=hhgFqkGoWpaZuKJ7R6_A@mail.gmail.com>
	<CA+55aFwAw=AZNqmDNip_P6WiY4zGRNWks-kLwN7ZgJ8JJsAx-A@mail.gmail.com>
	<20130827143938.GA19425@redhat.com>
	<20130827144004.GB19425@redhat.com>
	<CA+55aFzoXyA8TU5XXqaNj1EzZ9H-pbTbJ85--zhWzAOLThyjSQ@mail.gmail.com>
	<20130827174916.GA802@redhat.com>
Date: Tue, 27 Aug 2013 11:15:56 -0700
X-Google-Sender-Auth: QIxTiaig3bBbayxWhI3CIaxqodg
Message-ID: <CA+55aFwwLtxWbNnHO-8Nrpo5q9W=3D-oubUeJ3pFZCxCa4__RQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] proc: make /proc/self point to thread
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Willy Tarreau <w@1wt.eu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 10:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Why? To me /proc/self == /proc/$((sys_gettid)) looks more natural.
> Say, /proc/self/task... But this is subjective.

Actually, you're right - I incorrectly thought we had removed the
thread id lookup from the top level in /proc. But we never actually
did that. We only removed them from readdir.

So while you won't see thread id's in the directory listing, we *do*
successfully look up thread id's when specified explicitly. It's
confusing, but it happens to work. So you can do

   ls -l /proc/<tid>/

and get the expected result, but if you do

   ls -l /proc | grep <tid>

it won't actually show up unless the thread ID is also the thread group leader.

> Although to be honest, I was seduced by "Worth testing". I mean I am
> just curious, who can suffer from this change? Nevermind, please
> ignore.

Yeah, if we were to redesign /proc I'd do it differently, but I think
we should just accept that it works "well enough" and there's just too
much risk from making changes that aren't strictly required.

            Linus
