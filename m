Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaCHDg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 22:36:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44898 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaCHDg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 22:36:26 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFxpy_soEgGE3oap1N9+RucYCxOjfgvuRzhRqfC7zEm6PA@mail.gmail.com>
References: <201403072325.s27NPvlt003528@terminus.zytor.com> <CA+55aFxpy_soEgGE3oap1N9+RucYCxOjfgvuRzhRqfC7zEm6PA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [GIT PULL] x86 fixes for v3.14-rc6
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 07 Mar 2014 19:34:03 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <bp@suse.de>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Russ Anderson <rja@sgi.com>,
        Steven Rostedt <rostedt@goodmis.org>, seiji.aguchi@hds.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Message-ID: <4ac825d6-a2c7-4ab3-a554-37e02af61fa7@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bloody hell.  Friday afternoon malfunction (thought I checked the output and apparently missed.)

On March 7, 2014 7:03:09 PM PST, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>Oww, oww, oww.
>
>DAMMIT.
>
>On Fri, Mar 7, 2014 at 3:25 PM, H. Peter Anvin <hpa@linux.intel.com>
>wrote:
>>
>> A small collection of minor fixes.  The FPU stuff is still pending, I
>> fear.  I haven't heard anything from Suresh so I suspect I'm going to
>> have to dig into the init specifics myself and fix up the patchset.
>
>I pulled this and then pushed out without test-compiling, because I'm
>not used to the x86 trees causing problems. Usually they've gone
>through a lot of build tests etc.
>
>But dammit, it's broken:
>
>  arch/x86/kernel/head_64.o: In function `early_idt_handler':
>  (.init.text+0x124): undefined reference to `X86_TRAP_NMI'
>
>because X86_TRAP_NMI is an enum, not a #define.
>
>This can not have worked in your tree either, because that thing has
>never been anything *but* an enum. So I'm pissed off. This patch was
>clearly never tested anywhere. Why was it sent to me?
>
>Grr. Consider yourself cursed at. Saatana.
>
>              Linus

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
