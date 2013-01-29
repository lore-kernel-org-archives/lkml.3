Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3A2Tuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:50:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab3A2Tui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:50:38 -0500
Date: Tue, 29 Jan 2013 20:49:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lingzhu Xiang <lxiang@redhat.com>, Roman Rakus <rrakus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: set_termios/set_termiox should not return
	-EINTR
Message-ID: <20130129194908.GA29480@redhat.com>
References: <20130129190720.GA28000@redhat.com> <20130129190741.GA28004@redhat.com> <51082470.2070601@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51082470.2070601@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Jiri Slaby wrote:
>
> On 01/29/2013 08:07 PM, Oleg Nesterov wrote:
> >
> > Change set_termios/set_termiox to return -ERESTARTSYS to fix this
> > particular problem.
>
> This looks reasonable. However given the link above says:
>  You are not authorized to access bug #904907.
> the description above is poor. What problem exactly does this fix?

A syscall must never return EINTR unless it can not be restarted
(or it should not be restarted by, say, historical reasons).

In this case ioctl(TCSETAW) returns -EINTR even if it is interrupted
by the signal which has the SA_RESTART handler. This doesn't look right
no matter what.

> Why this should go to stable at all?

OK, this is up to you.

But if this patch is correct, perhaps it should be backported. This
-EINTR breaks /bin/bash which doesn't expect it, this leads to
"*** glibc detected *** ./bash-4.1.2-14.el6/bin/bash: double free or corruption (out):"

Perhaps /bin/bash is buggy too, I do not know. Probably Roman and
Lingzhu can tell more.

Oleg.

