Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3H0Qj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:39:57 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:36951 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3H0Qjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:39:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130827144004.GB19425@redhat.com>
References: <20130825065039.GB9299@1wt.eu>
	<CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com>
	<20130825194844.GA16717@redhat.com>
	<CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com>
	<20130826153301.GA15890@redhat.com>
	<20130826163704.GA21763@redhat.com>
	<20130826175441.GA28856@redhat.com>
	<CA+55aFzCghYYF1_dcvBY9XZ82TU9b=hhgFqkGoWpaZuKJ7R6_A@mail.gmail.com>
	<CA+55aFwAw=AZNqmDNip_P6WiY4zGRNWks-kLwN7ZgJ8JJsAx-A@mail.gmail.com>
	<20130827143938.GA19425@redhat.com>
	<20130827144004.GB19425@redhat.com>
Date: Tue, 27 Aug 2013 09:39:54 -0700
X-Google-Sender-Auth: Behd6Kg0nziKtz8uo-oZR5LFbYY
Message-ID: <CA+55aFzoXyA8TU5XXqaNj1EzZ9H-pbTbJ85--zhWzAOLThyjSQ@mail.gmail.com>
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

On Tue, Aug 27, 2013 at 7:40 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> /proc/self points to /proc/<tgid>, not to /proc/<tid>, and thus
> "self" actually means "group leader".
>
> Change fs/proc/self.c to print the caller's tid, this is probably
> what the users actually expect.

Yeah, thinking more about this, this can't work. I think you'd need to
use "/proc/<tgid>/task/<tid>" wouldn't you?

Or perhaps even more complicated, and say "if it's a task group
leader, keep the old /proc/<tgid>, otherwise do the full thread path".

Anyway, does not not sound worth it. Your previous simple patch is
probably the right thing to do.

             Linus
