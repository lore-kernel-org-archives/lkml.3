Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaCHDDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 22:03:12 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:48034 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaCHDDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 22:03:10 -0500
MIME-Version: 1.0
In-Reply-To: <201403072325.s27NPvlt003528@terminus.zytor.com>
References: <201403072325.s27NPvlt003528@terminus.zytor.com>
Date: Fri, 7 Mar 2014 19:03:09 -0800
X-Google-Sender-Auth: ZHiYyxUTfdynM-AYUycmEv_4gGg
Message-ID: <CA+55aFxpy_soEgGE3oap1N9+RucYCxOjfgvuRzhRqfC7zEm6PA@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes for v3.14-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <bp@suse.de>, Don Zickus <dzickus@redhat.com>,
        Peter Anvin <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Russ Anderson <rja@sgi.com>,
        Steven Rostedt <rostedt@goodmis.org>, seiji.aguchi@hds.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oww, oww, oww.

DAMMIT.

On Fri, Mar 7, 2014 at 3:25 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> A small collection of minor fixes.  The FPU stuff is still pending, I
> fear.  I haven't heard anything from Suresh so I suspect I'm going to
> have to dig into the init specifics myself and fix up the patchset.

I pulled this and then pushed out without test-compiling, because I'm
not used to the x86 trees causing problems. Usually they've gone
through a lot of build tests etc.

But dammit, it's broken:

  arch/x86/kernel/head_64.o: In function `early_idt_handler':
  (.init.text+0x124): undefined reference to `X86_TRAP_NMI'

because X86_TRAP_NMI is an enum, not a #define.

This can not have worked in your tree either, because that thing has
never been anything *but* an enum. So I'm pissed off. This patch was
clearly never tested anywhere. Why was it sent to me?

Grr. Consider yourself cursed at. Saatana.

              Linus
