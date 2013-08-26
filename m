Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3HZSJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:09:27 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:46648 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3HZSJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:09:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130826175441.GA28856@redhat.com>
References: <20130822201530.GL31117@1wt.eu>
	<20130824182939.GA23630@redhat.com>
	<20130824212432.GA9299@1wt.eu>
	<20130825052317.GZ27005@ZenIV.linux.org.uk>
	<20130825065039.GB9299@1wt.eu>
	<CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com>
	<20130825194844.GA16717@redhat.com>
	<CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com>
	<20130826153301.GA15890@redhat.com>
	<20130826163704.GA21763@redhat.com>
	<20130826175441.GA28856@redhat.com>
Date: Mon, 26 Aug 2013 11:09:25 -0700
X-Google-Sender-Auth: pyAIkOtICcc0aqAK46ZBwHuCVnA
Message-ID: <CA+55aFzCghYYF1_dcvBY9XZ82TU9b=hhgFqkGoWpaZuKJ7R6_A@mail.gmail.com>
Subject: Re: [PATCH] proc: make proc_fd_permission() thread-friendly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 10:54 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> proc_fd_permission() says "process can still access /proc/self/fd
> after it has executed a setuid()", but the "task_pid() = proc_pid()
> check only helps if the task is group leader, /proc/self points to
> /proc/leader-pid.

Patch looks ok to me, but since this has never worked and nobody has
actually complained, I can't really convince myself that this is
critical.

So I'm not going to apply it for 3.11, and it had better wait for the
next merge window.

                 Linus
