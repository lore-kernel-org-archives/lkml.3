Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbaDBHmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:42:10 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:42579 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbaDBHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:42:07 -0400
Date: Wed, 2 Apr 2014 09:42:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Jovi Zhangwei <jovi.zhangwei@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>,
        Geoff.Levand@huawei.com
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for
 Linux
Message-ID: <20140402074202.GB22680@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
 <20140331071749.GA1252@gmail.com>
 <CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
 <CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com>
 <CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
 <CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> [...]
>
> It seems that your definition of 'safe ktap' is that user cannot break
> kernel if he uses ktap scripting syntax.
> In that sense ktap is not much different from stap.
> 
> Overall it seems you view ktap bytecode as a continuation
> of ktap syntax.
> ktap language allows to read pid,uid,tid, so they were added as
> separate instructions to ktap bytecode...
> ktap allows dump of a table, so kernel has to do tab_histdump()
> including sorting of fields and printf formatting.
> What if ktap user wants a different table dump?
> or new features from the language?
> keep extending bytecode for every printf tweak is not a great solution.
> 
> I think design approach to ktap needs to change.
> What I'm proposing is the following:
> - keep ktap syntax as-is, but remove loops
> - ktap style of accessing tables is definitely less verbose then C,
>  so keep it, but don't let compiled program to own the memory
> - keep table dump as-is, but do it in userspace instead

I'd suggest using C syntax instead initially, because that's what the 
kernel is using.

The overwhelming majority of people probing the kernel are 
programmers, so there's no point in inventing new syntax, we should 
reuse existing syntax!

That is one reason why for example the (very simple!) ftrace filter 
language tries to mimic C syntax.

Especially as C is simpler for an important category, filters:

> Though I think C as a language to express filters is simpler,
> ktap syntax is fine as well.

Thanks,

	Ingo
