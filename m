Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaBJTMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:12:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaBJTMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:12:40 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v3] audit: Turn off TIF_SYSCALL_AUDIT when there are no rules
Date: Mon, 10 Feb 2014 14:12:21 -0500
Message-ID: <6663120.dfAPuuBWIr@x2>
Organization: Red Hat
User-Agent: KMail/4.11.5 (Linux/3.12.9-301.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALCETrX0GtSaLUB9UBeKsxOoVhiVyMzWrZTYt3O5He1Wdvz+1Q@mail.gmail.com>
References: <ee359482b77f8f633014ec300bc5a4b93f8961e8.1391893528.git.luto@amacapital.net> <CALCETrX9gb_+zW4UZZv5icCQ-3HNG7BFZOaqMPYaQfzotsZpnA@mail.gmail.com> <CALCETrX0GtSaLUB9UBeKsxOoVhiVyMzWrZTYt3O5He1Wdvz+1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 10, 2014 11:01:36 AM Andy Lutomirski wrote:
> >> And I still think this needs more changes. Once again, I do not think
> >> that, say, __audit_log_bprm_fcaps() should populate context->aux if
> >> !TIF_SYSCALL_AUDIT, this list can grow indefinitely. Or
> >> __audit_signal_info()...
> >> 
> >> Perhaps __audit_syscall_exit() should also set context->dummy?
> > 
> > That would work.
> > 
> > I'm still torn between trying to make it possible for things like
> > __audit_log_bprm_fcaps to start a syscall audit record in the middle
> > of a syscall or to just try to tighten up the current approach to the
> > point where it will work correctly.
> 
> This is worse than I thought.  Things like signal auditing can enter
> the audit system from outside of a syscall.  I don't think there's
> currently any way to tell whether you're in a syscall (when
> TIF_SYSCALL_AUDIT is clear) so getting this to work right would
> require arch help.
> 
> I'll ask what people on the Fedora list think about just changing the
> default to -t task,never.

I can't recall ever seeing the task filter used in real life. But assuming you 
wanted to audit no tasks, what is the difference between using that filter and 
never setting audit_enable in the first place?

-Steve
