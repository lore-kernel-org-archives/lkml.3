Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935915Ab3DPOql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935614Ab3DPOqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:46:40 -0400
Date: Tue, 16 Apr 2013 16:42:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/6] signal x86: Propage RF EFLAGS bit throught the
	signal restore call
Message-ID: <20130416144226.GA12848@redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com> <1362940871-24486-2-git-send-email-jolsa@redhat.com> <20130416010524.GH17561@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416010524.GH17561@somewhere.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Frederic Weisbecker wrote:
>
> On Sun, Mar 10, 2013 at 07:41:06PM +0100, Jiri Olsa wrote:
> > Adding RF EFLAGS bit to be restored on return from signal from
> > the original register context before the signal was entered.
> >
> > This will prevent the RF flag to disappear when returning
> > from exception due to the signal handler being executed.
>
> So that happens if, say, we get a breakpoint exception and then we
> run a signal handler before returning to the ip that triggered the
> breakpoint?

Afaics these changes (1 and 2) should fix the bug.

Suppose that the first insn in the signal handler should trigger
another bp, we should clear X86_EFLAGS_RF (2/6).

Otoh, we should restore it when we return to the original insn
which triggered the trap to avoid another trap.

But. it seems that we have yet another problem? Suppose that
the signal handler does siglongjmp() and jumps to yet another
insn which should trigger the trap?

Oleg.

