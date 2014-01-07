Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaAGTMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 14:12:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaAGTM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 14:12:28 -0500
Date: Tue, 7 Jan 2014 20:12:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sergio Durigan Junior <sergiodj@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Pedro Alves <palves@redhat.com>,
        Tom Tromey <tromey@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] Implement new PTRACE_EVENT_SYSCALL_{ENTER,EXIT}
Message-ID: <20140107191257.GA31341@redhat.com>
References: <m3wqic205t.fsf@redhat.com> <20140107153036.GA4749@redhat.com> <m3vbxvzr1t.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3vbxvzr1t.fsf@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07, Sergio Durigan Junior wrote:
>
> On Tuesday, January 07 2014, Oleg Nesterov wrote:
>
> > Finally. If we add this feature, we should probably also report
> > is_compat_task() somehow. Currently the debugger can't know if, say,
> > a 64bit tracee does int80.
>
> OK, I will look into it, have no idea how to do that.  Suggestions are
> welcome, of course.

Well, you can probably encode is_compat_task() in ->ptrace_message along
with syscall_get_nr(). But I am not sure about __X32_SYSCALL_BIT in
->orig_ax. Probably we should not clear it and report both bits.

Oleg.q

