Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaGaTH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:07:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaGaTHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:07:54 -0400
Date: Thu, 31 Jul 2014 21:05:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: TIF_NOHZ can escape nonhz mask? (Was: [PATCH v3 6/8] x86:
	Split syscall_trace_enter into two phases)
Message-ID: <20140731190518.GA21938@redhat.com>
References: <20140728192209.GA26017@localhost.localdomain> <20140729175414.GA3289@redhat.com> <20140730163516.GC18158@localhost.localdomain> <20140730174630.GA30862@redhat.com> <20140731003034.GA32078@localhost.localdomain> <20140731160353.GA14772@redhat.com> <20140731171329.GD7842@localhost.localdomain> <20140731181230.GA18695@redhat.com> <20140731184729.GA12296@localhost.localdomain> <CAFTL4hyHh3Bw0eeJe9q50HVrt=B-zgmyu6C_hy+RoW21kQEJtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hyHh3Bw0eeJe9q50HVrt=B-zgmyu6C_hy+RoW21kQEJtg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Frederic Weisbecker wrote:
>
> 2014-07-31 20:47 GMT+02:00 Frederic Weisbecker <fweisbec@gmail.com>:
> > On Thu, Jul 31, 2014 at 08:12:30PM +0200, Oleg Nesterov wrote:
> >> On 07/31, Frederic Weisbecker wrote:
> > No, because preempt_schedule_irq() does the ctx_state save and restore with
> > exception_enter/exception_exit.
>
> Similar thing happens with schedule_user().
>
> preempt_schedule_irq() handles kernel preemption and schedule_user()
> the user preemption. On both cases we save and restore the context
> tracking state.
>
> This might be the missing piece you were missing :)

YYYYYEEEEESSSS, thanks!!

And in fact I was going to suggest to add this logic into preempt schedule
paths to improve the situation if we can't make TIF_NOHZ per-cpu.

But Frederic, perhaps I'll return here tomorrow with another question, it
is too late for me now ;)

Thanks!

Oleg.

